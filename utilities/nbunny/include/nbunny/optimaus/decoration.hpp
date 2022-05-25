////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/decoration.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_DECORATION_HPP
#define NBUNNY_OPTIMAUS_DECORATION_HPP

#include <memory>
#include "nbunny/nbunny.hpp"
#include "nbunny/optimaus/resource.hpp"

namespace nbunny
{
	struct DecorationFeature
	{
		std::string tile_id;
		glm::vec3 position = glm::vec3(0.0f);
		glm::quat rotation = glm::quat(1.0f, 0.0f, 0.0f, 0.0f);
		glm::vec3 scale = glm::vec3(1.0f);
		glm::vec4 color = glm::vec4(1.0f);

		DecorationFeature() = default;
		DecorationFeature(const DecorationFeature& other) = default;
	};

	class Decoration
	{
	private:
		std::vector<std::unique_ptr<DecorationFeature>> features;

	public:
		Decoration() = default;
		~Decoration() = default;

		DecorationFeature* add_feature(const DecorationFeature& description);
		bool remove_feature(DecorationFeature* feature);

		std::size_t get_num_features() const;
		DecorationFeature* get_feature_by_index(std::size_t index) const;
	};
}

#endif
