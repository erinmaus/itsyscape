////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/model.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "common/runtime.h"
#include "nbunny/optimaus/common.hpp"
#include "nbunny/optimaus/model.hpp"

std::shared_ptr<nbunny::ResourceInstance> nbunny::ModelResource::instantiate(lua_State* L)
{
	return std::make_shared<nbunny::ModelInstance>(allocate_id(), set_weak_reference((L)));
}

static int nbunny_model_resource_instantiate(lua_State* L)
{
	auto& resource = sol::stack::get<nbunny::ModelResource&>(L, 1);
	lua_pushvalue(L, 2);
	auto instance = resource.instantiate(L);
	sol::stack::push(L, std::reinterpret_pointer_cast<nbunny::ModelInstance>(instance));
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_modelresource(lua_State* L)
{
	sol::usertype<nbunny::ModelResource> T(
		sol::base_classes, sol::bases<nbunny::Resource>(),
		sol::call_constructor, sol::constructors<nbunny::ModelResource()>(),
		"instantiate", &nbunny_model_resource_instantiate);

	sol::stack::push(L, T);

	return 1;
}

nbunny::ModelInstance::ModelInstance(int id, int reference) :
	ResourceInstance(id, reference)
{
	// Nothing.
}

void nbunny::ModelInstance::setMesh(love::graphics::Mesh* value)
{
	mesh.set(value);
}

love::graphics::Mesh* nbunny::ModelInstance::getMesh() const
{
	return mesh.get();
}

static int nbunny_model_instance_set_mesh(lua_State* L)
{
	auto& model = sol::stack::get<nbunny::ModelInstance&>(L, 1);
	auto mesh = love::luax_checktype<love::graphics::Mesh>(L, 2);
	model.setMesh(mesh);
	return 0;
}

static int nbunny_model_instance_get_mesh(lua_State* L)
{
	auto& model = sol::stack::get<nbunny::ModelInstance&>(L, 1);
	auto mesh = model.getMesh();
	if (mesh == nullptr)
	{
		lua_pushnil(L);
	}
	else
	{
		love::luax_pushtype(L, model.getMesh());
	}

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_modelresourceinstance(lua_State* L)
{
	sol::usertype<nbunny::ModelInstance> T(
		sol::base_classes, sol::bases<nbunny::ResourceInstance>(),
		sol::call_constructor, sol::constructors<nbunny::ModelInstance()>(),
		"setMesh", &nbunny_model_instance_set_mesh,
		"getMesh", &nbunny_model_instance_get_mesh);

	sol::stack::push(L, T);

	return 1;
}
