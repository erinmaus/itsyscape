////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/deferred_renderer_pass.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "common/Matrix.h"
#include "common/Module.h"
#include "common/pixelformat.h"
#include "common/runtime.h"
#include "modules/graphics/Graphics.h"
#include "modules/filesystem/Filesystem.h"
#include "modules/math/Transform.h"
#include "nbunny/optimaus/deferred_renderer_pass.hpp"

static const std::string SHADER_DEFAULT           = "Default";
static const std::string SHADER_AMBIENT_LIGHT     = "AmbientLight";
static const std::string SHADER_DIRECTIONAL_LIGHT = "DirectionalLight";
static const std::string SHADER_POINT_LIGHT       = "PointLight";
static const std::string SHADER_FOG               = "Fog";
static const std::string SHADER_COPY_DEPTH        = "CopyDepth";
static const std::string SHADER_SHADOW            = "Shadow";

nbunny::DeferredRendererPass::DeferredRendererPass(ShadowRendererPass* shadow_pass) :
	RendererPass(RENDERER_PASS_DEFERRED),
	shadow_pass(shadow_pass),
	g_buffer({ love::PIXELFORMAT_RGBA8, love::PIXELFORMAT_RGBA16F, love::PIXELFORMAT_RGBA16F, love::PIXELFORMAT_RGBA8 }),
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
	for (auto& visible_scene_node: visible_scene_nodes)
	{
		auto& material = visible_scene_node->get_material();
		if (!material.get_is_translucent() && !material.get_is_full_lit())
		{
			drawable_scene_nodes.push_back(visible_scene_node);
		}
	}
}

