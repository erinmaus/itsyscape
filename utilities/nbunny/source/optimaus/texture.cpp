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

static int nbunny_texture_resource_constructor(lua_State* L)
{
	nbunny::lua::push(L, std::make_shared<nbunny::TextureResource>());
	return 1;
}

static int nbunny_skeleton_texture_resource_constructor(lua_State* L)
{
	nbunny::lua::push(L, std::make_shared<nbunny::TextureResource>());
	return 1;
}

static int nbunny_texture_resource_instantiate(lua_State* L)
{
	auto resource = nbunny::lua::get<nbunny::TextureResource*>(L, 1);
	lua_pushvalue(L, 2);
	auto instance = resource->instantiate(L);
	nbunny::lua::push(L, std::reinterpret_pointer_cast<nbunny::TextureInstance>(instance));
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_textureresource(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "instantiate", &nbunny_texture_resource_instantiate },
		{ nullptr, nullptr }
	};
	
	nbunny::lua::register_child_type<nbunny::TextureResource, nbunny::Resource>(L, &nbunny_texture_resource_constructor, metatable);

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

void nbunny::TextureInstance::set_bound_texture(const std::string& name, love::graphics::Texture* value)
{
	if (!value)
	{
		bound_textures.erase(name);
	}
	else
	{
		bound_textures.insert_or_assign(name, value);
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

love::graphics::Texture* nbunny::TextureInstance::get_bound_texture(const std::string& name) const
{
	auto result = bound_textures.find(name);
	if (result != bound_textures.end())
	{
		return result->second.get();
	}

	return nullptr;
}

bool nbunny::TextureInstance::has_per_pass_texture(int pass_id) const
{
	return per_pass_textures.find(pass_id) != per_pass_textures.end();
}

bool nbunny::TextureInstance::has_bound_texture(const std::string& name) const
{
	return bound_textures.find(name) != bound_textures.end();
}

static int nbunny_texture_instance_set_texture(lua_State* L)
{
	auto texture = nbunny::lua::get<nbunny::TextureInstance*>(L, 1);
	if (lua_isnil(L, 2))
	{
		texture->set_texture(nullptr);
	}
	else
	{
		auto t = love::luax_checktype<love::graphics::Texture>(L, 2);
		texture->set_texture(t);
	}
	return 0;
}

static int nbunny_texture_instance_set_per_pass_texture(lua_State* L)
{
	auto texture = nbunny::lua::get<nbunny::TextureInstance*>(L, 1);
	auto index = luaL_checkinteger(L, 2);

	if (lua_isnil(L, 3))
	{
		texture->set_per_pass_texture(index, nullptr);
	}
	else
	{
		auto t = love::luax_checktype<love::graphics::Texture>(L, 3);
		texture->set_per_pass_texture(index, t);
	}
	return 0;
}

static int nbunny_texture_instance_set_bound_texture(lua_State* L)
{
	auto texture = nbunny::lua::get<nbunny::TextureInstance*>(L, 1);
	auto name = luaL_checkstring(L, 2);

	if (lua_isnil(L, 3))
	{
		texture->set_bound_texture(name, nullptr);
	}
	else
	{
		auto t = love::luax_checktype<love::graphics::Texture>(L, 3);
		texture->set_bound_texture(name, t);
	}
	return 0;
}

static int nbunny_texture_instance_get_texture(lua_State* L)
{
	auto texture = nbunny::lua::get<nbunny::TextureInstance*>(L, 1);
	auto t = texture->get_texture();
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
	auto texture = nbunny::lua::get<nbunny::TextureInstance*>(L, 1);
	auto index = luaL_checkinteger(L, 2);
	auto t = texture->get_per_pass_texture(index);
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

static int nbunny_texture_instance_get_bound_texture(lua_State* L)
{
	auto texture = nbunny::lua::get<nbunny::TextureInstance*>(L, 1);
	auto name = luaL_checkstring(L, 2);

	auto t = texture->get_bound_texture(name);
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
	static const luaL_Reg metatable[] = {
		{ "setTexture", &nbunny_texture_instance_set_texture },
		{ "setPerPassTexture", &nbunny_texture_instance_set_per_pass_texture },
		{ "setBoundTexture", &nbunny_texture_instance_set_bound_texture },
		{ "getTexture", &nbunny_texture_instance_get_texture },
		{ "getPerPassTexture", &nbunny_texture_instance_get_per_pass_texture },
		{ "getBoundTexture", &nbunny_texture_instance_get_bound_texture },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_child_type<nbunny::TextureInstance, nbunny::ResourceInstance>(L, &nbunny_resource_constructor<nbunny::TextureInstance>, metatable);

	return 1;
}
