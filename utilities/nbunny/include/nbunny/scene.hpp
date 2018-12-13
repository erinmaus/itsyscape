////////////////////////////////////////////////////////////////////////////////
// nbunny/scene.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_SCENE_HPP
#define NBUNNY_SCENE_HPP

#define GLM_ENABLE_EXPERIMENTAL
#include <algorithm>
#include <memory>
#include <vector>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/quaternion.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <glm/gtx/quaternion.hpp>

namespace nbunny
{
	struct SceneNode;

	struct SceneNodeTransform
	{
		std::shared_ptr<SceneNodeTransform> parent;

		glm::vec3 currentScale = glm::vec3(1.0f);
		glm::quat currentRotation = glm::quat(1.0f, 0.0f, 0.0f, 0.0f);
		glm::vec3 currentTranslation = glm::vec3(0.0f);

		glm::vec3 previousScale;
		glm::quat previousRotation;
		glm::vec3 previousTranslation;

		bool ticked = false;

		void tick();

		glm::mat4 get_local(float delta);
		glm::mat4 get_global(float delta);
	};

	struct SceneNodeMaterial
	{
		int shader = 0;
		std::vector<int> textures;

		bool operator <(const SceneNodeMaterial& other) const;
	};

	struct Camera;

	struct SceneNode
	{
		std::shared_ptr<SceneNode> parent;
		std::vector<std::shared_ptr<SceneNode>> children;

		glm::vec3 min = glm::vec3(0.0f);
		glm::vec3 max = glm::vec3(0.0f);

		std::shared_ptr<SceneNodeTransform> transform = std::make_shared<SceneNodeTransform>();
		SceneNodeMaterial material;

		sol::object reference;

		static void walk_by_material(const std::shared_ptr<SceneNode>& node, const Camera& camera, float delta, std::vector<std::shared_ptr<SceneNode>>& result);
		static void walk_by_position(const std::shared_ptr<SceneNode>& node, const Camera& camera, float delta, std::vector<std::shared_ptr<SceneNode>>& result);
	};

	struct Camera
	{
		glm::mat4 view = glm::mat4(1.0f);
		glm::mat4 projection = glm::mat4(1.0f);

		bool enable_cull = true;

		static const int NUM_PLANES = 6;
		mutable glm::vec4 planes[NUM_PLANES];

		void compute_planes() const;
		bool inside(const SceneNode& node, float delta) const;

		mutable bool is_dirty = true;
	};
}

#endif
