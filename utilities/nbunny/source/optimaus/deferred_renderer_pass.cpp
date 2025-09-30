////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/deferred_renderer_pass.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include <array>
#include "common/Matrix.h"
#include "common/Module.h"
#include "common/pixelformat.h"
#include "common/runtime.h"
#include "modules/graphics/Graphics.h"
#include "modules/graphics/opengl/OpenGL.h"
#include "modules/filesystem/Filesystem.h"
#include "modules/math/Transform.h"
#include "modules/graphics/opengl/OpenGL.h"
#include "nbunny/optimaus/deferred_renderer_pass.hpp"

static const int MAX_NUM_LIGHTS = 64;
static const std::string SHADER_DEFAULT                 = "Default";
static const std::string SHADER_AMBIENT_LIGHT           = "AmbientLight";
static const std::string SHADER_MULTI_AMBIENT_LIGHT     = "MultiAmbientLight";
static const std::string SHADER_DIRECTIONAL_LIGHT       = "DirectionalLight";
static const std::string SHADER_MULTI_DIRECTIONAL_LIGHT = "MultiDirectionalLight";
static const std::string SHADER_POINT_LIGHT             = "PointLight";
static const std::string SHADER_MULTI_POINT_LIGHT       = "MultiPointLight";
static const std::string SHADER_FOG                     = "Fog";
static const std::string SHADER_COPY_DEPTH              = "CopyDepth";
static const std::string SHADER_SHADOW                  = "Shadow";
static const std::string SHADER_MIX_LIGHTS              = "MixLights";

nbunny::DeferredRendererPass::DeferredRendererPass(const std::shared_ptr<ShadowRendererPass>& shadow_pass) :
	RendererPass(RENDERER_PASS_DEFERRED),
	shadow_pass(shadow_pass),
	g_buffer({ love::PIXELFORMAT_RGBA8, love::PIXELFORMAT_RG16F, love::PIXELFORMAT_RGBA8 }),
	depth_buffer({}),
	light_buffer(love::PIXELFORMAT_RGBA8, g_buffer),
	fog_buffer(love::PIXELFORMAT_RGBA8, g_buffer),
	shadow_buffer(love::PIXELFORMAT_RGBA8, g_buffer),
	output_buffer(love::PIXELFORMAT_RGBA8, g_buffer)
{
	// Nothing.
}

void nbunny::DeferredRendererPass::walk_all_nodes(SceneNode& node, float delta)
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

void nbunny::DeferredRendererPass::walk_visible_lights()
{
	const auto& all_scene_nodes = get_renderer()->get_all_scene_nodes();

	ambient_light_scene_nodes.clear();
	directional_light_scene_nodes.clear();
	point_light_scene_nodes.clear();
	fog_scene_nodes.clear();

	for (auto node: all_scene_nodes)
	{
		const auto& node_type = node->get_type();
		if (node_type == AmbientLightSceneNode::type_pointer ||
			node_type == DirectionalLightSceneNode::type_pointer ||
			node_type == PointLightSceneNode::type_pointer)
		{
			if (node_type == AmbientLightSceneNode::type_pointer)
			{
				ambient_light_scene_nodes.push_back(reinterpret_cast<AmbientLightSceneNode*>(node));
			}
			else if (node_type == DirectionalLightSceneNode::type_pointer)
			{
				directional_light_scene_nodes.push_back(reinterpret_cast<DirectionalLightSceneNode*>(node));
			}
			else if (node_type == PointLightSceneNode::type_pointer)
			{
				point_light_scene_nodes.push_back(reinterpret_cast<PointLightSceneNode*>(node));
			}
		}
		else if (node_type == FogSceneNode::type_pointer)
		{
			fog_scene_nodes.push_back(reinterpret_cast<FogSceneNode*>(node));
		}
	}

	std::stable_sort(
		fog_scene_nodes.begin(),
		fog_scene_nodes.end(),
		[&](auto a, auto b)
		{
			return a->get_current_far_distance() < b->get_current_far_distance();
		});
}

void nbunny::DeferredRendererPass::draw_ambient_light(lua_State* L, LightSceneNode& node, float delta)
{
	auto shader = get_builtin_shader(L, BUILTIN_SHADER_AMBIENT_LIGHT, SHADER_AMBIENT_LIGHT);
	get_renderer()->set_current_shader(shader);

	Light light;
	node.to_light(light, delta);

	ambient_light += light.ambient_coefficient;

	auto& shader_cache = get_renderer()->get_shader_cache();
	shader_cache.update_uniform(shader, "scape_SpecularOutlineTexture", g_buffer.get_canvas(SPECULAR_OUTLINE_INDEX));
	shader_cache.update_uniform(shader, "scape_LightAmbientCoefficient", &light.ambient_coefficient, sizeof(float));
	shader_cache.update_uniform(shader, "scape_LightColor", glm::value_ptr(light.color), sizeof(glm::vec3));

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	graphics->draw(g_buffer.get_canvas(COLOR_INDEX), love::Matrix4());
}

