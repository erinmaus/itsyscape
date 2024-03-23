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
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::TextureResource>("NTextureResource",
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

void nbunny::TextureInstance::set_per_pass_texture(int pass_id, love::graphics::Texture* value)
{
	if (!value)
	{
		per_pass_textures.erase(pass_id);
	}
	else
	{
		per_pass_textures.insert_or_assign(pass_id, value);
	}
}

love::graphics::Texture* nbunny::TextureInstance::get_texture() const
{
	return texture.get();
}

love::graphics::Texture* nbunny::TextureInstance::get_per_pass_texture(int pass_id) const
{
	auto result = per_pass_textures.find(pass_id);
	if (result != per_pass_textures.end())
	{
		return result->second.get();
	}

	// Fall back to default texture if no per pass texture specified.
	return texture.get();
}

bool nbunny::TextureInstance::has_per_pass_texture(int pass_id) const
{
	return per_pass_textures.find(pass_id) != per_pass_textures.end();
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

static int nbunny_texture_instance_set_per_pass_texture(lua_State* L)
{
	auto& texture = sol::stack::get<nbunny::TextureInstance&>(L, 1);
	auto index = luaL_checkinteger(L, 2);

	if (lua_isnil(L, 3))
	{
		texture.set_per_pass_texture(index, nullptr);
	}
	else
	{
		auto t = love::luax_checktype<love::graphics::Texture>(L, 3);
		texture.set_per_pass_texture(index, t);
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

static int nbunny_texture_instance_get_per_pass_texture(lua_State* L)
{
	auto& texture = sol::stack::get<nbunny::TextureInstance&>(L, 1);
	auto index = luaL_checkinteger(L, 2);
	auto t = texture.get_per_pass_texture(index);
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
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::TextureInstance>("NTextureInstance",
		sol::base_classes, sol::bases<nbunny::ResourceInstance>(),
		sol::call_constructor, sol::constructors<nbunny::TextureInstance()>(),
		"setTexture", &nbunny_texture_instance_set_texture,
		"setPerPassTexture", &nbunny_texture_instance_set_per_pass_texture,
		"getTexture", &nbunny_texture_instance_get_texture,
		"getPerPassTexture", &nbunny_texture_instance_get_per_pass_texture);

	sol::stack::push(L, T);

	return 1;
}
