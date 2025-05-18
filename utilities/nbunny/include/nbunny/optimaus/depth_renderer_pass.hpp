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

#ifndef NBUNNY_OPTIMAUS_DEPTH_RENDERER_PASS_HPP
#define NBUNNY_OPTIMAUS_DEPTH_RENDERER_PASS_HPP

#include "modules/graphics/Canvas.h"
#include "modules/graphics/Shader.h"
#include "nbunny/optimaus/g_buffer.hpp"
#include "nbunny/optimaus/light.hpp"
#include "nbunny/optimaus/renderer.hpp"
#include "nbunny/optimaus/scene.hpp"

namespace nbunny
{
	class DepthRendererPass : public RendererPass
	{
	private:
		std::vector<SceneNode*> visible_scene_nodes;

		std::vector<SceneNode*> drawable_scene_nodes;
		std::vector<SceneNode*> stencil_masked_drawable_scene_nodes;
		std::vector<SceneNode*> stencil_write_drawable_scene_nodes;

		void walk_all_nodes(SceneNode& node, float delta);
		void draw_nodes(lua_State* L, float delta, const std::vector<SceneNode*>& scene_nodes);
		void draw_pass(lua_State* L, float delta);

	public:
        GBuffer& g_buffer;

		DepthRendererPass(GBuffer& g_buffer);

		void draw(lua_State* L, SceneNode& node, float delta) override;
		void resize(int width, int height) override;
		void attach(Renderer& renderer) override;

        love::graphics::Shader* get_node_shader(lua_State* L, const SceneNode& node) override;
	};
}

#endif
