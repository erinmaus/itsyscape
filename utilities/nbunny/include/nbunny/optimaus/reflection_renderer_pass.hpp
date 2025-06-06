////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/reflection_renderer_pass.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_REFLECTION_RENDERER_PASS_HPP
#define NBUNNY_OPTIMAUS_REFLECTION_RENDERER_PASS_HPP

#include "modules/graphics/Shader.h"
#include "nbunny/optimaus/g_buffer.hpp"
#include "nbunny/optimaus/renderer.hpp"
#include "nbunny/optimaus/scene.hpp"

namespace nbunny
{
	class ReflectionRendererPass : public RendererPass
	{
	private:
		GBuffer reflection_buffer;
		GBuffer& g_buffer;

		std::vector<SceneNode*> reflective_or_refractive_scene_nodes;
		std::vector<SceneNode*> translucent_scene_nodes;

		void walk_all_nodes(SceneNode& node, float delta);
		void draw_nodes(lua_State* L, float delta);

		void copy_g_buffer();

	public:
		enum
		{
			REFLECTION_PROPERTIES_INDEX = 1,
			NORMALS_INDEX               = 2
		};

		ReflectionRendererPass(GBuffer& g_buffer);
		~ReflectionRendererPass() = default;

		GBuffer& get_r_buffer();

		void draw(lua_State* L, SceneNode& node, float delta) override;
		void resize(int width, int height) override;
		void attach(Renderer& renderer) override;
        
        bool get_has_reflections() const;

        love::graphics::Shader* get_node_shader(lua_State* L, const SceneNode& node) override;
	};
}

#endif
