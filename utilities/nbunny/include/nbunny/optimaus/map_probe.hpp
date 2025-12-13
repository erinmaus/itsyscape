////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/map_probe.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_MAP_HPP
#define NBUNNY_OPTIMAUS_MAP_HPP

#include "nbunny/nbunny.hpp"
#include "nbunny/optimaus/common.hpp"

#include <unordered_set>
#include <unordered_map>
#include <vector>

namespace nbunny
{
	template <typename T>
	class Curve
	{
	private:
		std::vector<T> values;

		T lerp(float t) const
		{
			if (values.size() == 0)
			{
				return value();
			}

			if (values.size() == 1)
			{
				return values.at(0);
			}

			float t_length = length() * t;

			float previous_length = 0.0f;
			float current_length = distance(values[0], values[1]);
			int previous_index = 0;
			int current_index = 1;
			while (current_length < t_length && current_index < values.size())
			{
				previous_index = current_index;
				current_index = current_index + 1;

				previous_length = current_length;
				current_length += distance(values[previous_index], values[current_index]);
			}

			float step_length = current_length - previous_length;
			float delta = (t_length - previous_length) / step_length;

			return evaluate(values[previous_index], values[current_index], delta);
		}

		T bezier(float t) const
		{
			std::vector<T> curve(values);

			for(auto i = 1; i < curve.size(); ++i)
			{
				for (auto j = 0; j < curve.size() - i; ++j)
				{
					curve[j] = evaluate(curve[j], curve[j + 1], t);
				}
			}

			if (curve.size() > 0)
			{
				return curve[1];
			}

			return value();
		}

	public:
		~Curve() = default;

		void initialize(std::vector<T>& other)
		{
			values = std::move(other);
		}

		int size() const
		{
			return (int)values.size();
		}

		const T& at(int index) const
		{
			index = std::max(index, 0);
			return values.at(index);
		}

		virtual float distance(const T& a, const T& b) const = 0;
		virtual T value() const = 0;
		virtual T evaluate(const T& a, const T& b, float t) const = 0;

		float length() const
		{
			float length = 0.0f;
			for (auto i = 1; i < values.size(); ++i)
			{
				length += distance(values[i - 1], values[i]);
			}
			return length;
		}

		virtual T compute(bool linear, float t) const
		{
			if (linear)
			{
				return lerp(t);
			}

			return bezier(t);
		}
	};

	class PositionCurve : public Curve<glm::vec3>
	{
	public:
		virtual float distance(const glm::vec3& a, const glm::vec3& b) const override;
		glm::vec3 value() const override;
		virtual glm::vec3 evaluate(const glm::vec3& a, const glm::vec3& b, float t) const override;
	}; 

	class RotationCurve : public Curve<glm::quat>
	{
	public:
		virtual float distance(const glm::quat& a, const glm::quat& b) const override;
		glm::quat value() const override;
		virtual glm::quat evaluate(const glm::quat& a, const glm::quat& b, float t) const override;
	};

	class NormalCurve : public Curve<glm::vec3>
	{
	public:
		virtual float distance(const glm::vec3& a, const glm::vec3& b) const override;
		glm::vec3 value() const override;
		virtual glm::vec3 evaluate(const glm::vec3& a, const glm::vec3& b, float t) const override;
	};

	class ScaleCurve : public Curve<glm::vec3>
	{
	public:
		virtual float distance(const glm::vec3& a, const glm::vec3& b) const override;
		glm::vec3 value() const override;
		virtual glm::vec3 evaluate(const glm::vec3& a, const glm::vec3& b, float t) const override;
	};

	struct MapCurveConfig
	{
		bool linear;
		std::vector<glm::vec3> positions;
		std::vector<glm::quat> rotations;
		std::vector<glm::vec3> normals;
		std::vector<glm::vec3> scales;
		glm::vec3 axis;
		glm::vec3 up;
		glm::vec3 min, max;
	};

	class MapCurve
	{
	private:
		bool linear = true;
		PositionCurve position_curve;
		RotationCurve rotation_curve;
		NormalCurve normal_curve;
		ScaleCurve scale_curve;

		glm::vec3 axis, other_axis, up;
		glm::vec3 min, max;
		glm::vec3 size, half_size;

	public:
		MapCurve(MapCurveConfig config);
		~MapCurve() = default;

		const glm::vec3& get_axis() const;
		const glm::vec3& get_up() const;
		const glm::vec3& get_other_axis() const;
		const glm::vec3& get_min() const;
		const glm::vec3& get_max() const;

		glm::vec3 evaluate_position(float t) const;
		glm::quat evaluate_rotation(float t) const;
		glm::vec3 evaluate_normal(float t) const;
		glm::vec3 evaluate_scale(float t) const;

		bool transform(glm::vec3& position, glm::quat& rotation) const;
	};

	struct MapTile
	{
		enum
		{
			CREASE_FORWARD = 0,
			CREASE_BACKWARD = 1
		};

		float top_left = 0.0f, top_right = 0.0f;
		float bottom_left = 0.0f, bottom_right = 0.0f;

		int get_crease() const;
	};

	class Map
	{
	private:
		std::vector<MapTile> tiles;
		int width = 0, height = 0;
		float cell_size = 2.0f;

	public:
		Map(int width, int height, float cell_size);
		~Map() = default;

		int get_width() const;
		int get_height() const;
		float get_cell_size() const;

		MapTile& at(int i, int j);
		const MapTile& at(int i, int j) const;
	};

	struct MapHit
	{
		int i, j;
		glm::vec3 position;
	};

	struct MapTriangle
	{
		std::array<glm::vec3, 3> vertices;
		int i, j;
	};

	struct MapContourTriangle
	{
		std::array<glm::vec3, 3> pretransformed_vertices;
		std::array<glm::vec3, 3> transformed_vertices;
	};

	class TransformedMap
	{
	private:
		std::vector<MapTriangle> triangles;
		std::unordered_set<int> visited_triangles;
		std::unordered_map<glm::vec3, std::vector<int>> cells;
		glm::vec3 map_min, map_max;

		std::unordered_map<glm::ivec2, std::vector<int>> contour_tiles;
		std::vector<MapContourTriangle> contour_triangles;

		glm::vec3 cell_size = glm::vec3(4.0f);

		void add(MapTriangle& triangle);
		void build_map(const Map& map, const MapCurve* map_curve = nullptr);
		void build_contour(const Map& map, const std::vector<MapContourTriangle>& contour);

	public:
		TransformedMap(const Map& map, const std::vector<MapContourTriangle>& contour);
		TransformedMap(const Map& map, const std::vector<MapContourTriangle>& contour, const MapCurve& map_curve);

		void cast_ray(const glm::vec3& origin, const glm::vec3& direction, std::vector<MapHit>& hits);
	};
}

#endif
