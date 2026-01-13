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

#include <iostream>

struct LuaCallSample
{
    std::string filename;
    int line = 0;

    std::string name;
    std::string id;

    int depth = 0;

    float memory_before = 0.0f;
    float memory_after = 0.0f;

    float time_before = 0.0f;
    float time_after = 0.0f;

    std::string traceback;
};

struct LuaUniqueCall
{
    float total_memory = 0.0f;
    float total_time = 0.0f;
};

struct LuaCall
{
    std::string name;
    float total_memory = 0.0f;
    float total_time = 0.0f;

    std::vector<LuaCallSample> samples;
    std::unordered_map<std::string, LuaUniqueCall> unique_calls;
};

struct LuaCallsInfo
{
    int id = -1;

    float total_time = 0.0f;
    float total_memory = 0.0f;

    std::unordered_map<std::string, LuaCall> calls;
    std::vector<LuaCallSample> stack;
};

thread_local std::unordered_map<lua_State*, LuaCallsInfo> lua_calls;
thread_local int lua_calls_info_id = 0;

static float nbunny_lua_gc_count(lua_State* L)
{
    return (float)lua_gc(L, LUA_GCCOUNT, 0) + lua_gc(L, LUA_GCCOUNTB, 0) / 1024.0f;
}

static float nbunny_lua_get_time()
{
    auto timer_instance = love::Module::getInstance<love::timer::Timer>(love::Module::M_TIMER);
    return (float)timer_instance->getTime();
}

static int nbunny_lua_get_depth(lua_State* L)
{
    int level = 1;
    lua_Debug ar;

    while (lua_getstack(L, level, &ar))
    {
        ++level;
    }

    return level;
}

static LuaCallsInfo* nbunny_lua_get_calls_info(lua_State* L)
{
    auto iter = lua_calls.find(L);
    if (iter == lua_calls.end())
    {
        ++lua_calls_info_id;

        LuaCallsInfo c;
        c.id = lua_calls_info_id;

        lua_calls.emplace(L, c);

        iter = lua_calls.find(L);
        if (iter == lua_calls.end())
        {
            return nullptr;
        }
    }

    return &iter->second;
}

static std::string nbunny_lua_traceback(lua_State* L, int level)
{
    lua_Debug ar;
    std::stringstream result;
    while(lua_getstack(L, level, &ar))
    {
        lua_getinfo(L, "nSl", &ar);

        if (ar.name != nullptr)
        {
            result << ar.name;
        }
        else if (ar.what != nullptr)
        {
            result << "#" << ar.what;
        }
        else
        {
            result << "?";
        }

        if (ar.source != nullptr && ar.source[0] == '@')
        {
            result << "@";
            result << std::string(ar.source + 1);
            result << ":";
            result << ar.linedefined;
        }
        else
        {
            result << ar.short_src;
        }

        result << "\n";

        ++level;
    }

    return result.str();
}

static void nbunny_lua_enter(lua_State* L, LuaCallsInfo& calls_info, int level, int depth)
{
    LuaCallSample sample;

    lua_Debug ar;
    if (!(lua_getstack(L, level, &ar) && lua_getinfo(L, "nSl", &ar)))
    {
        return;
    }

    if (ar.source && ar.source[0] == '@')
    {
        sample.filename = std::string(ar.source + 1);
    }
    else
    {
        sample.filename = ar.short_src;
    }

    std::stringstream id;
    id << sample.filename << "@" << ar.linedefined;

    sample.id = id.str();
    sample.line = ar.linedefined;
    sample.depth = depth;

    sample.traceback = nbunny_lua_traceback(L, level);

    if (ar.name)
    {
        sample.name = ar.name;
    }
    else
    {
        sample.name = std::string("*") + sample.id;
    }

    calls_info.stack.emplace_back(std::move(sample));

    calls_info.stack.back().memory_before = nbunny_lua_gc_count(L);
    calls_info.stack.back().time_before = nbunny_lua_get_time();
}

