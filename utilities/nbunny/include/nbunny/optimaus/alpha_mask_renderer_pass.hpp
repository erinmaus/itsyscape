////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/alpha_mask_renderer_pass.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_ALPHA_MASK_RENDERER_PASS_HPP
#define NBUNNY_OPTIMAUS_ALPHA_MASK_RENDERER_PASS_HPP

#include <memory>
#include "modules/graphics/Shader.h"
#include "nbunny/optimaus/g_buffer.hpp"
#include "nbunny/optimaus/light.hpp"
#include "nbunny/optimaus/renderer.hpp"
#include "nbunny/optimaus/scene.hpp"

namespace nbunny
{
	class AlphaMaskRendererPass : public RendererPass
	{
	private:
		std::shared_ptr<GBuffer> a_buffer;
		std::shared_ptr<GBuffer> depth_buffer;

		std::vector<SceneNode*> opaque_scene_nodes;
		std::vector<SceneNode*> translucent_scene_nodes;
		std::vector<SceneNode*> particle_scene_nodes;

		void walk_all_nodes(SceneNode& node, float delta);
		void draw_nodes(lua_State* L, float delta);

		void copy_depth_buffer();

	public:
		AlphaMaskRendererPass(const std::shared_ptr<GBuffer>& a_buffer, const std::shared_ptr<GBuffer>& depth_buffer);
		~AlphaMaskRendererPass() = default;

		const std::shared_ptr<GBuffer>& get_a_buffer();

		void draw(lua_State* L, SceneNode& node, float delta) override;
		void resize(int width, int height) override;
		void attach(Renderer& renderer) override;

        love::graphics::Shader* get_node_shader(lua_State* L, const SceneNode& node) override;
	};
}

#endif
