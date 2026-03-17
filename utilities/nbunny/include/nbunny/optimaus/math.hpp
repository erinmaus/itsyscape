////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/math.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_MATH_HPP
#define NBUNNY_OPTIMAUS_MATH_HPP

#include "nbunny/optimaus/common.hpp"

namespace nbunny
{
	namespace math
	{
		std::uint32_t next_power_of_two(std::uint32_t value);
		void look_at(glm::quat& result, const glm::vec3& source, const glm::vec3& target, const glm::vec3& up);
	}
}

#endif
