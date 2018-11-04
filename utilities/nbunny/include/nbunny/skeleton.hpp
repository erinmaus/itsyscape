////////////////////////////////////////////////////////////////////////////////
// nbunny/skeleton.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_SKELETON_HPP
#define NBUNNY_SKELETON_HPP

#define GLM_ENABLE_EXPERIMENTAL
#include <vector>
#include <algorithm>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/quaternion.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <glm/gtx/quaternion.hpp>

namespace nbunny
{
	struct KeyFrame
	{
		float time;
		glm::vec3 scale;
		glm::quat rotation;
		glm::vec3 translation;

		static glm::mat4 interpolate(const KeyFrame& self, const KeyFrame& other, float time);
	};
}

inline glm::mat4
nbunny::KeyFrame::interpolate(const KeyFrame& self, const KeyFrame& other, float time)
{
	static const float E = 0.001f;
	float timeDifference = std::max(time - self.time, 0.0f);
	float frameDifference = other.time - self.time;

	float delta;
	if (frameDifference <= E)
	{
		delta = 1.0f;
	}
	else
	{
		delta = timeDifference / frameDifference;
	}

	auto rotation = glm::slerp(self.rotation, other.rotation, delta);
	auto scale = glm::mix(self.scale, other.scale, delta);
	auto translation = glm::mix(self.translation, other.translation, delta);

	auto r = glm::toMat4(rotation);
	auto s = glm::scale(glm::mat4(1), scale);
	auto t = glm::translate(glm::mat4(1), translation);
	auto result = t * r * s;

	return result;
}

#endif
