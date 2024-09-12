////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/scene.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "common/Matrix.h"
#include "common/runtime.h"
#include "modules/math/Transform.h"
#include "modules/math/MathModule.h"
#include "nbunny/nbunny.hpp"
#include "nbunny/optimaus/common.hpp"
#include "nbunny/optimaus/scene.hpp"
#include "nbunny/optimaus/shader_cache.hpp"

nbunny::SceneNodeTransform::SceneNodeTransform(SceneNode& scene_node) :
	scene_node(scene_node)
{
	// Nothing.
}

nbunny::SceneNode& nbunny::SceneNodeTransform::get_scene_node()
{
	return scene_node;
}

const nbunny::SceneNode& nbunny::SceneNodeTransform::get_scene_node() const
{
	return scene_node;
}

void nbunny::SceneNodeTransform::set_current_translation(const glm::vec3& value)
{
	current_translation = value;
}

void nbunny::SceneNodeTransform::set_previous_translation(const glm::vec3& value)
{
	previous_translation = value;
}

const glm::vec3& nbunny::SceneNodeTransform::get_current_translation() const
{
	return current_translation;
}

const glm::vec3& nbunny::SceneNodeTransform::get_previous_translation() const
{
	return previous_translation;
}

void nbunny::SceneNodeTransform::set_current_rotation(const glm::quat& value)
{
	current_rotation = value;
}

void nbunny::SceneNodeTransform::set_previous_rotation(const glm::quat& value)
{
	previous_rotation = value;
}

const glm::quat& nbunny::SceneNodeTransform::get_current_rotation() const
{
	return current_rotation;
}

const glm::quat& nbunny::SceneNodeTransform::get_previous_rotation() const
{
	return previous_rotation;
}

void nbunny::SceneNodeTransform::set_current_scale(const glm::vec3& value)
{
	current_scale = value;
}

void nbunny::SceneNodeTransform::set_previous_scale(const glm::vec3& value)
{
	previous_scale = value;
}

const glm::vec3& nbunny::SceneNodeTransform::get_current_scale() const
{
	return current_scale;
}

const glm::vec3& nbunny::SceneNodeTransform::get_previous_scale() const
{
	return previous_scale;
}

void nbunny::SceneNodeTransform::set_current_offset(const glm::vec3& value)
{
	current_offset = value;
}

void nbunny::SceneNodeTransform::set_previous_offset(const glm::vec3& value)
{
	previous_offset = value;
}

const glm::vec3& nbunny::SceneNodeTransform::get_current_offset() const
{
	return current_offset;
}

const glm::vec3& nbunny::SceneNodeTransform::get_previous_offset() const
{
	return previous_offset;
}

void nbunny::SceneNodeTransform::tick(float delta)
{
	get_delta(delta, previous_rotation, previous_scale, previous_translation, previous_offset);

	ticked = true;
}

bool nbunny::SceneNodeTransform::get_ticked() const
{
	return ticked;
}

void nbunny::SceneNodeTransform::get_delta(float delta, glm::quat& rotation, glm::vec3& scale, glm::vec3& translation, glm::vec3& offset) const
{
	auto pS = ticked ? previous_scale : current_scale;
	auto pR = ticked ? previous_rotation : current_rotation;
	auto pT = ticked ? previous_translation : current_translation;
	auto pO = ticked ? previous_offset : current_offset;
	auto cS = current_scale;
	auto cR = current_rotation;
	auto cT = current_translation;
	auto cO = current_offset;

	rotation = glm::slerp(pR, cR, delta);
	scale = glm::mix(pS, cS, delta);
	translation = glm::mix(pT, cT, delta);
	offset = glm::mix(pO, cO, delta);
}

glm::mat4 nbunny::SceneNodeTransform::get_local(float delta) const
{
	glm::quat rotation;
	glm::vec3 scale;
	glm::vec3 translation;
	glm::vec3 offset;

	get_delta(delta, rotation, scale, translation, offset);

	auto r = glm::toMat4(rotation);
	auto s = glm::scale(glm::mat4(1), scale);
	auto t = glm::translate(glm::mat4(1), translation);
	auto oF = glm::translate(glm::mat4(1), -offset);
	auto oT = glm::translate(glm::mat4(1), offset);

	auto result = oT * t * s * r * oF;
	return result;
}

glm::mat4 nbunny::SceneNodeTransform::get_global(float delta) const
{
	auto local_transform = get_local(delta);

	auto parent = scene_node.get_parent();
	if (parent)
	{
		auto parent_transform = parent->get_transform().get_global(delta);
		return parent_transform * local_transform;
	}

	return local_transform;
}

nbunny::SceneNodeMaterial::SceneNodeMaterial(SceneNode& scene_node) :
	scene_node(scene_node)
{
	// Nothing.
}

nbunny::SceneNode& nbunny::SceneNodeMaterial::get_scene_node()
{
	return scene_node;
}

const nbunny::SceneNode& nbunny::SceneNodeMaterial::get_scene_node() const
{
	return scene_node;
}

void nbunny::SceneNodeMaterial::set_is_translucent(bool value)
{
	is_translucent = value;	
}

bool nbunny::SceneNodeMaterial::get_is_translucent() const
{
	return is_translucent || color.w < 1.0f;
}

void nbunny::SceneNodeMaterial::set_is_full_lit(bool value)
{
	is_full_lit = value;	
}

bool nbunny::SceneNodeMaterial::get_is_full_lit() const
{
	return is_full_lit;
}

void nbunny::SceneNodeMaterial::set_is_light_target_position_enabled(bool value)
{
	is_light_target_position_enabled = value;	
}

bool nbunny::SceneNodeMaterial::get_is_light_target_position_enabled() const
{
	return is_light_target_position_enabled;
}

void nbunny::SceneNodeMaterial::set_is_z_write_disabled(bool value)
{
	is_z_write_disabled = value;	
}

bool nbunny::SceneNodeMaterial::get_is_z_write_disabled() const
{
	return is_z_write_disabled;
}

void nbunny::SceneNodeMaterial::set_is_cull_disabled(bool value)
{
	is_cull_disabled = value;	
}

bool nbunny::SceneNodeMaterial::get_is_cull_disabled() const
{
	return is_cull_disabled;
}

void nbunny::SceneNodeMaterial::set_is_shadow_caster(bool value)
{
	is_shadow_caster = value;	
}

bool nbunny::SceneNodeMaterial::get_is_shadow_caster() const
{
	return is_shadow_caster;
}

void nbunny::SceneNodeMaterial::set_is_rendered(bool value)
{
	is_rendered = value;	
}

bool nbunny::SceneNodeMaterial::get_is_rendered() const
{
	return is_rendered;
}

void nbunny::SceneNodeMaterial::set_outline_threshold(float value)
{
	outline_threshold = value;	
}

float nbunny::SceneNodeMaterial::get_outline_threshold() const
{
	return outline_threshold;
}

