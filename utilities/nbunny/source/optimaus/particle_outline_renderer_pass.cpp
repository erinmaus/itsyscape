////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/particle_outline_renderer_pass.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include <algorithm>
#include "modules/graphics/Graphics.h"
#include "modules/math/Transform.h"
#include "nbunny/optimaus/deferred_renderer_pass.hpp"
#include "nbunny/optimaus/particle.hpp"
#include "nbunny/optimaus/particle_outline_renderer_pass.hpp"

void nbunny::ParticleOutlineRendererPass::walk_all_nodes(SceneNode& node, float delta)
{
	const auto& visible_scene_nodes = get_renderer()->get_visible_scene_nodes_by_position();

	particle_scene_nodes.clear();
	other_scene_nodes.clear();
	for (auto& visible_scene_node: visible_scene_nodes)
	{
		if (visible_scene_node->get_type() == ParticleSceneNode::type_pointer)
		{
            particle_scene_nodes.push_back(visible_scene_node);
			continue;
		}

		auto material = visible_scene_node->get_material();

		if (material.get_is_z_write_disabled())
		{
			continue;
		}

		if (material.get_is_translucent() || material.get_is_full_lit())
		{
			other_scene_nodes.push_back(visible_scene_node);
		}
	}
}

love::graphics::Shader* nbunny::ParticleOutlineRendererPass::get_node_shader(lua_State* L, const SceneNode& node)
{
	auto shader_resource = node.get_material().get_shader();
	if (!shader_resource || shader_resource->get_id() == 0)
	{
		return nullptr;
	}

    return RendererPass::get_node_shader(L, node);
}

void nbunny::ParticleOutlineRendererPass::draw_nodes(lua_State* L, float delta)
{
	auto renderer = get_renderer();
	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	const auto& camera = renderer->get_camera();
	love::math::Transform view(love::Matrix4(glm::value_ptr(camera.get_view())));
	love::Matrix4 projection(glm::value_ptr(camera.get_projection()));

    o_buffer.use();

	graphics->clear(
		love::Colorf(0.0, 0.0, 0.0, 0.0),
		0,
		1.0f);

	if (particle_scene_nodes.size() == 0)
	{
		return;
	}

	copy_depth_buffer();
	graphics->flushStreamDraws();

	graphics->replaceTransform(&view);
	graphics->setProjection(projection);

	love::graphics::Graphics::ColorMask enabledMask;
	enabledMask.r = true;
	enabledMask.g = true;
	enabledMask.b = true;
	enabledMask.a = true;

	love::graphics::Graphics::ColorMask disabledMask;
	disabledMask.r = false;
	disabledMask.g = false;
	disabledMask.b = false;
	disabledMask.a = false;

	for (auto& scene_node: other_scene_nodes)
	{
		auto shader = get_node_shader(L, *scene_node);
		if (!shader)
		{
			continue;
		}
		renderer->set_current_shader(shader);

        graphics->setMeshCullMode(love::graphics::CULL_BACK);

		graphics->setColorMask(disabledMask);
        graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, true);	
		renderer->draw_node(L, *scene_node, delta);
	}

	for (auto& scene_node: particle_scene_nodes)
	{
		auto shader = get_node_shader(L, *scene_node);
		if (!shader)
		{
			continue;
		}
		renderer->set_current_shader(shader);

        graphics->setMeshCullMode(love::graphics::CULL_BACK);

		graphics->setColorMask(disabledMask);
        graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, true);	
		renderer->draw_node(L, *scene_node, delta);

		graphics->setColorMask(enabledMask);
        graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, false);
		graphics->setBlendMode(love::graphics::Graphics::BLEND_ALPHA, love::graphics::Graphics::BLENDALPHA_MULTIPLY);

		auto color = scene_node->get_material().get_color();
		graphics->setColor(love::Colorf(color.r, color.g, color.b, color.a));

		renderer->draw_node(L, *scene_node, delta);
	}

	graphics->setColorMask(enabledMask);
	graphics->setColor(love::Colorf(1.0f, 1.0f, 1.0f, 1.0f));
}

void nbunny::ParticleOutlineRendererPass::copy_depth_buffer()
{	
	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

    graphics->setDepthMode(love::graphics::COMPARE_ALWAYS, true);
    graphics->origin();
    graphics->setOrtho(o_buffer.get_width(), o_buffer.get_height(), !graphics->isCanvasActive());

	auto shader = get_renderer()->get_shader_cache().get(RENDERER_PASS_DEFERRED, DeferredRendererPass::BUILTIN_SHADER_DEPTH_COPY);
	if (!shader)
	{
		return;
	}

	love::graphics::Graphics::ColorMask disabledMask;
	disabledMask.r = false;
	disabledMask.g = false;
	disabledMask.b = false;
	disabledMask.a = false;
	graphics->setColorMask(disabledMask);

	get_renderer()->set_current_shader(shader);
	graphics->draw(depth_buffer.get_canvas(0), love::Matrix4());
}

nbunny::ParticleOutlineRendererPass::ParticleOutlineRendererPass(GBuffer& o_buffer, GBuffer& depth_buffer) :
	RendererPass(RENDERER_PASS_PARTICLE_OUTLINE), o_buffer(o_buffer), depth_buffer(depth_buffer)
{
	// Nothing.
}

nbunny::GBuffer& nbunny::ParticleOutlineRendererPass::get_o_buffer()
{
	return o_buffer;
}

void nbunny::ParticleOutlineRendererPass::draw(lua_State* L, SceneNode& node, float delta)
{
	walk_all_nodes(node, delta);
	draw_nodes(L, delta);
}

void nbunny::ParticleOutlineRendererPass::resize(int width, int height)
{
	o_buffer.resize(width, height);
}

void nbunny::ParticleOutlineRendererPass::attach(Renderer& renderer)
{
	RendererPass::attach(renderer);

	load_builtin_shader(
		"Resources/Renderers/ParticleOutline/Base.vert.glsl",
		"Resources/Renderers/ParticleOutline/Base.frag.glsl");
}

static std::shared_ptr<nbunny::ParticleOutlineRendererPass> nbunny_outline_renderer_pass_create(
	sol::variadic_args args, sol::this_state S)
{
	lua_State* L = S;
	auto& o_buffer = sol::stack::get<nbunny::GBuffer&>(L, 2);
	auto& depth_buffer = sol::stack::get<nbunny::GBuffer&>(L, 3);
	return std::make_shared<nbunny::ParticleOutlineRendererPass>(o_buffer, depth_buffer);
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_particleoutlinerendererpass(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::ParticleOutlineRendererPass>("NParticleOutlineRendererPass",
		sol::base_classes, sol::bases<nbunny::RendererPass>(),
		"getOBuffer", &nbunny::ParticleOutlineRendererPass::get_o_buffer,
		sol::call_constructor, sol::factories(&nbunny_outline_renderer_pass_create));

	sol::stack::push(L, T);

	return 1;
}
