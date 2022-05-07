////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/resource.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

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

static int nbunny_resource_instance_get_resource(lua_State* L)
{
	auto& instance = sol::stack::get<nbunny::ResourceInstance>(L, 1);
	instance.get_reference(L);

	return 1;
}

static int nbunny_resource_instantiate(lua_State* L)
{
	auto& resource = sol::stack::get<nbunny::Resource>(L, 1);

	// We only want to capture the second argument
	lua_pushvalue(L, 2);
	sol::stack::push(L, resource.instantiate(L));

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_resourceinstance(lua_State* L)
{
	sol::usertype<nbunny::ResourceInstance> T(
		"getID", &nbunny::ResourceInstance::get_id,
		"getResource", &nbunny_resource_instance_get_resource);
	sol::stack::push(L, T);
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_resource(lua_State* L)
{
	sol::usertype<nbunny::Resource> T(
		sol::call_constructor, sol::constructors<nbunny::Resource()>(),
		"getCurrentID", &nbunny::Resource::get_current_id,
		"allocateID", &nbunny::Resource::allocate_id,
		"instantiate", &nbunny_resource_instantiate);

	sol::stack::push(L, T);
	return 1;
}