void nbunny::SceneNodeMaterial::set_is_reflective_or_refractive(bool value)
{
	is_reflective_or_refractive = value;	
}

bool nbunny::SceneNodeMaterial::get_is_reflective_or_refractive() const
{
	return is_reflective_or_refractive;
}

void nbunny::SceneNodeMaterial::set_reflection_power(float value)
{
	reflection_power = value;	
}

float nbunny::SceneNodeMaterial::get_reflection_power() const
{
	return reflection_power;
}

void nbunny::SceneNodeMaterial::set_reflection_distance(float value)
{
	reflection_distance = value;	
}

float nbunny::SceneNodeMaterial::get_reflection_distance() const
{
	return reflection_distance;
}

void nbunny::SceneNodeMaterial::set_roughness(float value)
{
	roughness = value;	
}

float nbunny::SceneNodeMaterial::get_roughness() const
{
	return roughness;
}

void nbunny::SceneNodeMaterial::set_is_particulate(bool value)
{
	is_particulate = value;	
}

bool nbunny::SceneNodeMaterial::get_is_particulate() const
{
	return is_particulate;
}

void nbunny::SceneNodeMaterial::set_z_bias(float value)
{
	z_bias = value;	
}

float nbunny::SceneNodeMaterial::get_z_bias() const
{
	return z_bias;
}

const glm::vec4& nbunny::SceneNodeMaterial::get_color() const
{
	return color;
}

void nbunny::SceneNodeMaterial::set_color(const glm::vec4& value)
{
	color = value;
}

const glm::vec4& nbunny::SceneNodeMaterial::get_outline_color() const
{
	return outline_color;
}

void nbunny::SceneNodeMaterial::set_outline_color(const glm::vec4& value)
{
	outline_color = value;
}

void nbunny::SceneNodeMaterial::set_shader(const std::shared_ptr<ResourceInstance>& value)
{
	if (!value)
	{
		shader = std::make_shared<ResourceInstance>();
	}
	else
	{
		shader = value;
	}
}

const std::shared_ptr<nbunny::ResourceInstance>& nbunny::SceneNodeMaterial::get_shader() const
{
	return shader;
}

void nbunny::SceneNodeMaterial::set_textures(const std::vector<std::shared_ptr<TextureInstance>>& value)
{
	textures = value;

	sorted_textures = value;
	std::sort(
		sorted_textures.begin(),
		sorted_textures.end(),
		[&](const auto& a, const auto& b)
		{
			return a->get_id() < b->get_id();
		});
}

const std::vector<std::shared_ptr<nbunny::TextureInstance>>& nbunny::SceneNodeMaterial::get_textures() const
{
	return textures;
}

void nbunny::SceneNodeMaterial::set_uniform(const std::string& uniform_name, const float* data, std::size_t count)
{
	std::vector<std::uint8_t> value;

	value.resize(count * sizeof(float));
	std::memcpy(&value[0], data, value.size());

	value_uniforms.insert_or_assign(uniform_name, value);
}

void nbunny::SceneNodeMaterial::set_uniform(const std::string& uniform_name, const int* data, std::size_t count)
{
	std::vector<std::uint8_t> value;

	value.resize(count * sizeof(int));
	std::memcpy(&value[0], data, value.size());

	value_uniforms.insert_or_assign(uniform_name, value);
}

void nbunny::SceneNodeMaterial::set_uniform(const std::string& uniform_name, love::graphics::Texture* texture)
{
	texture_uniforms.insert_or_assign(uniform_name, texture);
}

void nbunny::SceneNodeMaterial::unset_uniform(const std::string& uniform_name)
{
	value_uniforms.erase(uniform_name);
	texture_uniforms.erase(uniform_name);
}

void nbunny::SceneNodeMaterial::apply_uniforms(ShaderCache& cache, love::graphics::Shader* shader) const
{
	for (auto& i: value_uniforms)
	{
		cache.update_uniform(shader, i.first, i.second);
	}

	for (auto& i: texture_uniforms)
	{
		cache.update_uniform(shader, i.first, i.second);
	}
}

bool nbunny::SceneNodeMaterial::operator <(const SceneNodeMaterial& other) const
{
	if (shader->get_id() < other.shader->get_id())
	{
		return true;
	}
	else if (shader->get_id() > other.shader->get_id())
	{
		return false;
	}

	if (sorted_textures.size() < other.sorted_textures.size())
	{
		return true;
	}
	else if (sorted_textures.size() > other.sorted_textures.size())
	{
		return false;
	}

	for (auto i = 0; i < sorted_textures.size(); ++i)
	{
		if (sorted_textures[i]->get_id() < other.sorted_textures[i]->get_id())
		{
			return true;
		}
		else if (sorted_textures[i]->get_id() > other.sorted_textures[i]->get_id())
		{
			return false;
		}
	}

	return false;
}

const nbunny::Type<nbunny::SceneNode> nbunny::SceneNode::type_pointer;

nbunny::SceneNode::SceneNode(int reference) :
	reference(reference), transform(*this), material(*this)
{
	// Nothing.
}

const nbunny::BaseType& nbunny::SceneNode::get_type() const
{
	return type_pointer;
}

bool nbunny::SceneNode::is_base_type() const
{
	return get_type() == type_pointer;
}

bool nbunny::SceneNode::get_reference(lua_State* L) const
{
	get_weak_reference(L, reference);
	return !lua_isnil(L, -1);;
}

nbunny::SceneNode::~SceneNode()
{
	unset_parent();
	for (auto child: children)
	{
		child->unset_parent();
	}
}

void nbunny::SceneNode::tick(float delta)
{
	transform.tick(delta);
}

bool nbunny::SceneNode::get_ticked() const
{
	return transform.get_ticked();
}

void nbunny::SceneNode::unset_parent()
{
	if (parent)
	{
		parent->children.erase(
			std::remove_if(
				parent->children.begin(),
				parent->children.end(),
				[this](auto& a)
				{
					return a == this;
				}
			),
			parent->children.end()
		);

		parent = nullptr;
	}
}

void nbunny::SceneNode::set_parent(SceneNode* value)
{
	unset_parent();
	if (value)
	{
		parent = value;
		parent->children.push_back(this);
	}
}

nbunny::SceneNode* nbunny::SceneNode::get_parent()
{
	return parent;
}

const std::vector<nbunny::SceneNode*> nbunny::SceneNode::get_children() const
{
	return children;
}

const nbunny::SceneNode* nbunny::SceneNode::get_parent() const
{
	return parent;
}

void nbunny::SceneNode::set_min(const glm::vec3& value)
{
	min = value;
}

const glm::vec3& nbunny::SceneNode::get_min() const
{
	return min;
}

void nbunny::SceneNode::set_max(const glm::vec3& value)
{
	max = value;
}

