////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/map_probe.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "nbunny/lua_runtime.hpp"
#include "nbunny/optimaus/map_probe.hpp"
#include "nbunny/optimaus/math.hpp"
#include "nbunny/optimaus/probe.hpp"

float nbunny::PositionCurve::distance(const glm::vec3& a, const glm::vec3& b) const
{
	return glm::distance(a, b);
}

glm::vec3 nbunny::PositionCurve::value() const 
{
	return glm::vec3(0.0f);
}

glm::vec3 nbunny::PositionCurve::evaluate(const glm::vec3& a, const glm::vec3& b, float t) const
{
	return glm::mix(a, b, t);
}

float nbunny::RotationCurve::distance(const glm::quat& a, const glm::quat& b) const
{
	auto q = glm::conjugate(a) * b;
	return 2.0f * glm::atan(glm::length(glm::vec3(q.x, q.y, q.z)), q.w);
}

glm::quat nbunny::RotationCurve::value() const 
{
	return glm::quat(1.0f, 0.0f, 0.0f, 0.0f);
}

glm::quat nbunny::RotationCurve::evaluate(const glm::quat& a, const glm::quat& b, float t) const
{
	return glm::normalize(glm::slerp(glm::normalize(a), glm::normalize(b), t));
}

float nbunny::NormalCurve::distance(const glm::vec3& a, const glm::vec3& b) const
{
	return 1.0f;
}

glm::vec3 nbunny::NormalCurve::value() const 
{
	return glm::vec3(0.0f, 1.0f, 0.0f);
}

glm::vec3 nbunny::NormalCurve::evaluate(const glm::vec3& a, const glm::vec3& b, float t) const
{
	return glm::normalize(glm::mix(a, b, t));
}

float nbunny::ScaleCurve::distance(const glm::vec3& a, const glm::vec3& b) const
{
	return 1.0f;
}

glm::vec3 nbunny::ScaleCurve::value() const 
{
	return glm::vec3(1.0f);
}

glm::vec3 nbunny::ScaleCurve::evaluate(const glm::vec3& a, const glm::vec3& b, float t) const
{
	return glm::mix(a, b, t);
}

nbunny::MapCurve::MapCurve(nbunny::MapCurveConfig config) :
	linear(config.linear),
	axis(config.axis), up(config.up), other_axis(glm::normalize(glm::cross(config.up, config.axis))),
	min(config.min), max(config.max),
	size(config.max - config.min), half_size((config.max - config.min) / glm::vec3(2.0f))
{
	position_curve.initialize(config.positions);
	rotation_curve.initialize(config.rotations);
	normal_curve.initialize(config.normals);
	scale_curve.initialize(config.scales);
}

glm::vec3 nbunny::MapCurve::evaluate_position(float t) const
{
	return position_curve.compute(linear, t);
}

glm::quat nbunny::MapCurve::evaluate_rotation(float t) const
{
	return rotation_curve.compute(linear, t);
}

glm::vec3 nbunny::MapCurve::evaluate_normal(float t) const
{
	return normal_curve.compute(linear, t);
}

glm::vec3 nbunny::MapCurve::evaluate_scale(float t) const
{
	return scale_curve.compute(linear, t);
}

#include <iostream>

bool nbunny::MapCurve::transform(glm::vec3& position, glm::quat& rotation) const
{
	glm::vec3 planar_position(position.x, 0.0f, position.z);
	auto relative_position = (planar_position - min) / size;

	float t = glm::max(relative_position.x * axis.x, relative_position.z * axis.z);
	if (t < 0.0f || t > 1.0f)
	{
		return false;
	}

	auto curve_position = evaluate_position(t);
	auto curve_rotation = glm::normalize(evaluate_rotation(t));
	auto curve_normal = glm::normalize(evaluate_normal(t));
	auto curve_scale = evaluate_scale(t);

	auto current_up = glm::vec3(position.y) * curve_normal;
	auto current_center = half_size * other_axis;

	auto result = other_axis * position - current_center + current_up;
	position = glm::rotate(curve_rotation, result) * curve_scale + curve_position;

	glm::quat up_rotation;
	math::look_at(up_rotation, glm::vec3(0.0f), curve_normal, up);

	rotation = up_rotation * curve_rotation * rotation;

	return true;
}

