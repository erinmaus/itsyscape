////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/renderer.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "common/Module.h"
#include "common/runtime.h"
#include "modules/graphics/Graphics.h"
#include "modules/timer/Timer.h"
#include "modules/filesystem/Filesystem.h"
#include "nbunny/optimaus/renderer.hpp"

nbunny::Renderer::Renderer(int reference) :
	reference(reference), camera(&default_camera)
{
	auto timer_instance = love::Module::getInstance<love::timer::Timer>(love::Module::M_TIMER);
	time = timer_instance->getTime();
}

void nbunny::Renderer::add_renderer_pass(RendererPass* renderer_pass)
{
	renderer_pass->attach(*this);
	renderer_passes.push_back(renderer_pass);
}

void nbunny::Renderer::set_clear_color(const glm::vec4& value)
{
	clear_color = value;
}

const glm::vec4& nbunny::Renderer::get_clear_color() const
{
	return clear_color;
}

void nbunny::Renderer::set_camera(Camera& camera)
{
	this->camera = &camera;
}

nbunny::Camera& nbunny::Renderer::get_camera()
{
	return *(this->camera);
}

const nbunny::Camera& nbunny::Renderer::get_camera() const
{
	return *this->camera;
}

void nbunny::Renderer::set_current_shader(love::graphics::Shader* shader)
{
	if (shader != current_shader)
	{
		auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
		graphics->setShader(shader);
		current_shader = shader;
	}
}

love::graphics::Shader* nbunny::Renderer::get_current_shader() const
{
	return current_shader;
}

nbunny::ShaderCache& nbunny::Renderer::get_shader_cache()
{
	return shader_cache;
}

const nbunny::ShaderCache& nbunny::Renderer::get_shader_cache() const
{
	return shader_cache;
}

void nbunny::Renderer::draw(lua_State* L, SceneNode& node, float delta, int width, int height)
{
	if (this->width != width || this->height != height)
	{
		this->width = width <= 0 ? 1 : width;
		this->height = height <= 0 ? 1 : height;

		for (auto& renderer_pass: renderer_passes)
		{
			renderer_pass->resize(width, height);
		}
	}

	for (auto& renderer_pass: renderer_passes)
	{
		renderer_pass->draw(L, node, delta);
	}
}

void nbunny::Renderer::draw_node(lua_State* L, SceneNode& node, float delta)
{
	auto timer_instance = love::Module::getInstance<love::timer::Timer>(love::Module::M_TIMER);
	auto shader = get_current_shader();

	auto time_uniform = shader->getUniformInfo("scape_Time");
	if (time_uniform)
	{
        *time_uniform->floats = timer_instance->getTime() - time;
		shader->updateUniform(time_uniform, 1);
	}

	if (!node.is_base_type())
	{
		node.before_draw(*this, delta);
		node.draw(*this, delta);
		node.after_draw(*this, delta);
	}

	if (!reference)
	{
		return;
	}

	get_weak_reference(L, reference);
	if (lua_isnil(L, -1))
	{
		lua_pop(L, 1);
		return;
	}

	lua_getfield(L, -1, "renderNode");
	if (lua_isnil(L, -1))
	{
		lua_pop(L, 2); // Renderer reference and field
		return;
	}

	lua_pushvalue(L, -2);
	node.get_reference(L);
	lua_pushnumber(L, delta);
	lua_call(L, 3, 0);

	lua_pop(L, 1); // Renderer reference
}

nbunny::RendererPass::RendererPass(int renderer_pass_id) :
	renderer_pass_id(renderer_pass_id)
{
	// Nothing.
}

int nbunny::RendererPass::get_renderer_pass_id() const
{
	return renderer_pass_id;
}

nbunny::Renderer* nbunny::RendererPass::get_renderer()
{
	return renderer;
}

const nbunny::Renderer* nbunny::RendererPass::get_renderer() const
{
	return renderer;
}

void nbunny::RendererPass::attach(Renderer& renderer)
{
	this->renderer = &renderer;
}

void nbunny::RendererPass::load_builtin_shader(
	const std::string& vertex_filename,
	const std::string& pixel_filename)
{
	auto filesystem = love::Module::getInstance<love::filesystem::Filesystem>(love::Module::M_FILESYSTEM);

	auto vertex_file_data = filesystem->read(vertex_filename.c_str());
	auto pixel_file_data = filesystem->read(pixel_filename.c_str());

	std::string vertex_source(reinterpret_cast<const char*>(vertex_file_data->getData()), vertex_file_data->getSize());
	std::string pixel_source(reinterpret_cast<const char*>(pixel_file_data->getData()), pixel_file_data->getSize());

	get_renderer()->get_shader_cache().register_renderer_pass(
		get_renderer_pass_id(),
		vertex_source,
		pixel_source);
}

