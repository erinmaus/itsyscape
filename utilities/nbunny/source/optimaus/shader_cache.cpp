////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/shader_cache.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "common/Exception.h"
#include "common/Module.h"
#include "common/runtime.h"
#include "modules/graphics/Graphics.h"

#include "nbunny/optimaus/shader_cache.hpp"
#include "nbunny/optimaus/resource.hpp"

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

		v = base_vertex_source + vertex_source;
		p = base_pixel_source + pixel_source;

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