void nbunny::DeferredRendererPass::draw_ambient_lights(lua_State* L, float delta)
{
	auto& shader_cache = get_renderer()->get_shader_cache();
	auto shader = get_builtin_shader(L, BUILTIN_SHADER_MULTI_AMBIENT_LIGHT, SHADER_MULTI_AMBIENT_LIGHT);
	get_renderer()->set_current_shader(shader);

	std::array<glm::vec3, MAX_NUM_LIGHTS> light_colors; 
	std::array<float, MAX_NUM_LIGHTS> ambient_coefficients;

	int index = 0;
	for (auto& ambient_light: ambient_light_scene_nodes)
	{
		if (index >= MAX_NUM_LIGHTS)
		{
			break;
		}

		Light light;
		ambient_light->to_light(light, delta);

		light_colors.at(index) = light.color;
		ambient_coefficients.at(index) = light.ambient_coefficient;
		++index;

		this->ambient_light += light.ambient_coefficient;
	}

	shader_cache.update_uniform(shader, "scape_SpecularOutlineTexture", g_buffer.get_canvas(SPECULAR_OUTLINE_INDEX));
	shader_cache.update_uniform(shader, "scape_LightAmbientCoefficient", &ambient_coefficients[0], sizeof(float) * index);
	shader_cache.update_uniform(shader, "scape_LightColor", glm::value_ptr(light_colors[0]), sizeof(glm::vec3) * index);
	shader_cache.update_uniform(shader, "scape_NumLights", &index, sizeof(int));

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	graphics->draw(g_buffer.get_canvas(COLOR_INDEX), love::Matrix4());
}

void nbunny::DeferredRendererPass::draw_directional_light(lua_State* L, LightSceneNode& node, float delta)
{
	auto shader = get_builtin_shader(L, BUILTIN_SHADER_DIRECTIONAL_LIGHT, SHADER_DIRECTIONAL_LIGHT);
	get_renderer()->set_current_shader(shader);

	Light light;
	node.to_light(light, delta);

	auto& shader_cache = get_renderer()->get_shader_cache();
	shader_cache.update_uniform(shader, "scape_DepthTexture", g_buffer.get_canvas(DEPTH_INDEX));
	shader_cache.update_uniform(shader, "scape_NormalTexture", g_buffer.get_canvas(NORMAL_INDEX));
	shader_cache.update_uniform(shader, "scape_SpecularOutlineTexture", g_buffer.get_canvas(SPECULAR_OUTLINE_INDEX));

	shader_cache.update_uniform(shader, "scape_LightDirection", glm::value_ptr(light.position), sizeof(glm::vec3));
	shader_cache.update_uniform(shader, "scape_LightColor", glm::value_ptr(light.color), sizeof(glm::vec3));

	auto camera_target = get_renderer()->get_camera().get_target_position();
	shader_cache.update_uniform(shader, "scape_CameraTarget", glm::value_ptr(camera_target), sizeof(glm::vec3));

	auto camera_eye = get_renderer()->get_camera().get_eye_position();
	shader_cache.update_uniform(shader, "scape_CameraEye", glm::value_ptr(camera_eye), sizeof(glm::vec3));

	auto inverse_projection_matrix = glm::inverse(get_renderer()->get_camera().get_projection());
	shader_cache.update_uniform(shader, "scape_InverseProjectionMatrix", glm::value_ptr(inverse_projection_matrix), sizeof(glm::mat4));

	auto inverse_view_matrix = glm::inverse(get_renderer()->get_camera().get_view());
	shader_cache.update_uniform(shader, "scape_InverseViewMatrix", glm::value_ptr(inverse_view_matrix), sizeof(glm::mat4));

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	graphics->draw(g_buffer.get_canvas(COLOR_INDEX), love::Matrix4());
}

