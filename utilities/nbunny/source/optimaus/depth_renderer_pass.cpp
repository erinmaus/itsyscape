////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/depth_renderer_pass.cpp
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
#include "nbunny/optimaus/depth_renderer_pass.hpp"

void nbunny::DepthRendererPass::walk_all_nodes(SceneNode& node, float delta)
{
	const auto& visible_scene_nodes = get_renderer()->get_visible_scene_nodes_by_material();

	drawable_scene_nodes.clear();
	stencil_masked_drawable_scene_nodes.clear();
	stencil_write_drawable_scene_nodes.clear();

	for (auto& visible_scene_node: visible_scene_nodes)
	{
		auto& material = visible_scene_node->get_material();
		if (material.get_is_translucent() || material.get_is_full_lit())
		{
			continue;
		}

		if (material.should_stencil_mask())
		{
			stencil_masked_drawable_scene_nodes.push_back(visible_scene_node);
		}
		else if (material.should_stencil_write())
		{
			stencil_write_drawable_scene_nodes.push_back(visible_scene_node);
		}
		else
		{
			drawable_scene_nodes.push_back(visible_scene_node);
		}
	}
}

love::graphics::Shader* nbunny::DepthRendererPass::get_node_shader(lua_State* L, const SceneNode& node)
{
	auto shader_resource = node.get_material().get_shader();
	if (!shader_resource || shader_resource->get_id() == 0)
	{
		return nullptr;
	}

    return RendererPass::get_node_shader(L, node);
}

void nbunny::DepthRendererPass::draw_nodes(lua_State* L, float delta, const std::vector<SceneNode*>& nodes)
{
	auto renderer = get_renderer();
	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	love::graphics::CompareMode depth_compare_mode = love::graphics::COMPARE_LEQUAL;
	bool depth_write_enabled = true;
	graphics->getDepthMode(depth_compare_mode, depth_write_enabled);

	for (auto& scene_node: nodes)
	{
		auto shader = get_node_shader(L, *scene_node);
        if (!shader)
        {
            continue;
        }

		renderer->set_current_shader(shader);

		auto outline_threshold = scene_node->get_material().get_outline_threshold();
		renderer->get_shader_cache().update_uniform(shader, "scape_OutlineThreshold", &outline_threshold, sizeof(float));

		auto color = scene_node->get_material().get_color();
		graphics->setColor(love::Colorf(color.r, color.g, color.b, color.a));

		if (scene_node->get_material().get_is_z_write_disabled())
		{
			graphics->setDepthMode(depth_compare_mode, false);
		}

		renderer->draw_node(L, *scene_node, delta);

		if (scene_node->get_material().get_is_z_write_disabled())
		{
			graphics->setDepthMode(depth_compare_mode, depth_write_enabled);
		}
	}
}

void nbunny::DepthRendererPass::draw_pass(lua_State* L, float delta)
{
	auto renderer = get_renderer();
	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	g_buffer.use();

	const auto& camera = renderer->get_camera();
	auto view_matrix = camera.get_view();
	auto projection_matrix = camera.get_projection();
	love::math::Transform view(love::Matrix4(glm::value_ptr(view_matrix)));
	love::Matrix4 projection(glm::value_ptr(projection_matrix));

	graphics->replaceTransform(&view);
	graphics->setProjection(projection);

	graphics->clear(
		love::graphics::OptionalColorf(),
		0,
		1.0f);

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
	
	graphics->setBlendMode(love::graphics::Graphics::BLEND_REPLACE, love::graphics::Graphics::BLENDALPHA_PREMULTIPLIED);
	graphics->setMeshCullMode(love::graphics::CULL_BACK);

    graphics->setColorMask(disabled_mask);
	graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, true);
	if (!stencil_write_drawable_scene_nodes.empty())
	{
		draw_nodes(L, delta, stencil_masked_drawable_scene_nodes);

		graphics->setDepthMode(love::graphics::COMPARE_GEQUAL, false);
		graphics->drawToStencilBuffer(love::graphics::STENCIL_INCREMENT, 0);
		glad::glStencilOp(GL_KEEP, GL_INCR, GL_KEEP);
		draw_nodes(L, delta, stencil_write_drawable_scene_nodes);

		graphics->stopDrawToStencilBuffer();
		glad::glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);

		graphics->setMeshCullMode(love::graphics::CULL_BACK);
		graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, true);
	}

	graphics->clear(
		love::graphics::OptionalColorf(),
		love::OptionalInt(),
		1.0f);
	draw_nodes(L, delta, drawable_scene_nodes);

	if (!stencil_masked_drawable_scene_nodes.empty())
	{
		graphics->setStencilTest(love::graphics::COMPARE_EQUAL, 0);
		draw_nodes(L, delta, stencil_masked_drawable_scene_nodes);
		graphics->setStencilTest(love::graphics::COMPARE_ALWAYS, 0);
	}

	graphics->setColor(love::Colorf(1.0f, 1.0f, 1.0f, 1.0f));
    graphics->setColorMask(enabled_mask);
}

nbunny::DepthRendererPass::DepthRendererPass(GBuffer& g_buffer) :
	RendererPass(RENDERER_PASS_DEPTH), g_buffer(g_buffer)
{
	// Nothing.
}

void nbunny::DepthRendererPass::draw(lua_State* L, SceneNode& node, float delta)
{
	walk_all_nodes(node, delta);
	draw_pass(L, delta);
}

void nbunny::DepthRendererPass::resize(int width, int height)
{
	g_buffer.resize(width, height);
}

void nbunny::DepthRendererPass::attach(Renderer& renderer)
{
	RendererPass::attach(renderer);

	load_builtin_shader(
		"Resources/Renderers/Depth/Base.vert.glsl",
		"Resources/Renderers/Depth/Base.frag.glsl");
}

static int nbunny_depth_renderer_pass_constructor(lua_State* L)
{
	auto g_buffer = nbunny::lua::get<nbunny::GBuffer*>(L, 2);
	nbunny::lua::push(L, std::make_shared<nbunny::DepthRendererPass>(*g_buffer));

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_depthrendererpass(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ nullptr, nullptr }
	};
	
	nbunny::lua::register_child_type<nbunny::DepthRendererPass, nbunny::RendererPass>(L, &nbunny_depth_renderer_pass_constructor, metatable);

	return 1;
}