const glm::vec3& nbunny::SceneNode::get_max() const
{
	return max;
}

float nbunny::SceneNode::calculate_screen_size_percent(const Camera& camera, float delta) const
{
	auto transform = camera.get_projection() * camera.get_view() * get_transform().get_global(delta);
	auto min = get_min();
	auto max = get_max();

	const int NUM_CORNERS = 8;
	glm::vec3 corners[NUM_CORNERS] =
	{
		glm::vec3(min.x, min.y, min.z),
		glm::vec3(max.x, min.y, min.z),
		glm::vec3(min.x, max.y, min.z),
		glm::vec3(min.x, min.y, max.z),
		glm::vec3(max.x, max.y, min.z),
		glm::vec3(max.x, min.y, max.z),
		glm::vec3(min.x, max.y, max.z),
		glm::vec3(max.x, max.y, max.z)
	};

	min = glm::vec3(std::numeric_limits<float>::infinity());
	max = glm::vec3(-std::numeric_limits<float>::infinity());
	for (int i = 0; i < NUM_CORNERS; ++i)
	{
		auto p = transform * glm::vec4(corners[i], 1.0f);
		p /= p.w;

		p += glm::vec4(1.0f);
		p /= glm::vec4(2.0f);

		min = glm::min(min, glm::vec3(p));
		max = glm::max(max, glm::vec3(p));
	}

	auto size = max - min;
	return glm::max(size.x, size.y);
}

nbunny::SceneNodeTransform& nbunny::SceneNode::get_transform()
{
	return transform;
}

const nbunny::SceneNodeTransform& nbunny::SceneNode::get_transform() const
{
	return transform;
}

nbunny::SceneNodeMaterial& nbunny::SceneNode::get_material()
{
	return material;
}

const nbunny::SceneNodeMaterial& nbunny::SceneNode::get_material() const
{
	return material;
}

void nbunny::SceneNode::before_draw(Renderer &renderer, float delta)
{
	// Nothing.
}

void nbunny::SceneNode::draw(Renderer& renderer, float delta)
{
	// Nothing.
}

void nbunny::SceneNode::after_draw(Renderer &renderer, float delta)
{
	// Nothing.
}

void nbunny::SceneNode::collect(SceneNode& node, std::vector<SceneNode*>& result)
{
	if (!node.material.get_is_rendered())
	{
		return;
	}

	result.push_back(&node);
	for (auto child: node.children)
	{
		collect(*child, result);
	}
}

void nbunny::SceneNode::filter_visible(std::vector<SceneNode*>& nodes, const Camera& camera, float delta, std::vector<SceneNode*>& result)
{
	for (auto node: nodes)
	{
		if (!camera.get_is_cull_enabled() || node->get_material().get_is_cull_disabled() || camera.inside(*node, delta))
		{
			result.push_back(node);
		}
	}
}

void nbunny::SceneNode::sort_by_material(std::vector<SceneNode*>& nodes)
{
	std::stable_sort(
		nodes.begin(),
		nodes.end(),
		[](auto a, auto b)
		{
			return a->material < b->material;
		}
	);
}

void nbunny::SceneNode::sort_by_position(std::vector<SceneNode*>& nodes, const Camera& camera, float delta)
{
	std::unordered_map<SceneNode*, glm::vec3> screen_positions;
	std::stable_sort(
		nodes.begin(),
		nodes.end(),
		[&](auto a, auto b)
		{
			if (a->get_material().get_is_cull_disabled() != b->get_material().get_is_cull_disabled())
			{
				if (a->get_material().get_is_cull_disabled())
				{
					return true;
				}
				else
				{
					return false;
				}
			}

			auto a_screen_position = screen_positions.find(a);
			if (a_screen_position == screen_positions.end())
			{
				auto world = glm::vec3(b->transform.get_global(delta) * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f));
				auto p = glm::project(
					world,
					camera.get_view(),
					camera.get_projection(),
					glm::vec4(0.0f, 0.0f, 1.0f, 1.0f)
				);
				a_screen_position = screen_positions.insert(std::make_pair(a, p)).first;
			}

			auto b_screen_position = screen_positions.find(b);
			if (b_screen_position == screen_positions.end())
			{
				auto world = glm::vec3(a->transform.get_global(delta) * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f));
				auto p = glm::project(
					world,
					camera.get_view(),
					camera.get_projection(),
					glm::vec4(0.0f, 0.0f, 1.0f, 1.0f)
				);
				b_screen_position = screen_positions.insert(std::make_pair(b, p)).first;
			}

			return glm::floor(a_screen_position->second.z * 1000) + a->get_material().get_z_bias() < glm::floor(b_screen_position->second.z * 1000) + b->get_material().get_z_bias();
		});
}

void nbunny::SceneNode::walk_by_material(
	SceneNode& node,
	const Camera& camera,
	float delta,
	std::vector<SceneNode*>& result)
{
	if (!camera.get_is_cull_enabled() || node.get_material().get_is_cull_disabled() || camera.inside(node, delta))
	{
		auto p = node.get_transform().get_global(delta) * glm::vec4(0, 0, 0, 1);
		result.push_back(&node);
	}

	for (auto child: node.children)
	{
		walk_by_material(*child, camera, delta, result);
	}

	if (!node.parent)
	{
		sort_by_material(result);
	}
}

void nbunny::SceneNode::walk_by_position(
	SceneNode& node,
	const Camera& camera,
	float delta,
	std::vector<SceneNode*>& result)
{
	if (!camera.get_is_cull_enabled() || node.get_material().get_is_cull_disabled() || camera.inside(node, delta))
	{
		result.push_back(&node);
	}

	for (auto& child : node.children)
	{
		walk_by_position(*child, camera, delta, result);
	}

	if (!node.parent)
	{
		sort_by_position(result, camera, delta);
	}
}

