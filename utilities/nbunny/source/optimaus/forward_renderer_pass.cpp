////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/forward_renderer_pass.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "modules/graphics/Graphics.h"
#include "modules/math/Transform.h"
#include "nbunny/optimaus/forward_renderer_pass.hpp"

void nbunny::ForwardRendererPass::walk_all_nodes(SceneNode& node, float delta)
{
	const auto& visible_scene_nodes = get_renderer()->get_visible_scene_nodes_by_position();

	drawable_scene_nodes.clear();
	for (auto visible_scene_node: visible_scene_nodes)
	{
		auto& material = visible_scene_node->get_material();
		if (material.get_is_translucent() || material.get_is_full_lit())
		{
			drawable_scene_nodes.push_back(visible_scene_node);
		}
	}
}

void nbunny::ForwardRendererPass::walk_visible_lights()
{
	const auto& all_scene_nodes = get_renderer()->get_all_scene_nodes();

	global_light_scene_nodes.clear();
	local_light_scene_nodes.clear();
	fog_scene_nodes.clear();

	for (auto node: all_scene_nodes)
	{
		const auto& node_type = node->get_type();
		if (node_type == AmbientLightSceneNode::type_pointer ||
		    node_type == DirectionalLightSceneNode::type_pointer ||
		    node_type == PointLightSceneNode::type_pointer)
		{
			auto light_node = reinterpret_cast<LightSceneNode*>(node);
			if (light_node->get_is_global())
			{
				global_light_scene_nodes.push_back(light_node);
			}
			else
			{
				local_light_scene_nodes.push_back(light_node);
			}
		}
		else if (node_type == FogSceneNode::type_pointer)
		{
			fog_scene_nodes.push_back(reinterpret_cast<FogSceneNode*>(node));
		}
	}
}

void nbunny::ForwardRendererPass::prepare_fog(float delta)
{
	std::stable_sort(
		fog_scene_nodes.begin(),
		fog_scene_nodes.end(),
		[&](auto a, auto b)
		{
			return a->get_current_far_distance() < b->get_current_far_distance();
		});

	fog.clear();
	for (auto fog_scene_node: fog_scene_nodes)
	{
		Light light;
		fog_scene_node->to_light(light, delta);

		glm::vec3 camera_eye;
		switch (fog_scene_node->get_follow_mode())
		{
			case FogSceneNode::FOLLOW_MODE_EYE:
			default:
				camera_eye = get_renderer()->get_camera().get_eye_position();
				break;
			case FogSceneNode::FOLLOW_MODE_TARGET:
				camera_eye = get_renderer()->get_camera().get_target_position();
				break;
			case FogSceneNode::FOLLOW_MODE_SELF:
				camera_eye = glm::vec3(light.position);
				break;
		}

		light.position = glm::vec4(camera_eye, 1.0f);

		if (fog.size() < MAX_FOG)
		{
			fog.push_back(light);
		}
		else
		{
			break;
		}
	}
}

void nbunny::ForwardRendererPass::get_nearby_lights(SceneNode& node, float delta)
{
	glm::vec4 position;
	if (node.get_material().get_is_light_target_position_enabled())
	{
		auto transform = node.get_transform().get_global(delta);
		position = transform * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f);
	}
	else
	{
		position = glm::vec4(get_renderer()->get_camera().get_target_position(), 1.0f);
	}

	lights.clear();
	if (node.get_material().get_is_full_lit() || (global_light_scene_nodes.empty() && local_light_scene_nodes.empty()))
	{
		Light light;
		light.ambient_coefficient = 1.0f;
		light.diffuse_coefficient = 0.0f;

		lights.push_back(light);
		return;
	}

	for (auto global_light: global_light_scene_nodes)
	{
		if (lights.size() >= MAX_LIGHTS)
		{
			return;
		}

		Light light;
		global_light->to_light(light, delta);
		lights.push_back(light);
	}

	std::stable_sort(
		local_light_scene_nodes.begin(),
		local_light_scene_nodes.end(),
		[&](auto& a, auto& b)
		{
			auto a_position = a->get_transform().get_global(delta) * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f);
			auto b_position = b->get_transform().get_global(delta) * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f);

			auto a_distance = glm::length(glm::vec3(a_position) - glm::vec3(position));
			auto b_distance = glm::length(glm::vec3(b_position) - glm::vec3(position));

			return a_distance < b_distance;
		});

	for (auto local_light: local_light_scene_nodes)
	{
		if (lights.size() >= MAX_LIGHTS)
		{
			return;
		}

		Light light;
		local_light->to_light(light, delta);
		lights.push_back(light);
	}
}

love::graphics::Shader* nbunny::ForwardRendererPass::get_node_shader(lua_State* L, const SceneNode& node)
{
	auto shader_resource = node.get_material().get_shader();
	if (!shader_resource || shader_resource->get_id() == 0)
	{
		return nullptr;
	}

    return RendererPass::get_node_shader(L, node);
}

void nbunny::ForwardRendererPass::send_light_property(
	love::graphics::Shader* shader,
	const std::string& array,
	int index,
	const std::string& property_name,
	float* property_value,
    std::size_t size_bytes)
{
	auto& shader_cache = get_renderer()->get_shader_cache();

	std::string uniform_name = array + std::string("[") + std::to_string(index) + std::string("].") + property_name;
	shader_cache.update_uniform(shader, uniform_name, property_value, size_bytes);
}

