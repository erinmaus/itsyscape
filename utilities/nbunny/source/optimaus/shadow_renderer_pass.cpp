////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/shadow_renderer_pass.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include <algorithm>
#include <limits>
#include "common/runtime.h"
#include "modules/graphics/Graphics.h"
#include "modules/math/Transform.h"
#include "nbunny/optimaus/shadow_renderer_pass.hpp"
#include "nbunny/optimaus/particle.hpp"

void nbunny::ShadowRendererPass::walk_all_nodes(SceneNode& node, float delta)
{
	visible_scene_nodes.clear();
	SceneNode::collect(node, visible_scene_nodes);

	shadow_casting_scene_nodes.clear();
	directional_lights.clear();

	for (auto& visible_scene_node: visible_scene_nodes)
	{
		auto& material = visible_scene_node->get_material();

		if (material.get_is_translucent())
		{
			continue;
		}

		if (material.get_color().a < 1.0f)
		{
			continue;
		}

		const auto& node_type = visible_scene_node->get_type();

		if (node_type == ParticleSceneNode::type_pointer)
		{
			continue;
		}

		if (node_type == AmbientLightSceneNode::type_pointer ||
		    node_type == PointLightSceneNode::type_pointer ||
		    node_type == FogSceneNode::type_pointer)
		{
			continue;
		}

		if (node_type == DirectionalLightSceneNode::type_pointer)
		{
			auto light_node = reinterpret_cast<DirectionalLightSceneNode*>(visible_scene_node);
			directional_lights.push_back(light_node);
		}
		else 
		{
			shadow_casting_scene_nodes.push_back(visible_scene_node);
		}
	}

	auto& camera = get_renderer()->get_camera();

	std::unordered_map<SceneNode*, glm::vec3> screen_positions;
	std::stable_sort(
		shadow_casting_scene_nodes.begin(),
		shadow_casting_scene_nodes.end(),
		[&](auto a, auto b)
		{
			auto a_screen_position = screen_positions.find(a);
			if (a_screen_position == screen_positions.end())
			{
				auto world = glm::vec3(b->get_transform().get_global(delta) * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f));
				auto p = glm::project(
					world,
					camera.get_view(),
					camera.get_projection(),
					glm::vec4(0.0f, 0.0f, 1.0f, 1.0f)
				);
				a_screen_position = screen_positions.insert(std::make_pair(a, p)).first;
			}

			auto b_screen_position = screen_positions.find(b);
			if (b_screen_position == screen_positions.end())
			{
				auto world = glm::vec3(a->get_transform().get_global(delta) * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f));
				auto p = glm::project(
					world,
					camera.get_view(),
					camera.get_projection(),
					glm::vec4(0.0f, 0.0f, 1.0f, 1.0f)
				);
				b_screen_position = screen_positions.insert(std::make_pair(b, p)).first;
			}

			return glm::floor(a_screen_position->second.z * 1000) > glm::floor(b_screen_position->second.z * 1000);
		});
}

void nbunny::ShadowRendererPass::calculate_viewing_frustum_corners()
{
	auto& camera = get_renderer()->get_camera();
	auto inverse_projection_view = glm::inverse(camera.get_projection() * camera.get_view());

	viewing_frustum_corners.clear();
	for (float x = 0.0f; x < 2.0f; x += 1.0f)
	{
		for (float y = 0.0f; y < 2.0f; y += 1.0f)
		{
			for (float z = 0.0f; z < 2.0f; z += 1.0f)
			{
				auto corner = glm::vec4(2.0f * x - 1.0f, 2.0f * y - 1.0f, 2.0f * z - 1.0f, 1.0f);
				corner = inverse_projection_view * corner;
				corner /= corner.w;

                viewing_frustum_corners.push_back(glm::vec3(corner));
			}
		}
	}
}

glm::mat4 nbunny::ShadowRendererPass::get_light_view_matrix(float delta) const
{
	auto directional_light = directional_lights.at(0);

	Light light;
	directional_light->to_light(light, delta);

	return glm::lookAt(glm::vec3(light.position), glm::vec3(0.0f), glm::vec3(0.0f, 1.0f, 0.0f));
}

void nbunny::ShadowRendererPass::get_light_projection_matrix(int cascade_index, glm::mat4& projection_matrix, float& near_plane, float& far_plane) const
{
	auto directional_light = directional_lights.at(0);

	auto frustum_min = glm::vec3(std::numeric_limits<float>::infinity());
	auto frustum_max = glm::vec3(-std::numeric_limits<float>::infinity());

	for (auto& corner: viewing_frustum_corners)
	{
		frustum_min = glm::min(frustum_min, corner);
		frustum_max = glm::max(frustum_max, corner);
	}

	auto light_min = directional_light->get_min();
	auto light_max = directional_light->get_max();
	light_min.z = (light_max.z - light_min.z) * (cascade_index / (float)num_cascades);

	auto bounds_min = glm::max(light_min, frustum_min);
	auto bounds_max = glm::min(light_max, frustum_max);

	projection_matrix = glm::ortho(bounds_min.x, bounds_max.x, bounds_min.y, bounds_max.y, bounds_min.z, bounds_max.z);
	near_plane = bounds_min.z;
	far_plane = bounds_max.z;
}

