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
#include "nbunny/optimaus/common.hpp"
#include "nbunny/optimaus/static_mesh.hpp"

std::shared_ptr<nbunny::ResourceInstance> nbunny::StaticMeshResource::instantiate(lua_State* L)
{
	return std::make_shared<StaticMeshInstance>(allocate_id(), set_weak_reference((L)));
}

static int nbunny_static_mesh_resource_instantiate(lua_State* L)
{
	auto& resource = sol::stack::get<nbunny::StaticMeshResource&>(L, 1);
	lua_pushvalue(L, 2);
	auto instance = resource.instantiate(L);
	sol::stack::push(L, std::reinterpret_pointer_cast<nbunny::StaticMeshInstance>(instance));
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_staticmeshresource(lua_State* L)
{
	sol::usertype<nbunny::StaticMeshResource> T(
		sol::base_classes, sol::bases<nbunny::Resource>(),
		sol::call_constructor, sol::factories(&nbunny_resource_create<nbunny::StaticMeshResource>),
		"instantiate", &nbunny_static_mesh_resource_instantiate);

	sol::stack::push(L, T);

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
	auto& static_mesh = sol::stack::get<nbunny::StaticMeshInstance&>(L, 1);
	auto group = luaL_checkstring(L, 2);
	auto mesh = love::luax_checktype<love::graphics::Mesh>(L, 3);

	static_mesh.set_mesh(group, mesh);

	return 0;
}

static int nbunny_static_mesh_instance_get_mesh(lua_State* L)
{
	auto& static_mesh = sol::stack::get<nbunny::StaticMeshInstance&>(L, 1);
	auto group = luaL_checkstring(L, 2);

	love::luax_pushtype(L, static_mesh.get_mesh(group));

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_staticmeshresourceinstance(lua_State* L)
{
	sol::usertype<nbunny::StaticMeshInstance> T(
		sol::base_classes, sol::bases<nbunny::ResourceInstance>(),
		sol::call_constructor, sol::constructors<nbunny::StaticMeshInstance()>(),
		"setMesh", &nbunny_static_mesh_instance_set_mesh,
		"getMesh", &nbunny_static_mesh_instance_get_mesh,
		"hasMesh", &nbunny::StaticMeshInstance::has_mesh);

	sol::stack::push(L, T);

	return 1;
}
