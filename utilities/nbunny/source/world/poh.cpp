////////////////////////////////////////////////////////////////////////////////
// nbunny/world/voronoi.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "common/Module.h"
#include "common/runtime.h"
#include "modules/graphics/Graphics.h"
#include "nbunny/world/poh.hpp"

static float signed_distance(const glm::vec3& point, const csg::plane_t& plane) {
    return dot(plane.normal, point) + plane.offset;
}

static glm::vec3 project_point(const glm::vec3& point, const csg::plane_t& plane)
{
	return point - signed_distance(point, plane) * plane.normal;
}

static csg::plane_t make_plane(const glm::vec3& point, const glm::vec3& normal)
{
	return csg::plane_t {
		normal,
		-glm::dot(point, normal)
	};
}

static csg::plane_t transform_plane(const csg::plane_t& plane, const glm::mat4& transform)
{
	glm::vec3 origin_transformed = glm::vec3(transform * glm::vec4(project_point(glm::vec3(0,0,0), plane), 1.0f));
	glm::vec3 normal_transformed = glm::normalize(glm::vec3(transpose(inverse(transform)) * glm::vec4(plane.normal, 0.0f)));
	csg::plane_t transformed_plane = make_plane(origin_transformed, normal_transformed);
	return transformed_plane;
}

nbunny::POHBuilder::POHBuilder() :
	mesh_attribs({
		{ "VertexPosition", love::graphics::vertex::DATA_FLOAT, 3 },
		{ "VertexNormal", love::graphics::vertex::DATA_FLOAT, 3 }
	})
{
	building.set_void_volume(POH_AIR);
}

void nbunny::POHBuilder::cube(csg::volume_t volume, const glm::mat4& transform)
{
	auto brush = building.add();
	brush->set_volume_operation(csg::make_fill_operation(volume));

	static std::vector<csg::plane_t> cube_planes =
	{
		make_plane(glm::vec3(+1, 0, 0), glm::vec3(+1, 0, 0)),
		make_plane(glm::vec3(-1, 0, 0), glm::vec3(-1, 0, 0)),
		make_plane(glm::vec3(0, +1, 0), glm::vec3(0, +1, 0)),
		make_plane(glm::vec3(0, -1, 0), glm::vec3(0, -1, 0)),
		make_plane(glm::vec3(0, 0, +1), glm::vec3(0, 0, +1)),
		make_plane(glm::vec3(0, 0, -1), glm::vec3(0, 0, -1))
	};

	std::vector<csg::plane_t> transformed_planes;
	for (auto& plane: cube_planes)
	{
		transformed_planes.push_back(transform_plane(plane, transform));
	}

	brush->set_planes(transformed_planes);
}

love::graphics::Mesh* nbunny::POHBuilder::build()
{
	std::vector<Vertex> mesh_vertices;

	for (auto brush: building_brushes)
	{
		for (auto& face: brush->get_faces())
		{
			for (auto& fragment: face.fragments)
			{
				if (fragment.back_volume == fragment.front_volume)
				{
					continue;
				}

				auto& vertices = fragment.vertices;

				auto flip = fragment.back_volume == POH_SOLID;
				auto normal = face.plane->normal;
				if (flip)
				{
					normal = -normal;
				}

				auto triangles = csg::triangulate(fragment);
				for (auto& triangle: triangles)
				{
					if (flip)
					{
						mesh_vertices.push_back({ vertices[triangle.i].position, normal });
						mesh_vertices.push_back({ vertices[triangle.k].position, normal });
						mesh_vertices.push_back({ vertices[triangle.j].position, normal });
					}
					else
					{
						mesh_vertices.push_back({ vertices[triangle.i].position, normal });
						mesh_vertices.push_back({ vertices[triangle.j].position, normal });
						mesh_vertices.push_back({ vertices[triangle.k].position, normal });
					}
				}
			}
		}
	}

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	auto mesh = graphics->newMesh(
		mesh_attribs,
		&mesh_vertices[0],
		sizeof(Vertex) * mesh_vertices.size(),
		love::graphics::PRIMITIVE_TRIANGLES,
		love::graphics::vertex::USAGE_STATIC);

	return mesh;
}

int nbunny_poh_builder_cube(lua_State* L)
{
	auto& poh_builder = sol::stack::get<nbunny::POHBuilder&>(L, 1);
	auto volume_type = luaL_checkinteger(L, 2);
	auto transform = love::luax_checktype<love::math::Transform>(L, 3, love::math::Transform::type);
	auto matrix = glm::make_mat4(transform->getMatrix().getElements());

	poh_builder.cube(volume_type, matrix);

	return 0;
}

int nbunny_poh_builder_build(lua_State* L)
{
	auto& poh_builder = sol::stack::get<nbunny::POHBuilder&>(L, 1);
	auto mesh = poh_builder.build();

	if (!mesh)
	{
		lua_pushnil(L);
	}
	else
	{
		love::luax_pushtype(L, mesh);
	}

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_world_pohbuilder(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::POHBuilder>("NPOHBuilder",
		sol::call_constructor, sol::constructors<nbunny::POHBuilder()>(),
		"cube", &nbunny_poh_builder_cube,
		"build", &nbunny_poh_builder_build);

	sol::stack::push(L, T);

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_world_pohvolumes(lua_State* L)
{
	lua_newtable(L);
	lua_pushinteger(L, nbunny::POH_AIR);
	lua_setfield(L, -2, "TYPE_AIR");
	lua_pushinteger(L, nbunny::POH_SOLID);
	lua_setfield(L, -2, "TYPE_SOLID");
	lua_pushinteger(L, nbunny::POH_WATER);
	lua_setfield(L, -2, "TYPE_WATER");

	return 1;
}
