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
	for (auto& visible_scene_node: visible_scene_nodes)
	{
		auto material = visible_scene_node->get_material();

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

    reflection_buffer.use();

	graphics->clear(
		love::Colorf(0.0, 0.0, 0.0, 0.0),
		0,
		1.0f);

	if (reflective_or_refractive_scene_nodes.size() == 0)
	{
		return;
	}

	graphics->replaceTransform(&view);
	graphics->setProjection(projection);

	graphics->setBlendMode(love::graphics::Graphics::BLEND_ALPHA, love::graphics::Graphics::BLENDALPHA_MULTIPLY);

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

	for (auto& scene_node: reflective_or_refractive_scene_nodes)
	{
		auto shader = get_node_shader(L, *scene_node);
		if (!shader)
		{
			continue;
		}
		renderer->set_current_shader(shader);

        auto reflection_properties_uniform = shader->getUniformInfo("scape_ReflectionProperties");
        if (reflection_properties_uniform)
        {
            const auto& material = scene_node->get_material();
            auto properties = glm::vec3(material.get_reflection_power(), material.get_ratio_index_of_refraction(), material.get_roughness());
            std::memcpy(reflection_properties_uniform->floats, glm::value_ptr(properties), sizeof(glm::vec3));
            shader->updateUniform(reflection_properties_uniform, 1);
        }

        graphics->setMeshCullMode(love::graphics::CULL_BACK);

		graphics->setColorMask(disabledMask);
        graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, !scene_node->get_material().get_is_z_write_disabled());	
		renderer->draw_node(L, *scene_node, delta);

		graphics->setColorMask(enabledMask);
        graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, false);

		auto color = scene_node->get_material().get_color();
		graphics->setColor(love::Colorf(color.r, color.g, color.b, color.a));

		renderer->draw_node(L, *scene_node, delta);
	}

	graphics->setColorMask(enabledMask);
	graphics->setColor(love::Colorf(1.0f, 1.0f, 1.0f, 1.0f));
}

nbunny::ReflectionRendererPass::ReflectionRendererPass() :
	RendererPass(RENDERER_PASS_REFLECTION), reflection_buffer({ love::PIXELFORMAT_RGBA16F })
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
	return std::make_shared<nbunny::ReflectionRendererPass>();
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_reflectionrendererpass(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::ReflectionRendererPass>("NReflectionRendererPass",
		sol::base_classes, sol::bases<nbunny::RendererPass>(),
		"getRBuffer", &nbunny::ReflectionRendererPass::get_r_buffer,
		sol::call_constructor, sol::factories(&nbunny_reflection_renderer_pass_create));

	sol::stack::push(L, T);

	return 1;
}