void nbunny::DeferredRendererPass::draw_directional_lights(lua_State* L, float delta)
{
	auto& shader_cache = get_renderer()->get_shader_cache();
	auto shader = get_builtin_shader(L, BUILTIN_SHADER_MULTI_DIRECTIONAL_LIGHT, SHADER_MULTI_DIRECTIONAL_LIGHT);
	get_renderer()->set_current_shader(shader);

	std::array<glm::vec3, MAX_NUM_LIGHTS> light_colors;
	std::array<glm::vec3, MAX_NUM_LIGHTS> light_directions;

	int index = 0;
	for (auto& directional_light: directional_light_scene_nodes)
	{
		if (index >= MAX_NUM_LIGHTS)
		{
			break;
		}

		Light light;
		directional_light->to_light(light, delta);

		light_colors.at(index) = light.color;
		light_directions.at(index) = glm::vec3(light.position);
		++index;
	}

	shader_cache.update_uniform(shader, "scape_LightColor", glm::value_ptr(light_colors[0]), sizeof(glm::vec3) * index);
	shader_cache.update_uniform(shader, "scape_LightDirection", glm::value_ptr(light_directions[0]), sizeof(glm::vec3) * index);
	shader_cache.update_uniform(shader, "scape_NumLights", &index, sizeof(int));

	shader_cache.update_uniform(shader, "scape_DepthTexture", g_buffer.get_canvas(DEPTH_INDEX));
	shader_cache.update_uniform(shader, "scape_NormalTexture", g_buffer.get_canvas(NORMAL_INDEX));
	shader_cache.update_uniform(shader, "scape_SpecularOutlineTexture", g_buffer.get_canvas(SPECULAR_OUTLINE_INDEX));

	auto camera_target = get_renderer()->get_camera().get_target_position();
	shader_cache.update_uniform(shader, "scape_CameraTarget", glm::value_ptr(camera_target), sizeof(glm::vec3));

	auto camera_eye = get_renderer()->get_camera().get_eye_position();
	shader_cache.update_uniform(shader, "scape_CameraEye", glm::value_ptr(camera_eye), sizeof(glm::vec3));

	auto inverse_projection_matrix = glm::inverse(get_renderer()->get_camera().get_projection());
	shader_cache.update_uniform(shader, "scape_InverseProjectionMatrix", glm::value_ptr(inverse_projection_matrix), sizeof(glm::mat4));

	auto inverse_view_matrix = glm::inverse(get_renderer()->get_camera().get_view());
	shader_cache.update_uniform(shader, "scape_InverseViewMatrix", glm::value_ptr(inverse_view_matrix), sizeof(glm::mat4));

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	graphics->draw(g_buffer.get_canvas(COLOR_INDEX), love::Matrix4());
}

void nbunny::DeferredRendererPass::draw_point_light(lua_State* L, LightSceneNode& node, float delta)
{
	auto shader = get_builtin_shader(L, BUILTIN_SHADER_POINT_LIGHT, SHADER_POINT_LIGHT);
	get_renderer()->set_current_shader(shader);

	Light light;
	node.to_light(light, delta);

	auto& shader_cache = get_renderer()->get_shader_cache();
	shader_cache.update_uniform(shader, "scape_DepthTexture", g_buffer.get_canvas(DEPTH_INDEX));
	shader_cache.update_uniform(shader, "scape_NormalTexture", g_buffer.get_canvas(NORMAL_INDEX));
	shader_cache.update_uniform(shader, "scape_SpecularOutlineTexture", g_buffer.get_canvas(SPECULAR_OUTLINE_INDEX));
	
	shader_cache.update_uniform(shader, "scape_LightPosition", glm::value_ptr(light.position), sizeof(glm::vec3));
	shader_cache.update_uniform(shader, "scape_LightColor", glm::value_ptr(light.color), sizeof(glm::vec3));
	shader_cache.update_uniform(shader, "scape_LightAttenuation", &light.attenuation, sizeof(float));

	auto inverse_projection_matrix = glm::inverse(get_renderer()->get_camera().get_projection());
	shader_cache.update_uniform(shader, "scape_InverseProjectionMatrix", glm::value_ptr(inverse_projection_matrix), sizeof(glm::mat4));

	auto inverse_view_matrix = glm::inverse(get_renderer()->get_camera().get_view());
	shader_cache.update_uniform(shader, "scape_InverseViewMatrix", glm::value_ptr(inverse_view_matrix), sizeof(glm::mat4));

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	graphics->draw(g_buffer.get_canvas(COLOR_INDEX), love::Matrix4());
}