void nbunny::Camera::compute_planes() const
{
	if (!is_dirty)
	{
		return;
	}

	auto projection_view = projection * view;
	auto m = glm::value_ptr(projection_view);

#define M(i, j) m[(j - 1) * 4 + (i - 1)]
	// left
	planes[0].x = M(1, 1) + M(4, 1);
	planes[0].y = M(1, 2) + M(4, 2);
	planes[0].z = M(1, 3) + M(4, 3);
	planes[0].w = M(1, 4) + M(4, 4);
	float left_length_inverse = 1.0f / glm::length(glm::vec3(planes[0]));
	planes[0] *= left_length_inverse;

	// right
	planes[1].x = -M(1, 1) + M(4, 1);
	planes[1].y = -M(1, 2) + M(4, 2);
	planes[1].z = -M(1, 3) + M(4, 3);
	planes[1].w = -M(1, 4) + M(4, 4);
	float right_length_inverse = 1.0f / glm::length(glm::vec3(planes[1]));
	planes[1] *= right_length_inverse;

	// top
	planes[2].x = -M(2, 1) + M(4, 1);
	planes[2].y = -M(2, 2) + M(4, 2);
	planes[2].z = -M(2, 3) + M(4, 3);
	planes[2].w = -M(2, 4) + M(4, 4);
	float top_length_inverse = 1.0f / glm::length(glm::vec3(planes[2]));
	planes[2] *= top_length_inverse;

	// bottom
	planes[3].x = M(2, 1) + M(4, 1);
	planes[3].y = M(2, 2) + M(4, 2);
	planes[3].z = M(2, 3) + M(4, 3);
	planes[3].w = M(2, 4) + M(4, 4);
	float bottom_length_inverse = 1.0f / glm::length(glm::vec3(planes[3]));
	planes[3] *= bottom_length_inverse;

	// near
	planes[4].x = M(3, 1) + M(4, 1);
	planes[4].y = M(3, 2) + M(4, 2);
	planes[4].z = M(3, 3) + M(4, 3);
	planes[4].w = M(3, 4) + M(4, 4);
	float near_length_inverse = 1.0f / glm::length(glm::vec3(planes[4]));
	planes[4] *= near_length_inverse;

	// far
	planes[5].x = -M(3, 1) + M(4, 1);
	planes[5].y = -M(3, 2) + M(4, 2);
	planes[5].z = -M(3, 3) + M(4, 3);
	planes[5].w = -M(3, 4) + M(4, 4);
	float far_length_inverse = 1.0f / glm::length(glm::vec3(planes[5]));
	planes[5] *= far_length_inverse;
#undef M

	auto inverse_view_projection = glm::inverse(projection_view);

	glm::vec4 corners[NUM_POINTS] =
	{
		inverse_view_projection * glm::vec4(-1, -1, -1, 1),
		inverse_view_projection * glm::vec4( 1, -1, -1, 1),
		inverse_view_projection * glm::vec4(-1,  1, -1, 1),
		inverse_view_projection * glm::vec4(-1, -1,  1, 1),
		inverse_view_projection * glm::vec4( 1,  1, -1, 1),
		inverse_view_projection * glm::vec4( 1, -1,  1, 1),
		inverse_view_projection * glm::vec4(-1,  1,  1, 1),
		inverse_view_projection * glm::vec4( 1,  1,  1, 1)
	};

	auto min = glm::vec3(std::numeric_limits<float>::infinity());
	auto max = glm::vec3(-std::numeric_limits<float>::infinity());
	for (int i = 0; i < NUM_POINTS; ++i)
	{
		auto p = glm::vec3(corners[i]) / corners[i].w;
		min = glm::min(min, p);
		max = glm::max(max, p);
	}

	min_frustum = min;
	max_frustum = max;

	is_dirty = false;
}

glm::vec3 nbunny::Camera::get_negative_vertex(
	const glm::vec3& min,
	const glm::vec3& max,
	const glm::vec3& normal)
{
	glm::vec3 result = max;

	if (normal.x <= 0)
	{
		result.x = min.x;
	}

	if (normal.y <= 0)
	{
		result.y = min.y;
	}

	if (normal.z <= 0)
	{
		result.z = min.z;
	}

	return result;
}

void nbunny::Camera::set_field_of_view(float value)
{
	field_of_view = value;
}

float nbunny::Camera::get_field_of_view() const
{
	return field_of_view;
}

void nbunny::Camera::set_near(float value)
{
	near = value;
}

float nbunny::Camera::get_near() const
{
	return near;
}

void nbunny::Camera::set_far(float value)
{
	far = value;
}

float nbunny::Camera::get_far() const
{
	return far;
}

void nbunny::Camera::set_is_cull_enabled(bool value)
{
	is_cull_enabled = value;
}

bool nbunny::Camera::get_is_cull_enabled() const
{
	return is_cull_enabled;
}

const glm::mat4& nbunny::Camera::get_view() const
{
	return view;
}

const glm::mat4& nbunny::Camera::get_projection() const
{
	return projection;
}

const glm::vec3& nbunny::Camera::get_eye_position() const
{
	return eye_position;
}

const glm::vec3& nbunny::Camera::get_target_position() const
{
	return target_position;
}

const glm::quat& nbunny::Camera::get_rotation() const
{
	return rotation;
}

void nbunny::Camera::update(const glm::mat4& view, const glm::mat4& projection)
{
	this->view = view;
	this->projection = projection;
	is_dirty = true;
}

void nbunny::Camera::move(const glm::vec3& eye_position, const glm::vec3& target_position)
{
	this->eye_position = eye_position;
	this->target_position = target_position;
}

void nbunny::Camera::set_bounding_sphere_position(const glm::vec3& value)
{
	bounding_sphere_position = value;
}

const glm::vec3& nbunny::Camera::get_bounding_sphere_position() const
{
	return bounding_sphere_position;
}

void nbunny::Camera::set_bounding_sphere_radius(float value)
{
	bounding_sphere_radius = value;
}

float nbunny::Camera::get_bounding_sphere_radius() const
{
	return bounding_sphere_radius;
}

void nbunny::Camera::set_clip_plane(const glm::vec4& value)
{
	clip_plane = value;
}

const glm::vec4& nbunny::Camera::get_clip_plane() const
{
	return clip_plane;
}

void nbunny::Camera::set_is_clip_plane_enabled(bool value)
{
	is_clip_plane_enabled = value;
}

bool nbunny::Camera::get_is_clip_plane_enabled() const
{
	return is_clip_plane_enabled;
}

void nbunny::Camera::rotate(const glm::quat& rotation)
{
	this->rotation = rotation;
}

static float get_square_axis_difference(float value, float min, float max)
{
	float difference = 0.0;

	if (value < min)
	{
		difference = value - min;
	}
	else if (value > max)
	{
		difference = value - max;
	}

	return difference * difference;
}

bool is_node_intersecting_sphere(const glm::vec3& min, const glm::vec3& max, const glm::vec3& position, float radius)
{
	if (radius == std::numeric_limits<float>::infinity())
	{
		return true;
	}

	float radius_squared = radius * radius;
	float min_distance = 0.0;

	min_distance += get_square_axis_difference(position.x, min.x, max.x);
	min_distance += get_square_axis_difference(position.z, min.z, max.z);
	min_distance += get_square_axis_difference(position.z, min.z, max.z);

	return min_distance <= radius_squared;
}

