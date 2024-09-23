////////////////////////////////////////////////////////////////////////////////
// nbunny/lua_runtime.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "common/Module.h"
#include "common/runtime.h"
#include "modules/timer/Timer.h"
#include "nbunny/nbunny.hpp"
#include "nbunny/lua_runtime.hpp"

// const static int WEAK_USERDATA_REFERENCE_KEY = 0;
// void nbunny::lua::impl::get_weak_userdata_reference_table(lua_State* L)
// {
// 	lua_pushlightuserdata(L, const_cast<int*>(&WEAK_USERDATA_REFERENCE_KEY));
// 	lua_rawget(L, LUA_REGISTRYINDEX);

// 	if (lua_isnil(L, -1)) {
// 		lua_pop(L, 1);
// 		lua_pushlightuserdata(L, const_cast<int*>(&WEAK_USERDATA_REFERENCE_KEY));
// 		lua_newtable(L);

// 		// Create metatable with 'weak values'.
// 		lua_newtable(L);
// 		lua_pushstring(L, "__mode");
// 		lua_pushstring(L, "v");
// 		lua_rawset(L, -3);

// 		// Assign metatable.
// 		lua_setmetatable(L, -2);

// 		// Assign table to registory.
// 		lua_rawset(L, LUA_REGISTRYINDEX);

// 		// Retrieve table again.
// 		lua_pushlightuserdata(L, const_cast<int*>(&WEAK_USERDATA_REFERENCE_KEY));
// 		lua_rawget(L, LUA_REGISTRYINDEX);
// 	}
// }

// bool nbunny::lua::impl::get_weak_userdata_reference(lua_State* L, void* key)
// {
// 	get_weak_reference_table(L);
//     lua_
// 	lua_rawgeti(L, -1, key);
// 	lua_remove(L, -2);
// }

// void nbunny::lua::impl::set_weak_userdata_reference(lua_State* L)
// {
// 	get_weak_reference_table(L);

//     auto key = lua_touserdata(L, -2);
//     lua_pushlightuserdata(L, key);
// 	lua_pushvalue(L, -3);
//     lua_settable(L, LUA_REGISTRYINDEX);
// }

thread_local std::unordered_map<std::string, float> luax_wrapper_func_times;
thread_local bool luax_wrapper_func_measure = false;
thread_local int luax_wrapper_func_num_calls = 0;

static int nbunny_lua_runtime_get_func_times(lua_State* L)
{
    lua_createtable(L, 0, luax_wrapper_func_times.size());
    float total_time = 0.0f;
    for (auto& time: luax_wrapper_func_times)
    {
        lua_pushlstring(L, time.first.c_str(), time.first.size());
        lua_pushnumber(L, time.second);
        lua_settable(L, -3);

        total_time += time.second;
    }

    lua_pushnumber(L, total_time);
    return 2;
}

static int nbunny_lua_runtime_get_num_calls(lua_State* L)
{
    lua_pushinteger(L, luax_wrapper_func_num_calls);
    return 1;
}

static int nbunny_lua_runtime_start_measurements(lua_State* L)
{
    luax_wrapper_func_measure = true;
    luax_wrapper_func_num_calls = 0;
    luax_wrapper_func_times.clear();
    return 0;
}