void nbunny::DeferredRendererPass::draw_point_lights(lua_State* L, float delta)
{
	auto& shader_cache = get_renderer()->get_shader_cache();
	auto shader = get_builtin_shader(L, BUILTIN_SHADER_MULTI_POINT_LIGHT, SHADER_MULTI_POINT_LIGHT);
	get_renderer()->set_current_shader(shader);

	std::array<glm::vec3, MAX_NUM_LIGHTS> light_colors;
	std::array<glm::vec3, MAX_NUM_LIGHTS> light_positions;
	std::array<float, MAX_NUM_LIGHTS> light_attenuations;

	int index = 0;
	for (auto& point_light: point_light_scene_nodes)
	{
		if (index >= MAX_NUM_LIGHTS)
		{
			break;
		}

		Light light;
		point_light->to_light(light, delta);

		light_colors.at(index) = light.color;
		light_positions.at(index) = glm::vec3(light.position);
		light_attenuations.at(index) = light.attenuation;

		++index;
	}
	
	shader_cache.update_uniform(shader, "scape_LightPosition", glm::value_ptr(light_positions[0]), sizeof(glm::vec3) * index);
	shader_cache.update_uniform(shader, "scape_LightColor", glm::value_ptr(light_colors[0]), sizeof(glm::vec3) * index);
	shader_cache.update_uniform(shader, "scape_LightAttenuation", &light_attenuations[0], sizeof(float) * index);
	shader_cache.update_uniform(shader, "scape_NumLights", &index, sizeof(int));

	auto camera_target = get_renderer()->get_camera().get_target_position();
	shader_cache.update_uniform(shader, "scape_CameraTarget", glm::value_ptr(camera_target), sizeof(glm::vec3));

	auto camera_eye = get_renderer()->get_camera().get_eye_position();
	shader_cache.update_uniform(shader, "scape_CameraEye", glm::value_ptr(camera_eye), sizeof(glm::vec3));

	shader_cache.update_uniform(shader, "scape_DepthTexture", g_buffer.get_canvas(DEPTH_INDEX));
	shader_cache.update_uniform(shader, "scape_NormalTexture", g_buffer.get_canvas(NORMAL_INDEX));
	shader_cache.update_uniform(shader, "scape_SpecularOutlineTexture", g_buffer.get_canvas(SPECULAR_OUTLINE_INDEX));

	auto inverse_projection_matrix = glm::inverse(get_renderer()->get_camera().get_projection());
	shader_cache.update_uniform(shader, "scape_InverseProjectionMatrix", glm::value_ptr(inverse_projection_matrix), sizeof(glm::mat4));

	auto inverse_view_matrix = glm::inverse(get_renderer()->get_camera().get_view());
	shader_cache.update_uniform(shader, "scape_InverseViewMatrix", glm::value_ptr(inverse_view_matrix), sizeof(glm::mat4));

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	graphics->draw(g_buffer.get_canvas(COLOR_INDEX), love::Matrix4());
}

void nbunny::DeferredRendererPass::draw_fog(lua_State* L, FogSceneNode& node, float delta)
{
	auto shader = get_builtin_shader(L, BUILTIN_SHADER_FOG, SHADER_FOG);
	get_renderer()->set_current_shader(shader);

	Light light;
	node.to_light(light, delta);

	auto& shader_cache = get_renderer()->get_shader_cache();
	shader_cache.update_uniform(shader, "scape_DepthTexture", g_buffer.get_canvas(DEPTH_INDEX));
	shader_cache.update_uniform(shader, "scape_SpecularOutlineTexture", g_buffer.get_canvas(SPECULAR_OUTLINE_INDEX));

	auto inverse_projection_matrix = glm::inverse(get_renderer()->get_camera().get_projection());
	shader_cache.update_uniform(shader, "scape_InverseProjectionMatrix", glm::value_ptr(inverse_projection_matrix), sizeof(glm::mat4));

	auto inverse_view_matrix = glm::inverse(get_renderer()->get_camera().get_view());
	shader_cache.update_uniform(shader, "scape_InverseViewMatrix", glm::value_ptr(inverse_view_matrix), sizeof(glm::mat4));

	auto fog_parameters = glm::vec2(light.near_distance, light.far_distance);
	shader_cache.update_uniform(shader, "scape_FogParameters", glm::value_ptr(fog_parameters), sizeof(glm::vec2));
	shader_cache.update_uniform(shader, "scape_FogColor", glm::value_ptr(light.color), sizeof(glm::vec3));

	glm::vec3 camera_eye;
	switch (node.get_follow_mode())
	{
		case FogSceneNode::FOLLOW_MODE_EYE:
		default:
			camera_eye = get_renderer()->get_camera().get_eye_position();
			break;
		case FogSceneNode::FOLLOW_MODE_TARGET:
			camera_eye = get_renderer()->get_camera().get_target_position();
			break;
		case FogSceneNode::FOLLOW_MODE_SELF:
			camera_eye = light.position;
			break;
	}

	shader_cache.update_uniform(shader, "scape_CameraEye", glm::value_ptr(camera_eye), sizeof(glm::vec3));

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	graphics->draw(g_buffer.get_canvas(COLOR_INDEX), love::Matrix4());
}