bool nbunny::Camera::inside(const SceneNode& node, float delta) const
{
	auto transform = node.get_transform().get_global(delta);
	auto min = node.get_min();
	auto max = node.get_max();

	const int NUM_CORNERS = 8;
	glm::vec3 corners[NUM_CORNERS] =
	{
		glm::vec3(min.x, min.y, min.z),
		glm::vec3(max.x, min.y, min.z),
		glm::vec3(min.x, max.y, min.z),
		glm::vec3(min.x, min.y, max.z),
		glm::vec3(max.x, max.y, min.z),
		glm::vec3(max.x, min.y, max.z),
		glm::vec3(min.x, max.y, max.z),
		glm::vec3(max.x, max.y, max.z)
	};

	min = glm::vec3(std::numeric_limits<float>::infinity());
	max = glm::vec3(-std::numeric_limits<float>::infinity());
	for (int i = 0; i < NUM_CORNERS; ++i)
	{
		auto p = glm::vec3(transform * glm::vec4(corners[i], 1.0f));
		min = glm::min(min, p);
		max = glm::max(max, p);
	}

	if (!is_node_intersecting_sphere(min, max, bounding_sphere_position, bounding_sphere_radius))
	{
		return false;
	}

	compute_planes();

	for (int i = 0; i < NUM_PLANES; ++i)
	{
		auto plane = planes[i];
		auto normal = glm::vec3(plane);

		auto vertex = get_negative_vertex(min, max, normal);

		float dot = glm::dot(vertex, normal) + plane.w;
		if (dot < 0.0f)
		{
			return false;
		}
	}

	return true;
}

int nbunny::Camera::get_num_planes() const
{
	return NUM_PLANES;
}

const glm::vec4& nbunny::Camera::get_plane(int index) const
{
	compute_planes();

	index = std::max(std::min(index, NUM_PLANES - 1), 1);
	return planes[index];
}

const glm::vec3& nbunny::Camera::get_min_frustum() const
{
	compute_planes();
	return min_frustum;
}

const glm::vec3& nbunny::Camera::get_max_frustum() const
{
	compute_planes();
	return max_frustum;
}

static int nbunny_scene_node_transform_get_scene_node(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);

	sol::stack::push(L, &transform->get_scene_node());
	return 1;
}

static int nbunny_scene_node_transform_get_current_translation(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	const auto& current_translation = transform->get_current_translation();
	lua_pushnumber(L, current_translation.x);
	lua_pushnumber(L, current_translation.y);
	lua_pushnumber(L, current_translation.z);
	return 3;
}

static int nbunny_scene_node_transform_set_current_translation(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	transform->set_current_translation(glm::vec3(x, y, z));
	return 0;
}

static int nbunny_scene_node_transform_get_previous_translation(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	const auto& previous_translation = transform->get_previous_translation();
	lua_pushnumber(L, previous_translation.x);
	lua_pushnumber(L, previous_translation.y);
	lua_pushnumber(L, previous_translation.z);
	return 3;
}

static int nbunny_scene_node_transform_set_previous_translation(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	transform->set_previous_translation(glm::vec3(x, y, z));
	return 0;
}

static int nbunny_scene_node_transform_get_current_rotation(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	const auto& current_rotation = transform->get_current_rotation();
	lua_pushnumber(L, current_rotation.x);
	lua_pushnumber(L, current_rotation.y);
	lua_pushnumber(L, current_rotation.z);
	lua_pushnumber(L, current_rotation.w);
	return 4;
}

static int nbunny_scene_node_transform_set_current_rotation(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	float w = (float)luaL_checknumber(L, 5);
	transform->set_current_rotation(glm::quat(w, x, y, z));
	return 0;
}

static int nbunny_scene_node_transform_get_previous_rotation(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	const auto& previous_rotation = transform->get_previous_rotation();
	lua_pushnumber(L, previous_rotation.x);
	lua_pushnumber(L, previous_rotation.y);
	lua_pushnumber(L, previous_rotation.z);
	lua_pushnumber(L, previous_rotation.w);
	return 4;
}

static int nbunny_scene_node_transform_set_previous_rotation(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	float w = (float)luaL_checknumber(L, 5);
	transform->set_previous_rotation(glm::quat(x, y, z, w));
	return 0;
}

static int nbunny_scene_node_transform_get_previous_scale(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	const auto& previous_scale = transform->get_previous_scale();
	lua_pushnumber(L, previous_scale.x);
	lua_pushnumber(L, previous_scale.y);
	lua_pushnumber(L, previous_scale.z);
	return 3;
}

static int nbunny_scene_node_transform_set_previous_scale(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	transform->set_previous_scale(glm::vec3(x, y, z));
	return 0;
}

static int nbunny_scene_node_transform_get_current_scale(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	const auto& current_scale = transform->get_current_scale();
	lua_pushnumber(L, current_scale.x);
	lua_pushnumber(L, current_scale.y);
	lua_pushnumber(L, current_scale.z);
	return 3;
}

static int nbunny_scene_node_transform_set_current_scale(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	transform->set_current_scale(glm::vec3(x, y, z));
	return 0;
}

static int nbunny_scene_node_transform_get_current_offset(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	const auto& current_offset = transform->get_current_offset();
	lua_pushnumber(L, current_offset.x);
	lua_pushnumber(L, current_offset.y);
	lua_pushnumber(L, current_offset.z);
	return 3;
}

static int nbunny_scene_node_transform_set_current_offset(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	transform->set_current_offset(glm::vec3(x, y, z));
	return 0;
}

static int nbunny_scene_node_transform_get_previous_offset(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	const auto& previous_offset = transform->get_previous_offset();
	lua_pushnumber(L, previous_offset.x);
	lua_pushnumber(L, previous_offset.y);
	lua_pushnumber(L, previous_offset.z);
	return 3;
}

static int nbunny_scene_node_transform_set_previous_offset(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	transform->set_previous_offset(glm::vec3(x, y, z));
	return 0;
}

static int nbunny_scene_node_transform_get_global_delta_transform(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	float delta = (float)luaL_checknumber(L, 2);
	auto t = love::luax_checktype<love::math::Transform>(L, 3, love::math::Transform::type);

	auto result = transform->get_global(delta);
	auto pointer = glm::value_ptr(result);
	love::Matrix4 matrix(pointer);
	t->setMatrix(matrix);

	return 0;
}

