////////////////////////////////////////////////////////////////////////////////
// nbunny/world/resource.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "nbunny/world/voronoi.hpp"

#define JC_VORONOI_IMPLEMENTATION
#include "nbunny/deps/jc_voronoi.h"

nbunny::VoronoiPointsBuffer::VoronoiPointsBuffer(std::size_t size)
{
	points.resize(size);
}

std::size_t nbunny::VoronoiPointsBuffer::get_size() const
{
	return points.size();
}

void nbunny::VoronoiPointsBuffer::resize(std::size_t size)
{
	points.resize(size);
}

void nbunny::VoronoiPointsBuffer::set(std::size_t index, const glm::vec2& value)
{
	auto& p = points.at(index);
	p.x = value.x;
	p.y = value.y;
}

glm::vec2 nbunny::VoronoiPointsBuffer::get(std::size_t index) const
{
	auto& p = points.at(index);
	return glm::vec2(p.x, p.y);
}

bool nbunny::VoronoiPointsBuffer::inside(const glm::vec2& point) const
{
	if (points.size() == 0)
	{
		return false;
	}

	auto point1 = points.at(points.size() - 1);
	auto winding_number = 0;

	for (auto& p: points)
	{
		auto point2 = point1;
		point1 = p;

		if (point1.y > point.y)
		{
			if (point2.y <= point.y && (point1.x - point.x) * (point2.y - point.y) < (point2.x - point.x) * (point1.y - point.y))
			{
				++winding_number;
			}
		}
		else
		{
			if (point2.y > point.y && (point1.x - point.x) * (point2.y - point.y) > (point2.x - point.x) * (point1.y - point.y))
			{
				--winding_number;
			}
		}
	}

	return winding_number != 0;
}

const jcv_point* nbunny::VoronoiPointsBuffer::get_points() const
{
	return &points[0];
}

int nbunny_vorono_points_buffer_set(lua_State* L)
{
	auto& points = sol::stack::get<nbunny::VoronoiPointsBuffer&>(L, 1);
	points.set(luaL_checkinteger(L, 2), glm::vec2(luaL_checknumber(L, 3), luaL_checknumber(L, 4)));

	return 0;
}

int nbunny_vorono_points_buffer_get(lua_State* L)
{
	auto& points = sol::stack::get<nbunny::VoronoiPointsBuffer&>(L, 1);
	auto p = points.get(luaL_checkinteger(L, 2));

	lua_pushnumber(L, p.x);
	lua_pushnumber(L, p.y);

	return 2;
}

int nbunny_vorono_points_buffer_inside(lua_State* L)
{
	auto& points = sol::stack::get<nbunny::VoronoiPointsBuffer&>(L, 1);
	auto result = points.inside(glm::vec2(luaL_checknumber(L, 2), luaL_checknumber(L, 3)));

	lua_pushboolean(L, result);

	return 1;
}


extern "C"
NBUNNY_EXPORT int luaopen_nbunny_world_voronoipointsbuffer(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::VoronoiPointsBuffer>("NVoronoiPointsBuffer",
		sol::call_constructor, sol::constructors<nbunny::VoronoiPointsBuffer(std::size_t)>(),
		"getSize", &nbunny::VoronoiPointsBuffer::get_size,
		"resize", &nbunny::VoronoiPointsBuffer::resize,
		"set", &nbunny_vorono_points_buffer_set,
		"get", &nbunny_vorono_points_buffer_get,
		"inside", &nbunny_vorono_points_buffer_inside);

	sol::stack::push(L, T);

	return 1;
}

nbunny::VoronoiDiagram::VoronoiDiagram(const VoronoiPointsBuffer& points) :
	points(points)
{
	jcv_diagram_generate(this->points.get_size(), this->points.get_points(), nullptr, nullptr, &diagram);
}

nbunny::VoronoiDiagram::~VoronoiDiagram()
{
	jcv_diagram_free(&diagram);
}

nbunny::VoronoiPointsBuffer nbunny::VoronoiDiagram::relax() const
{
	VoronoiPointsBuffer result(points);

    const jcv_site* sites = jcv_diagram_get_sites(&diagram);
    for (std::size_t i = 0; i < diagram.numsites; ++i)
    {
    	const jcv_site* site = sites + i;

    	jcv_point sum = site->p;
    	float total = 1.0f;

    	const jcv_graphedge* edge = site->edges;
    	while (edge)
    	{
    		sum.x += edge->pos[0].x;
    		sum.y += edge->pos[0].y;

    		total += 1.0f;

    		edge = edge->next;
    	}

    	sum.x /= total;
    	sum.y /= total;

    	result.set(site->index, glm::vec2(sum.x, sum.y));
    }

    return result;
}

std::size_t nbunny::VoronoiDiagram::get_num_polygons() const
{
	return diagram.numsites;
}

nbunny::VoronoiPointsBuffer nbunny::VoronoiDiagram::get_polygon(std::size_t polygon_index)
{
	std::vector<jcv_point> initial_result;

	const jcv_site* sites = jcv_diagram_get_sites(&diagram);
	if (polygon_index < diagram.numsites)
	{
		const jcv_site* site = sites + polygon_index;

    	const jcv_graphedge* edge = site->edges;
    	while (edge)
    	{
    		initial_result.push_back(edge->pos[0]);

    		edge = edge->next;
    	}
	}

	VoronoiPointsBuffer marshalled_result(initial_result.size());
	for (std::size_t i = 0; i < initial_result.size(); ++i)
	{
		auto& p = initial_result.at(i);
		marshalled_result.set(i, glm::vec2(p.x, p.y));
	}

	return marshalled_result;
}

std::size_t nbunny::VoronoiDiagram::get_point_index_from_polygon(std::size_t polygon_index)
{
	const jcv_site* sites = jcv_diagram_get_sites(&diagram);
	if (polygon_index < diagram.numsites)
	{
		return sites[polygon_index].index;
	}

	return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_world_voronoidiagram(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::VoronoiDiagram>("NVoronoiDiagram",
		sol::call_constructor, sol::constructors<nbunny::VoronoiDiagram(const nbunny::VoronoiPointsBuffer&)>(),
		"relax", &nbunny::VoronoiDiagram::relax,
		"getNumPolygons", &nbunny::VoronoiDiagram::get_num_polygons,
		"getPolygonAtIndex", &nbunny::VoronoiDiagram::get_polygon,
		"getPointIndexFromPolygon", &nbunny::VoronoiDiagram::get_point_index_from_polygon);

	sol::stack::push(L, T);

	return 1;
}
