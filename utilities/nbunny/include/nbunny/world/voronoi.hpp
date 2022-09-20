////////////////////////////////////////////////////////////////////////////////
// nbunny/world/resource.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_WORLD_VORONOI_HPP
#define NBUNNY_WORLD_VORONOI_HPP

#define GLM_ENABLE_EXPERIMENTAL
#include <glm/glm.hpp>
#include "nbunny/nbunny.hpp"
#include "nbunny/deps/jc_voronoi.h"

namespace nbunny
{
	class VoronoiPointsBuffer
	{
		std::vector<jcv_point> points;

	public:
		VoronoiPointsBuffer(const VoronoiPointsBuffer& other) = default;
		VoronoiPointsBuffer(std::size_t size);
		~VoronoiPointsBuffer() = default;

		std::size_t get_size() const;
		void resize(std::size_t size);

		void set(std::size_t index, const glm::vec2& value);
		glm::vec2 get(std::size_t index) const;

		bool inside(const glm::vec2& point) const;

		const jcv_point* get_points() const;
	};

	class VoronoiDiagram
	{
	private:
		jcv_diagram diagram = {};
		VoronoiPointsBuffer points;

	public:
		VoronoiDiagram(const VoronoiPointsBuffer& points);
		~VoronoiDiagram();

		VoronoiPointsBuffer relax() const;

		std::size_t get_num_polygons() const;
		VoronoiPointsBuffer get_polygon(std::size_t polygon_index);

		std::size_t get_point_index_from_polygon(std::size_t polygon_index);
	};
}

#endif
