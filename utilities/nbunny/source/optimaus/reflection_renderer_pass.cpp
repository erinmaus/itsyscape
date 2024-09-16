////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/reflection_renderer_pass.cpp
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
#include "nbunny/optimaus/particle.hpp"
#include "nbunny/optimaus/reflection_renderer_pass.hpp"

void nbunny::ReflectionRendererPass::walk_all_nodes(SceneNode& node, float delta)
{
	const auto& visible_scene_nodes = get_renderer()->get_visible_scene_nodes_by_position();

	reflective_or_refractive_scene_nodes.clear();
	translucent_scene_nodes.clear();
	for (auto& visible_scene_node: visible_scene_nodes)
	{
		auto material = visible_scene_node->get_material();

		if (material.get_is_translucent() || material.get_is_full_lit())
		{
			translucent_scene_nodes.push_back(visible_scene_node);
		}

        if (material.get_is_reflective_or_refractive())
        {
            reflective_or_refractive_scene_nodes.push_back(visible_scene_node);
        }
        else
        {
            auto& textures = material.get_textures();
            if (textures.size() >= 1 && textures.at(0)->has_per_pass_texture(get_renderer_pass_id()))
            {
                reflective_or_refractive_scene_nodes.push_back(visible_scene_node);
            }
        }
	}
}

bool nbunny::ReflectionRendererPass::get_has_reflections() const
{
    return reflective_or_refractive_scene_nodes.size() > 0;
}

love::graphics::Shader* nbunny::ReflectionRendererPass::get_node_shader(lua_State* L, const SceneNode& node)
{
	auto shader_resource = node.get_material().get_shader();
	if (!shader_resource || shader_resource->get_id() == 0)
	{
		return nullptr;
	}

    return RendererPass::get_node_shader(L, node);
}

void nbunny::ReflectionRendererPass::draw_nodes(lua_State* L, float delta)
{
	auto renderer = get_renderer();
	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	const auto& camera = renderer->get_camera();
	love::math::Transform view(love::Matrix4(glm::value_ptr(camera.get_view())));
	love::Matrix4 projection(glm::value_ptr(camera.get_projection()));

	if (reflective_or_refractive_scene_nodes.size() == 0)
	{
		return;
	}

	copy_g_buffer();

	graphics->replaceTransform(&view);
	graphics->setProjection(projection);

	love::graphics::Graphics::ColorMask enabled_mask;
	enabled_mask.r = true;
	enabled_mask.g = true;
	enabled_mask.b = true;
	enabled_mask.a = true;
	graphics->setColorMask(enabled_mask);

	reflection_buffer.use();
	graphics->setMeshCullMode(love::graphics::CULL_BACK);
	graphics->setBlendMode(love::graphics::Graphics::BLEND_REPLACE, love::graphics::Graphics::BLENDALPHA_PREMULTIPLIED);
    graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, false);	

	for (auto& scene_node: translucent_scene_nodes)
	{
		auto shader = get_node_shader(L, *scene_node);
		if (!shader)
		{
			continue;
		}
		renderer->set_current_shader(shader);

		float reflection_threshold = 0.0f;
		renderer->get_shader_cache().update_uniform(shader, "scape_ReflectionThreshold", &reflection_threshold, sizeof(float));

		renderer->draw_node(L, *scene_node, delta);
	}

	graphics->setBlendMode(love::graphics::Graphics::BLEND_ALPHA, love::graphics::Graphics::BLENDALPHA_MULTIPLY);

	graphics->clear(
		{
			love::graphics::OptionalColorf(love::Colorf(0.0, 0.0, 0.0, 0.0)),
			love::graphics::OptionalColorf(),
			love::graphics::OptionalColorf()
		},
		love::OptionalInt(),
		love::OptionalDouble());

	for (auto& scene_node: reflective_or_refractive_scene_nodes)
	{
		auto shader = get_node_shader(L, *scene_node);
		if (!shader)
		{
			continue;
		}
		renderer->set_current_shader(shader);

		float reflection_threshold = 0.0f;
		renderer->get_shader_cache().update_uniform(shader, "scape_ReflectionThreshold", &reflection_threshold, sizeof(float));

		auto& material = scene_node->get_material();
        auto reflection_properties = glm::vec3(material.get_reflection_power(), material.get_reflection_distance(), material.get_roughness());
		renderer->get_shader_cache().update_uniform(shader, "scape_ReflectionProperties", &reflection_properties, sizeof(glm::vec3));

		auto color = scene_node->get_material().get_color();
		graphics->setColor(love::Colorf(color.r, color.g, color.b, color.a));

		renderer->draw_node(L, *scene_node, delta);
	}

	graphics->setColor(love::Colorf(1.0f, 1.0f, 1.0f, 1.0f));
}