void nbunny::ForwardRendererPass::send_light(
	love::graphics::Shader* shader,
	Light& light,
	int index)
{
	send_light_property(shader, "scape_Lights", index, "position", glm::value_ptr(light.position), sizeof(glm::vec4));
	send_light_property(shader, "scape_Lights", index, "color", glm::value_ptr(light.color), sizeof(glm::vec3));
	send_light_property(shader, "scape_Lights", index, "attenuation", &light.attenuation, sizeof(float));
	send_light_property(shader, "scape_Lights", index, "ambientCoefficient", &light.ambient_coefficient, sizeof(float));
	send_light_property(shader, "scape_Lights", index, "diffuseCoefficient", &light.diffuse_coefficient, sizeof(float));
	send_light_property(shader, "scape_Lights", index, "coneAngle", &light.cone_angle, sizeof(float));
	send_light_property(shader, "scape_Lights", index, "coneDirection", glm::value_ptr(light.cone_direction), sizeof(glm::vec3));
}

void nbunny::ForwardRendererPass::send_fog(
	love::graphics::Shader* shader,
	Light& light,
	int index)
{
	send_light_property(shader, "scape_Fog", index, "near", &light.near_distance, sizeof(float));
	send_light_property(shader, "scape_Fog", index, "far", &light.far_distance, sizeof(float));
	send_light_property(shader, "scape_Fog", index, "color", glm::value_ptr(light.color), sizeof(glm::vec3));
	send_light_property(shader, "scape_Fog", index, "position", glm::value_ptr(light.position), sizeof(glm::vec3));
}

void nbunny::ForwardRendererPass::draw_nodes(lua_State* L, float delta)
{
	auto renderer = get_renderer();
	auto& shader_cache = get_renderer()->get_shader_cache();

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	const auto& camera = renderer->get_camera();
	love::math::Transform view(love::Matrix4(glm::value_ptr(camera.get_view())));
	love::Matrix4 projection(glm::value_ptr(camera.get_projection()));

    c_buffer.use();

	graphics->replaceTransform(&view);
	graphics->setProjection(projection);

	graphics->setMeshCullMode(love::graphics::CULL_BACK);
	graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, true);
	graphics->setBlendMode(love::graphics::Graphics::BLEND_ALPHA, love::graphics::Graphics::BLENDALPHA_MULTIPLY);

	for (auto& scene_node: drawable_scene_nodes)
	{
		auto shader = get_node_shader(L, *scene_node);
		if (!shader)
		{
			continue;
		}
		renderer->set_current_shader(shader);

		get_nearby_lights(*scene_node, delta);
		for (auto i = 0; i < lights.size(); ++i)
		{
			send_light(shader, lights[i], i);
		}

		auto num_lights = (int)lights.size();
		shader_cache.update_uniform(shader, "scape_NumLights", &num_lights, sizeof(int));

		for (auto i = 0; i < fog.size(); ++i)
		{
			send_fog(shader, fog[i], i);
		}

		int num_fog = scene_node->get_material().get_is_full_lit() ? 0 : (int)fog.size();
		shader_cache.update_uniform(shader, "scape_NumFog", &num_fog, sizeof(int));

		auto color = scene_node->get_material().get_color();
		graphics->setColor(love::Colorf(color.r, color.g, color.b, color.a));

		if (scene_node->get_material().get_is_z_write_disabled())
		{
			graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, false);
		}

		renderer->draw_node(L, *scene_node, delta);

		if (scene_node->get_material().get_is_z_write_disabled())
		{
			graphics->setDepthMode(love::graphics::COMPARE_LEQUAL, true);
		}
	}

	graphics->setColor(love::Colorf(1.0f, 1.0f, 1.0f, 1.0f));
}

nbunny::ForwardRendererPass::ForwardRendererPass(LBuffer& c_buffer) :
	RendererPass(RENDERER_PASS_FORWARD), c_buffer(c_buffer)
{
	// Nothing.
}

nbunny::LBuffer& nbunny::ForwardRendererPass::get_c_buffer()
{
	return c_buffer;
}

void nbunny::ForwardRendererPass::draw(lua_State* L, SceneNode& node, float delta)
{
	walk_all_nodes(node, delta);
	walk_visible_lights();
	prepare_fog(delta);

	draw_nodes(L, delta);
}

void nbunny::ForwardRendererPass::resize(int width, int height)
{
	// Nothing.
}

void nbunny::ForwardRendererPass::attach(Renderer& renderer)
{
	RendererPass::attach(renderer);

	load_builtin_shader(
		"Resources/Renderers/Mobile/Base.vert.glsl",
		"Resources/Renderers/Mobile/Base.frag.glsl");
}

static int nbunny_forward_renderer_pass_constructor(lua_State* L)
{
	auto c_buffer = nbunny::lua::get<nbunny::LBuffer*>(L, 2);
	nbunny::lua::push(L, std::make_shared<nbunny::ForwardRendererPass>(*c_buffer));
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_forwardrendererpass(lua_State* L)
{	
	nbunny::lua::register_child_type<nbunny::ForwardRendererPass, nbunny::RendererPass>(L, &nbunny_forward_renderer_pass_constructor, nullptr);

	return 1;
}