static void nbunny_lua_leave(lua_State* L, LuaCallsInfo& calls_info)
{
    auto time = nbunny_lua_get_time();

    if (calls_info.stack.empty())
    {
        return;
    }

    auto top = calls_info.stack.back();
    calls_info.stack.pop_back();

    top.memory_after = nbunny_lua_gc_count(L);
    top.time_after = time;

    auto total_memory = top.memory_after - top.memory_before;
    auto total_time = top.time_after - top.time_before;

    calls_info.total_memory += total_memory;
    calls_info.total_time += total_time;

    auto& calls = calls_info.calls[top.id];
    calls.name = top.name;
    calls.total_time += total_time;
    calls.total_memory += total_memory;

    auto& unique_call = calls.unique_calls[top.traceback];
    unique_call.total_time += total_time;
    unique_call.total_memory += total_memory;

    calls.samples.push_back(std::move(top));
}

static void nbunny_lua_hook(lua_State* L, lua_Debug* ar)
{
    if (ar->event != LUA_HOOKCOUNT)
    {
        return;
    }

    auto calls = nbunny_lua_get_calls_info(L);
    if (!calls)
    {
        return;
    }

    int current_depth = nbunny_lua_get_depth(L);

    int previous_depth = 0;
    if (!calls->stack.empty())
    {
        previous_depth = calls->stack.back().depth;
    }

    if (current_depth > previous_depth)
    {
        for (int i = previous_depth + 1; i <= current_depth; ++i)
        {
            nbunny_lua_enter(L, *calls, current_depth - i + 1, i);
        }
    }
    else if (current_depth < previous_depth)
    {
        for (int i = previous_depth; i >= current_depth + 1; --i)
        {
            nbunny_lua_leave(L, *calls);
        }
    }
}

static int nbunny_lua_profile_start(lua_State* L)
{
    lua_calls.clear();
    lua_calls_info_id = 0;

    lua_sethook(L, &nbunny_lua_hook, LUA_MASKCOUNT, 1);

    return 0;
}

static int nbunny_lua_profile_stop(lua_State* L)
{
    lua_sethook(L, nullptr, 0, 0);

    lua_newtable(L);
    int calls_info_index = 1;
    for (auto& i: lua_calls)
    {
        auto& calls_info = i.second;

        lua_newtable(L);

        lua_pushnumber(L, calls_info.id);
        lua_setfield(L, -2, "id");

        lua_pushnumber(L, calls_info.total_memory);
        lua_setfield(L, -2, "memory");

        lua_pushnumber(L, calls_info.total_time);
        lua_setfield(L, -2, "time");

        lua_newtable(L);
        int calls_index = 1;
        for (auto& j: calls_info.calls)
        {
            auto& id = j.first;
            auto& call = j.second;

            lua_newtable(L);

            lua_pushlstring(L, id.data(), id.size());
            lua_setfield(L, -2, "id");

            lua_pushlstring(L, call.name.data(), call.name.size());
            lua_setfield(L, -2, "name");

            lua_pushnumber(L, call.total_memory);
            lua_setfield(L, -2, "memory");

            lua_pushnumber(L, call.total_time);
            lua_setfield(L, -2, "time");

            lua_pushnumber(L, call.samples.size());
            lua_setfield(L, -2, "samples");

            lua_newtable(L);
            int unique_calls_index = 1;
            for (auto& k: call.unique_calls)
            {
                auto& traceback = k.first;
                auto& unique_call = k.second;

                lua_newtable(L);

                lua_pushlstring(L, traceback.data(), traceback.size());
                lua_setfield(L, -2, "traceback");

                lua_pushnumber(L, unique_calls_index);
                lua_setfield(L, -2, "id");

                lua_pushnumber(L, unique_call.total_memory);
                lua_setfield(L, -2, "memory");

                lua_pushnumber(L, unique_call.total_time);
                lua_setfield(L, -2, "time");

                lua_rawseti(L, -2, unique_calls_index);
                ++unique_calls_index;
            }
            lua_setfield(L, -2, "unique");

            lua_rawseti(L, -2, calls_index);
            ++calls_index;
        }
        lua_setfield(L, -2, "calls");

        lua_rawseti(L, -2, calls_info_index);
        ++calls_info_index;
    }

    return 1;
}