void nbunny::ReflectionRendererPass::copy_g_buffer()
{	
	auto renderer = get_renderer();
	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	love::graphics::Graphics::RenderTargets render_targets;

	love::graphics::Graphics::ColorMask disabled_alpha_mask;
	disabled_alpha_mask.r = true;
	disabled_alpha_mask.g = true;
	disabled_alpha_mask.b = true;
	disabled_alpha_mask.a = false;
	graphics->setColorMask(disabled_alpha_mask);

	renderer->set_current_shader(nullptr);
	graphics->origin();
    graphics->setDepthMode(love::graphics::COMPARE_ALWAYS, false);
	graphics->setBlendMode(love::graphics::Graphics::BLEND_REPLACE, love::graphics::Graphics::BLENDALPHA_PREMULTIPLIED);

	render_targets.colors.emplace_back(reflection_buffer.get_canvas(NORMALS_INDEX));
	graphics->setCanvas(render_targets);
	graphics->clear(love::Colorf(0.0, 0.0, 0.0, 0.0), false, 1.0f);
	graphics->draw(g_buffer.get_canvas(DeferredRendererPass::NORMAL_INDEX), love::Matrix4());

	reflection_buffer.use();
	graphics->origin();
    graphics->setOrtho(reflection_buffer.get_width(), reflection_buffer.get_height(), !graphics->isCanvasActive());
    graphics->setDepthMode(love::graphics::COMPARE_ALWAYS, true);

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
	graphics->draw(g_buffer.get_canvas(0), love::Matrix4());

	graphics->flushStreamDraws();
}

nbunny::ReflectionRendererPass::ReflectionRendererPass(GBuffer& g_buffer) :
	RendererPass(RENDERER_PASS_REFLECTION),
	reflection_buffer({ love::PIXELFORMAT_RGBA16F, love::PIXELFORMAT_RGBA16F, love::PIXELFORMAT_RGBA16F }),
	g_buffer(g_buffer)
{
	// Nothing.
}

nbunny::GBuffer& nbunny::ReflectionRendererPass::get_r_buffer()
{
	return reflection_buffer;
}

void nbunny::ReflectionRendererPass::draw(lua_State* L, SceneNode& node, float delta)
{
	walk_all_nodes(node, delta);
	draw_nodes(L, delta);
}

void nbunny::ReflectionRendererPass::resize(int width, int height)
{
	reflection_buffer.resize(width, height);
}

void nbunny::ReflectionRendererPass::attach(Renderer& renderer)
{
	RendererPass::attach(renderer);

	load_builtin_shader(
		"Resources/Renderers/Reflection/Base.vert.glsl",
		"Resources/Renderers/Reflection/Base.frag.glsl");
}

static std::shared_ptr<nbunny::ReflectionRendererPass> nbunny_reflection_renderer_pass_create(
	sol::variadic_args args, sol::this_state S)
{
	lua_State *L = S;
	auto& g_buffer = sol::stack::get<nbunny::GBuffer&>(L, 2);
	return std::make_shared<nbunny::ReflectionRendererPass>(g_buffer);
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_reflectionrendererpass(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::ReflectionRendererPass>("NReflectionRendererPass",
		sol::base_classes, sol::bases<nbunny::RendererPass>(),
		"getRBuffer", &nbunny::ReflectionRendererPass::get_r_buffer,
		"getHasReflections", &nbunny::ReflectionRendererPass::get_has_reflections,
		sol::call_constructor, sol::factories(&nbunny_reflection_renderer_pass_create));

	sol::stack::push(L, T);

	return 1;
}
