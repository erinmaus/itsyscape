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

#include <cstdint>
#include <algorithm>
#include <limits>
#include <memory>
#include <vector>
#include "modules/graphics/Shader.h"
#include "nbunny/nbunny.hpp"
#include "nbunny/lua_runtime.hpp"
#include "nbunny/optimaus/common.hpp"
#include "nbunny/optimaus/resource.hpp"
#include "nbunny/optimaus/texture.hpp"

namespace nbunny
{
	class Renderer;
	class SceneNode;
	class Camera;
	class ShaderCache;

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
		std::vector<std::shared_ptr<TextureInstance>> sorted_textures;

		std::unordered_map<std::string, std::vector<std::uint8_t>> value_uniforms;
		std::unordered_map<std::string, love::StrongRef<love::graphics::Texture>> texture_uniforms;

		bool is_translucent = false;
		bool is_full_lit = false;
		bool is_z_write_disabled = false;
		bool is_cull_disabled = false;
		float outline_threshold = 1.0;
		glm::vec4 color = glm::vec4(1.0f);
		glm::vec4 outline_color = glm::vec4(glm::vec3(0.0f), 1.0f);

		float reflection_power = 0.0f;
		float reflection_distance = 1.0f;
		float roughness = 0.0f;
		bool is_reflective_or_refractive = false;

		bool is_shadow_caster = true;

		bool is_rendered = true;

		bool is_light_target_position_enabled = false;

		bool is_particulate = false;

		float z_bias = 0.0f;

		bool is_stencil_write_enabled = false;
		bool is_stencil_mask_enabled = false;

		bool is_shimmer_enabled = false;
		glm::vec4 shimmer_color = glm::vec4(1.0f);

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

		void set_is_stencil_write_enabled(bool value);
		bool get_is_stencil_write_enabled() const;

		void set_is_stencil_mask_enabled(bool value);
		bool get_is_stencil_mask_enabled() const;

		bool should_stencil_mask() const;
		bool should_stencil_write() const;

		void set_is_z_write_disabled(bool value);
		bool get_is_z_write_disabled() const;

		void set_is_cull_disabled(bool value);
		bool get_is_cull_disabled() const;

		void set_is_shadow_caster(bool value);
		bool get_is_shadow_caster() const;

		void set_is_rendered(bool value);
		bool get_is_rendered() const;

		void set_outline_threshold(float value);
		float get_outline_threshold() const;

		void set_is_reflective_or_refractive(bool value);
		bool get_is_reflective_or_refractive() const;

		void set_reflection_power(float value);
		float get_reflection_power() const;

		void set_reflection_distance(float value);
		float get_reflection_distance() const;

		void set_roughness(float value);
		float get_roughness() const;

		void set_is_particulate(bool value);
		bool get_is_particulate() const;

		void set_z_bias(float value);
		float get_z_bias() const;

		void set_is_shimmer_enabled(bool value);
		bool get_is_shimmer_enabled() const;

		const glm::vec4& get_shimmer_color() const;
		void set_shimmer_color(const glm::vec4& value);

		const glm::vec4& get_color() const;
		void set_color(const glm::vec4& value);

		const glm::vec4& get_outline_color() const;
		void set_outline_color(const glm::vec4& value);

		void set_shader(const std::shared_ptr<ResourceInstance>& value);
		const std::shared_ptr<ResourceInstance>& get_shader() const;

		void set_textures(const std::vector<std::shared_ptr<TextureInstance>>& textures);
		const std::vector<std::shared_ptr<TextureInstance>>& get_textures() const;

		void set_uniform(const std::string& uniform_name, const float* data, std::size_t count);
		void set_uniform(const std::string& uniform_name, const int* data, std::size_t count);
		void set_uniform(const std::string& uniform_name, love::graphics::Texture* texture);
		void unset_uniform(const std::string& uniform_name);
		void apply_uniforms(ShaderCache& cache, love::graphics::Shader* shader) const;

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

		std::shared_ptr<SceneNodeTransform> transform;
		std::shared_ptr<SceneNodeMaterial> material;

		std::vector<SceneNode*> pending_scene_nodes;

	public:
		static const Type<SceneNode> type_pointer;

		SceneNode(int reference);
		virtual ~SceneNode();

		virtual const BaseType& get_type() const;
		bool is_base_type() const;

		bool get_reference(lua_State* L) const;

		virtual void tick(float delta);
		void tick_children(lua_State* L, float delta);
		bool get_ticked() const;