void nbunny::DeferredRendererPass::walk_visible_lights()
{
	const auto& all_scene_nodes = get_renderer()->get_all_scene_nodes();

	light_scene_nodes.clear();
	fog_scene_nodes.clear();

	for (auto node: all_scene_nodes)
	{
		const auto& node_type = node->get_type();
		if (node_type == AmbientLightSceneNode::type_pointer ||
			node_type == DirectionalLightSceneNode::type_pointer ||
			node_type == PointLightSceneNode::type_pointer)
		{
			light_scene_nodes.push_back(reinterpret_cast<LightSceneNode*>(node));
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

	auto color_texture_uniform = shader->getUniformInfo("scape_ColorTexture");
	if (color_texture_uniform)
	{
		auto texture = static_cast<love::graphics::Texture*>(g_buffer.get_canvas(COLOR_INDEX));
		shader->sendTextures(color_texture_uniform, &texture, 1);
	}

	auto position_texture_uniform = shader->getUniformInfo("scape_PositionTexture");
	if (position_texture_uniform)
	{
		auto texture = static_cast<love::graphics::Texture*>(g_buffer.get_canvas(POSITION_INDEX));
		shader->sendTextures(position_texture_uniform, &texture, 1);    
	}

	auto light_ambient_coefficient_uniform = shader->getUniformInfo("scape_LightAmbientCoefficient");
	if (light_ambient_coefficient_uniform)
	{
		*light_ambient_coefficient_uniform->floats = light.ambient_coefficient;
		shader->updateUniform(light_ambient_coefficient_uniform, 1);
	}

	auto light_color_uniform = shader->getUniformInfo("scape_LightColor");
	if (light_color_uniform)
	{
		std::memcpy(light_color_uniform->floats, glm::value_ptr(light.color), sizeof(glm::vec3));
		shader->updateUniform(light_color_uniform, 1);
	}

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	graphics->draw(g_buffer.get_canvas(COLOR_INDEX), love::Matrix4());
}

void nbunny::DeferredRendererPass::draw_directional_light(lua_State* L, LightSceneNode& node, float delta)
{
	auto shader = get_builtin_shader(L, BUILTIN_SHADER_DIRECTIONAL_LIGHT, SHADER_DIRECTIONAL_LIGHT);
	get_renderer()->set_current_shader(shader);

	Light light;
	node.to_light(light, delta);

	auto position_texture_uniform = shader->getUniformInfo("scape_PositionTexture");
	if (position_texture_uniform)
	{
		auto texture = static_cast<love::graphics::Texture*>(g_buffer.get_canvas(POSITION_INDEX));
		shader->sendTextures(position_texture_uniform, &texture, 1);    
	}

	auto normal_map_specular_texture_uniform = shader->getUniformInfo("scape_NormalOutlineTexture");
	if (normal_map_specular_texture_uniform)
	{
		auto texture = static_cast<love::graphics::Texture*>(g_buffer.get_canvas(NORMAL_OUTLINE_INDEX));
		shader->sendTextures(normal_map_specular_texture_uniform, &texture, 1); 
	}

	auto specular_texture_uniform = shader->getUniformInfo("scape_SpecularTexture");
	if (specular_texture_uniform)
	{
		auto texture = static_cast<love::graphics::Texture*>(g_buffer.get_canvas(SPECULAR_INDEX));
		shader->sendTextures(specular_texture_uniform, &texture, 1);
	}

	auto color_texture_uniform = shader->getUniformInfo("scape_ColorTexture");
	if (color_texture_uniform)
	{
		auto texture = static_cast<love::graphics::Texture*>(g_buffer.get_canvas(COLOR_INDEX));
		shader->sendTextures(color_texture_uniform, &texture, 1);
	}

	auto light_direction_uniform = shader->getUniformInfo("scape_LightDirection");
	if (light_direction_uniform)
	{
		std::memcpy(light_direction_uniform->floats, glm::value_ptr(light.position), sizeof(glm::vec3));
		shader->updateUniform(light_direction_uniform, 1);
	}

	auto light_color_uniform = shader->getUniformInfo("scape_LightColor");
	if (light_color_uniform)
	{
		std::memcpy(light_color_uniform->floats, glm::value_ptr(light.color), sizeof(glm::vec3));
		shader->updateUniform(light_color_uniform, 1);
	}

	auto camera_target_uniform = shader->getUniformInfo("scape_CameraTarget");
	if (camera_target_uniform)
	{
		auto eye = get_renderer()->get_camera().get_target_position();
		std::memcpy(camera_target_uniform->floats, glm::value_ptr(eye), sizeof(glm::vec3));
		shader->updateUniform(camera_target_uniform, 1);
	}

	auto camera_eye_uniform = shader->getUniformInfo("scape_CameraEye");
	if (camera_eye_uniform)
	{
		auto eye = get_renderer()->get_camera().get_eye_position();
		std::memcpy(camera_eye_uniform->floats, glm::value_ptr(eye), sizeof(glm::vec3));
		shader->updateUniform(camera_eye_uniform, 1);
	}

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	graphics->draw(g_buffer.get_canvas(COLOR_INDEX), love::Matrix4());
}

void nbunny::DeferredRendererPass::draw_point_light(lua_State* L, LightSceneNode& node, float delta)
{
	auto shader = get_builtin_shader(L, BUILTIN_SHADER_POINT_LIGHT, SHADER_POINT_LIGHT);
	get_renderer()->set_current_shader(shader);

	Light light;
	node.to_light(light, delta);

	auto position_texture_uniform = shader->getUniformInfo("scape_PositionTexture");
	if (position_texture_uniform)
	{
		auto texture = static_cast<love::graphics::Texture*>(g_buffer.get_canvas(POSITION_INDEX));
		shader->sendTextures(position_texture_uniform, &texture, 1);    
	}

	auto color_texture_uniform = shader->getUniformInfo("scape_ColorTexture");
	if (color_texture_uniform)
	{
		auto texture = static_cast<love::graphics::Texture*>(g_buffer.get_canvas(COLOR_INDEX));
		shader->sendTextures(color_texture_uniform, &texture, 1);
	}

	auto light_position_uniform = shader->getUniformInfo("scape_LightPosition");
	if (light_position_uniform)
	{
		std::memcpy(light_position_uniform->floats, glm::value_ptr(light.position), sizeof(glm::vec3));
		shader->updateUniform(light_position_uniform, 1);
	}

	auto light_color_uniform = shader->getUniformInfo("scape_LightColor");
	if (light_color_uniform)
	{
		std::memcpy(light_color_uniform->floats, glm::value_ptr(light.color), sizeof(glm::vec3));
		shader->updateUniform(light_color_uniform, 1);
	}

	auto light_attenuation_uniform = shader->getUniformInfo("scape_LightAttenuation");
	if (light_attenuation_uniform)
	{
		*light_attenuation_uniform->floats = light.attenuation;
		shader->updateUniform(light_attenuation_uniform, 1);
	}

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	graphics->draw(g_buffer.get_canvas(COLOR_INDEX), love::Matrix4());
}

void nbunny::DeferredRendererPass::draw_fog(lua_State* L, FogSceneNode& node, float delta)
{
	auto shader = get_builtin_shader(L, BUILTIN_SHADER_FOG, SHADER_FOG);
	get_renderer()->set_current_shader(shader);

	Light light;
	node.to_light(light, delta);

	auto fog_parameters = glm::vec2(light.near_distance, light.far_distance);
	auto fog_parameters_uniform = shader->getUniformInfo("scape_FogParameters");
	if (fog_parameters_uniform)
	{
		std::memcpy(fog_parameters_uniform->floats, glm::value_ptr(fog_parameters), sizeof(glm::vec2));
		shader->updateUniform(fog_parameters_uniform, 1);
	}

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

	auto camera_eye_uniform = shader->getUniformInfo("scape_CameraEye");
	if (camera_eye_uniform)
	{
		std::memcpy(camera_eye_uniform->floats, glm::value_ptr(camera_eye), sizeof(glm::vec3));
		shader->updateUniform(camera_eye_uniform, 1);
	}

	auto fog_color_uniform = shader->getUniformInfo("scape_FogColor");
	if (fog_color_uniform)
	{
		std::memcpy(fog_color_uniform->floats, glm::value_ptr(light.color), sizeof(glm::vec3));
		shader->updateUniform(fog_color_uniform, 1);
	}

	auto position_texture_uniform = shader->getUniformInfo("scape_PositionTexture");
	if (position_texture_uniform)
	{
		auto texture = static_cast<love::graphics::Texture*>(g_buffer.get_canvas(POSITION_INDEX));
		shader->sendTextures(position_texture_uniform, &texture, 1);    
	}

	auto color_texture_uniform = shader->getUniformInfo("scape_ColorTexture");
	if (color_texture_uniform)
	{
		auto texture = static_cast<love::graphics::Texture*>(g_buffer.get_canvas(COLOR_INDEX));
		shader->sendTextures(color_texture_uniform, &texture, 1);
	}

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	graphics->draw(g_buffer.get_canvas(COLOR_INDEX), love::Matrix4());
}

void nbunny::DeferredRendererPass::copy_depth_buffer(lua_State* L)
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
}

void nbunny::DeferredRendererPass::draw_shadows(lua_State* L, float delta)
{
	if (!shadow_pass || !shadow_pass->get_has_shadow_map())
	{
		return;
	}

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	shadow_buffer.use();
	graphics->clear(love::Colorf(0.0f, 0.0f, 0.0f, 0.0f), love::OptionalInt(), love::OptionalDouble());

	graphics->setDepthMode(love::graphics::COMPARE_ALWAYS, false);
	graphics->setBlendMode(love::graphics::Graphics::BLEND_ALPHA, love::graphics::Graphics::BLENDALPHA_MULTIPLY);
	graphics->origin();
	graphics->setOrtho(g_buffer.get_width(), g_buffer.get_height(), !graphics->isCanvasActive());
	graphics->setColor(love::Colorf(1.0f, 1.0f, 1.0f, 1.0f));

	auto shader = get_builtin_shader(L, BUILTIN_SHADER_SHADOW, SHADER_SHADOW);
	get_renderer()->set_current_shader(shader);

	auto shadow_map = shadow_pass->get_shadow_map();
	auto shadow_map_texture_uniform = shader->getUniformInfo("scape_ShadowMap");
	if (shadow_map_texture_uniform)
	{
		auto texture = static_cast<love::graphics::Texture*>(shadow_map);
		shader->sendTextures(shadow_map_texture_uniform, &texture, 1);  
	}

	auto position_texture_uniform = shader->getUniformInfo("scape_PositionTexture");
	if (position_texture_uniform)
	{
		auto texture = static_cast<love::graphics::Texture*>(g_buffer.get_canvas(POSITION_INDEX));
		shader->sendTextures(position_texture_uniform, &texture, 1);    
	}

	auto normal_map_specular_texture_uniform = shader->getUniformInfo("scape_NormalOutlineTexture");
	if (normal_map_specular_texture_uniform)
	{
		auto texture = static_cast<love::graphics::Texture*>(g_buffer.get_canvas(NORMAL_OUTLINE_INDEX));
		shader->sendTextures(normal_map_specular_texture_uniform, &texture, 1); 
	}

	auto texel_size_uniform = shader->getUniformInfo("scape_TexelSize");
	if (texel_size_uniform)
	{
		auto texel_size = glm::vec2(1.0f / shadow_map->getWidth(), 1.0f / shadow_map->getHeight());
		std::memcpy(texel_size_uniform->floats, glm::value_ptr(texel_size), sizeof(glm::vec2));
		shader->updateUniform(texel_size_uniform, 1);
	}

	auto light_direction_uniform = shader->getUniformInfo("scape_LightDirection");
	if (light_direction_uniform)
	{
		auto light_direction = shadow_pass->get_light_direction(delta);
		std::memcpy(light_direction_uniform->floats, glm::value_ptr(light_direction), sizeof(glm::vec3));
		shader->updateUniform(light_direction_uniform, 1);
	}

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

	auto view_uniform = shader->getUniformInfo("scape_View");
	if (view_uniform)
	{
		auto view = get_renderer()->get_camera().get_view();
		std::memcpy(view_uniform->floats, glm::value_ptr(view), sizeof(glm::mat4));
		shader->updateUniform(view_uniform, 1);
	}

	auto light_space_matrices_uniform = shader->getUniformInfo("scape_CascadeLightSpaceMatrices");
	if (light_space_matrices_uniform)
	{
		std::memcpy(light_space_matrices_uniform->floats, glm::value_ptr(light_space_matrices[0]), sizeof(glm::mat4) * shadow_pass->get_num_cascades());
		shader->updateUniform(light_space_matrices_uniform, shadow_pass->get_num_cascades());
	}

	auto near_planes_uniform = shader->getUniformInfo("scape_CascadePlanes");
	if (near_planes_uniform)
	{
		std::memcpy(near_planes_uniform->floats, &near_planes[0], sizeof(glm::vec2) * shadow_pass->get_num_cascades());
		shader->updateUniform(near_planes_uniform, shadow_pass->get_num_cascades());
	}

	auto num_cascades_uniform = shader->getUniformInfo("scape_NumCascades");
	if (num_cascades_uniform)
	{
		*num_cascades_uniform->ints = shadow_pass->get_num_cascades();
		shader->updateUniform(num_cascades_uniform, 1);
	}

	auto shadow_alpha_uniform = shader->getUniformInfo("scape_ShadowAlpha");
	if (shadow_alpha_uniform)
	{
		*shadow_alpha_uniform->floats = std::max(1.0f - std::min(ambient_light, 1.0f), 0.3f);
		shader->updateUniform(shadow_alpha_uniform, 1);
	}

	auto near_uniform = shader->getUniformInfo("scape_Near");
	if (near_uniform)
	{
		*near_uniform->floats = get_renderer()->get_camera().get_near();
		shader->updateUniform(near_uniform, 1);
	}

	auto far_uniform = shader->getUniformInfo("scape_Far");
	if (far_uniform)
	{
		*far_uniform->floats = get_renderer()->get_camera().get_far();
		shader->updateUniform(far_uniform, 1);
	}

	graphics->draw(g_buffer.get_canvas(1), love::Matrix4());

	output_buffer.use();
	get_renderer()->set_current_shader(nullptr);
	graphics->draw(shadow_buffer.get_color(), love::Matrix4());
}

void nbunny::DeferredRendererPass::draw_nodes(lua_State* L, float delta)
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
			love::Colorf(0.0, 0.0, 0.0, 1.0),
			love::Colorf(0.0, 0.0, 0.0, 1.0),
			love::Colorf(0.0, 0.0, 0.0, 0.0)
		},
		0,
		1.0f);

	for (auto& scene_node: drawable_scene_nodes)
	{
		auto shader = get_node_shader(L, *scene_node);
		renderer->set_current_shader(shader);

		auto outline_threshold = shader->getUniformInfo("scape_OutlineThreshold");
		if (outline_threshold)
		{
			*outline_threshold->floats = scene_node->get_material().get_outline_threshold();
			shader->updateUniform(outline_threshold, 1);
		}
	
		graphics->setBlendMode(love::graphics::Graphics::BLEND_REPLACE, love::graphics::Graphics::BLENDALPHA_PREMULTIPLIED);
		graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, !scene_node->get_material().get_is_z_write_disabled());
		graphics->setMeshCullMode(love::graphics::CULL_BACK);

		auto color = scene_node->get_material().get_color();
		graphics->setColor(love::Colorf(color.r, color.g, color.b, color.a));

		renderer->draw_node(L, *scene_node, delta);

		graphics->setColor(love::Colorf(1.0f, 1.0f, 1.0f, 1.0f));
	}
}

