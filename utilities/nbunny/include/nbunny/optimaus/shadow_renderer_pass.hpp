////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/shadow_renderer_pass.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_SHADODW_RENDERER_PASS_HPP
#define NBUNNY_OPTIMAUS_SHADODW_RENDERER_PASS_HPP

#include "modules/graphics/Canvas.h"
#include "modules/graphics/Shader.h"
#include "nbunny/optimaus/g_buffer.hpp"
#include "nbunny/optimaus/light.hpp"
#include "nbunny/optimaus/renderer.hpp"
#include "nbunny/optimaus/scene.hpp"

namespace nbunny
{
	class ShadowRendererPass : public RendererPass
	{
	private:
		int num_cascades = 5;
		int width = 0, height = 0;

		love::graphics::Canvas* shadow_map = nullptr;

		std::vector<DirectionalLightSceneNode*> directional_lights;
		std::vector<SceneNode*> visible_scene_nodes;
		std::vector<SceneNode*> shadow_casting_scene_nodes;

		void walk_all_nodes(SceneNode& node, float delta);
		void draw_nodes(lua_State* L, float delta);

		std::vector<glm::vec3> viewing_frustum_corners;
		void calculate_viewing_frustum_corners();

		bool has_shadow_map = false;

	public:
		ShadowRendererPass(int num_cascades);
		~ShadowRendererPass();

		love::graphics::Canvas* get_shadow_map();

		int get_num_cascades() const;
		bool get_has_shadow_map() const;

		void draw(lua_State* L, SceneNode& node, float delta) override;
		void resize(int width, int height) override;
		void attach(Renderer& renderer) override;

		glm::mat4 get_light_view_matrix(float delta) const;
		void get_light_projection_matrix(int cascade_index, glm::mat4& projection_matrix, float& near_plane, float& far_plane) const;

        love::graphics::Shader* get_node_shader(lua_State* L, const SceneNode& node) override;
	};
}

#endif