love::graphics::Shader* nbunny::RendererPass::get_node_shader(lua_State* L, const SceneNode& node)
{
    auto shader_resource = node.get_material().get_shader();

    return get_renderer()->get_shader_cache().build(
            get_renderer_pass_id(),
            shader_resource->get_id(),
            [&](const auto& base_vertex_source, const auto& base_pixel_source, auto& v, auto& p)
            {
                // Get source object from resource
                // This assumes the object is an ItsyScape.Graphics.ShaderResource, which should be a valid assumption.
                // TODO: error handling
                shader_resource->get_reference(L);

                lua_getfield(L, -1, "getResource");
                lua_pushvalue(L, -2);
                lua_call(L, 1, 1);

                v = base_vertex_source;

                lua_getfield(L, -1, "getVertexSource");
                lua_pushvalue(L, -2);
                lua_call(L, 1, 1);

                v += luaL_checkstring(L, -1);
                lua_pop(L, 1);

                p = base_pixel_source;

                lua_getfield(L, -1, "getPixelSource");
                lua_pushvalue(L, -2);
                lua_call(L, 1, 1);

                p += luaL_checkstring(L, -1);
                lua_pop(L, 1);

                // Pop return value from "getResource" and the reference
                lua_pop(L, 2);

                love::luax_getfunction(L, "graphics", "_shaderCodeToGLSL");

                lua_pushboolean(L, get_renderer()->get_shader_cache().get_is_mobile());
                lua_pushlstring(L, v.c_str(), v.size());
                lua_pushlstring(L, p.c_str(), p.size());

                if (lua_pcall(L, 3, 2, 0) != 0)
                    luaL_error(L, "%s", lua_tostring(L, -1));

                v = luaL_checkstring(L, -2);
                p = luaL_checkstring(L, -1);

                lua_pop(L, 2);
            });
}

static std::shared_ptr<nbunny::Renderer> nbunny_renderer_create(sol::variadic_args args, sol::this_state S)
{
	lua_State* L = S;

	int reference = 0;
	if (!lua_isnil(L, 2))
	{
		lua_pushvalue(L, 2);
		reference = nbunny::set_weak_reference(L);
	}

	return std::make_shared<nbunny::Renderer>(reference);
}

static int nbunny_renderer_set_clear_color(lua_State* L)
{
	auto renderer = sol::stack::get<nbunny::Renderer*>(L, 1);
	float r = luaL_checknumber(L, 2);
	float g = luaL_checknumber(L, 3);
	float b = luaL_checknumber(L, 4);
	float a = luaL_checknumber(L, 5);
	renderer->set_clear_color(glm::vec4(r, g, b, a));
	return 0;
}

static int nbunny_renderer_get_clear_color(lua_State* L)
{
	auto renderer = sol::stack::get<nbunny::Renderer*>(L, 1);
	const auto& clear_color = renderer->get_clear_color();
	lua_pushnumber(L, clear_color.x);
	lua_pushnumber(L, clear_color.y);
	lua_pushnumber(L, clear_color.z);
	lua_pushnumber(L, clear_color.w);
	return 4;
}

static int nbunny_renderer_set_camera(lua_State* L)
{
	auto renderer = sol::stack::get<nbunny::Renderer*>(L, 1);
	auto camera = sol::stack::get<nbunny::Camera*>(L, 2);
	renderer->set_camera(*camera);
	return 0;
}

static int nbunny_renderer_get_camera(lua_State* L)
{
	auto renderer = sol::stack::get<nbunny::Renderer*>(L, 1);
    auto& camera = renderer->get_camera();
	sol::stack::push(L, &camera);
	return 1;
}

static int nbunny_renderer_get_current_shader(lua_State* L)
{
    auto renderer = sol::stack::get<nbunny::Renderer*>(L, 1);
    auto shader = renderer->get_current_shader();
    if (shader == nullptr)
    {
        lua_pushnil(L);
    }
    else
    {
        love::luax_pushtype(L, shader);
    }

    return 1;
}

static int nbunny_renderer_get_shader_cache(lua_State* L)
{
	auto renderer = sol::stack::get<nbunny::Renderer*>(L, 1);
    auto& shader_cache = renderer->get_shader_cache();
	sol::stack::push(L, &shader_cache);
	return 1;
}

static int nbunny_renderer_draw(lua_State* L)
{
	auto renderer = sol::stack::get<nbunny::Renderer*>(L, 1);
	auto& node = sol::stack::get<nbunny::SceneNode&>(L, 2);
	float delta = (float)luaL_checknumber(L, 3);
	int width = luaL_checkinteger(L, 4);
	int height = luaL_checkinteger(L, 5);
	renderer->draw(L, node, delta, width, height);
	return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_renderer(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::Renderer>("NRenderer",
		sol::call_constructor, sol::factories(&nbunny_renderer_create),
		"addRendererPass", &nbunny::Renderer::add_renderer_pass,
		"setClearColor", &nbunny_renderer_set_clear_color,
		"getClearColor", &nbunny_renderer_get_clear_color,
		"setCamera", &nbunny_renderer_set_camera,
		"getCamera", &nbunny_renderer_get_camera,
        "getCurrentShader", &nbunny_renderer_get_current_shader,
		"getShaderCache", &nbunny_renderer_get_shader_cache,
		"draw", &nbunny_renderer_draw);

	sol::stack::push(L, T);

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_rendererpass(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::RendererPass>("NRendererPass",
		"new", sol::no_constructor,
		"getRendererPassID", &nbunny::RendererPass::get_renderer_pass_id);

	sol::stack::push(L, T);

	return 1;
}
