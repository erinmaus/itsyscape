////////////////////////////////////////////////////////////////////////////////
// enbunny/optimaus/resource.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "nbunny/lua_runtime.hpp"
#include "nbunny/optimaus/common.hpp"
#include "nbunny/optimaus/resource.hpp"

int nbunny::Resource::get_current_id() const
{
	return current_id;
}

int nbunny::Resource::allocate_id()
{
	return ++current_id;
}

std::shared_ptr<nbunny::ResourceInstance> nbunny::Resource::instantiate(lua_State* L)
{
	return std::make_shared<ResourceInstance>(allocate_id(), set_weak_reference(L));
}

int nbunny_resource_constructor(lua_State* L)
{
	nbunny::lua::push(L, std::make_shared<nbunny::Resource>());
	return 1;
}

static int nbunny_resource_get_current_id(lua_State* L)
{
	auto instance = nbunny::lua::get<nbunny::Resource*>(L, 1);
	nbunny::lua::push(L, instance->get_current_id());
	return 1;
}

static int nbunny_resource_allocate_id(lua_State* L)
{
	auto instance = nbunny::lua::get<nbunny::Resource*>(L, 1);
	nbunny::lua::push(L, instance->allocate_id());
	return 1;
}

static int nbunny_resource_instantiate(lua_State* L)
{
	auto resource = nbunny::lua::get<nbunny::Resource*>(L, 1);
	lua_pushvalue(L, 2);
	auto instance = resource->instantiate(L);
	nbunny::lua::push(L, instance);
	return 1;
}

nbunny::ResourceInstance::ResourceInstance(int id, int reference) :
	id(id), reference(reference)
{
	// Nothing.
}

int nbunny::ResourceInstance::get_id() const
{
	return id;
}

int nbunny::ResourceInstance::get_reference_key() const
{
	return reference;
}

bool nbunny::ResourceInstance::get_reference(lua_State* L) const
{
	get_weak_reference(L, reference);
	return !lua_isnoneornil(L, -1);
}

int nbunny_resource_instance_constructor(lua_State* L)
{
	auto id = nbunny::lua::get<int>(L, 2);
	lua_pushvalue(L, 3);

	nbunny::lua::push(L, std::make_shared<nbunny::ResourceInstance>(id, nbunny::set_weak_reference(L)));
	return 1;
}

static int nbunny_resource_instance_get_id(lua_State* L)
{
	auto instance = nbunny::lua::get<nbunny::ResourceInstance*>(L, 1);
	nbunny::lua::push(L, instance->get_id());
	return 1;
}

static int nbunny_resource_instance_get_resource(lua_State* L)
{
	auto instance = nbunny::lua::get<nbunny::ResourceInstance*>(L, 1);
	instance->get_reference(L);
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_resourceinstance(lua_State* L)
{
	static const luaL_Reg metatable[] {
		{ "getID", &nbunny_resource_instance_get_id },
		{ "getResource", &nbunny_resource_instance_get_resource },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_type<nbunny::ResourceInstance>(L, &nbunny_resource_instance_constructor, metatable);

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_resource(lua_State* L)
{
	static const luaL_Reg metatable[] {
		{ "getCurrentID", &nbunny_resource_get_current_id },
		{ "allocateID", &nbunny_resource_allocate_id },
		{ "instantiate", &nbunny_resource_instantiate },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_type<nbunny::Resource>(L, &nbunny_resource_constructor, metatable);

	return 1;
}
