////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/scene.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_SCENE_HPP
#define NBUNNY_OPTIMAUS_SCENE_HPP

#include <algorithm>
#include <memory>
#include <vector>
#include "nbunny/nbunny.hpp"
#include "nbunny/optimaus/common.hpp"
#include "nbunny/optimaus/resource.hpp"
#include "nbunny/optimaus/texture.hpp"

namespace nbunny
{
	class Renderer;
	class SceneNode;
	class Camera;

	class SceneNodeTransform
	{
	private:
		SceneNode& scene_node;

		glm::vec3 current_scale = glm::vec3(1.0f);
		glm::quat current_rotation = glm::quat(1.0f, 0.0f, 0.0f, 0.0f);
		glm::vec3 current_translation = glm::vec3(0.0f);
		glm::vec3 current_offset = glm::vec3(0.0f);

		glm::vec3 previous_scale;
		glm::quat previous_rotation;
		glm::vec3 previous_translation;
		glm::vec3 previous_offset;

		void get_delta(float delta, glm::quat& rotation, glm::vec3& scale, glm::vec3& translation, glm::vec3& offset) const;

		bool ticked = false;

	public:
		SceneNodeTransform(SceneNode& scene_node);
		~SceneNodeTransform() = default;

		SceneNode& get_scene_node();
		const SceneNode& get_scene_node() const;

		void set_current_translation(const glm::vec3& value);
		void set_previous_translation(const glm::vec3& value);
		const glm::vec3& get_current_translation() const;
		const glm::vec3& get_previous_translation() const;

		void set_current_rotation(const glm::quat& value);
		void set_previous_rotation(const glm::quat& value);
		const glm::quat& get_current_rotation() const;
		const glm::quat& get_previous_rotation() const;

		void set_current_scale(const glm::vec3& value);
		void set_previous_scale(const glm::vec3& value);
		const glm::vec3& get_current_scale() const;
		const glm::vec3& get_previous_scale() const;

		void set_current_offset(const glm::vec3& value);
		void set_previous_offset(const glm::vec3& value);
		const glm::vec3& get_current_offset() const;
		const glm::vec3& get_previous_offset() const;

		void tick(float delta);
		bool get_ticked() const;

		glm::mat4 get_local(float delta) const;
		glm::mat4 get_global(float delta) const;
	};

	class SceneNodeMaterial
	{
	private:
		SceneNode& scene_node;

		std::shared_ptr<ResourceInstance> shader = std::make_shared<ResourceInstance>();
		std::vector<std::shared_ptr<TextureInstance>> textures;

		bool is_translucent = false;
		bool is_full_lit = false;
		bool is_z_write_disabled = false;
		bool is_cull_disabled = false;
		glm::vec4 color = glm::vec4(1.0f);

		bool is_light_target_position_enabled = false;

	public:
		SceneNodeMaterial(SceneNode& scene_node);
		~SceneNodeMaterial() = default;

		SceneNode& get_scene_node();
		const SceneNode& get_scene_node() const;

		void set_is_translucent(bool value);
		bool get_is_translucent() const;

		void set_is_full_lit(bool value);
		bool get_is_full_lit() const;

		void set_is_light_target_position_enabled(bool value);
		bool get_is_light_target_position_enabled() const;

		void set_is_z_write_disabled(bool value);
		bool get_is_z_write_disabled() const;

		void set_is_cull_disabled(bool value);
		bool get_is_cull_disabled() const;

		const glm::vec4& get_color() const;
		void set_color(const glm::vec4& value);

		void set_shader(const std::shared_ptr<ResourceInstance>& value);
		const std::shared_ptr<ResourceInstance>& get_shader() const;

		void set_textures(const std::vector<std::shared_ptr<TextureInstance>>& textures);
		const std::vector<std::shared_ptr<TextureInstance>>& get_textures() const;

		bool operator <(const SceneNodeMaterial& other) const;
	};

	class SceneNode
	{
	private:
		int reference = 0;

		SceneNode* parent = nullptr;
		std::vector<SceneNode*> children;

		glm::vec3 min = glm::vec3(0.0f);
		glm::vec3 max = glm::vec3(0.0f);

		SceneNodeTransform transform;
		SceneNodeMaterial material;

	public:
		static const Type<SceneNode> type_pointer;

		SceneNode(int reference);
		virtual ~SceneNode();

		virtual const BaseType& get_type() const;
		bool is_base_type() const;

		bool get_reference(lua_State* L) const;

		virtual void tick(float delta);
		bool get_ticked() const;

		void unset_parent();
		void set_parent(SceneNode* value);
		SceneNode* get_parent();
		const SceneNode* get_parent() const;

		const std::vector<SceneNode*> get_children() const;

		void set_min(const glm::vec3& value);
		const glm::vec3& get_min() const;

		void set_max(const glm::vec3& value);
		const glm::vec3& get_max() const;

		SceneNodeTransform& get_transform();
		const SceneNodeTransform& get_transform() const;

		SceneNodeMaterial& get_material();
		const SceneNodeMaterial& get_material() const;

		virtual void before_draw(Renderer& renderer, float delta);
		virtual void draw(Renderer& renderer, float delta);
		virtual void after_draw(Renderer& renderer, float delta);

		static void walk_by_material(
			SceneNode& node,
			const Camera& camera,
			float delta,
			std::vector<SceneNode*>& result);
		static void walk_by_position(
			SceneNode& node,
			const Camera& camera,
			float delta,
			std::vector<SceneNode*>& result);
	};

	class Camera
	{
	private:
		glm::mat4 view = glm::mat4(1.0f);
		glm::mat4 projection = glm::mat4(1.0f);

		glm::vec3 eye_position = glm::vec3(0.0f);
		glm::vec3 target_position = glm::vec3(0.0f);

		glm::quat rotation = glm::quat(1.0f, 0.0f, 0.0f, 0.0f);

		bool is_cull_enabled = true;

		static const int NUM_PLANES = 6;
		mutable glm::vec4 planes[NUM_PLANES];

		static const int NUM_POINTS = 8;
		mutable glm::vec3 minFrustum, maxFrustum;

		mutable bool is_dirty = true;

		void compute_planes() const;

		static glm::vec3 get_negative_vertex(
			const glm::vec3& min,
			const glm::vec3& max,
			const glm::vec3& normal);

	public:
		Camera() = default;
		~Camera() = default;

		void set_is_cull_enabled(bool value);
		bool get_is_cull_enabled() const;

		const glm::mat4& get_view() const;
		const glm::mat4& get_projection() const;

		const glm::vec3& get_eye_position() const;
		const glm::vec3& get_target_position() const;

		const glm::quat& get_rotation() const;

		void update(
			const glm::mat4& view,
			const glm::mat4& projection);

		void move(
			const glm::vec3& eye_position,
			const glm::vec3& target_position);

		void rotate(const glm::quat& rotation);

		bool inside(const SceneNode& node, float delta) const;
	};
}

template <typename SceneNode>
std::shared_ptr<SceneNode> nbunny_scene_node_create(sol::object reference, sol::this_state S)
{
	lua_State* L = S;
	lua_pushvalue(L, 2);
	return std::make_shared<SceneNode>(nbunny::set_weak_reference(L));
}

#endif
