////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/shimmer_renderer_pass.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include <algorithm>
#include "modules/graphics/Graphics.h"
#include "modules/graphics/opengl/OpenGL.h"
#include "modules/math/Transform.h"
#include "nbunny/optimaus/deferred_renderer_pass.hpp"
#include "nbunny/optimaus/shimmer_renderer_pass.hpp"

void nbunny::ShimmerRendererPass::walk_all_nodes(SceneNode& node, float delta)
{
	const auto& visible_scene_nodes = get_renderer()->get_visible_scene_nodes_by_position();

	shimmer_scene_nodes.clear();
	visited_shimmer_scene_nodes.clear();
	for (auto& visible_scene_node: visible_scene_nodes)
	{
		bool is_shimmer_enabled = false;
		auto current = visible_scene_node;
		while (current)
		{
			auto& material = current->get_material();
			if (material.get_is_shimmer_enabled())
			{
				is_shimmer_enabled = true;
				break;
			}

			current = current->get_parent();
		}

		if (is_shimmer_enabled)
		{
			current_shimmer_scene_nodes.clear();
			SceneNode::collect(*visible_scene_node, current_shimmer_scene_nodes);

			for (auto& child_scene_node: current_shimmer_scene_nodes)
			{
				if (!visited_shimmer_scene_nodes.contains(child_scene_node))
				{
					visited_shimmer_scene_nodes.insert(child_scene_node);
					shimmer_scene_nodes.push_back(child_scene_node);
				}
			}
		}
	}
}

love::graphics::Shader* nbunny::ShimmerRendererPass::get_node_shader(lua_State* L, const SceneNode& node)
{
	auto shader_resource = node.get_material().get_shader();
	if (!shader_resource || shader_resource->get_id() == 0)
	{
		return nullptr;
	}

    return RendererPass::get_node_shader(L, node);
}

void nbunny::ShimmerRendererPass::draw_nodes(lua_State* L, float delta)
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

	if (shimmer_scene_nodes.size() == 0)
	{
		return;
	}

	graphics->replaceTransform(&view);
	graphics->setProjection(projection);

	graphics->setBlendMode(love::graphics::Graphics::BLEND_ALPHA, love::graphics::Graphics::BLENDALPHA_MULTIPLY);

    graphics->setMeshCullMode(love::graphics::CULL_BACK);
    graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, true);

	for (auto& scene_node: shimmer_scene_nodes)
	{
		glm::vec4 shimmer_color = glm::vec4(1, 0.5, 0.0, 1.0);

		auto current = scene_node;
		while (current)
		{
			auto& material = current->get_material();
			if (material.get_is_shimmer_enabled())
			{
				shimmer_color = material.get_shimmer_color();
				break;
			}

			current = current->get_parent();
		}

		auto shader = get_node_shader(L, *scene_node);
		if (!shader)
		{
			continue;
		}
		renderer->set_current_shader(shader);

		auto& shader_cache = get_renderer()->get_shader_cache();
		shader_cache.update_uniform(shader, "scape_ShimmerColor", glm::value_ptr(shimmer_color), sizeof(glm::vec4));

		auto color = scene_node->get_material().get_color();
		graphics->setColor(love::Colorf(color.r, color.g, color.b, color.a));

		renderer->draw_node(L, *scene_node, delta);
	}

	graphics->setColor(love::Colorf(1.0f, 1.0f, 1.0f, 1.0f));
}

void nbunny::ShimmerRendererPass::copy_depth_buffer()
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

	love::graphics::Graphics::ColorMask disabled_mask;
	disabled_mask.r = false;
	disabled_mask.g = false;
	disabled_mask.b = false;
	disabled_mask.a = false;
	graphics->setColorMask(disabled_mask);

	get_renderer()->set_current_shader(shader);
	graphics->draw(depth_buffer.get_canvas(0), love::Matrix4());

	love::graphics::Graphics::ColorMask enabled_mask;
	enabled_mask.r = true;
	enabled_mask.g = true;
	enabled_mask.b = true;
	enabled_mask.a = true;
	graphics->setColorMask(enabled_mask);
}

nbunny::ShimmerRendererPass::ShimmerRendererPass(GBuffer& o_buffer, GBuffer& depth_buffer) :
	RendererPass(RENDERER_PASS_SHIMMER), o_buffer(o_buffer), depth_buffer(depth_buffer)
{
	// Nothing.
}

nbunny::GBuffer& nbunny::ShimmerRendererPass::get_o_buffer()
{
	return o_buffer;
}

void nbunny::ShimmerRendererPass::draw(lua_State* L, SceneNode& node, float delta)
{
	walk_all_nodes(node, delta);
	draw_nodes(L, delta);
}

void nbunny::ShimmerRendererPass::resize(int width, int height)
{
	o_buffer.resize(width, height);
}

void nbunny::ShimmerRendererPass::attach(Renderer& renderer)
{
	RendererPass::attach(renderer);

	load_builtin_shader(
		"Resources/Renderers/Shimmer/Base.vert.glsl",
		"Resources/Renderers/Shimmer/Base.frag.glsl");
}

static int nbunny_shimmer_renderer_pass_constructor(lua_State* L)
{
	auto o_buffer = nbunny::lua::get<nbunny::GBuffer*>(L, 2);
	auto depth_buffer = nbunny::lua::get<nbunny::GBuffer*>(L, 3);
	nbunny::lua::push(L, std::make_shared<nbunny::ShimmerRendererPass>(*o_buffer, *depth_buffer));

	return 1;
}

static int nbunny_shimmer_renderer_pass_get_o_buffer(lua_State* L)
{
	auto self = nbunny::lua::get<nbunny::ShimmerRendererPass*>(L, 1);
	nbunny::lua::push(L, &self->get_o_buffer());
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_shimmerrendererpass(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "getOBuffer", &nbunny_shimmer_renderer_pass_get_o_buffer },
		{ nullptr, nullptr }
	};
	
	nbunny::lua::register_child_type<nbunny::ShimmerRendererPass, nbunny::RendererPass>(L, &nbunny_shimmer_renderer_pass_constructor, metatable);

	return 1;
}