void nbunny::DeferredRendererPass::draw_lights(lua_State* L, float delta)
{
	light_buffer.use();

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	graphics->setBlendMode(love::graphics::Graphics::BLEND_ADD, love::graphics::Graphics::BLENDALPHA_MULTIPLY);

	graphics->clear(love::Colorf(0.0f, 0.0f, 0.0f, 1.0f), love::OptionalInt(), love::OptionalDouble());

	graphics->setDepthMode(love::graphics::COMPARE_ALWAYS, false);
	graphics->origin();
	graphics->setOrtho(g_buffer.get_width(), g_buffer.get_height(), !graphics->isCanvasActive());

	if (light_scene_nodes.empty())
	{
		AmbientLightSceneNode full_lit_node(0);
		full_lit_node.set_current_ambience(1.0f);
		full_lit_node.set_previous_ambience(1.0f);

		draw_ambient_light(L, full_lit_node, delta);
	}

	ambient_light = 0.0f;
	for (auto light: light_scene_nodes)
	{
		const auto& light_type = light->get_type();

		if (light_type == AmbientLightSceneNode::type_pointer)
		{
			draw_ambient_light(L, *light, delta);
		}
		else if (light_type == DirectionalLightSceneNode::type_pointer)
		{
			draw_directional_light(L, *light, delta);
		}
		else if (light_type == PointLightSceneNode::type_pointer)
		{
			draw_point_light(L, *light, delta);
		}
	}

	mix_lights();
}

