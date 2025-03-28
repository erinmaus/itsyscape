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

#include <memory>
#include "modules/graphics/Shader.h"
#include "nbunny/optimaus/common.hpp"
#include "nbunny/optimaus/g_buffer.hpp"
#include "nbunny/optimaus/l_buffer.hpp"
#include "nbunny/optimaus/light.hpp"
#include "nbunny/optimaus/renderer.hpp"
#include "nbunny/optimaus/scene.hpp"
#include "nbunny/optimaus/shadow_renderer_pass.hpp"

namespace nbunny
{
	class DeferredRendererPass : public RendererPass
	{
	private:
		GBuffer g_buffer;
		GBuffer depth_buffer;
		LBuffer light_buffer;
		LBuffer shadow_buffer;
		LBuffer fog_buffer;
		LBuffer output_buffer;

		std::shared_ptr<ShadowRendererPass> shadow_pass;

		std::vector<SceneNode*> drawable_scene_nodes;
		std::vector<SceneNode*> stencil_masked_drawable_scene_nodes;
		std::vector<SceneNode*> stencil_write_drawable_scene_nodes;
		std::vector<PointLightSceneNode*> point_light_scene_nodes;
		std::vector<AmbientLightSceneNode*> ambient_light_scene_nodes;
		std::vector<DirectionalLightSceneNode*> directional_light_scene_nodes;
		std::vector<FogSceneNode*> fog_scene_nodes;

		void walk_all_nodes(SceneNode& node, float delta);
		void walk_visible_lights();

		void draw_ambient_light(lua_State* L, LightSceneNode& node, float delta);
		void draw_directional_light(lua_State* L, LightSceneNode& node, float delta);
		void draw_point_light(lua_State* L, LightSceneNode& node, float delta);

		void draw_ambient_lights(lua_State* L, float delta);
		void draw_directional_lights(lua_State* L, float delta);
		void draw_point_lights(lua_State* L, float delta);

		void draw_fog(lua_State* L, FogSceneNode& node, float delta);

		void draw_nodes(lua_State* L, float delta, const std::vector<SceneNode*>& nodes);
		void draw_pass(lua_State* L, float delta);
		void draw_lights(lua_State* L, float delta);
		void draw_fog(lua_State* L, float delta);
		void draw_shadows(lua_State* L, float delta);
		void copy_depth_buffer(lua_State* L);

		float ambient_light = 0.0f;

		void mix_lights(lua_State* L);
		void mix_fog();

		love::graphics::Shader* get_builtin_shader(lua_State* L, int builtin_id, const std::string& filename, bool is_light = true);

	public:
		enum
		{
			DEPTH_INDEX            = 0,
			COLOR_INDEX            = 1,
			NORMAL_INDEX           = 2,
			SPECULAR_OUTLINE_INDEX = 3
		};

		enum
		{
			BUILTIN_SHADER_DEFAULT                 = -1,
			BUILTIN_SHADER_AMBIENT_LIGHT           = -2,
			BUILTIN_SHADER_DIRECTIONAL_LIGHT       = -3,
			BUILTIN_SHADER_POINT_LIGHT             = -4,
			BUILTIN_SHADER_FOG                     = -5,
			BUILTIN_SHADER_DEPTH_COPY              = -6,
			BUILTIN_SHADER_SHADOW                  = -7,
			BUILTIN_SHADER_MULTI_AMBIENT_LIGHT     = -9,
			BUILTIN_SHADER_MULTI_DIRECTIONAL_LIGHT = -10,
			BUILTIN_SHADER_MULTI_POINT_LIGHT       = -11,
			BUILTIN_SHADER_MIX_LIGHTS              = -12
		};

		DeferredRendererPass(const std::shared_ptr<ShadowRendererPass>& shadow_pass);
		~DeferredRendererPass() = default;

		GBuffer& get_g_buffer();
		GBuffer& get_depth_buffer();

		LBuffer& get_output_buffer();

		void draw(lua_State* L, SceneNode& node, float delta) override;

		void resize(int width, int height) override;

		void attach(Renderer& renderer) override;

        love::graphics::Shader* get_node_shader(lua_State* L, const SceneNode& node) override;
	};
}

#endif