static int nbunny_lua_runtime_stop_measurements(lua_State* L)
{
    luax_wrapper_func_measure = false;
    return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_luaruntime(lua_State* L)
{
    lua_newtable(L);

    lua_pushcfunction(L, &nbunny_lua_runtime_get_func_times);
    lua_setfield(L, -2, "getMeasurements");

    lua_pushcfunction(L, &nbunny_lua_runtime_get_num_calls);
    lua_setfield(L, -2, "getNumCalls");

    lua_pushcfunction(L, &nbunny_lua_runtime_start_measurements);
    lua_setfield(L, -2, "startMeasurements");

    lua_pushcfunction(L, &nbunny_lua_runtime_stop_measurements);
    lua_setfield(L, -2, "stopMeasurements");

    return 1;
}

static int luax_wrapper_func(lua_State* L)
{
    auto func = lua_tocfunction(L, lua_upvalueindex(1));

    int result = 0;
    if (luax_wrapper_func_measure)
    {
        ++luax_wrapper_func_num_calls;

        auto timer_instance = love::Module::getInstance<love::timer::Timer>(love::Module::M_TIMER);
        auto before = timer_instance->getTime();
        love::luax_catchexcept(L, [&]() { result = func(L); });
        auto after = timer_instance->getTime();

        luax_wrapper_func_times[lua_tostring(L, lua_upvalueindex(2))] += after - before;
    }
    else
    {
        love::luax_catchexcept(L, [&]() { result = func(L); });
    }

    return result;
}

void nbunny::lua::impl::luax_register(lua_State* L, const char* tname, const luaL_Reg* l)
{
    for (auto current = l; current->name && current->func; ++current)
    {
        auto name = std::string(tname) + std::string("::") + std::string(current->name);

        lua_pushcfunction(L, current->func);
        lua_pushlstring(L, name.c_str(), name.size());
        lua_pushcclosure(L, &luax_wrapper_func, 2);
        lua_setfield(L, -2, current->name);
    }
}

int nbunny::lua::impl::luax_newmetatable(lua_State* L, const char* tname, const void* tpointer)
{
    lua_pushlightuserdata(L, const_cast<void*>(tpointer));
    lua_rawget(L, LUA_REGISTRYINDEX);

    if (lua_isnil(L, -1))
    {
        lua_pop(L, 1);

        lua_newtable(L);
        lua_pushstring(L, tname);
        lua_setfield(L, -2, "__name");

        lua_pushlightuserdata(L, const_cast<void*>(tpointer));
        lua_pushvalue(L, -2);
        lua_rawset(L, LUA_REGISTRYINDEX);

        return 1;
    }

    return 0;
}

bool nbunny::lua::impl::luax_isudata(lua_State* L, int index, const char* tname, const void* tpointer)
{
    auto real_index = luax_toabsoluteindex(L, index);

    if (!lua_isuserdata(L, real_index))
    {
        return false;
    }

    luax_newmetatable(L, tname, tpointer);
    lua_getmetatable(L, real_index);

    while(!lua_rawequal(L, -1, -2) && !lua_isnil(L, -1))
    {
        lua_getfield(L, -1, "__parent");
        lua_remove(L, -2);
    }

    bool result = lua_rawequal(L, -1, -2) && !lua_isnil(L, -1);
    lua_pop(L, 2);

    return result;
}

void* nbunny::lua::impl::luax_checkudata(lua_State* L, int index, const char* tname, const void* tpointer)
{
    auto real_index = luax_toabsoluteindex(L, index);

    if (!lua_isuserdata(L, real_index))
    {
        luaL_error(L, "expected %s userdata at stack index %d; got %s", tname, real_index, lua_typename(L, lua_type(L, real_index)));
    }

    luax_newmetatable(L, tname, tpointer);
    lua_getmetatable(L, real_index);

    while(!lua_rawequal(L, -1, -2) && !lua_isnil(L, -1))
    {
        lua_getfield(L, -1, "__parent");
        lua_remove(L, -2);
    }

    if (!lua_rawequal(L, -1, -2) || lua_isnil(L, -1))
    {
        lua_getmetatable(L, real_index);
        lua_getfield(L, -1, "__name");

        std::string userdata_type_name;
        if (lua_isstring(L, -1))
        {
            userdata_type_name = lua_tostring(L, -1);
        }
        else
        {
            userdata_type_name = lua_typename(L, lua_type(L, real_index));
        }

        luaL_error(L, "expected %s userdata at stack index %d; got %s", tname, real_index, userdata_type_name.c_str());
    }

    lua_pop(L, 2);
    return lua_touserdata(L, real_index);
}

int nbunny::lua::impl::luax_toabsoluteindex(lua_State* L, int index)
{
    if (index > 0 || index <= LUA_REGISTRYINDEX)
    {
        return index;
    }

    return lua_gettop(L) + index + 1;
}

nbunny::lua::TemporaryReference::TemporaryReference(lua_State* L, int index) :
    L(L), reference(index)
{
    // Nothing.
}

nbunny::lua::TemporaryReference::TemporaryReference(const TemporaryReference& other)
{
    *this = other;
}

nbunny::lua::TemporaryReference::TemporaryReference(TemporaryReference&& other)
{
    *this = other;
}

nbunny::lua::TemporaryReference::~TemporaryReference()
{
    reset();
}

void nbunny::lua::TemporaryReference::push() const
{
    if (!is_valid())
    {
        throw std::runtime_error("reference is invalid");
    }

    lua_rawgeti(L, LUA_REGISTRYINDEX, reference);
}

void nbunny::lua::TemporaryReference::reset()
{
    if (L && reference != LUA_NOREF)
    {
        luaL_unref(L, LUA_REGISTRYINDEX, reference);
    }

    L = nullptr;
    reference = LUA_NOREF;
}

int nbunny::lua::TemporaryReference::fork()
{
    int old_reference = reference;

    L = nullptr;
    reference = LUA_NOREF;

    return old_reference;
}

std::size_t nbunny::lua::TemporaryReference::size() const
{
    if (!is_valid())
    {
        return 0;
    }

    push();
    std::size_t result = lua_objlen(L, -1);
    lua_pop(L, 1);

    return result;
}

bool nbunny::lua::TemporaryReference::is_valid() const
{
    return L && reference != LUA_NOREF;
}

nbunny::lua::TemporaryReference& nbunny::lua::TemporaryReference::operator =(const TemporaryReference& other)
{
    reset();

    if (other.is_valid())
    {
        other.push();

        L = other.L;
        reference = luaL_ref(L, LUA_REGISTRYINDEX);
    }

    return *this;
}

nbunny::lua::TemporaryReference& nbunny::lua::TemporaryReference::operator =(TemporaryReference&& other)
{
    reset();

    L = other.L;
    reference = other.reference;

    other.L = nullptr;
    other.reference = LUA_NOREF;

    return *this;
}