love::graphics::Shader* nbunny::ShadowRendererPass::get_node_shader(lua_State* L, const SceneNode& node)
{
	auto shader_resource = node.get_material().get_shader();
	if (!shader_resource || shader_resource->get_id() == 0)
	{
		return nullptr;
	}

    return RendererPass::get_node_shader(L, node);
}

void nbunny::ShadowRendererPass::draw_nodes(lua_State* L, float delta)
{
	auto renderer = get_renderer();
	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	graphics->clear(
		love::graphics::OptionalColorf(),
		0,
		1.0f);

	has_shadow_map = directional_lights.size() > 0;
	if (!has_shadow_map)
	{
		has_shadow_map = false;
		return;
	}

	calculate_viewing_frustum_corners();

	auto view_matrix = get_light_view_matrix(delta);
	love::math::Transform view_transform(love::Matrix4(glm::value_ptr(view_matrix)));
	graphics->replaceTransform(&view_transform);

	love::graphics::Graphics::ColorMask disabledMask;
	disabledMask.r = false;
	disabledMask.g = false;
	disabledMask.b = false;
	disabledMask.a = false;

	love::graphics::Graphics::ColorMask enabledMask;
	enabledMask.r = true;
	enabledMask.g = true;
	enabledMask.b = true;
	enabledMask.a = true;

	for (int i = 0; i < num_cascades; ++i)
	{
		glm::mat4 projection_matrix;
		float near_plane, far_plane;

		get_light_projection_matrix(i, projection_matrix, near_plane, far_plane);
		auto projection_transform = love::Matrix4(glm::value_ptr(projection_matrix));
		graphics->setProjection(projection_transform);

		love::graphics::Graphics::RenderTargets render_targets;

		render_targets.depthStencil = love::graphics::Graphics::RenderTarget(shadow_map, i);
		graphics->setCanvas(render_targets);

		for (auto& scene_node: visible_scene_nodes)
		{
			auto shader = get_node_shader(L, *scene_node);
			if (!shader)
			{
				continue;
			}
			renderer->set_current_shader(shader);

			graphics->setColorMask(disabledMask);
			graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, true);
			graphics->setMeshCullMode(love::graphics::CULL_FRONT);

			renderer->draw_node(L, *scene_node, delta);
		}
	}

	graphics->setColorMask(enabledMask);
}

nbunny::ShadowRendererPass::ShadowRendererPass(int num_cascades) :
	RendererPass(RENDERER_PASS_SHADOW), num_cascades(num_cascades)
{
	// Nothing.
}

nbunny::ShadowRendererPass::~ShadowRendererPass()
{
	if (shadow_map)
	{
		shadow_map->release();
	}
}

love::graphics::Canvas* nbunny::ShadowRendererPass::get_shadow_map()
{
	return shadow_map;
}

int nbunny::ShadowRendererPass::get_num_cascades() const
{
	return num_cascades;
}

bool nbunny::ShadowRendererPass::get_has_shadow_map() const
{
	return has_shadow_map;
}

void nbunny::ShadowRendererPass::draw(lua_State* L, SceneNode& node, float delta)
{
	walk_all_nodes(node, delta);
	draw_nodes(L, delta);
}

void nbunny::ShadowRendererPass::resize(int width, int height)
{
	if (this->width == width && this->height == height)
	{
		return;
	}

	if (shadow_map)
	{
		shadow_map->release();
	}

	this->width = width < 1 ? 1 : width;
	this->height = height < 1 ? 1 : height;

	love::graphics::Graphics* instance = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	love::graphics::Canvas::Settings settings;
	settings.width = this->width;
	settings.height = this->height;
	settings.layers = num_cascades;
	settings.dpiScale = instance->getScreenDPIScale();
	settings.format = love::PIXELFORMAT_DEPTH24;
	settings.type = love::graphics::TEXTURE_2D_ARRAY;
	settings.readable = true;

	shadow_map = instance->newCanvas(settings);
}

void nbunny::ShadowRendererPass::attach(Renderer& renderer)
{
	RendererPass::attach(renderer);

	load_builtin_shader(
		"Resources/Renderers/Shadow/Base.vert.glsl",
		"Resources/Renderers/Shadow/Base.frag.glsl");
}

static int nbunny_shadow_renderer_get_shadow_map(lua_State* L)
{
	auto renderer = sol::stack::get<nbunny::ShadowRendererPass*>(L, 1);
	auto shadow_map = renderer->get_shadow_map();
	shadow_map->retain();

	love::luax_pushtype(L, shadow_map);

	return 1;
}

static std::shared_ptr<nbunny::ShadowRendererPass> nbunny_shadow_renderer_pass_create(
	sol::variadic_args args, sol::this_state S)
{
	lua_State* L = S;
	int num_cascades = luaL_checkinteger(L, 2);
	return std::make_shared<nbunny::ShadowRendererPass>(num_cascades);
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_shadowrendererpass(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::ShadowRendererPass>("ShadowRendererPass",
		sol::base_classes, sol::bases<nbunny::RendererPass>(),
		"getShadowMap", nbunny_shadow_renderer_get_shadow_map,
		sol::call_constructor, sol::factories(&nbunny_shadow_renderer_pass_create));

	sol::stack::push(L, T);

	return 1;
}
