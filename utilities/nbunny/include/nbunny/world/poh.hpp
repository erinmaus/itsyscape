////////////////////////////////////////////////////////////////////////////////
// nbunny/world/poh.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

// This module is named "POH" aka "player-owned home".

#pragma once

#ifndef NBUNNY_WORLD_POH_HPP
#define NBUNNY_WORLD_POH_HPP

#include "csg.hpp"
#include "modules/graphics/Mesh.h"
#include "nbunny/nbunny.hpp"

namespace nbunny
{
	static constexpr csg::volume_t POH_AIR   = 0;
	static constexpr csg::volume_t POH_SOLID = 1;
	static constexpr csg::volume_t POH_WATER = 2;

	class POHBuilder
	{
	private:
		csg::world_t building;
		std::vector<csg::brush_t*> building_brushes;

		std::vector<love::graphics::Mesh::AttribFormat> mesh_attribs;
		struct Vertex
		{
			glm::vec3 position;
			glm::vec3 normal;
		};

	public:
		POHBuilder();
		~POHBuilder() = default;

		void cube(csg::volume_t volume, const glm::mat4& transform);

		love::graphics::Mesh* build();
	};
}

#endif
