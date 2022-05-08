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
	visible_scene_nodes.clear();
	SceneNode::walk_by_position(node, get_renderer()->get_camera(), delta, visible_scene_nodes);

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
	global_light_scene_nodes.clear();
	local_light_scene_nodes.clear();

	for (auto node: visible_scene_nodes)
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
	}
}

void nbunny::ForwardRendererPass::get_nearby_lights(SceneNode& node, float delta)
{
	auto transform = node.get_transform().get_global(delta);
	auto position = transform * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f);

	lights.clear();
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
	if (!shader_resource)
	{
		return nullptr;
	}

	get_renderer()->get_shader_cache().build(
		get_renderer_pass_id(),
		shader_resource->get_id(),
		[&](const auto& base_vertex_source, const auto& base_pixel_source, auto& v, auto& p)
		{
			// Get source object from resource
			// This assumes the object is an ItsyScape.Graphics.ShaderResource, which should be a valid assumption.
			// TODO: error handling
			shader_resource->get_reference(L);
			lua_getfield(L, -1, "getResource");
			lua_pushvalue(L, -2);
			lua_call(L, 1, 1);

			v = base_vertex_source;

			lua_getfield(L, -1, "getVertexSource");
			lua_pushvalue(L, -2);
			lua_call(L, 1, 1);

			v += luaL_checkstring(L, -1);
			lua_pop(L, 1);

			p = base_pixel_source;

			lua_getfield(L, -1, "getPixelSource");
			lua_pushvalue(L, -2);
			lua_call(L, 1, 1);

			p += luaL_checkstring(L, -1);
			lua_pop(L, 1);

			// Pop return value from "getResource" and the reference
			lua_pop(L, 2);
		});
}

void nbunny::ForwardRendererPass::send_light_property(
	love::graphics::Shader* shader,
	int index,
	const std::string& property_name,
	float* property_value)
{
	std::string uniform_name = std::string("scape_Lights[") + std::to_string(index) + std::string("].") + property_name;
	auto uniform = shader->getUniformInfo(uniform_name);
	if (uniform)
	{
		auto u = *uniform;
		u.floats = property_value;
		shader->updateUniform(&u, 1);
	}
}

void nbunny::ForwardRendererPass::send_light(
	love::graphics::Shader* shader,
	Light& light,
	int index)
{
	send_light_property(shader, index, "position", glm::value_ptr(light.position));
	send_light_property(shader, index, "color", glm::value_ptr(light.color));
	send_light_property(shader, index, "attenuation", &light.attenuation);
	send_light_property(shader, index, "ambientCoefficient", &light.ambient_coefficient);
	send_light_property(shader, index, "coneAngle", &light.cone_angle);
	send_light_property(shader, index, "coneDirection", glm::value_ptr(light.cone_direction));
}

void nbunny::ForwardRendererPass::draw_nodes(lua_State* L, float delta)
{
	auto renderer = get_renderer();
	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	const auto& camera = renderer->get_camera();
	love::math::Transform view(love::Matrix4(glm::value_ptr(camera.get_view())));
	love::Matrix4 projection(glm::value_ptr(camera.get_projection()));

	graphics->replaceTransform(&view);
	graphics->setProjection(projection);

	c_buffer.use();

	for (auto& scene_node: drawable_scene_nodes)
	{
		auto shader = get_node_shader(L, *scene_node);
		if (!shader)
		{
			continue;
		}
		renderer->set_current_shader(shader);

		auto world = scene_node->get_transform().get_global(delta);

		auto world_matrix_uniform = shader->getUniformInfo("scape_WorldMatrix");
		if (world_matrix_uniform)
		{
			auto uniform = *world_matrix_uniform;
			uniform.floats = glm::value_ptr(world);
			shader->updateUniform(&uniform, 1);
		}

		auto normal_matrix_uniform = shader->getUniformInfo("scape_NormalMatrix");
		if (normal_matrix_uniform)
		{
			auto normal_matrix = glm::inverse(glm::transpose(world));
			auto uniform = *normal_matrix_uniform;
			uniform.floats = glm::value_ptr(world);
			shader->updateUniform(&uniform, 1);
		}

		get_nearby_lights(*scene_node, delta);
		for (auto i = 0; i < lights.size(); ++i)
		{
			send_light(shader, lights[i], i);
		}

		auto num_lights_uniform = shader->getUniformInfo("scape_NumLights");
		if (num_lights_uniform)
		{
			auto uniform = *num_lights_uniform;
			int num_lights = (int)lights.size();
			uniform.ints = &num_lights;
			shader->updateUniform(&uniform, 1);
		}

		auto num_fog_uniform = shader->getUniformInfo("scape_NumFog");
		if (num_fog_uniform)
		{
			auto uniform = *num_fog_uniform;
			int num_fog = 0;
			uniform.ints = &num_fog;
			shader->updateUniform(&uniform, 1);
		}

		renderer->draw_node(L, *scene_node, delta);
	}
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

static std::shared_ptr<nbunny::ForwardRendererPass> nbunny_forward_renderer_pass_create(
	sol::variadic_args args, sol::this_state S)
{
	lua_State* L = S;
	auto& c_buffer = sol::stack::get<nbunny::LBuffer&>(L, 2);
	return std::make_shared<nbunny::ForwardRendererPass>(c_buffer);
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_forwardrendererpass(lua_State* L)
{
	sol::usertype<nbunny::ForwardRendererPass> T(
		sol::base_classes, sol::bases<nbunny::RendererPass>(),
		sol::call_constructor, sol::factories(&nbunny_forward_renderer_pass_create));

	sol::stack::push(L, T);

	return 1;
}