static int nbunny_map_curve_constructor(lua_State* L)
{
	auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, 2, nbunny::lua::TemporaryReference());

	nbunny::MapCurveConfig config;
	config.linear = table.get("linear", true);
	config.up = glm::vec3(0.0f, 1.0f, 0.0f);

	auto axis_table = table.get("axis", nbunny::lua::TemporaryReference());
	if (!axis_table.is_valid())
	{
		config.axis = glm::vec3(0.0f, 0.0f, 1.0f);
	}
	else
	{
		config.axis = glm::vec3(axis_table.get(1, 0.0f), axis_table.get(2, 0.0f), axis_table.get(3, 0.0f));
	}

	auto min_table = table.get("min", nbunny::lua::TemporaryReference());
	if (!min_table.is_valid())
	{
		config.min = glm::vec3(0.0f, 0.0f, 1.0f);
	}
	else
	{
		config.min = glm::vec3(min_table.get(1, 0.0f), min_table.get(2, 0.0f), min_table.get(3, 0.0f));
	}

	auto max_table = table.get("max", nbunny::lua::TemporaryReference());
	if (!max_table.is_valid())
	{
		config.max = glm::vec3(0.0f, 0.0f, 1.0f);
	}
	else
	{
		config.max = glm::vec3(max_table.get(1, 0.0f), max_table.get(2, 0.0f), max_table.get(3, 0.0f));
	}

	auto positions = table.get("positions", nbunny::lua::TemporaryReference());
	for (auto i = 0; i < positions.size(); ++i)
	{
		auto position_table = positions.get(i + 1, nbunny::lua::TemporaryReference());
		config.positions.emplace_back(position_table.get(1, 0.0f), position_table.get(2, 0.0f), position_table.get(3, 0.0f));
	}

	auto rotations = table.get("rotations", nbunny::lua::TemporaryReference());
	for (auto i = 0; i < rotations.size(); ++i)
	{
		auto rotation_table = rotations.get(i + 1, nbunny::lua::TemporaryReference());
		config.rotations.emplace_back(rotation_table.get(4, 1.0f), rotation_table.get(1, 0.0f), rotation_table.get(2, 0.0f), rotation_table.get(3, 0.0f));
	}

	auto normals = table.get("normals", nbunny::lua::TemporaryReference());
	for (auto i = 0; i < normals.size(); ++i)
	{
		auto normal_table = normals.get(i + 1, nbunny::lua::TemporaryReference());
		config.normals.emplace_back(normal_table.get(1, 0.0f), normal_table.get(2, 0.0f), normal_table.get(3, 0.0f));
	}

	auto scales = table.get("scales", nbunny::lua::TemporaryReference());
	for (auto i = 0; i < scales.size(); ++i)
	{
		auto scale_table = scales.get(i + 1, nbunny::lua::TemporaryReference());
		config.scales.emplace_back(scale_table.get(1, 0.0f), scale_table.get(2, 0.0f), scale_table.get(3, 0.0f));
	}

	nbunny::lua::push(L, std::make_shared<nbunny::MapCurve>(config));

	return 1;
}

static int nbunny_map_curve_transform(lua_State* L)
{
	auto curve = nbunny::lua::get<nbunny::MapCurve*>(L, 1);

	auto position_x = nbunny::lua::get<float>(L, 2);
	auto position_y = nbunny::lua::get<float>(L, 3);
	auto position_z = nbunny::lua::get<float>(L, 4);
	glm::vec3 position(position_x, position_y, position_z);

	auto rotation_x = nbunny::lua::get<float>(L, 5);
	auto rotation_y = nbunny::lua::get<float>(L, 6);
	auto rotation_z = nbunny::lua::get<float>(L, 7);
	auto rotation_w = nbunny::lua::get<float>(L, 8);
	glm::quat rotation(rotation_w, rotation_x, rotation_y, rotation_z);

	auto result = curve->transform(position, rotation);

	nbunny::lua::push(L,result);
	nbunny::lua::push(L, position.x);
	nbunny::lua::push(L, position.y);
	nbunny::lua::push(L, position.z);
	nbunny::lua::push(L, rotation.x);
	nbunny::lua::push(L, rotation.y);
	nbunny::lua::push(L, rotation.z);
	nbunny::lua::push(L, rotation.w);

	return 8;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_mapcurve(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "transform", &nbunny_map_curve_transform },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_type<nbunny::MapCurve>(L, &nbunny_map_curve_constructor, metatable);

	return 1;
}

int nbunny::MapTile::get_crease() const
{
	if (top_left == bottom_right)
	{
		return CREASE_FORWARD;
	}

	return CREASE_BACKWARD;
}