struct FuncTime
{
    double time = 0.0;
    double memory = 0.0;
    int num_calls = 0;
};

struct Call
{
    std::string func;
    nbunny::GameManagerVariant arguments;
    nbunny::GameManagerVariant return_value;
    std::vector<std::string> stack;
    double time = 0.0;
    double memory = 0.0;
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
    double total_memory = 0.0;
    for (auto& time: luax_wrapper_func_times)
    {
        lua_pushlstring(L, time.first.c_str(), time.first.size());
        lua_newtable(L);
        lua_pushnumber(L, time.second.time * 1000.0f);
        lua_setfield(L, -2, "time");
        lua_pushnumber(L, time.second.memory);
        lua_setfield(L, -2, "memory");
        lua_pushinteger(L, time.second.num_calls);
        lua_setfield(L, -2, "calls");
        lua_settable(L, -3);

        total_time += time.second.time;
        total_memory += time.second.memory;
    }

    lua_pushnumber(L, total_time);
    lua_pushnumber(L, total_memory);
    return 3;
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

        lua_pushnumber(L, call.memory);
        lua_setfield(L, -2, "memory");

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

    lua_pushcfunction(L, &nbunny_lua_profile_start);
    lua_setfield(L, -2, "startProfile");

    lua_pushcfunction(L, &nbunny_lua_profile_stop);
    lua_setfield(L, -2, "stopProfile");

    return 1;
}

void nbunny::lua::push_sub(lua_State* L, const std::string& function_name)
{
    if (luax_wrapper_func_debug)
    {
        auto& t = luax_wrapper_func_times[function_name];
        ++t.num_calls;
        ++luax_wrapper_func_num_calls;

        auto timer_instance = love::Module::getInstance<love::timer::Timer>(love::Module::M_TIMER);

        Call call;
        call.func = function_name;
        call.time = timer_instance->getTime();
        call.memory = (double)lua_gc(L, LUA_GCCOUNT, 0) + lua_gc(L, LUA_GCCOUNTB, 0) / 1024.0;

        luax_wrapper_pending_debug_calls.push_back(call);
    }
}

void nbunny::lua::pop_sub(lua_State* L)
{
    if (luax_wrapper_func_debug && !luax_wrapper_debug_calls.empty())
    {
        auto call = luax_wrapper_pending_debug_calls.back();
        luax_wrapper_pending_debug_calls.pop_back();

        auto& t = luax_wrapper_func_times[call.func];

        auto timer_instance = love::Module::getInstance<love::timer::Timer>(love::Module::M_TIMER);
        call.time = (timer_instance->getTime() - call.time) * 1000.0;

        auto memory_after = call.memory = (double)lua_gc(L, LUA_GCCOUNT, 0) + lua_gc(L, LUA_GCCOUNTB, 0) / 1024.0;
        call.memory = memory_after - call.memory;

        luax_wrapper_debug_calls.push_back(call);

        t.time += call.time;
        t.memory += call.memory;
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
        auto memory_before = (double)lua_gc(L, LUA_GCCOUNT, 0) + lua_gc(L, LUA_GCCOUNTB, 0) / 1024.0;

        love::luax_catchexcept(L, [&]() { result = func(L); });

        auto after = timer_instance->getTime();
        auto memory_after = (double)lua_gc(L, LUA_GCCOUNT, 0) + lua_gc(L, LUA_GCCOUNTB, 0) / 1024.0;

        if (luax_wrapper_func_debug)
        {
            call.return_value.from_lua(L, call.arguments.length() + 1, lua_gettop(L), true);
            call.time = (after - before) * 1000.0;
            call.memory = memory_after - memory_before;

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

void nbunny::lua::push_function(lua_State* L, lua_CFunction function, const std::string& name)
{
    lua_pushcfunction(L, function);
    lua_pushlstring(L, name.c_str(), name.size());
    lua_pushcclosure(L, &luax_wrapper_func, 2);
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
