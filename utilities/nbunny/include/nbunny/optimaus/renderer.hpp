////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/renderer.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_RENDERER_HPP
#define NBUNNY_OPTIMAUS_RENDERER_HPP

#include <vector>
#include "modules/graphics/Shader.h"
#include "nbunny/optimaus/common.hpp"
#include "nbunny/optimaus/scene.hpp"
#include "nbunny/optimaus/shader_cache.hpp"

namespace nbunny
{
	enum
	{
		RENDERER_PASS_NONE             = 0,
		RENDERER_PASS_DEFERRED         = 1,
		RENDERER_PASS_FORWARD          = 2,
		RENDERER_PASS_MOBILE           = 3,
		RENDERER_PASS_OUTLINE          = 4,
		RENDERER_PASS_ALPHA_MASK       = 5,
		RENDERER_PASS_PARTICLE_OUTLINE = 6,
		RENDERER_PASS_SHADOW           = 7,
		RENDERER_PASS_REFLECTION       = 8,
		RENDERER_PASS_MAX              = 8
	};

	class RendererPass;

	class Renderer
	{
	private:
		int width = 0, height = 0;
		int reference;

		ShaderCache shader_cache;

		Camera default_camera;
		Camera skybox_camera;
		Camera* camera = nullptr;

		std::vector<SceneNode*> all_scene_nodes;
		std::vector<SceneNode*> visible_scene_nodes;
		std::vector<SceneNode*> visible_scene_nodes_by_material;
		std::vector<SceneNode*> visible_scene_nodes_by_position;

		glm::vec4 clear_color = glm::vec4(0.39f, 0.58f, 0.93f, 1);

		std::vector<RendererPass*> renderer_passes;

		love::graphics::Shader* current_shader = nullptr;

		float time = 0.0f;
		float current_time = 0.0f;

		int current_renderer_pass_id = 0;
		bool is_clip_enabled = false;

		SceneNode* root_node = nullptr;

		Camera get_skybox_camera(SceneNode& skybox_scene_node);

		bool should_clear = false;

	public:
		Renderer(int reference);
		~Renderer() = default;

		const std::vector<SceneNode*>& get_all_scene_nodes() const;
		const std::vector<SceneNode*>& get_visible_scene_nodes() const;
		const std::vector<SceneNode*>& get_visible_scene_nodes_by_material() const;
		const std::vector<SceneNode*>& get_visible_scene_nodes_by_position() const;

		void add_renderer_pass(RendererPass* renderer_pass);

		void set_clear_color(const glm::vec4& color);
		const glm::vec4& get_clear_color() const;

		void set_camera(Camera& camera);
		Camera& get_camera();
		const Camera& get_camera() const;

		void set_current_shader(love::graphics::Shader* value);
		love::graphics::Shader* get_current_shader() const;
		int get_current_pass_id() const;

		ShaderCache& get_shader_cache();
		const ShaderCache& get_shader_cache() const;

		SceneNode* get_root_node() const;

		virtual void draw(lua_State* L, SceneNode& node, float delta, int width, int height);
		virtual void draw_node(lua_State* L, SceneNode& node, float delta);
	};

	class RendererPass
	{
	private:
		Renderer* renderer = nullptr;
		int renderer_pass_id = 0;

	public:
		RendererPass(int renderer_pass_id);
		virtual ~RendererPass() = default;

		int get_renderer_pass_id() const;

		Renderer* get_renderer();
		const Renderer* get_renderer() const;

		virtual void draw(lua_State* L, SceneNode& node, float delta) = 0;
		virtual void resize(int width, int height) = 0;

		virtual void attach(Renderer& renderer);
		virtual void load_builtin_shader(
			const std::string& vertex_filename,
			const std::string& pixel_filename);

        virtual love::graphics::Shader* get_node_shader(lua_State* L, const SceneNode& node);
	};
}

#endif
