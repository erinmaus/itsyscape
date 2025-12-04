#include "nbunny/optimaus/math.hpp"

std::uint32_t nbunny::math::next_power_of_two(std::uint32_t value)
{
    value--;
    value |= value >> 1;
    value |= value >> 2;
    value |= value >> 4;
    value |= value >> 8;
    value |= value >> 16;
    value++;

    return value;
}

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

	result = glm::angleAxis(glm::acos(dot), axis);
}