		virtual void frame(float delta);
		void frame_children(lua_State* L, float delta);

		void unset_parent();
		void set_parent(SceneNode* value);
		SceneNode* get_parent();
		const SceneNode* get_parent() const;

		const std::vector<SceneNode*>& get_children() const;

		void set_min(const glm::vec3& value);
		const glm::vec3& get_min() const;

		void set_max(const glm::vec3& value);
		const glm::vec3& get_max() const;

		float calculate_screen_size_percent(const Camera& camera, float delta) const;

		SceneNodeTransform& get_transform();
		const SceneNodeTransform& get_transform() const;

		const std::shared_ptr<SceneNodeTransform>& get_transform_pointer();

		SceneNodeMaterial& get_material();
		const SceneNodeMaterial& get_material() const;

		const std::shared_ptr<SceneNodeMaterial>& get_material_pointer();

		virtual void before_draw(Renderer& renderer, float delta);
		virtual void draw(Renderer& renderer, float delta);
		virtual void after_draw(Renderer& renderer, float delta);

		static void collect(
			SceneNode& node,
			std::vector<SceneNode*>& result);

		static void filter_visible(std::vector<SceneNode*>& nodes, const Camera& camera, float delta, std::vector<SceneNode*>& result);
		static void sort_by_material(std::vector<SceneNode*>& nodes);
		static void sort_by_position(std::vector<SceneNode*>& nodes, const Camera& camera, float delta);

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

	class LuaSceneNode : public SceneNode
	{
	public:
		static const Type<LuaSceneNode> type_pointer;
		virtual const BaseType& get_type() const override;

		LuaSceneNode(int reference);
		virtual ~LuaSceneNode() = default;
	};

	class SkyboxSceneNode : public SceneNode
	{
	public:
		static const Type<SkyboxSceneNode> type_pointer;
		virtual const BaseType& get_type() const override;

		SkyboxSceneNode(int reference);
		virtual ~SkyboxSceneNode() = default;
	};

	class Camera
	{
	private:
		glm::mat4 view = glm::mat4(1.0f);
		glm::mat4 projection = glm::mat4(1.0f);

		glm::vec3 eye_position = glm::vec3(0.0f);
		glm::vec3 target_position = glm::vec3(0.0f);

		glm::vec3 bounding_sphere_position = glm::vec3(0.0f);
		float bounding_sphere_radius = std::numeric_limits<float>::infinity();

		glm::quat rotation = glm::quat(1.0f, 0.0f, 0.0f, 0.0f);

		bool is_cull_enabled = true;

		static const int NUM_PLANES = 6;
		mutable glm::vec4 planes[NUM_PLANES];

		static const int NUM_POINTS = 8;
		mutable glm::vec3 min_frustum, max_frustum;

		float field_of_view = glm::radians(30.0f);
		float near = 0.01f;
		float far = 192.0f;

		glm::vec4 clip_plane = glm::vec4(0.0);
		bool is_clip_plane_enabled = false;

		mutable bool is_dirty = true;

		void compute_planes() const;

		static glm::vec3 get_negative_vertex(
			const glm::vec3& min,
			const glm::vec3& max,
			const glm::vec3& normal);

	public:
		Camera() = default;
		Camera(const Camera& other) = default;
		~Camera() = default;

		void set_field_of_view(float value);
		float get_field_of_view() const;

		void set_near(float value);
		float get_near() const;

		void set_far(float value);
		float get_far() const;

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
		
		void set_bounding_sphere_position(const glm::vec3& value);
		const glm::vec3& get_bounding_sphere_position() const;

		void set_bounding_sphere_radius(float distance);
		float get_bounding_sphere_radius() const;

		void set_clip_plane(const glm::vec4& value);
		const glm::vec4& get_clip_plane() const;

		void set_is_clip_plane_enabled(bool value);
		bool get_is_clip_plane_enabled() const;

		void rotate(const glm::quat& rotation);

		bool inside(const SceneNode& node, float delta) const;

		int get_num_planes() const;
		const glm::vec4& get_plane(int index) const;

		const glm::vec3& get_min_frustum() const;
		const glm::vec3& get_max_frustum() const;
	};
}

template <typename SceneNode>
int nbunny_scene_node_constructor(lua_State* L)
{
	auto typed_pointer = std::make_shared<SceneNode>(nbunny::set_weak_reference(L));
	nbunny::lua::push<SceneNode>(L, typed_pointer);
	return 1;
}

#endif