void nbunny::DeferredRendererPass::draw_fog(lua_State* L, float delta)
{
	if (fog_scene_nodes.empty())
	{
		return;
	}

	fog_buffer.use();

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

void nbunny::DeferredRendererPass::mix_lights()
{
	output_buffer.use();
	get_renderer()->set_current_shader(nullptr);

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	graphics->setDepthMode(love::graphics::COMPARE_ALWAYS, false);
	graphics->origin();
	graphics->setOrtho(g_buffer.get_width(), g_buffer.get_height(), false);

	graphics->setBlendMode(love::graphics::Graphics::BLEND_REPLACE, love::graphics::Graphics::BLENDALPHA_PREMULTIPLIED);
	graphics->draw(g_buffer.get_canvas(COLOR_INDEX), love::Matrix4());

	graphics->setBlendMode(love::graphics::Graphics::BLEND_MULTIPLY, love::graphics::Graphics::BLENDALPHA_PREMULTIPLIED);
	graphics->draw(light_buffer.get_color(), love::Matrix4());

	graphics->setCanvas();
}

void nbunny::DeferredRendererPass::mix_fog()
{
	output_buffer.use();
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

	draw_nodes(L, delta);
	draw_lights(L, delta);
	draw_shadows(L, delta);
	draw_fog(L, delta);

	copy_depth_buffer(L);
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

static std::shared_ptr<nbunny::DeferredRendererPass> nbunny_deferred_renderer_pass_create(
	sol::variadic_args args, sol::this_state S)
{
	lua_State* L = S;

	nbunny::ShadowRendererPass* shadow_pass = nullptr;
	if (lua_gettop(L) > 1)
	{
		shadow_pass = sol::stack::get<nbunny::ShadowRendererPass*>(L, 2);
	}

	return std::make_shared<nbunny::DeferredRendererPass>(shadow_pass);
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_deferredrendererpass(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::DeferredRendererPass>("NDeferredRendererPass",
		sol::base_classes, sol::bases<nbunny::RendererPass>(),
		sol::call_constructor, sol::factories(&nbunny_deferred_renderer_pass_create),
		"getGBuffer", &nbunny::DeferredRendererPass::get_g_buffer,
		"getDepthBuffer", &nbunny::DeferredRendererPass::get_depth_buffer,
		"getCBuffer", &nbunny::DeferredRendererPass::get_output_buffer);

	sol::stack::push(L, T);

	return 1;
}
