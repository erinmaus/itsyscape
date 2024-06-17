////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/shader_cache.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include <regex>
#include <sstream>
#include "common/Exception.h"
#include "common/Module.h"
#include "common/runtime.h"
#include "modules/filesystem/Filesystem.h"
#include "modules/graphics/Graphics.h"

#include "nbunny/optimaus/shader_cache.hpp"
#include "nbunny/optimaus/resource.hpp"

void nbunny::ShaderCache::ShaderSource::combine(
	const std::string& version,
	const std::string& base_vertex_source,
	const std::string& base_pixel_source,
	std::string& result_vertex_source,
	std::string& result_pixel_source)
{
	std::stringstream result_vertex;
	result_vertex << "#pragma language" << " " << version << "\n";
	result_vertex << vertex_prologue << "\n";
	result_vertex << base_vertex_source << "\n";
	result_vertex << vertex;

	std::stringstream result_pixel;
	result_pixel << "#pragma language" << " " << version << "\n";
	result_pixel << pixel_prologue << "\n";
	result_pixel << base_pixel_source << "\n";
	result_pixel << pixel;

	result_vertex_source = result_vertex.str();
	result_pixel_source = result_pixel.str();

	std::cout << "vertex: " << result_vertex_source << std::endl;
	std::cout << "pixel: " << result_pixel_source << std::endl;
}

std::string nbunny::ShaderCache::ShaderSource::parse_includes(const std::string& source, std::unordered_set<std::string>& filenames)
{
	std::string result;

	auto filesystem = love::Module::getInstance<love::filesystem::Filesystem>(love::Module::M_FILESYSTEM);

	auto include_regex = std::regex("#include\\s+\"([^\"]+)\"\r?\n?");

	auto begin = std::sregex_iterator(source.begin(), source.end(), include_regex);
	auto end = std::sregex_iterator();

	if (std::distance(begin, end) == 0)
	{
		return source;
	}

	std::size_t current_line_number = 1;

	std::string suffix;
	for (auto i = begin; i != end; ++i)
	{
		auto filename = (*i)[1].str();
		if (!filenames.contains(filename))
		{
			filenames.insert(filename);

			auto sub_source_file_data = filesystem->read(filename.c_str());
			std::string sub_source(reinterpret_cast<const char*>(sub_source_file_data->getData()), sub_source_file_data->getSize());

			result += i->prefix().str() + "#line 1\n" + parse_includes(sub_source, filenames) + "\n";

			auto prefix = i->prefix().str();
			current_line_number += std::count(prefix.begin(), prefix.end(), '\n');

			std::stringstream line;
			line << "#line" << " " << current_line_number << std::endl;

			result += line.str();

			++current_line_number;
		}

		suffix = i->suffix();
	}

	result += suffix;

	return result;
}

std::string nbunny::ShaderCache::ShaderSource::parse_pragmas(const std::string& source, std::string& prologue)
{
	std::string result;

	auto pragma_regex = std::regex("#pragma\\s+([a-zA-Z_][a-zA-Z_0-9]*)\\s+([a-zA-Z_][a-zA-Z_0-9]*)\\s+([^\\s\n\r]*)?\r?\n?");

	auto begin = std::sregex_iterator(source.begin(), source.end(), pragma_regex);
	auto end = std::sregex_iterator();

	if (std::distance(begin, end) == 0)
	{
		return source;
	}

	std::string suffix;
	for (auto i = begin; i != end; ++i)
	{
		auto match = (*i)[0].str();
		auto type = (*i)[1].str();
		auto value = (*i)[2].str();

		if (type == "option")
		{
			prologue += std::string("#define ") + value;

			if (i->length() >= 4)
			{
				prologue += " ";
				prologue += (*i)[3].str();
			}

			prologue += "\n";
		}

		result += i->prefix().str() + "// " + match;
		suffix = i->suffix();
	}

	result += suffix;
	return result;
}

nbunny::ShaderCache::~ShaderCache()
{
	release();
}

void nbunny::ShaderCache::release()
{
	for (auto& i: shader_cache)
	{
		auto& shader_map = i.second;
		for (auto& j: shader_map)
		{
			j.second->release();
		}
		shader_map.clear();
	}
}

void nbunny::ShaderCache::register_renderer_pass(
	int renderer_pass_id,
	const std::string& vertex_source,
	const std::string& pixel_source)
{
	shader_source.emplace(renderer_pass_id, ShaderSource(vertex_source, pixel_source));
	shader_cache.emplace(renderer_pass_id, ShaderMap());
}

