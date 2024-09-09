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

#include "modules/keyboard/Keyboard.h"

void nbunny::ShadowRendererPass::walk_all_nodes(SceneNode& node, float delta)
{
	visible_scene_nodes = get_renderer()->get_all_scene_nodes();
	SceneNode::sort_by_position(visible_scene_nodes, get_renderer()->get_camera(), delta);

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

		if (!material.get_is_shadow_caster())
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
			if (light_node->get_casts_shadows())
			{
				directional_lights.push_back(light_node);
			}
		}
		else 
		{
			shadow_casting_scene_nodes.push_back(visible_scene_node);
		}
	}
}

void nbunny::ShadowRendererPass::calculate_viewing_frustum_corners(float near, float far, std::vector<glm::vec3>& result) const
{
	auto& camera = get_renderer()->get_camera();
	auto projection = glm::perspectiveLH(camera.get_field_of_view(), width / (float)height, near, far);
	auto inverse_projection_view = glm::inverse(projection * camera.get_view());

	result.clear();
	for (float x = 0.0f; x < 2.0f; x += 1.0f)
	{
		for (float y = 0.0f; y < 2.0f; y += 1.0f)
		{
			for (float z = 0.0f; z < 2.0f; z += 1.0f)
			{
				auto corner = glm::vec4(2.0f * x - 1.0f, 2.0f * y - 1.0f, 2.0f * z - 1.0f, 1.0f);
				corner = inverse_projection_view * corner;
				corner /= corner.w;

                result.push_back(glm::vec3(corner));
			}
		}
	}
}

glm::mat4 nbunny::ShadowRendererPass::get_light_view_matrix(const glm::vec3& center, float delta) const
{
	auto directional_light = directional_lights.at(0);

	Light light;
	directional_light->to_light(light, delta);

	return glm::lookAt(center + glm::vec3(light.position), center, glm::vec3(0.0f, 1.0f, 0.0f));
}

void nbunny::ShadowRendererPass::get_light_projection_view_matrix(int cascade_index, float delta, glm::mat4& projection_matrix, glm::mat4& view_matrix) const
{
	float near_plane = get_near_plane(cascade_index);
	float far_plane = get_far_plane(cascade_index);

	std::vector<glm::vec3> viewing_frustum_corners;
	calculate_viewing_frustum_corners(near_plane, far_plane, viewing_frustum_corners);

	auto center = glm::vec3(0.0f);
	for (auto& corner: viewing_frustum_corners)
	{
		center += corner;
	}
	center /= viewing_frustum_corners.size();
	view_matrix = get_light_view_matrix(center, delta);

	auto bounds_min = glm::vec3(std::numeric_limits<float>::infinity());
	auto bounds_max = glm::vec3(-std::numeric_limits<float>::infinity());
	for (auto& corner: viewing_frustum_corners)
	{
		auto point = glm::vec3(view_matrix * glm::vec4(corner, 1.0f));
		bounds_min = glm::min(point, bounds_min);
		bounds_max = glm::max(point, bounds_max);
	}

	bounds_min.z -= 10.0f;
	bounds_max.z += 10.0f;

	projection_matrix = glm::ortho(bounds_min.x, bounds_max.x, bounds_max.y, bounds_min.y, bounds_min.z, bounds_max.z);
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

	has_shadow_map = directional_lights.size() > 0;
	if (!has_shadow_map)
	{
		has_shadow_map = false;
		return;
	}

	love::graphics::Graphics::ColorMask disabled_mask;
	disabled_mask.r = false;
	disabled_mask.g = false;
	disabled_mask.b = false;
	disabled_mask.a = false;

	love::graphics::Graphics::ColorMask enabled_mask;
	enabled_mask.r = true;
	enabled_mask.g = true;
	enabled_mask.b = true;
	enabled_mask.a = true;

	graphics->setColorMask(disabled_mask);
	graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, true);
	graphics->setMeshCullMode(love::graphics::CULL_BACK);

	for (int i = 0; i < num_cascades; ++i)
	{
		glm::mat4 projection_matrix, view_matrix;

		love::graphics::Graphics::RenderTargets render_targets;

		render_targets.depthStencil = love::graphics::Graphics::RenderTarget(shadow_map, i);
		graphics->setCanvas(render_targets);

		get_light_projection_view_matrix(i, delta, projection_matrix, view_matrix);

		auto projection_transform = love::Matrix4(glm::value_ptr(projection_matrix));
		graphics->setProjection(projection_transform);
	
		love::math::Transform view_transform(love::Matrix4(glm::value_ptr(view_matrix)));
		graphics->replaceTransform(&view_transform);

		graphics->clear(
			love::graphics::OptionalColorf(),
			0,
			1.0f);

		Camera shadow_camera;
		shadow_camera.update(view_matrix, projection_matrix);

		for (auto& scene_node: shadow_casting_scene_nodes)
		{
			if (!shadow_camera.inside(*scene_node, delta))
			{
				continue;
			}

			auto shader = get_node_shader(L, *scene_node);
			if (!shader)
			{
				continue;
			}
			renderer->set_current_shader(shader);

			renderer->draw_node(L, *scene_node, delta);
		}
	}

	graphics->setColorMask(enabled_mask);
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
	settings.format = love::PIXELFORMAT_DEPTH16;
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

glm::mat4 nbunny::ShadowRendererPass::get_light_space_matrix(int cascade_index, float delta) const
{
	glm::mat4 projection_matrix, view_matrix;
	get_light_projection_view_matrix(cascade_index, delta, projection_matrix, view_matrix);

	return projection_matrix * view_matrix;
}

float nbunny::ShadowRendererPass::get_near_plane(int cascade_index) const
{
	float near_plane = get_renderer()->get_camera().get_near();
	float far_plane = get_renderer()->get_camera().get_far();

	float result = (far_plane - near_plane) * (cascade_index / (float)num_cascades) + near_plane;

	if (cascade_index > 0 && cascade_index < num_cascades)
	{
		result = glm::clamp(result - (far_plane - near_plane) / 10.0f, near_plane, far_plane);
	}

	return result;
}

float nbunny::ShadowRendererPass::get_far_plane(int cascade_index) const
{
	float near_plane = get_renderer()->get_camera().get_near();
	float far_plane = get_renderer()->get_camera().get_far();

	float result = (far_plane - near_plane) * ((cascade_index + 1) / (float)num_cascades) + near_plane;

	if (cascade_index > 0 && cascade_index < num_cascades)
	{
		result = glm::clamp(result + (far_plane - near_plane) / 10.0f, near_plane, far_plane);
	}

	return result;
}

glm::vec3 nbunny::ShadowRendererPass::get_light_direction(float delta) const
{
	auto directional_light = directional_lights.at(0);

	Light light;
	directional_light->to_light(light, delta);

	return glm::vec3(light.position);
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
