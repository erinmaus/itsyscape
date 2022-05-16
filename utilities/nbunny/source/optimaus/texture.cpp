////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/texture.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "common/runtime.h"
#include "nbunny/optimaus/common.hpp"
#include "nbunny/optimaus/texture.hpp"

std::shared_ptr<nbunny::ResourceInstance> nbunny::TextureResource::instantiate(lua_State* L)
{
	return std::make_shared<nbunny::TextureInstance>(allocate_id(), set_weak_reference((L)));
}

static int nbunny_texture_resource_instantiate(lua_State* L)
{
	auto& resource = sol::stack::get<nbunny::TextureResource&>(L, 1);
	lua_pushvalue(L, 2);
	auto instance = resource.instantiate(L);
	sol::stack::push(L, std::reinterpret_pointer_cast<nbunny::TextureInstance>(instance));
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_textureresource(lua_State* L)
{
	sol::usertype<nbunny::TextureResource> T(
		sol::base_classes, sol::bases<nbunny::Resource>(),
		sol::call_constructor, sol::factories(&nbunny_resource_create<nbunny::TextureResource>),
		"instantiate", &nbunny_texture_resource_instantiate);

	sol::stack::push(L, T);

	return 1;
}

nbunny::TextureInstance::TextureInstance(int id, int reference) :
	ResourceInstance(id, reference)
{
	// Nothing.
}

void nbunny::TextureInstance::set_texture(love::graphics::Texture* value)
{
	texture.set(value);
}

love::graphics::Texture* nbunny::TextureInstance::get_texture() const
{
	return texture.get();
}

static int nbunny_texture_instance_set_texture(lua_State* L)
{
	auto& texture = sol::stack::get<nbunny::TextureInstance&>(L, 1);
	if (lua_isnil(L, 2))
	{
		texture.set_texture(nullptr);
	}
	else
	{
		auto t = love::luax_checktype<love::graphics::Texture>(L, 2);
		texture.set_texture(t);
	}
	return 0;
}

static int nbunny_texture_instance_get_texture(lua_State* L)
{
	auto& texture = sol::stack::get<nbunny::TextureInstance&>(L, 1);
	auto t = texture.get_texture();
	if (t == nullptr)
	{
		lua_pushnil(L);
	}
	else
	{
		love::luax_pushtype(L, t);
	}

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_textureresourceinstance(lua_State* L)
{
	sol::usertype<nbunny::TextureInstance> T(
		sol::base_classes, sol::bases<nbunny::ResourceInstance>(),
		sol::call_constructor, sol::constructors<nbunny::TextureInstance()>(),
		"setTexture", &nbunny_texture_instance_set_texture,
		"getTexture", &nbunny_texture_instance_get_texture);

	sol::stack::push(L, T);

	return 1;
}
