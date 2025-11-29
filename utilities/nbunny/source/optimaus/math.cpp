#include "nbunny/optimaus/math.hpp"

#include <iostream>
void nbunny::math::look_at(glm::quat& result, const glm::vec3& source, const glm::vec3& target, const glm::vec3& up)
{
	auto forward = glm::normalize(target - source);
	auto dot = glm::dot(forward, up);
	auto axis = glm::cross(up, forward);
	auto length = glm::length(axis);
	if (length == 0.0f)
	{
		result = glm::quat(1.0f, 0.0f, 0.0f, 0.0f);
		return;
	}

	axis /= glm::vec3(length);
	std::cout << "axis: " << axis.x << ", " << axis.y << ", " << axis.z << std::endl;

	result = glm::angleAxis(glm::acos(dot), axis);
}
