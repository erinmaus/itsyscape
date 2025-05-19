////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/static_mesh.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "common/runtime.h"
#include "nbunny/lua_runtime.hpp"
#include "nbunny/optimaus/common.hpp"
#include "nbunny/optimaus/static_mesh.hpp"

std::shared_ptr<nbunny::ResourceInstance> nbunny::StaticMeshResource::instantiate(lua_State* L)
{
	return std::make_shared<StaticMeshInstance>(allocate_id(), set_weak_reference((L)));
}

static int nbunny_static_mesh_resource_constructor(lua_State* L)
{
	nbunny::lua::push(L, std::make_shared<nbunny::StaticMeshResource>());
	return 1;
}

static int nbunny_static_mesh_resource_instantiate(lua_State* L)
{
	auto resource = nbunny::lua::get<nbunny::StaticMeshResource*>(L, 1);
	lua_pushvalue(L, 2);
	auto instance = resource->instantiate(L);
	nbunny::lua::push(L, std::reinterpret_pointer_cast<nbunny::StaticMeshInstance>(instance));
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_staticmeshresource(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "instantiate", &nbunny_static_mesh_resource_instantiate },
		{ nullptr, nullptr }
	};
	
	nbunny::lua::register_child_type<nbunny::StaticMeshResource, nbunny::Resource>(L, &nbunny_static_mesh_resource_constructor, metatable);

	return 1;
}

nbunny::StaticMeshInstance::StaticMeshInstance(int id, int reference) :
	ResourceInstance(id, reference)
{
	// Nothing.
}

void nbunny::StaticMeshInstance::set_mesh(const std::string& group, love::graphics::Mesh* mesh)
{
	auto i = meshes.find(group);
	if (i == meshes.end())
	{
		meshes.emplace(group, mesh);
		groups.push_back(group);

		std::vector<std::uint8_t> data;
		data.resize(mesh->getVertexCount() * mesh->getVertexStride());
		auto gpu_data = (const std::uint8_t*)mesh->mapVertexData();
		std::memcpy(&data[0], gpu_data, data.size());
		mesh->unmapVertexData(0, 0);

		mesh_data.emplace(group, data);
	}
	else
	{
		i->second.set(mesh);
	}
}

love::graphics::Mesh* nbunny::StaticMeshInstance::get_mesh(const std::string& group) const
{
	return meshes.at(group).get();
}

const std::uint8_t* nbunny::StaticMeshInstance::get_mesh_data(const std::string& group) const
{
	return &mesh_data.at(group)[0];
}

bool nbunny::StaticMeshInstance::has_mesh(const std::string& group) const
{
	return meshes.count(group) > 0;
}

const std::vector<std::string>& nbunny::StaticMeshInstance::get_mesh_groups() const
{
	return groups;
}

static int nbunny_static_mesh_instance_set_mesh(lua_State* L)
{
	auto static_mesh = nbunny::lua::get<nbunny::StaticMeshInstance>(L, 1);
	auto group = luaL_checkstring(L, 2);
	auto mesh = love::luax_checktype<love::graphics::Mesh>(L, 3);

	static_mesh->set_mesh(group, mesh);

	return 0;
}

static int nbunny_static_mesh_instance_get_mesh(lua_State* L)
{
	auto static_mesh = nbunny::lua::get<nbunny::StaticMeshInstance>(L, 1);
	auto group = luaL_checkstring(L, 2);

	love::luax_pushtype(L, static_mesh->get_mesh(group));

	return 1;
}

static int nbunny_static_mesh_instance_has_mesh(lua_State* L)
{
	auto static_mesh = nbunny::lua::get<nbunny::StaticMeshInstance>(L, 1);
	auto group = luaL_checkstring(L, 2);

	nbunny::lua::push(L, static_mesh->has_mesh(group));

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_staticmeshresourceinstance(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "setMesh", &nbunny_static_mesh_instance_set_mesh },
		{ "getMesh", &nbunny_static_mesh_instance_get_mesh },
		{ "hasMesh", &nbunny_static_mesh_instance_has_mesh },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_child_type<nbunny::StaticMeshInstance, nbunny::ResourceInstance>(L, &nbunny_resource_constructor<nbunny::StaticMeshInstance>, metatable);

	return 1;
}
