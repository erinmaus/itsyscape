////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/alpha_mask_renderer_pass.cpp
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
#include "nbunny/lua_runtime.hpp"
#include "nbunny/optimaus/alpha_mask_renderer_pass.hpp"
#include "nbunny/optimaus/deferred_renderer_pass.hpp"
#include "nbunny/optimaus/particle.hpp"

const float ALPHA_MASK_DISABLED = 0.0f;
const float ALPHA_MASK_ENABLED = 1.0f;

void nbunny::AlphaMaskRendererPass::walk_all_nodes(SceneNode& node, float delta)
{
	const auto& visible_scene_nodes = get_renderer()->get_visible_scene_nodes_by_position();

	opaque_scene_nodes.clear();
	translucent_scene_nodes.clear();
	particle_scene_nodes.clear();
	for (auto& visible_scene_node: visible_scene_nodes)
	{
		auto& material = visible_scene_node->get_material();

		if (material.get_outline_threshold() <= -1.0 && (material.get_is_translucent() || material.get_is_full_lit()))
		{
			continue;
		}

		if (material.get_color().a <= 0.0)
		{
			continue;
		}

		if (visible_scene_node->get_type() == ParticleSceneNode::type_pointer)
		{
			particle_scene_nodes.push_back(visible_scene_node);
		}
		else if (material.get_is_translucent() || material.get_is_full_lit())
		{
			translucent_scene_nodes.push_back(visible_scene_node);
		}
	}

	std::reverse(opaque_scene_nodes.begin(), opaque_scene_nodes.end());
}

love::graphics::Shader* nbunny::AlphaMaskRendererPass::get_node_shader(lua_State* L, const SceneNode& node)
{
	auto shader_resource = node.get_material().get_shader();
	if (!shader_resource || shader_resource->get_id() == 0)
	{
		return nullptr;
	}

    return RendererPass::get_node_shader(L, node);
}

void nbunny::AlphaMaskRendererPass::draw_nodes(lua_State* L, float delta)
{
	auto renderer = get_renderer();
	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	const auto& camera = renderer->get_camera();
	love::math::Transform view(love::Matrix4(glm::value_ptr(camera.get_view())));
	love::Matrix4 projection(glm::value_ptr(camera.get_projection()));

    a_buffer.use();
	graphics->clear(
		{
			love::Colorf(0.0, 0.0, 0.0, 0.0),
			love::Colorf(0.0, 0.0, 0.0, 0.0)
		},
		0,
		1.0f);

	copy_depth_buffer();
	graphics->flushStreamDraws();

	graphics->replaceTransform(&view);
	graphics->setProjection(projection);

	love::graphics::Graphics::ColorMask enabled_mask;
	enabled_mask.r = true;
	enabled_mask.g = true;
	enabled_mask.b = true;
	enabled_mask.a = true;

	love::graphics::Graphics::ColorMask disabled_mask;
	disabled_mask.r = false;
	disabled_mask.g = false;
	disabled_mask.b = false;
	disabled_mask.a = false;

    graphics->setMeshCullMode(love::graphics::CULL_BACK);
	graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, true);

	for (auto& scene_node: translucent_scene_nodes)
	{
		auto shader = get_node_shader(L, *scene_node);
		if (!shader)
		{
			continue;
		}
		renderer->set_current_shader(shader);
		renderer->get_shader_cache().update_uniform(shader, "scape_AlphaMask", &ALPHA_MASK_DISABLED, sizeof(float));

		graphics->setColorMask(disabled_mask);
		renderer->draw_node(L, *scene_node, delta);

		graphics->setColorMask(enabled_mask);

		auto color = scene_node->get_material().get_color();
		graphics->setColor(love::Colorf(color.r, color.g, color.b, color.a));

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
		renderer->get_shader_cache().update_uniform(shader, "scape_AlphaMask", &ALPHA_MASK_DISABLED, sizeof(float));

		graphics->setColorMask(disabled_mask);
		renderer->draw_node(L, *scene_node, delta);
	}

	graphics->setColor(love::Colorf(1.0f, 1.0f, 1.0f, 1.0f));
	graphics->setColorMask(enabled_mask);
}

void nbunny::AlphaMaskRendererPass::copy_depth_buffer()
{	
	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

    graphics->setDepthMode(love::graphics::COMPARE_ALWAYS, true);
    graphics->origin();
    graphics->setOrtho(a_buffer.get_width(), a_buffer.get_height(), !graphics->isCanvasActive());

	auto shader = get_renderer()->get_shader_cache().get(RENDERER_PASS_DEFERRED, DeferredRendererPass::BUILTIN_SHADER_DEPTH_COPY);
	if (!shader)
	{
		return;
	}

	love::graphics::Graphics::ColorMask disabled_mask;
	disabled_mask.r = false;
	disabled_mask.g = false;
	disabled_mask.b = false;
	disabled_mask.a = false;
	graphics->setColorMask(disabled_mask);

	get_renderer()->set_current_shader(shader);
	graphics->draw(depth_buffer.get_canvas(0), love::Matrix4());
}

nbunny::AlphaMaskRendererPass::AlphaMaskRendererPass(GBuffer& a_buffer, GBuffer& depth_buffer) :
	RendererPass(RENDERER_PASS_ALPHA_MASK), a_buffer(a_buffer), depth_buffer(depth_buffer)
{
	// Nothing.
}

nbunny::GBuffer& nbunny::AlphaMaskRendererPass::get_a_buffer()
{
	return a_buffer;
}

void nbunny::AlphaMaskRendererPass::draw(lua_State* L, SceneNode& node, float delta)
{
	walk_all_nodes(node, delta);
	draw_nodes(L, delta);
}

void nbunny::AlphaMaskRendererPass::resize(int width, int height)
{
	a_buffer.resize(width, height);
}

void nbunny::AlphaMaskRendererPass::attach(Renderer& renderer)
{
	RendererPass::attach(renderer);

	load_builtin_shader(
		"Resources/Renderers/AlphaMask/Base.vert.glsl",
		"Resources/Renderers/AlphaMask/Base.frag.glsl");
}

static int nbunny_alpha_mask_renderer_pass_constructor(lua_State* L)
{
	auto a_buffer = nbunny::lua::get<nbunny::GBuffer*>(L, 2);
	auto depth_buffer = nbunny::lua::get<nbunny::GBuffer*>(L, 3);
	
	nbunny::lua::push(L, std::make_shared<nbunny::AlphaMaskRendererPass>(*a_buffer, *depth_buffer));

	return 1;
}

static int nbunny_alpha_mask_renderer_pass_get_a_buffer(lua_State* L)
{
	auto self = nbunny::lua::get<nbunny::AlphaMaskRendererPass*>(L, 1);
	nbunny::lua::push(L, &self->get_a_buffer());

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_alphamaskrendererpass(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "getABuffer", &nbunny_alpha_mask_renderer_pass_get_a_buffer },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_child_type<nbunny::AlphaMaskRendererPass, nbunny::RendererPass>(L, &nbunny_alpha_mask_renderer_pass_constructor, metatable);

	return 1;
}
