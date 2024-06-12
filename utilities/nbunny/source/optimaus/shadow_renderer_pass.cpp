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
	auto directional_light = directional_lights.at(0);

	float min_near_plane = get_renderer()->get_camera().get_near();
	float max_far_plane = get_renderer()->get_camera().get_far();

	float near_plane = min_near_plane + (max_far_plane - min_near_plane) * (cascade_index / (float)num_cascades);
	float far_plane = min_near_plane + (max_far_plane - min_near_plane) * ((cascade_index + 1) / (float)num_cascades);
	//float near_plane = min_near_plane;
	//float far_plane = max_far_plane;

	std::vector<glm::vec3> viewing_frustum_corners;
	calculate_viewing_frustum_corners(near_plane, far_plane, viewing_frustum_corners);

	// auto center = glm::vec3(0.0f);
	// for (auto& corner: viewing_frustum_corners)
	// {
	// 	center += corner;
	// }
	// center /= viewing_frustum_corners.size();
	//auto center = get_renderer()->get_camera().get_target_position();

	//view_matrix = get_light_view_matrix(center, delta);
	//view_matrix = glm::mat4(1.0f);

	auto frustum_min = glm::vec3(std::numeric_limits<float>::infinity());
	auto frustum_max = glm::vec3(-std::numeric_limits<float>::infinity());

	for (auto& corner: viewing_frustum_corners)
	{
		//auto point = glm::vec3(view_matrix * glm::vec4(corner, 1.0f));
		auto point = corner;
		frustum_min = glm::min(frustum_min, point);
		frustum_max = glm::max(frustum_max, point);
	}

	auto scene_min = directional_light->get_min();
	auto scene_max = directional_light->get_max();

	const int NUM_CORNERS = 8;
	glm::vec3 corners[NUM_CORNERS] =
	{
		glm::vec3(scene_min.x, scene_min.y, scene_min.z),
		glm::vec3(scene_max.x, scene_min.y, scene_min.z),
		glm::vec3(scene_min.x, scene_max.y, scene_min.z),
		glm::vec3(scene_min.x, scene_min.y, scene_max.z),
		glm::vec3(scene_max.x, scene_max.y, scene_min.z),
		glm::vec3(scene_max.x, scene_min.y, scene_max.z),
		glm::vec3(scene_min.x, scene_max.y, scene_max.z),
		glm::vec3(scene_max.x, scene_max.y, scene_max.z)
	};

	auto light_min = glm::vec3(std::numeric_limits<float>::infinity());
	auto light_max = glm::vec3(-std::numeric_limits<float>::infinity());

	for (int i = 0; i < NUM_CORNERS; ++i)
	{
		auto point = glm::vec3(get_renderer()->get_camera().get_view() * glm::vec4(corners[i], 1.0f));
		light_min = glm::min(light_min, point);
		light_max = glm::max(light_max, point);
	}

	auto bounds_min = glm::max(light_min, frustum_min);
	auto bounds_max = glm::min(light_max, frustum_max);
	auto center = (bounds_max - bounds_min) / 2.0f + bounds_min;
	view_matrix = get_light_view_matrix(center, delta);
	//auto bounds_min = frustum_min;
	//auto bounds_max = frustum_max;

	
	auto keyboard = love::Module::getInstance<love::keyboard::Keyboard>(love::Module::M_KEYBOARD);
	if (keyboard->isDown({ love::keyboard::Keyboard::KEY_SPACE })) {
	std::cout << "index:" << cascade_index << std::endl;
	std::cout << "min near: " << min_near_plane << std::endl;
	std::cout << "max far: " << max_far_plane << std::endl;
	std::cout << "near: " << near_plane << std::endl;
	std::cout << "far: " << far_plane << std::endl;
	std::cout << "light min: " << light_min.x << ", " << light_min.y << ", " << light_min.z << std::endl;
	std::cout << "light max: " << light_max.x << ", " << light_max.y << ", " << light_max.z << std::endl;
	std::cout << "bounds min: " << bounds_min.x << ", " << bounds_min.y << ", " << bounds_min.z << std::endl;
	std::cout << "bounds max: " << bounds_max.x << ", " << bounds_max.y << ", " << bounds_max.z << std::endl;
	std::cout << "frustum min: " << frustum_min.x << ", " << frustum_min.y << ", " << frustum_min.z << std::endl;
	std::cout << "frustum max: " << frustum_max.x << ", " << frustum_max.y << ", " << frustum_max.z << std::endl;
	auto p1 = projection_matrix * view_matrix * glm::vec4(32.0f, 0.0f, 32.0f, 1.0f);
	auto p2 = view_matrix * glm::vec4(32.0f, 0.0f, 32.0f, 1.0f);
	//view_matrix = get_light_view_matrix(get_renderer()->get_camera().get_target_position(), delta);
	std::cout << "p1: " << p1.x << ", " << p1.y << ", " << p1.z << ", " << p1.w << std::endl;
	std::cout << "p2: " << p2.x << ", " << p2.y << ", " << p2.z << ", " << p2.w << std::endl;
	std::cout << "center: " << center.x << ", " << center.y << ", " << center.z << std::endl;
	std::cout << std::endl;
	}

	auto size = bounds_max - bounds_min;
	auto half_size = size / glm::vec3(2.0f);
	//auto half_size = size;

	//projection_matrix = glm::ortho(-1.0f, 1.0f, -1.0f, 1.0f, bounds_min.z, bounds_max.z);
	//projection_matrix = glm::ortho(-10.0f, 10.0f, -10.0f, 10.0f, bounds_min.z, bounds_max.z);
	projection_matrix = glm::ortho(-half_size.x, half_size.x, half_size.y, -half_size.y, -half_size.z, half_size.z);
	//projection_matrix = glm::ortho(bounds_min.x, bounds_max.x, bounds_max.y, bounds_min.y, bounds_min.z, bounds_max.z);
	//projection_matrix = glm::ortho(frustum_min.x, frustum_max.x, frustum_max.y, frustum_min.y, frustum_min.z, frustum_max.z);
	//projection_matrix = glm::ortho(-1.0f, 1.0f, -1.0f, 1.0f, bounds_min.z, bounds_max)

 	//projection_matrix = glm::ortho(-half_size.x, half_size.x, half_size.y, -half_size.y, bounds_min.z, bounds_max.z);
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
			graphics->setMeshCullMode(love::graphics::CULL_BACK);

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

	return (far_plane - near_plane) * (cascade_index / (float)num_cascades) + near_plane;
}

float nbunny::ShadowRendererPass::get_far_plane(int cascade_index) const
{
	return get_near_plane(cascade_index + 1);
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
