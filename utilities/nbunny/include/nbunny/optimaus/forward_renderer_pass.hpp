////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/forward_renderer_pass.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_FORWARD_RENDERER_PASS_HPP
#define NBUNNY_OPTIMAUS_FORWARD_RENDERER_PASS_HPP

#include "modules/graphics/Shader.h"
#include "nbunny/optimaus/l_buffer.hpp"
#include "nbunny/optimaus/light.hpp"
#include "nbunny/optimaus/renderer.hpp"
#include "nbunny/optimaus/scene.hpp"

namespace nbunny
{
	class ForwardRendererPass : public RendererPass
	{
	private:
		enum
		{
			MAX_LIGHTS = 16,
			MAX_FOG    = 4
		};

		LBuffer& c_buffer;

		std::vector<SceneNode*> visible_scene_nodes;
		std::vector<SceneNode*> drawable_scene_nodes;
		std::vector<LightSceneNode*> global_light_scene_nodes;
		std::vector<LightSceneNode*> local_light_scene_nodes;
		std::vector<LightSceneNode*> fog_scene_nodes;
		std::vector<Light> lights;

		void walk_all_nodes(SceneNode& node, float delta);
		void walk_visible_lights();

		void draw_nodes(lua_State* L, float delta);
		void get_nearby_lights(SceneNode& node, float delta);

		love::graphics::Shader* get_node_shader(lua_State* L, const SceneNode& node);

		void send_light_property(
			love::graphics::Shader* shader,
			int index,
			const std::string& property_name,
			float* property_value);
		void send_light(love::graphics::Shader* shader, Light& light, int index);

	public:
		ForwardRendererPass(LBuffer& c_buffer);
		~ForwardRendererPass() = default;

		LBuffer& get_c_buffer();

		void draw(lua_State* L, SceneNode& node, float delta) override;
		void resize(int width, int height) override;
		void attach(Renderer& renderer) override;
	};
}

#endif