void nbunny::DeferredRendererPass::copy_depth_buffer(lua_State* L, float delta)
{
	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	depth_buffer.use();

	graphics->setDepthMode(love::graphics::COMPARE_ALWAYS, true);
	graphics->origin();
	graphics->setOrtho(g_buffer.get_width(), g_buffer.get_height(), !graphics->isCanvasActive());

	graphics->clear(love::graphics::OptionalColorf(), false, 1.0f);

	auto shader = get_builtin_shader(L, BUILTIN_SHADER_DEPTH_COPY, SHADER_COPY_DEPTH);
	get_renderer()->set_current_shader(shader);

	graphics->draw(g_buffer.get_canvas(0), love::Matrix4());

	graphics->flushStreamDraws();

	if (!stencil_write_drawable_scene_nodes.empty())
	{
		auto renderer = get_renderer();

		const auto& camera = renderer->get_camera();
		auto view_matrix = camera.get_view();
		auto projection_matrix = camera.get_projection();
		love::math::Transform view(love::Matrix4(glm::value_ptr(view_matrix)));
		love::Matrix4 projection(glm::value_ptr(projection_matrix));

		graphics->replaceTransform(&view);
		graphics->setProjection(projection);
	
		graphics->setBlendMode(love::graphics::Graphics::BLEND_REPLACE, love::graphics::Graphics::BLENDALPHA_PREMULTIPLIED);
		graphics->setMeshCullMode(love::graphics::CULL_BACK);
		graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, true);

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
}

void nbunny::DeferredRendererPass::draw_shadows(lua_State* L, float delta)
{
	if (!shadow_pass || !shadow_pass->get_has_shadow_map())
	{
		return;
	}

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	shadow_buffer.use(false);
	graphics->clear(love::Colorf(0.0f, 0.0f, 0.0f, 0.0f), love::OptionalInt(), love::OptionalDouble());

	graphics->setDepthMode(love::graphics::COMPARE_ALWAYS, false);
	graphics->setBlendMode(love::graphics::Graphics::BLEND_ALPHA, love::graphics::Graphics::BLENDALPHA_MULTIPLY);
	graphics->origin();
	graphics->setOrtho(g_buffer.get_width(), g_buffer.get_height(), !graphics->isCanvasActive());
	graphics->setColor(love::Colorf(1.0f, 1.0f, 1.0f, 1.0f));

	auto shader = get_builtin_shader(L, BUILTIN_SHADER_SHADOW, SHADER_SHADOW);
	get_renderer()->set_current_shader(shader);

	auto& shader_cache = get_renderer()->get_shader_cache();
	shader_cache.update_uniform(shader, "scape_DepthTexture", g_buffer.get_canvas(DEPTH_INDEX));
	shader_cache.update_uniform(shader, "scape_NormalTexture", g_buffer.get_canvas(NORMAL_INDEX));
	shader_cache.update_uniform(shader, "scape_SpecularOutlineTexture", g_buffer.get_canvas(SPECULAR_OUTLINE_INDEX));

	auto inverse_projection_matrix = glm::inverse(get_renderer()->get_camera().get_projection());
	shader_cache.update_uniform(shader, "scape_InverseProjectionMatrix", glm::value_ptr(inverse_projection_matrix), sizeof(glm::mat4));

	auto view_matrix = get_renderer()->get_camera().get_view();
	shader_cache.update_uniform(shader, "scape_View", glm::value_ptr(view_matrix), sizeof(glm::mat4));

	auto inverse_view_matrix = glm::inverse(view_matrix);
	shader_cache.update_uniform(shader, "scape_InverseViewMatrix", glm::value_ptr(inverse_view_matrix), sizeof(glm::mat4));

	auto shadow_map = shadow_pass->get_shadow_map();
	shader_cache.update_uniform(shader, "scape_ShadowMap", static_cast<love::graphics::Texture*>(shadow_map));

	auto texel_size = glm::vec2(1.0f / shadow_map->getWidth(), 1.0f / shadow_map->getHeight());
	shader_cache.update_uniform(shader, "scape_TexelSize", glm::value_ptr(texel_size), sizeof(glm::vec2));

	auto light_direction = shadow_pass->get_light_direction(delta);
	shader_cache.update_uniform(shader, "scape_LightDirection", glm::value_ptr(light_direction), sizeof(glm::vec3));

	std::vector<glm::mat4> light_space_matrices;
	std::vector<glm::vec2> near_planes;
	for (int i = 0; i < shadow_pass->get_num_cascades(); ++i)
	{
		auto light_space_matrix = shadow_pass->get_light_space_matrix(i, delta);
		float near_plane = shadow_pass->get_near_plane(i);
		float far_plane = shadow_pass->get_far_plane(i);

		light_space_matrices.push_back(light_space_matrix);
		near_planes.emplace_back(near_plane, far_plane);
	}

	shader_cache.update_uniform(shader, "scape_CascadeLightSpaceMatrices", glm::value_ptr(light_space_matrices[0]), sizeof(glm::mat4) * shadow_pass->get_num_cascades());
	shader_cache.update_uniform(shader, "scape_CascadePlanes", glm::value_ptr(near_planes[0]), sizeof(glm::vec2) * shadow_pass->get_num_cascades());

	int num_cascades = shadow_pass->get_num_cascades();
	shader_cache.update_uniform(shader, "scape_NumCascades", &num_cascades, sizeof(int));
	
	auto shadow_alpha = std::max(1.0f - std::min(ambient_light, 1.0f), 0.3f);
	shader_cache.update_uniform(shader, "scape_ShadowAlpha", &shadow_alpha, sizeof(float));

	float near = get_renderer()->get_camera().get_near();
	shader_cache.update_uniform(shader, "scape_Near", &near, sizeof(float));

	float far = get_renderer()->get_camera().get_far();
	shader_cache.update_uniform(shader, "scape_Far", &far, sizeof(float));

	graphics->draw(g_buffer.get_canvas(DEPTH_INDEX), love::Matrix4());

	output_buffer.use(false);
	get_renderer()->set_current_shader(nullptr);
	graphics->draw(shadow_buffer.get_color(), love::Matrix4());
}