nbunny::Map::Map(int width, int height, float cell_size)
	: width(width), height(height), cell_size(cell_size)
{
	tiles.resize(width * height);
}

int nbunny::Map::get_width() const
{
	return width;
}

int nbunny::Map::get_height() const
{
	return height;
}

float nbunny::Map::get_cell_size() const
{
	return cell_size;
}

nbunny::MapTile& nbunny::Map::at(int i, int j)
{
	i = glm::clamp(i, 0, width - 1);
	j = glm::clamp(j, 0, height - 1);

	return tiles.at(i * height + j);
}

const nbunny::MapTile& nbunny::Map::at(int i, int j) const
{
	i = glm::clamp(i, 0, width - 1);
	j = glm::clamp(j, 0, height - 1);

	return tiles.at(i * height + j);
}

static int nbunny_map_constructor(lua_State* L)
{
	auto width = glm::max(nbunny::lua::get<int>(L, 2), 1);
	auto height = glm::max(nbunny::lua::get<int>(L, 3), 1);
	auto cell_size = nbunny::lua::get_or<float>(L, 4, 2.0f);

	nbunny::lua::push(L, std::make_shared<nbunny::Map>(width, height, cell_size));
	return 1;
}

static int nbunny_map_update(lua_State* L)
{
	auto map = nbunny::lua::get<nbunny::Map*>(L, 1);

	auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, 2, nbunny::lua::TemporaryReference());
	auto tiles = table.get("tiles", nbunny::lua::TemporaryReference());

	for (auto i = 0; i < map->get_width(); ++i)
	{
		for (auto j = 0; j < map->get_height(); ++j)
		{
			auto index = (j + 1) * map->get_width() + (i + 1);

			auto tile_table = tiles.get(index, nbunny::lua::TemporaryReference());
			auto& tile = map->at(i, j);

			tile.top_left = tile_table.get("topLeft", 0.0f);
			tile.top_right = tile_table.get("topRight", 0.0f);
			tile.bottom_left = tile_table.get("bottomLeft", 0.0f);
			tile.bottom_right = tile_table.get("bottomRight", 0.0f);
		}
	}

	return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_map(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "update", &nbunny_map_update },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_type<nbunny::Map>(L, &nbunny_map_constructor, metatable);

	return 1;
}

void nbunny::TransformedMap::add(MapTriangle& triangle)
{
	int index = triangles.size();

	glm::vec3 min = triangle.vertices.at(0);
	glm::vec3 max = triangle.vertices.at(0);

	for (auto i = 1; i < triangle.vertices.size(); ++i)
	{
		min = glm::min(min, triangle.vertices.at(i));
		max = glm::max(max, triangle.vertices.at(i));
	}

	glm::vec3 min_cell = glm::floor(min * cell_size) / cell_size;
	glm::vec3 max_cell = glm::ceil(max * cell_size) / cell_size;

	for (float x = min_cell.x; x <= max_cell.x; x += cell_size.x)
	{
		for (float y = min_cell.y; y <= max_cell.y; y += cell_size.y)
		{
			for (float z = min_cell.z; z <= max_cell.z; z += cell_size.z)
			{
				auto cell = glm::floor(glm::vec3(x, y, z) * cell_size) / cell_size;

				auto iter = cells.find(cell);
				if (iter == cells.end())
				{
					std::vector<int> e = { index };
					cells.emplace(std::make_pair(cell, e));
				}
				else
				{
					iter->second.push_back(index);
				}
			}
		}
	}

	triangles.emplace_back(std::move(triangle));
}

