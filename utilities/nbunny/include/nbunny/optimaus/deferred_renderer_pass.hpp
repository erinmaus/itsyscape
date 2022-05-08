////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/deferred_renderer_pass.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_DEFERRED_RENDERER_PASS_HPP
#define NBUNNY_OPTIMAUS_DEFERRED_RENDERER_PASS_HPP

#include "modules/graphics/Shader.h"
#include "nbunny/optimaus/common.hpp"
#include "nbunny/optimaus/g_buffer.hpp"
#include "nbunny/optimaus/l_buffer.hpp"
#include "nbunny/optimaus/light.hpp"
#include "nbunny/optimaus/renderer.hpp"
#include "nbunny/optimaus/scene.hpp"

namespace nbunny
{
	class DeferredRendererPass : public RendererPass
	{
	private:
		GBuffer g_buffer;
		LBuffer light_buffer;
		LBuffer fog_buffer;
		LBuffer output_buffer;

		enum
		{
			COLOR_INDEX           = 1,
			POSITION_INDEX        = 2,
			NORMAL_SPECULAR_INDEX = 3
		};

		enum
		{
			BUILTIN_SHADER_DEFAULT           = -1,
			BUILTIN_SHADER_AMBIENT_LIGHT     = -2,
			BUILTIN_SHADER_DIRECTIONAL_LIGHT = -3,
			BUILTIN_SHADER_POINT_LIGHT       = -4
		};

		std::vector<SceneNode*> scene_nodes;
		std::vector<LightSceneNode*> light_scene_nodes;
		std::vector<LightSceneNode*> fog_scene_nodes;

		void walk_all_nodes(SceneNode& node, float delta);
		void walk_visible_lights();

		void draw_ambient_light(LightSceneNode& node, float delta);
		void draw_directional_light(LightSceneNode& node, float delta);
		void draw_point_light(LightSceneNode& node, float delta);

		void draw_nodes(lua_State* L, float delta);
		void draw_lights(float delta);
		void draw_fog(float delta);

		void mix_lights();
		void mix_fog();

		love::graphics::Shader* get_builtin_shader(int builtin_id, const std::string& filename, bool is_light = true);
		love::graphics::Shader* get_node_shader(lua_State* L, const SceneNode& node);

	public:
		DeferredRendererPass();
		~DeferredRendererPass() = default;

		GBuffer& get_g_buffer();

		LBuffer& get_output_buffer();

		void draw(lua_State* L, SceneNode& node, float delta) override;

		void resize(int width, int height) override;

		void attach(Renderer& renderer) override;
	};
}

#endif
