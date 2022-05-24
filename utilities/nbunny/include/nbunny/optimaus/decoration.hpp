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
		glm::vec3 position;
		glm::quat rotation;
		glm::vec3 scale;
		glm::vec4 color;
	};

	class Decoration
	{
	private:
		std::vector<std::unique_ptr<DecorationFeature>> features;

	public:
		Decoration() = default;
		~Decoration() = default;

		DecorationFeature* add_feature(
			const std::string& tile_id,
			const glm::vec3& position,
			const glm::quat& rotation,
			const glm::vec3& scale,
			const glm::vec4& color);
		bool remove_feature(DecorationFeature* feature);

		std::size_t get_num_features() const;
		DecorationFeature* get_feature_by_index(std::size_t index) const;
	};
}

#endif
