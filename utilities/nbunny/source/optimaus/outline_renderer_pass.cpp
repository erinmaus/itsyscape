////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/outline_renderer_pass.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "modules/graphics/Graphics.h"
#include "modules/math/Transform.h"
#include "nbunny/optimaus/outline_renderer_pass.hpp"

void nbunny::OutlineRendererPass::walk_all_nodes(SceneNode& node, float delta)
{
	visible_scene_nodes.clear();
	SceneNode::walk_by_position(node, get_renderer()->get_camera(), delta, visible_scene_nodes);
}

love::graphics::Shader* nbunny::OutlineRendererPass::get_node_shader(lua_State* L, const SceneNode& node)
{
	auto shader_resource = node.get_material().get_shader();
	if (!shader_resource || shader_resource->get_id() == 0)
	{
		return nullptr;
	}

    return RendererPass::get_node_shader(L, node);
}

void nbunny::OutlineRendererPass::draw_nodes(lua_State* L, float delta)
{
	auto renderer = get_renderer();
	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	const auto& camera = renderer->get_camera();
	love::math::Transform view(love::Matrix4(glm::value_ptr(camera.get_view())));
	love::Matrix4 projection(glm::value_ptr(camera.get_projection()));

    o_buffer.use();

	graphics->clear(
		love::Colorf(1.0, 1.0, 1.0, 0.0),
		0,
		1.0f);

	graphics->replaceTransform(&view);
	graphics->setProjection(projection);

	for (auto& scene_node: visible_scene_nodes)
	{
		auto shader = get_node_shader(L, *scene_node);
		if (!shader)
		{
			continue;
		}
		renderer->set_current_shader(shader);

        graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, !scene_node->get_material().get_is_z_write_disabled());
        graphics->setMeshCullMode(love::graphics::CULL_BACK);
		graphics->setBlendMode(love::graphics::Graphics::BLEND_ALPHA, love::graphics::Graphics::BLENDALPHA_MULTIPLY);

		auto color = scene_node->get_material().get_color();
		graphics->setColor(love::Colorf(color.r, color.g, color.b, color.a));

		renderer->draw_node(L, *scene_node, delta);

		graphics->setColor(love::Colorf(1.0f, 1.0f, 1.0f, 1.0f));
	}
}

nbunny::OutlineRendererPass::OutlineRendererPass(GBuffer& o_buffer) :
	RendererPass(RENDERER_PASS_OUTLINE), o_buffer(o_buffer)
{
	// Nothing.
}

nbunny::GBuffer& nbunny::OutlineRendererPass::get_o_buffer()
{
	return o_buffer;
}

void nbunny::OutlineRendererPass::draw(lua_State* L, SceneNode& node, float delta)
{
	walk_all_nodes(node, delta);
	draw_nodes(L, delta);
}

void nbunny::OutlineRendererPass::resize(int width, int height)
{
	o_buffer.resize(width, height);
}

void nbunny::OutlineRendererPass::attach(Renderer& renderer)
{
	RendererPass::attach(renderer);

	load_builtin_shader(
		"Resources/Renderers/Outline/Base.vert.glsl",
		"Resources/Renderers/Outline/Base.frag.glsl");
}

static std::shared_ptr<nbunny::OutlineRendererPass> nbunny_outline_renderer_pass_create(
	sol::variadic_args args, sol::this_state S)
{
	lua_State* L = S;
	auto& o_buffer = sol::stack::get<nbunny::GBuffer&>(L, 2);
	return std::make_shared<nbunny::OutlineRendererPass>(o_buffer);
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_outlinerendererpass(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::OutlineRendererPass>("NOutlineRendererPass",
		sol::base_classes, sol::bases<nbunny::RendererPass>(),
		"getOBuffer", &nbunny::OutlineRendererPass::get_o_buffer,
		sol::call_constructor, sol::factories(&nbunny_outline_renderer_pass_create));

	sol::stack::push(L, T);

	return 1;
}