void nbunny::DeferredRendererPass::draw_nodes(lua_State* L, float delta, const std::vector<SceneNode*>& nodes)
{
	auto renderer = get_renderer();
	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	love::graphics::CompareMode depth_compare_mode = love::graphics::COMPARE_EQUAL;
	bool depth_write_enabled = false;
	graphics->getDepthMode(depth_compare_mode, depth_write_enabled);

	for (auto& scene_node: nodes)
	{
		auto shader = get_node_shader(L, *scene_node);
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

void nbunny::DeferredRendererPass::draw_pass(lua_State* L, float delta)
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

	auto clear_color = renderer->get_clear_color();
	graphics->clear(
		{
			love::Colorf(clear_color.x, clear_color.y, clear_color.z, clear_color.w),
			love::Colorf(0.0, 0.0, 0.0, 0.0),
			love::Colorf(0.0, 0.0, 0.0, 0.0)
		},
		love::OptionalInt(),
		love::OptionalDouble());
	
	graphics->setBlendMode(love::graphics::Graphics::BLEND_ALPHA, love::graphics::Graphics::BLENDALPHA_MULTIPLY);
	graphics->setMeshCullMode(love::graphics::CULL_BACK);

	graphics->setDepthMode(love::graphics::COMPARE_EQUAL, false);
	draw_nodes(L, delta, drawable_scene_nodes);

	if (!stencil_masked_drawable_scene_nodes.empty())
	{
		graphics->setStencilTest(love::graphics::COMPARE_EQUAL, 0);
		draw_nodes(L, delta, stencil_masked_drawable_scene_nodes);
		graphics->setStencilTest(love::graphics::COMPARE_ALWAYS, 0);
	}

	graphics->setColor(love::Colorf(1.0f, 1.0f, 1.0f, 1.0f));
}

void nbunny::DeferredRendererPass::draw_lights(lua_State* L, float delta)
{
	light_buffer.use(false);

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	graphics->setBlendMode(love::graphics::Graphics::BLEND_ADD, love::graphics::Graphics::BLENDALPHA_PREMULTIPLIED);

	glad::glBlendFunc(GL_ONE, GL_ONE);

	graphics->clear(love::Colorf(0.0f, 0.0f, 0.0f, 0.0f), love::OptionalInt(), love::OptionalDouble());

	graphics->setDepthMode(love::graphics::COMPARE_ALWAYS, false);
	graphics->origin();
	graphics->setOrtho(g_buffer.get_width(), g_buffer.get_height(), !graphics->isCanvasActive());

	if (directional_light_scene_nodes.empty() && ambient_light_scene_nodes.empty() && point_light_scene_nodes.empty())
	{
		AmbientLightSceneNode full_lit_node(0);
		full_lit_node.set_current_ambience(1.0f);
		full_lit_node.set_previous_ambience(1.0f);

		draw_ambient_light(L, full_lit_node, delta);
	}

	ambient_light = 0.0f;

	draw_directional_lights(L, delta);
	draw_ambient_lights(L, delta);
	draw_point_lights(L, delta);

	// We want to ensure all draws have been submitted before restoring
	// the blend state.
	graphics->flushStreamDraws();

	// Restore LOVE's BLEND_ADD.
	glad::glBlendFuncSeparate(GL_ONE, GL_ZERO, GL_ONE, GL_ONE);

	mix_lights(L);
}

void nbunny::DeferredRendererPass::draw_fog(lua_State* L, float delta)
{
	if (fog_scene_nodes.empty())
	{
		return;
	}

	fog_buffer.use(false);

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	graphics->clear(love::Colorf(0.0f, 0.0f, 0.0f, 0.0f), love::OptionalInt(), love::OptionalDouble());

	graphics->setDepthMode(love::graphics::COMPARE_ALWAYS, false);
	graphics->origin();
	graphics->setOrtho(g_buffer.get_width(), g_buffer.get_height(), false);
	graphics->setBlendMode(
		love::graphics::Graphics::BLEND_ALPHA,
		love::graphics::Graphics::BLENDALPHA_PREMULTIPLIED);

	for (auto fog: fog_scene_nodes)
	{
		draw_fog(L, *fog, delta);
	}

	mix_fog();
}

void nbunny::DeferredRendererPass::mix_lights(lua_State* L)
{
	output_buffer.use(false);
	get_renderer()->set_current_shader(nullptr);

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	graphics->setDepthMode(love::graphics::COMPARE_ALWAYS, false);
	graphics->setBlendMode(love::graphics::Graphics::BLEND_REPLACE, love::graphics::Graphics::BLENDALPHA_PREMULTIPLIED);
	graphics->origin();
	graphics->setOrtho(g_buffer.get_width(), g_buffer.get_height(), false);
	
	auto shader = get_builtin_shader(L, BUILTIN_SHADER_MIX_LIGHTS, SHADER_MIX_LIGHTS);
	get_renderer()->set_current_shader(shader);

	auto color_texture_uniform = shader->getUniformInfo("scape_ColorTexture");
	if (color_texture_uniform)
	{
		auto texture = static_cast<love::graphics::Texture*>(g_buffer.get_canvas(COLOR_INDEX));
		shader->sendTextures(color_texture_uniform, &texture, 1);
	}

	graphics->draw(light_buffer.get_color(), love::Matrix4());

	graphics->setCanvas();

	get_renderer()->set_current_shader(nullptr);
}

void nbunny::DeferredRendererPass::mix_fog()
{
	output_buffer.use(false);
	get_renderer()->set_current_shader(nullptr);

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	graphics->setDepthMode(love::graphics::COMPARE_ALWAYS, false);
	graphics->origin();
	graphics->setOrtho(g_buffer.get_width(), g_buffer.get_height(), false);

	graphics->setBlendMode(love::graphics::Graphics::BLEND_ALPHA, love::graphics::Graphics::BLENDALPHA_PREMULTIPLIED);
	graphics->draw(fog_buffer.get_color(), love::Matrix4());

	graphics->setCanvas();
}

love::graphics::Shader* nbunny::DeferredRendererPass::get_builtin_shader(lua_State* L, int builtin_id, const std::string& filename, bool is_light)
{
	return get_renderer()->get_shader_cache().build(
		get_renderer_pass_id(),
		builtin_id,
		[&](const auto& base_vertex_source, const auto& base_pixel_source, auto& v, auto& p)
		{
			std::string base = "Resources/Renderers/Deferred/";
			auto vertex_filename = base;
			if (is_light)
			{
				vertex_filename += "Light.vert.glsl";
			}
			else
			{
				vertex_filename += filename + ".vert.glsl";
			}

			auto pixel_filename = base + filename + ".frag.glsl";

			auto filesystem = love::Module::getInstance<love::filesystem::Filesystem>(love::Module::M_FILESYSTEM);

			auto vertex_file_data = filesystem->read(vertex_filename.c_str());
			auto pixel_file_data = filesystem->read(pixel_filename.c_str());

			std::string vertex_source(reinterpret_cast<const char*>(vertex_file_data->getData()), vertex_file_data->getSize());
			std::string pixel_source(reinterpret_cast<const char*>(pixel_file_data->getData()), pixel_file_data->getSize());

			auto shader_source = ShaderCache::ShaderSource(vertex_source, pixel_source);
			if (!is_light)
			{
				shader_source.combine("glsl3", base_vertex_source, base_pixel_source, v, p);
			}
			else
			{
				shader_source.combine("glsl3", "", "", v, p);
			}

			love::luax_getfunction(L, "graphics", "_shaderCodeToGLSL");

			lua_pushboolean(L, get_renderer()->get_shader_cache().get_is_mobile());
			lua_pushlstring(L, v.c_str(), v.size());
			lua_pushlstring(L, p.c_str(), p.size());

			if (lua_pcall(L, 3, 2, 0) != 0)
				luaL_error(L, "%s", lua_tostring(L, -1));

			v = luaL_checkstring(L, -2);
			p = luaL_checkstring(L, -1);

			lua_pop(L, 2);
		});
}

love::graphics::Shader* nbunny::DeferredRendererPass::get_node_shader(lua_State* L, const SceneNode& node)
{
	auto shader_resource = node.get_material().get_shader();
	if (!shader_resource || shader_resource->get_id() == 0)
	{
		return get_builtin_shader(L, BUILTIN_SHADER_DEFAULT, SHADER_DEFAULT, false);
	}

	return RendererPass::get_node_shader(L, node);
}

nbunny::GBuffer& nbunny::DeferredRendererPass::get_g_buffer()
{
	return g_buffer;
}

nbunny::GBuffer& nbunny::DeferredRendererPass::get_depth_buffer()
{
	return depth_buffer;
}

nbunny::LBuffer& nbunny::DeferredRendererPass::get_output_buffer()
{
	return output_buffer;
}

void nbunny::DeferredRendererPass::draw(lua_State* L, SceneNode& node, float delta)
{
	walk_all_nodes(node, delta);
	walk_visible_lights();
	draw_pass(L, delta);
	draw_lights(L, delta);
	draw_shadows(L, delta);
	draw_fog(L, delta);

	copy_depth_buffer(L, delta);
}

void nbunny::DeferredRendererPass::resize(int width, int height)
{
	g_buffer.resize(width, height);
	depth_buffer.resize(width, height);
	light_buffer.resize(g_buffer);
	fog_buffer.resize(g_buffer);
	shadow_buffer.resize(g_buffer);
	output_buffer.resize(g_buffer);
}

void nbunny::DeferredRendererPass::attach(Renderer& renderer)
{
	RendererPass::attach(renderer);

	load_builtin_shader(
		"Resources/Renderers/Deferred/Base.vert.glsl",
		"Resources/Renderers/Deferred/Base.frag.glsl");
}

static int nbunny_deferred_renderer_pass_constructor(lua_State* L)
{
	std::shared_ptr<nbunny::ShadowRendererPass> shadow_pass;
	if (lua_toboolean(L, 2))
	{
		shadow_pass = nbunny::lua::get<nbunny::ShadowRendererPass>(L, 2);
	}

	nbunny::lua::push(L, std::make_shared<nbunny::DeferredRendererPass>(shadow_pass));

	return 1;
}

static int nbunny_deferred_renderer_pass_get_g_buffer(lua_State* L)
{
	auto self = nbunny::lua::get<nbunny::DeferredRendererPass*>(L, 1);
	nbunny::lua::push(L, &self->get_g_buffer());
	return 1;
}

static int nbunny_deferred_renderer_pass_get_depth_buffer(lua_State* L)
{
	auto self = nbunny::lua::get<nbunny::DeferredRendererPass*>(L, 1);
	nbunny::lua::push(L, &self->get_depth_buffer());
	return 1;
}

static int nbunny_deferred_renderer_pass_get_c_buffer(lua_State* L)
{
	auto self = nbunny::lua::get<nbunny::DeferredRendererPass*>(L, 1);
	nbunny::lua::push(L, &self->get_output_buffer());
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_deferredrendererpass(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "getGBuffer", &nbunny_deferred_renderer_pass_get_g_buffer },
		{ "getDepthBuffer", &nbunny_deferred_renderer_pass_get_depth_buffer },
		{ "getCBuffer", &nbunny_deferred_renderer_pass_get_c_buffer },
		{ nullptr, nullptr }
	};
	
	nbunny::lua::register_child_type<nbunny::DeferredRendererPass, nbunny::RendererPass>(L, &nbunny_deferred_renderer_pass_constructor, metatable);

	return 1;
}
