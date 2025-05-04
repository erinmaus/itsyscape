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
#include "nbunny/game_manager.hpp"

struct FuncTime
{
    double time = 0.0;
    int num_calls = 0;
};

struct Call
{
    std::string func;
    nbunny::GameManagerVariant arguments;
    nbunny::GameManagerVariant return_value;
    std::vector<std::string> stack;
    double time = 0.0;
};

thread_local std::unordered_map<std::string, FuncTime> luax_wrapper_func_times;
thread_local bool luax_wrapper_func_measure = false;
thread_local int luax_wrapper_func_num_calls = 0;

thread_local std::vector<Call> luax_wrapper_debug_calls;
thread_local bool luax_wrapper_func_debug = false;

thread_local std::vector<Call> luax_wrapper_pending_debug_calls;

static int nbunny_lua_runtime_get_func_times(lua_State* L)
{
    lua_createtable(L, 0, luax_wrapper_func_times.size());
    double total_time = 0.0;
    for (auto& time: luax_wrapper_func_times)
    {
        lua_pushlstring(L, time.first.c_str(), time.first.size());
        lua_newtable(L);
        lua_pushnumber(L, time.second.time * 1000.0f);
        lua_setfield(L, -2, "time");
        lua_pushinteger(L, time.second.num_calls);
        lua_setfield(L, -2, "calls");
        lua_settable(L, -3);

        total_time += time.second.time;
    }

    lua_pushnumber(L, total_time);
    return 2;
}

static int nbunny_lua_runtime_get_calls(lua_State* L)
{
    lua_createtable(L, 0, luax_wrapper_debug_calls.size());
    int index = 1;
    for (auto& call: luax_wrapper_debug_calls)
    {
        lua_newtable(L);

        lua_pushlstring(L, call.func.c_str(), call.func.size());
        lua_setfield(L, -2, "functionName");

        lua_newtable(L);

        lua_newtable(L);
        for (auto i = 1; i <= call.arguments.length(); ++i)
        {
            auto value = call.arguments.get(i - 1);
            value.to_lua(L);
            lua_rawseti(L, -2, i);
        }
        lua_setfield(L, -2, "values");

        lua_pushinteger(L, call.arguments.length());
        lua_setfield(L, -2, "n");

        lua_setfield(L, -2, "arguments");

        lua_newtable(L);

        lua_newtable(L);
        for (auto i = 1; i <= call.return_value.length(); ++i)
        {
            auto value = call.return_value.get(i - 1);
            value.to_lua(L);
            lua_rawseti(L, -2, i);
        }
        lua_setfield(L, -2, "values");

        lua_pushinteger(L, call.return_value.length());
        lua_setfield(L, -2, "n");

        lua_setfield(L, -2, "returnValue");

        lua_newtable(L);
        for (auto i = 0; i < call.stack.size(); ++i)
        {
            auto& s = call.stack[i];
            lua_pushlstring(L, s.c_str(), s.size());
            lua_rawseti(L, -2, i + 1);
        }
        lua_setfield(L, -2, "stack");

        lua_pushnumber(L, call.time);
        lua_setfield(L, -2, "time");

        lua_pushinteger(L, index);
        lua_setfield(L, -2, "id");

        lua_rawseti(L, -2, index);
        ++index;
    }

    return 1;
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

static int nbunny_lua_runtime_start_debug(lua_State* L)
{
    luax_wrapper_func_debug = true;
    luax_wrapper_debug_calls.clear();
    luax_wrapper_pending_debug_calls.clear();
    return 0;
}

static int nbunny_lua_runtime_stop_debug(lua_State* L)
{
    luax_wrapper_func_debug = false;
    return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_luaruntime(lua_State* L)
{
    lua_newtable(L);

    lua_pushcfunction(L, &nbunny_lua_runtime_get_func_times);
    lua_setfield(L, -2, "getMeasurements");

    lua_pushcfunction(L, &nbunny_lua_runtime_get_calls);
    lua_setfield(L, -2, "getCalls");

    lua_pushcfunction(L, &nbunny_lua_runtime_get_num_calls);
    lua_setfield(L, -2, "getNumCalls");

    lua_pushcfunction(L, &nbunny_lua_runtime_start_measurements);
    lua_setfield(L, -2, "startMeasurements");

    lua_pushcfunction(L, &nbunny_lua_runtime_stop_measurements);
    lua_setfield(L, -2, "stopMeasurements");

    lua_pushcfunction(L, &nbunny_lua_runtime_start_debug);
    lua_setfield(L, -2, "startDebug");

    lua_pushcfunction(L, &nbunny_lua_runtime_stop_debug);
    lua_setfield(L, -2, "stopDebug");

    return 1;
}

void nbunny::lua::push_sub(const std::string& function_name)
{
    if (luax_wrapper_func_debug)
    {
        auto timer_instance = love::Module::getInstance<love::timer::Timer>(love::Module::M_TIMER);

        Call call;
        call.func = function_name;
        call.time = timer_instance->getTime();

        luax_wrapper_pending_debug_calls.push_back(call);
    }
}

void nbunny::lua::pop_sub()
{
    if (luax_wrapper_func_debug && !luax_wrapper_debug_calls.empty())
    {
        auto call = luax_wrapper_pending_debug_calls.back();
        luax_wrapper_pending_debug_calls.pop_back();

        auto timer_instance = love::Module::getInstance<love::timer::Timer>(love::Module::M_TIMER);
        call.time = (timer_instance->getTime() - call.time) * 1000.0;
        luax_wrapper_debug_calls.push_back(call);
    }
}

static int luax_wrapper_func(lua_State* L)
{
    auto func = lua_tocfunction(L, lua_upvalueindex(1));

    int result = 0;
    if (luax_wrapper_func_measure)
    {
        auto& t = luax_wrapper_func_times[lua_tostring(L, lua_upvalueindex(2))];
        ++t.num_calls;
        ++luax_wrapper_func_num_calls;

        Call call;
        if (luax_wrapper_func_debug)
        {
            call.func = lua_tostring(L, lua_upvalueindex(2));
            call.arguments.from_lua(L, 1, lua_gettop(L), true);
        }

        auto timer_instance = love::Module::getInstance<love::timer::Timer>(love::Module::M_TIMER);
        auto before = timer_instance->getTime();
        love::luax_catchexcept(L, [&]() { result = func(L); });
        auto after = timer_instance->getTime();

        if (luax_wrapper_func_debug)
        {
            call.return_value.from_lua(L, call.arguments.length() + 1, lua_gettop(L), true);
            call.time = (after - before) * 1000.0;

            int level = 1;
            lua_Debug debug;
            while(lua_getstack(L, level, &debug))
            {
                lua_getinfo(L, "nSl", &debug);
                call.stack.push_back(std::string(debug.short_src) + std::string(":") + std::to_string(debug.currentline) + std::string("@") + std::string(debug.name ? debug.name : "???"));
                ++level;
            }

            luax_wrapper_debug_calls.push_back(call);
        }

        t.time += after - before;
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