static int nbunny_scene_node_transform_get_local_delta_transform(lua_State* L)
{
	auto transform = sol::stack::get<nbunny::SceneNodeTransform*>(L, 1);
	float delta = (float)luaL_checknumber(L, 2);
	auto t = love::luax_checktype<love::math::Transform>(L, 3, love::math::Transform::type);

	auto result = transform->get_local(delta);
	auto pointer = glm::value_ptr(result);
	love::Matrix4 matrix(pointer);
	t->setMatrix(matrix);

	return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_scenenodetransform(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::SceneNodeTransform>("NSceneNodeTransform",
		"getSceneNode", &nbunny_scene_node_transform_get_scene_node,
		"getCurrentRotation", &nbunny_scene_node_transform_get_current_rotation,
		"setCurrentRotation", &nbunny_scene_node_transform_set_current_rotation,
		"getCurrentScale", &nbunny_scene_node_transform_get_current_scale,
		"setCurrentScale", &nbunny_scene_node_transform_set_current_scale,
		"getCurrentTranslation", &nbunny_scene_node_transform_get_current_translation,
		"setCurrentTranslation", &nbunny_scene_node_transform_set_current_translation,
		"getCurrentOffset", &nbunny_scene_node_transform_get_current_offset,
		"setCurrentOffset", &nbunny_scene_node_transform_set_current_offset,
		"getPreviousRotation", &nbunny_scene_node_transform_get_previous_rotation,
		"setPreviousRotation", &nbunny_scene_node_transform_set_previous_rotation,
		"getPreviousScale", &nbunny_scene_node_transform_get_previous_scale,
		"setPreviousScale", &nbunny_scene_node_transform_set_previous_scale,
		"getPreviousTranslation", &nbunny_scene_node_transform_get_previous_translation,
		"setPreviousTranslation", &nbunny_scene_node_transform_set_previous_translation,
		"getPreviousOffset", &nbunny_scene_node_transform_get_previous_offset,
		"setPreviousOffset", &nbunny_scene_node_transform_set_previous_offset,
		"getGlobalDeltaTransform", &nbunny_scene_node_transform_get_global_delta_transform,
		"getLocalDeltaTransform", &nbunny_scene_node_transform_get_local_delta_transform,
		"tick", &nbunny::SceneNodeTransform::tick);

	sol::stack::push(L, T);

	return 1;
}

static int nbunny_scene_node_material_get_scene_node(lua_State* L)
{
	auto material = sol::stack::get<nbunny::SceneNodeMaterial*>(L, 1);

	sol::stack::push(L, &material->get_scene_node());
	return 1;
}

static int nbunny_scene_node_material_set_color(lua_State* L)
{
	auto material = sol::stack::get<nbunny::SceneNodeMaterial*>(L, 1);
	float r = (float)luaL_checknumber(L, 2);
	float g = (float)luaL_checknumber(L, 3);
	float b = (float)luaL_checknumber(L, 4);
	float a = (float)luaL_checknumber(L, 5);
	material->set_color(glm::vec4(r, g, b, a));
	return 0;
}

static int nbunny_scene_node_material_get_color(lua_State* L)
{
	auto material = sol::stack::get<nbunny::SceneNodeMaterial*>(L, 1);
	const auto& color = material->get_color();
	lua_pushnumber(L, color.x);
	lua_pushnumber(L, color.y);
	lua_pushnumber(L, color.z);
	lua_pushnumber(L, color.w);
	return 4;
}

static int nbunny_scene_node_material_set_outline_color(lua_State* L)
{
	auto material = sol::stack::get<nbunny::SceneNodeMaterial*>(L, 1);
	float r = (float)luaL_checknumber(L, 2);
	float g = (float)luaL_checknumber(L, 3);
	float b = (float)luaL_checknumber(L, 4);
	float a = (float)luaL_checknumber(L, 5);
	material->set_outline_color(glm::vec4(r, g, b, a));
	return 0;
}

static int nbunny_scene_node_material_get_outline_color(lua_State* L)
{
	auto material = sol::stack::get<nbunny::SceneNodeMaterial*>(L, 1);
	const auto& outline_color = material->get_outline_color();
	lua_pushnumber(L, outline_color.x);
	lua_pushnumber(L, outline_color.y);
	lua_pushnumber(L, outline_color.z);
	lua_pushnumber(L, outline_color.w);
	return 4;
}

static int nbunny_scene_node_material_set_textures(lua_State* L)
{
	auto material = sol::stack::get<nbunny::SceneNodeMaterial*>(L, 1);

	std::vector<std::shared_ptr<nbunny::TextureInstance>> textures;
	for (int i = 2; i <= lua_gettop(L); ++i)
	{
		textures.push_back(sol::stack::get<std::shared_ptr<nbunny::TextureInstance>>(L, i));
	}

	material->set_textures(textures);

	return 0;
}

static int nbunny_scene_node_material_get_textures(lua_State* L)
{
	auto material = sol::stack::get<nbunny::SceneNodeMaterial*>(L, 1);
	const auto& textures = material->get_textures();

	for (auto& texture: textures)
	{
		sol::stack::push(L, texture);
	}

	return (int)textures.size();
}

static int nbunny_scene_node_material_send_int(lua_State* L)
{
	auto material = sol::stack::get<nbunny::SceneNodeMaterial*>(L, 1);
	auto uniform_name = luaL_checkstring(L, 2);

	std::vector<int> result;
	auto value = sol::stack::get<sol::table>(L, 3);
	for (std::size_t i = 0; i < value.size(); ++i)
	{
		result.push_back(value.get<int>(i + 1));
	}

	material->set_uniform(uniform_name, &result[0], result.size());

	return 0;
}

static int nbunny_scene_node_material_send_float(lua_State* L)
{
	auto material = sol::stack::get<nbunny::SceneNodeMaterial*>(L, 1);
	auto uniform_name = luaL_checkstring(L, 2);

	std::vector<float> result;
	auto value = sol::stack::get<sol::table>(L, 3);
	for (std::size_t i = 0; i < value.size(); ++i)
	{
		result.push_back(value.get<float>(i + 1));
	}

	material->set_uniform(uniform_name, &result[0], result.size());

	return 0;
}

static int nbunny_scene_node_material_send_texture(lua_State* L)
{
	auto material = sol::stack::get<nbunny::SceneNodeMaterial*>(L, 1);
	auto uniform_name = luaL_checkstring(L, 2);

	love::graphics::Texture* texture = nullptr;
	if (!lua_isnil(L, 3))
	{
		texture = love::luax_checktype<love::graphics::Texture>(L, 3);
	}

	material->set_uniform(uniform_name, texture);

	return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_scenenodematerial(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::SceneNodeMaterial>("NSceneNodeMaterial",
		"getSceneNode", &nbunny_scene_node_material_get_scene_node,
		"setIsTranslucent", &nbunny::SceneNodeMaterial::set_is_translucent,
		"getIsTranslucent", &nbunny::SceneNodeMaterial::get_is_translucent,
		"setIsFullLit", &nbunny::SceneNodeMaterial::set_is_full_lit,
		"getIsFullLit", &nbunny::SceneNodeMaterial::get_is_full_lit,
		"setIsLightTargetPositionEnabled", &nbunny::SceneNodeMaterial::set_is_light_target_position_enabled,
		"getIsLightTargetPositionEnabled", &nbunny::SceneNodeMaterial::get_is_light_target_position_enabled,
		"setIsZWriteDisabled", &nbunny::SceneNodeMaterial::set_is_z_write_disabled,
		"getIsZWriteDisabled", &nbunny::SceneNodeMaterial::get_is_z_write_disabled,
		"setIsCullDisabled", &nbunny::SceneNodeMaterial::set_is_cull_disabled,
		"getIsCullDisabled", &nbunny::SceneNodeMaterial::get_is_cull_disabled,
		"setIsShadowCaster", &nbunny::SceneNodeMaterial::set_is_shadow_caster,
		"getIsShadowCaster", &nbunny::SceneNodeMaterial::get_is_shadow_caster,
		"setOutlineThreshold", &nbunny::SceneNodeMaterial::set_outline_threshold,
		"getOutlineThreshold", &nbunny::SceneNodeMaterial::get_outline_threshold,
		"setIsReflectiveOrRefractive", &nbunny::SceneNodeMaterial::set_is_reflective_or_refractive,
		"getIsReflectiveOrRefractive", &nbunny::SceneNodeMaterial::get_is_reflective_or_refractive,
		"setReflectionPower", &nbunny::SceneNodeMaterial::set_reflection_power,
		"getReflectionPower", &nbunny::SceneNodeMaterial::get_reflection_power,
		"setReflectionDistance", &nbunny::SceneNodeMaterial::set_reflection_distance,
		"getReflectionDistance", &nbunny::SceneNodeMaterial::get_reflection_distance,
		"setRoughness", &nbunny::SceneNodeMaterial::set_roughness,
		"getRoughness", &nbunny::SceneNodeMaterial::get_roughness,
		"setIsParticulate", &nbunny::SceneNodeMaterial::set_is_particulate,
		"getIsParticulate", &nbunny::SceneNodeMaterial::get_is_particulate,
		"setZBias", &nbunny::SceneNodeMaterial::set_z_bias,
		"getZBias", &nbunny::SceneNodeMaterial::get_z_bias,
		"setColor", &nbunny_scene_node_material_set_color,
		"getColor", &nbunny_scene_node_material_get_color,
		"setOutlineColor", &nbunny_scene_node_material_set_outline_color,
		"getOutlineColor", &nbunny_scene_node_material_get_outline_color,
		"setShader", &nbunny::SceneNodeMaterial::set_shader,
		"getShader", &nbunny::SceneNodeMaterial::get_shader,
		"setTextures", &nbunny_scene_node_material_set_textures,
		"getTextures", &nbunny_scene_node_material_get_textures,
		"setIntUniform", &nbunny_scene_node_material_send_int,
		"setFloatUniform", &nbunny_scene_node_material_send_float,
		"setTextureUniform", &nbunny_scene_node_material_send_texture,
		"unsetUniform", &nbunny::SceneNodeMaterial::unset_uniform,
		sol::meta_function::less_than, &nbunny::SceneNodeMaterial::operator <);

	sol::stack::push(L, T);

	return 1;
}

static int nbunny_scene_node_get_reference(lua_State* L)
{
	auto node = sol::stack::get<nbunny::SceneNode*>(L, 1);
	node->get_reference(L);
	return 1;
}

static int nbunny_scene_node_set_parent(lua_State* L)
{
	auto node = sol::stack::get<nbunny::SceneNode*>(L, 1);

	if (lua_isnil(L, 2) || (lua_isboolean(L, 2) && !lua_toboolean(L, 2)))
	{
		node->unset_parent();
	}
	else
	{
		auto parent = sol::stack::get<nbunny::SceneNode*>(L, 2);
		node->set_parent(parent);
	}

	return 0;
}

static int nbunny_scene_node_get_parent(lua_State* L)
{
	auto node = sol::stack::get<nbunny::SceneNode*>(L, 1);
	node->get_reference(L);
	return 1;
}

static int nbunny_scene_node_get_transform(lua_State* L)
{
	auto node = sol::stack::get<nbunny::SceneNode*>(L, 1);
	sol::stack::push(L, &node->get_transform());
	return 1;
}

static int nbunny_scene_node_get_material(lua_State* L)
{
	auto node = sol::stack::get<nbunny::SceneNode*>(L, 1);
	sol::stack::push(L, &node->get_material());
	return 1;
}

static int nbunny_scene_node_get_children(lua_State* L)
{
	auto node = sol::stack::get<nbunny::SceneNode*>(L, 1);
	const auto& children = node->get_children();

	lua_createtable(L, (int)children.size(), 0);

	int index = 1;
	for (auto& child: children)
	{
		lua_pushinteger(L, index);

		node->get_reference(L);
		if (!lua_isnil(L, -1))
		{
			++index;
		}

		lua_rawset(L, -3);
	}

	return 1;
}

static int nbunny_scene_node_set_min(lua_State* L)
{
	auto node = sol::stack::get<nbunny::SceneNode*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	node->set_min(glm::vec3(x, y, z));
	return 0;
}

static int nbunny_scene_node_get_min(lua_State* L)
{
	auto node = sol::stack::get<nbunny::SceneNode*>(L, 1);
	const auto& max = node->get_min();
	lua_pushnumber(L, max.x);
	lua_pushnumber(L, max.y);
	lua_pushnumber(L, max.z);
	return 3;
}

static int nbunny_scene_node_set_max(lua_State* L)
{
	auto node = sol::stack::get<nbunny::SceneNode*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	node->set_max(glm::vec3(x, y, z));
	return 0;
}

static int nbunny_scene_node_get_max(lua_State* L)
{
	auto node = sol::stack::get<nbunny::SceneNode*>(L, 1);
	const auto& max = node->get_max();
	lua_pushnumber(L, max.x);
	lua_pushnumber(L, max.y);
	lua_pushnumber(L, max.z);
	return 3;
}

static int nbunny_scene_node_walk_by_material(lua_State* L)
{
	auto node = sol::stack::get<nbunny::SceneNode*>(L, 1);
	auto camera = sol::stack::get<nbunny::Camera*>(L, 2);
	auto delta = (float)luaL_checknumber(L, 3);

	std::vector<nbunny::SceneNode*> result;
	nbunny::SceneNode::walk_by_material(*node, *camera, delta, result);

	lua_createtable(L, (int)result.size(), 0);

	int index = 1;
	for (auto& i: result)
	{
		lua_pushinteger(L, index);

		if (i->get_reference(L))
		{
			++index;
		}

		lua_rawset(L, -3);
	}

	return 1;
}

static int nbunny_scene_node_walk_by_position(lua_State* L)
{
	auto node = sol::stack::get<nbunny::SceneNode*>(L, 1);
	auto camera = sol::stack::get<nbunny::Camera*>(L, 2);
	auto delta = (float)luaL_checknumber(L, 3);

	std::vector<nbunny::SceneNode*> result;
	nbunny::SceneNode::walk_by_position(*node, *camera, delta, result);

	lua_createtable(L, (int)result.size(), 0);

	int index = 1;
	for (auto& i: result)
	{
		lua_pushinteger(L, index);

		if (i->get_reference(L))
		{
			++index;
		}

		lua_rawset(L, -3);
	}

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_scenenode(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::SceneNode>("NSceneNode",
		sol::call_constructor, sol::factories(&nbunny_scene_node_create<nbunny::SceneNode>),
		"getParent", &nbunny_scene_node_get_parent,
		"setParent", &nbunny_scene_node_set_parent,
		"getTransform", &nbunny_scene_node_get_transform,
		"getMaterial", &nbunny_scene_node_get_material,
		"getReference", &nbunny_scene_node_get_reference,
		"getChildren", &nbunny_scene_node_get_children,
		"getMin", &nbunny_scene_node_get_min,
		"setMin", &nbunny_scene_node_set_min,
		"getMax", &nbunny_scene_node_get_max,
		"setMax", &nbunny_scene_node_set_max,
		"tick", &nbunny::SceneNode::tick,
		"walkByMaterial", &nbunny_scene_node_walk_by_material,
		"walkByPosition", &nbunny_scene_node_walk_by_position);

	sol::stack::push(L, T);

	return 1;
}

const nbunny::Type<nbunny::LuaSceneNode> nbunny::LuaSceneNode::type_pointer;

nbunny::LuaSceneNode::LuaSceneNode(int reference) :
	SceneNode(reference)
{
	// Nothing.
}

const nbunny::BaseType& nbunny::LuaSceneNode::get_type() const
{
	return type_pointer;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_scenenode_luascenenode(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::LuaSceneNode>("NLuaSceneNode",
		sol::base_classes, sol::bases<nbunny::SceneNode>(),
		sol::call_constructor, sol::factories(&nbunny_scene_node_create<nbunny::LuaSceneNode>));

	sol::stack::push(L, T);

	return 1;
}

const nbunny::Type<nbunny::SkyboxSceneNode> nbunny::SkyboxSceneNode::type_pointer;

nbunny::SkyboxSceneNode::SkyboxSceneNode(int reference) :
	SceneNode(reference)
{
	// Nothing.
}

const nbunny::BaseType& nbunny::SkyboxSceneNode::get_type() const
{
	return type_pointer;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_scenenode_skyboxscenenode(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::SkyboxSceneNode>("NSkyboxSceneNode",
		sol::base_classes, sol::bases<nbunny::SceneNode>(),
		sol::call_constructor, sol::factories(&nbunny_scene_node_create<nbunny::SkyboxSceneNode>));

	sol::stack::push(L, T);

	return 1;
}

static int nbunny_camera_get_view(lua_State* L)
{
	auto camera = sol::stack::get<nbunny::Camera*>(L, 1);

	love::math::Transform* transform = nullptr;
	if (!lua_isnil(L, 2))
	{
		transform = love::luax_checktype<love::math::Transform>(L, 2, love::math::Transform::type);
		transform->retain();
	}
	else
	{
		transform = love::math::Math::instance.newTransform();
	}

	const auto& matrix = camera->get_view();
	auto pointer = glm::value_ptr(matrix);
	transform->setMatrix(love::Matrix4(pointer));

	love::luax_pushtype(L, transform);
	transform->release();

	return 1;
}

static int nbunny_camera_get_projection(lua_State* L)
{
	auto camera = sol::stack::get<nbunny::Camera*>(L, 1);

	love::math::Transform* transform = nullptr;
	if (!lua_isnil(L, 2))
	{
		transform = love::luax_checktype<love::math::Transform>(L, 2, love::math::Transform::type);
		transform->retain();
	}
	else
	{
		transform = love::math::Math::instance.newTransform();
	}

	const auto& matrix = camera->get_projection();
	auto pointer = glm::value_ptr(matrix);
	transform->setMatrix(love::Matrix4(pointer));

	love::luax_pushtype(L, transform);
	transform->release();

	return 1;
}

static int nbunny_camera_update(lua_State* L)
{
	auto camera = sol::stack::get<nbunny::Camera*>(L, 1);
	auto view = love::luax_checktype<love::math::Transform>(L, 2, love::math::Transform::type);
	auto projection = love::luax_checktype<love::math::Transform>(L, 3, love::math::Transform::type);

	camera->update(
		glm::make_mat4(view->getMatrix().getElements()),
		glm::make_mat4(projection->getMatrix().getElements()));
	return 0;
}

static int nbunny_camera_move_target(lua_State* L)
{
	auto camera = sol::stack::get<nbunny::Camera*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);

	camera->move(camera->get_eye_position(), glm::vec3(x, y, z));

	return 0;
}

static int nbunny_camera_move_eye(lua_State* L)
{
	auto camera = sol::stack::get<nbunny::Camera*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);

	camera->move(glm::vec3(x, y, z), camera->get_target_position());

	return 0;
}

static int nbunny_camera_update_bounding_sphere(lua_State* L)
{
	auto camera = sol::stack::get<nbunny::Camera*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	float radius = (float)luaL_checknumber(L, 5);

	camera->set_bounding_sphere_position(glm::vec3(x, y, z));
	camera->set_bounding_sphere_radius(radius);

	return 0;
}

static int nbunny_camera_set_clip_plane(lua_State* L)
{
	auto camera = sol::stack::get<nbunny::Camera*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	float w = (float)luaL_checknumber(L, 5);

	camera->set_clip_plane(glm::vec4(x, y, z, w));
	camera->set_is_clip_plane_enabled(true);

	return 0;
}

static int nbunny_camera_unset_clip_plane(lua_State* L)
{
	auto camera = sol::stack::get<nbunny::Camera*>(L, 1);
	camera->set_is_clip_plane_enabled(false);

	return 0;
}

static int nbunny_camera_rotate(lua_State* L)
{
	auto camera = sol::stack::get<nbunny::Camera*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	float w = (float)luaL_checknumber(L, 5);

	camera->rotate(glm::quat(w, x, y, z));

	return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_camera(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::Camera>("NCamera",
		sol::call_constructor, sol::constructors<nbunny::Camera()>(),
		"setFieldOfView", &nbunny::Camera::set_field_of_view,
		"getFieldOfView", &nbunny::Camera::get_field_of_view,
		"setNear", &nbunny::Camera::set_near,
		"getNear", &nbunny::Camera::get_near,
		"setFar", &nbunny::Camera::set_far,
		"getFar", &nbunny::Camera::get_far,
		"setIsCullEnabled", &nbunny::Camera::set_is_cull_enabled,
		"getIsCullEnabled", &nbunny::Camera::get_is_cull_enabled,
		"getView", &nbunny_camera_get_view,
		"getProjection", &nbunny_camera_get_projection,
		"update", &nbunny_camera_update,
		"moveTarget", &nbunny_camera_move_target,
		"updateBoundingSphere", &nbunny_camera_update_bounding_sphere,
		"setClipPlane", &nbunny_camera_set_clip_plane,
		"unsetClipPlane", &nbunny_camera_unset_clip_plane,
		"moveEye", &nbunny_camera_move_eye,
		"rotate", &nbunny_camera_rotate,
		"inside", &nbunny::Camera::inside);

	sol::stack::push(L, T);

	return 1;
}