void nbunny::TransformedMap::build(const Map& map, const MapCurve* map_curve)
{
	for (int i = 0; i < map.get_width(); ++i)
	{
		for (int j = 0; j < map.get_height(); ++j)
		{
			float left = (float)i * map.get_cell_size();
			float right = left + map.get_cell_size(); 
			float top = (float)j * map.get_cell_size();
			float bottom = top + map.get_cell_size();

			auto& tile = map.at(i, j);
			glm::vec3 top_right(right, tile.top_right, top);
			glm::vec3 top_left(left, tile.top_left, top);
			glm::vec3 bottom_left(left,  tile.bottom_left, bottom);
			glm::vec3 bottom_right(right, tile.bottom_right, bottom);

			if (map_curve)
			{
				glm::quat rotation;

				map_curve->transform(top_left, rotation);
				map_curve->transform(top_right, rotation);
				map_curve->transform(bottom_left, rotation);
				map_curve->transform(bottom_right, rotation);
			}

			MapTriangle triangle_a;
			triangle_a.i = i;
			triangle_a.j = j;

			MapTriangle triangle_b;
			triangle_b.i = i;
			triangle_b.j = j;

			if (tile.get_crease() == MapTile::CREASE_FORWARD)
			{
				triangle_a.vertices.at(0) = top_right;
				triangle_a.vertices.at(1) = bottom_left;
				triangle_a.vertices.at(2) = bottom_right;

				triangle_b.vertices.at(0) = top_right;
				triangle_b.vertices.at(1) = top_left;
				triangle_b.vertices.at(2) = bottom_left;
			}
			else
			{
				triangle_a.vertices.at(0) = top_left;
				triangle_a.vertices.at(1) = bottom_right;
				triangle_a.vertices.at(2) = top_right;

				triangle_b.vertices.at(0) = bottom_right;
				triangle_b.vertices.at(1) = top_left;
				triangle_b.vertices.at(2) = bottom_left;
			}

			add(triangle_a);
			add(triangle_b);
		}
	}
}

nbunny::TransformedMap::TransformedMap(const Map& map)
{
	build(map);
}

nbunny::TransformedMap::TransformedMap(const Map& map, const MapCurve& map_curve)
{
	build(map, &map_curve);
}

#include <iostream>

void nbunny::TransformedMap::cast_ray(const glm::vec3& origin, const glm::vec3& direction, std::vector<MapHit>& hits)
{
	visited_triangles.clear();

	for (auto& cell: cells)
	{
		auto min = cell.first;
		auto max = min + cell_size;

		glm::vec3 p;
		if (!ray_hit_bounds(origin, direction, min, max, p))
		{
			continue;
		}

		for (auto& index: cell.second)
		{
			if (visited_triangles.contains(index))
			{
				continue;
			}

			auto& triangle = triangles.at(index);
			if (ray_hit_triangle(origin, direction, triangle.vertices.at(0), triangle.vertices.at(1), triangle.vertices.at(2), p))
			{
				MapHit hit;

				hit.i = triangle.i;
				hit.j = triangle.j;
				hit.position = p;

				hits.emplace_back(std::move(hit));
			}

			visited_triangles.emplace(index);
		}
	}
}

int nbunny_transformed_map_constructor(lua_State* L)
{
	auto map = nbunny::lua::get<nbunny::Map*>(L, 2);

	if (!lua_isnoneornil(L, 3))
	{
		auto map_curve = nbunny::lua::get<nbunny::MapCurve*>(L, 3);
		nbunny::lua::push(L, std::make_shared<nbunny::TransformedMap>(*map, *map_curve));
	}
	else
	{
		nbunny::lua::push(L, std::make_shared<nbunny::TransformedMap>(*map));
	}

	return 1;
}

int nbunny_transformed_map_cast_ray(lua_State* L)
{
	auto transformed_map = nbunny::lua::get<nbunny::TransformedMap*>(L, 1);
	auto origin_x = nbunny::lua::get<float>(L, 2);
	auto origin_y = nbunny::lua::get<float>(L, 3);
	auto origin_z = nbunny::lua::get<float>(L, 4);
	auto direction_x = nbunny::lua::get<float>(L, 5);
	auto direction_y = nbunny::lua::get<float>(L, 6);
	auto direction_z = nbunny::lua::get<float>(L, 7);

	std::vector<nbunny::MapHit> hits;
	transformed_map->cast_ray(
		glm::vec3(origin_x, origin_y, origin_z),
		glm::vec3(direction_x, direction_y, direction_z),
		hits);

	lua_newtable(L);
	for (auto& hit: hits)
	{
		lua_newtable(L);

		nbunny::lua::push(L, hit.i + 1);
		lua_setfield(L, -2, "i");

		nbunny::lua::push(L, hit.j + 1);
		lua_setfield(L, -2, "j");

		nbunny::lua::push(L, hit.position.x);
		lua_setfield(L, -2, "x");

		nbunny::lua::push(L, hit.position.y);
		lua_setfield(L, -2, "y");

		nbunny::lua::push(L, hit.position.z);
		lua_setfield(L, -2, "z");

		lua_rawseti(L, -2, lua_objlen(L, -2) + 1);
	}

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_transformedmap(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "castRay", &nbunny_transformed_map_cast_ray },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_type<nbunny::TransformedMap>(L, &nbunny_transformed_map_constructor, metatable);

	return 1;
}