love::graphics::Shader* nbunny::ShaderCache::get(int renderer_pass_id, int resource_id)
{
	auto i = shader_cache.find(renderer_pass_id);
	if (i != shader_cache.end())
	{
		auto& shader_map = i->second;
		const auto& j = shader_map.find(resource_id);
		if (j != shader_map.end())
		{
			return j->second;
		}
	}

	return nullptr;
}

love::graphics::Shader* nbunny::ShaderCache::build(
	int renderer_pass_id,
	int resource_id,
	const BuildFunc& build_func)
{
	auto i = shader_cache.find(renderer_pass_id);
	if (i != shader_cache.end())
	{
		auto& shader_map = i->second;
		const auto& j = shader_map.find(resource_id);
		if (j != shader_map.end())
		{
			return j->second;
		}

		const auto& source = shader_source.at(renderer_pass_id);

		std::string vertex_source, pixel_source;
		build_func(source.vertex, source.pixel, vertex_source, pixel_source);

		auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
		auto shader = graphics->newShader(vertex_source, pixel_source);

		shader_map.emplace(resource_id, shader);
		return shader;
	}

	return nullptr;
}

static bool get_is_mobile()
{
    auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
    return graphics->getRenderer() == love::graphics::Graphics::RENDERER_OPENGLES;
}

bool nbunny::ShaderCache::get_is_mobile() const
{
    return ::get_is_mobile();
}

static int nbunny_shader_cache_do_build(lua_State* L, const nbunny::ShaderCache::BuildFunc build_func)
{
	auto& shader_cache = sol::stack::get<nbunny::ShaderCache>(L, 1);
	auto renderer_pass_id = luaL_checkinteger(L, 2);
	auto& resource = sol::stack::get<nbunny::ResourceInstance>(L, 3);

	auto shader = shader_cache.build(
		renderer_pass_id,
		resource.get_id(),
		build_func);
	if (shader == nullptr)
	{
		lua_pushnil(L);
	}
	else
	{
		luax_pushtype(L, shader);
	}

	return 1;
}

static int nbunny_shader_cache_build_composite(lua_State* L)
{
	std::string vertex_source = luaL_checkstring(L, 4);
	std::string pixel_source = luaL_checkstring(L, 5);

	auto build_func = [&](
		const std::string& base_vertex_source, const std::string& base_pixel_source,
		std::string& v, std::string& p)
	{
		love::luax_getfunction(L, "graphics", "_shaderCodeToGLSL");

		nbunny::ShaderCache::ShaderSource shader_source(vertex_source, pixel_source);
		shader_source.combine("glsl3", base_vertex_source, base_pixel_source, vertex_source, pixel_source);

		lua_pushboolean(L, get_is_mobile());
		lua_pushlstring(L, v.data(), v.size());
		lua_pushlstring(L, p.data(), p.size());

		if (lua_pcall(L, 3, 2, 0) != 0)
			luaL_error(L, "%s", lua_tostring(L, -1));

		v = luaL_checkstring(L, -2);
		p = luaL_checkstring(L, -1);
	};

	return nbunny_shader_cache_do_build(L, build_func);
}

static int nbunny_shader_cache_build_primitive(lua_State* L)
{
	auto build_func = [&](
		const std::string& base_vertex_source, const std::string& base_pixel_source,
		std::string& v, std::string& p)
	{
		love::luax_getfunction(L, "graphics", "_shaderCodeToGLSL");

		lua_pushboolean(L, get_is_mobile());
		lua_pushvalue(L, 4);
		lua_pushvalue(L, 5);

		if (lua_pcall(L, 3, 2, 0) != 0)
			luaL_error(L, "%s", lua_tostring(L, -1));

		v = luaL_checkstring(L, -2);
		p = luaL_checkstring(L, -1);
	};

	return nbunny_shader_cache_do_build(L, build_func);
}

// This is a very low level method.
// It skips LÖVE's mangling of the shader source.
// Use with care.
static int nbunny_shader_cache_build(lua_State* L)
{
	auto build_func = [&](
		const std::string& base_vertex_source, const std::string& base_pixel_source,
		std::string& v, std::string& p)
	{
		v = luaL_checkstring(L, 4);
		p = luaL_checkstring(L, 5);
	};

	return nbunny_shader_cache_do_build(L, build_func);
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_shadercache(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::ShaderCache>("NShaderCache",
		sol::call_constructor, sol::constructors<nbunny::ShaderCache()>(),
		"release", &nbunny::ShaderCache::release,
		"registerRendererPass", &nbunny::ShaderCache::register_renderer_pass,
		"buildPrimitive", nbunny_shader_cache_build_primitive,
		"buildComposite", nbunny_shader_cache_build_composite,
		"build", nbunny_shader_cache_build);

	sol::stack::push(L, T);
	return 1;
}
