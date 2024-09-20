////////////////////////////////////////////////////////////////////////////////
// nbunny/lua_runtime.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_LUA_RUNTIME_HPP
#define NBUNNY_LUA_RUNTIME_HPP

#include <memory>
#include <stdexcept>
#include <string_view>
#include <string>
#include <type_traits>
#include "nbunny/nbunny.hpp"

namespace nbunny { namespace lua 
{
    namespace impl
    {
        template <typename T> constexpr std::string_view type_name();

        template <>
        constexpr std::string_view type_name<void>()
        {
            return "void";
        }
        using type_name_prober = void;

        template <typename T>
        constexpr std::string_view wrapped_type_name() 
        {
            #ifdef __clang__
                return __PRETTY_FUNCTION__;
            #elif defined(__GNUC__)
                return __PRETTY_FUNCTION__;
            #elif defined(_MSC_VER)
                return __FUNCSIG__;
            #else
            #error "Unsupported compiler"
            #endif
        }

        constexpr std::size_t wrapped_type_name_prefix_length() { 
            return wrapped_type_name<type_name_prober>().find(type_name<type_name_prober>()); 
        }

        constexpr std::size_t wrapped_type_name_suffix_length() { 
            return wrapped_type_name<type_name_prober>().length() 
                - wrapped_type_name_prefix_length() 
                - type_name<type_name_prober>().length();
        }

        template <typename T>
        constexpr std::string_view type_name() {
            constexpr auto wrapped_name = wrapped_type_name<T>();
            constexpr auto prefix_length = wrapped_type_name_prefix_length();
            constexpr auto suffix_length = wrapped_type_name_suffix_length();
            constexpr auto type_name_length = wrapped_name.length() - prefix_length - suffix_length;
            return wrapped_name.substr(prefix_length, type_name_length);
        }

        enum
        {
            USERDATA_TYPE_SHARED_POINTER = 0,
            USERDATA_TYPE_RAW_POINTER = 1
        };

        template <typename T>
        struct Userdata
        {
            int type;
            union {
                std::shared_ptr<T>* shared_pointer;
                T* raw_pointer;
            };
        };

        void* luax_checkudata(lua_State* L, int index, const char* tname, const void* tpointer);
        int luax_newmetatable(lua_State* L, const char* tname, const void* tpointer);

        int luax_toabsoluteindex(lua_State* L, int index);
    }

    // Should *NOT* persist after returning to Lua.
    struct TemporaryReference;

    template <typename T>
    struct LuaType
    {
        static const std::string user_type;
        static const int type_pointer;
    };

    template <typename T> const std::string LuaType<T>::user_type = std::string { impl::type_name<T>() };
    template <typename T> const int LuaType<T>::type_pointer = 0;

    template <typename T>
    int impl_gc(lua_State* L)
    {
        using Userdata = impl::Userdata<T>;

        auto pointer = lua_touserdata(L, 1);
        if (pointer) 
        {
            auto userdata = static_cast<Userdata*>(pointer);
            if (userdata->type == impl::USERDATA_TYPE_SHARED_POINTER)
            {
                delete userdata->shared_pointer;
            }
        }

        return 0;
    }

    template <typename T>
    void register_type(lua_State* L, lua_CFunction constructor, const luaL_Reg metatable[])
    {
        impl::luax_newmetatable(L, LuaType<T>::user_type.c_str(), &LuaType<T>::type_pointer);

        if (metatable)
        {
            luaL_register(L, nullptr, metatable);
        }

        lua_pushcfunction(L, &impl_gc<T>);
        lua_setfield(L, -2, "__gc");

        lua_pushvalue(L, -1);
        lua_setfield(L, -2, "__index");

        lua_newtable(L);
        if (constructor)
        {
            lua_pushcfunction(L, constructor);
            lua_setfield(L, -2, "__call");
        }
        lua_setmetatable(L, -2);
    }

    template <typename T, typename P>
    void register_child_type(lua_State* L, lua_CFunction constructor, const luaL_Reg metatable[])
    {
        register_type<T>(L, constructor, metatable);
        
        impl::luax_newmetatable(L, LuaType<P>::user_type.c_str(), &LuaType<P>::type_pointer);
        lua_setfield(L, -2, "__parent");
        
        lua_getmetatable(L, -1);
        impl::luax_newmetatable(L, LuaType<P>::user_type.c_str(), &LuaType<P>::type_pointer);
        lua_setfield(L, -2, "__index");
        lua_pop(L, 1);
    }

    template <typename T>
    T get_primitive(lua_State* L, int index);

    template <typename T>
    std::enable_if<std::is_class<T>::value && !std::is_same<T, TemporaryReference>::value && !std::is_pointer<T>::value && !std::is_same<T, std::string>::value, std::shared_ptr<T>>::type get(lua_State* L, int index)
    {
        using Userdata = impl::Userdata<T>;
        auto userdata = (Userdata*)impl::luax_checkudata(L, index, LuaType<T>::user_type.c_str(), &LuaType<T>::type_pointer);
        if (userdata->type != impl::USERDATA_TYPE_SHARED_POINTER)
        {
            luaL_error(L, "expected %s shared pointer userdata, got type %d at index %d", LuaType<T>::user_type.c_str(), userdata->type, impl::luax_toabsoluteindex(L, index));
        }
        
        return *userdata->shared_pointer;
    }

    template <typename T>
    std::enable_if<std::is_pointer<T>::value && !std::is_same<T, void*>::value && !std::is_same<T, lua_CFunction>::value, T>::type get(lua_State* L, int index)
    {
        using PointerlessT = typename std::remove_pointer<T>::type;
        using Userdata = impl::Userdata<PointerlessT>;
        auto userdata = (Userdata*)impl::luax_checkudata(L, index, LuaType<PointerlessT>::user_type.c_str(), &LuaType<PointerlessT>::type_pointer);
        if (userdata->type == impl::USERDATA_TYPE_SHARED_POINTER)
        {
            return userdata->shared_pointer->get();
        }
        else if (userdata->type == impl::USERDATA_TYPE_RAW_POINTER)
        {
            return userdata->raw_pointer;
        }
        
        luaL_error(L, "unhandled %s userdata pointer type %d", LuaType<T>::user_type.c_str(), userdata->type);
        return nullptr;
    }

    template <typename T>
    std::enable_if<(!std::is_class<T>::value || std::is_same<T, std::string>::value) && (std::is_same<T, void*>::value || std::is_same<T, lua_CFunction>::value || !std::is_pointer<T>::value), T>::type get(lua_State* L, int index)
    {
        return get_primitive<T>(L, index);
    }

    template <>
    inline lua_Integer get_primitive<lua_Integer>(lua_State* L, int index)
    {
        return luaL_checkinteger(L, index);
    }

    template <>
    inline lua_Number get_primitive<lua_Number>(lua_State* L, int index)
    {
        return luaL_checknumber(L, index);
    }

    template <>
    inline void* get_primitive<void*>(lua_State* L, int index)
    {
        return lua_touserdata(L, index);
    }

    template <>
    inline std::string get_primitive<std::string>(lua_State* L, int index)
    {
        return luaL_checkstring(L, index);
    }

    template <>
    inline bool get_primitive<bool>(lua_State* L, int index)
    {
        return lua_toboolean(L, index);
    }

    template <>
    inline lua_CFunction get_primitive<lua_CFunction>(lua_State* L, int index)
    {
        return lua_tocfunction(L, index);
    }

    template <typename T>
    auto get_field(lua_State* L, int index, const std::string& key)
    {
        lua_getfield(L, index, key.c_str());

        auto result = get<T>(L, -1);
        lua_pop(L, 1);

        return result;
    }

    template <typename T>
    auto get_field(lua_State* L, int index, int key)
    {
        lua_pushnumber(L, key);
        lua_gettable(L, index);

        auto result = get<T>(L, -1);
        lua_pop(L, 1);

        return result;
    }

    template <typename T>
    void push_primitive(lua_State* L, const T& value);

    template <typename T, std::enable_if<std::is_class<T>::value && !std::is_same<T, TemporaryReference>::value && !std::is_pointer<T>::value, bool>::type = true>
    void push(lua_State* L, const std::shared_ptr<T>& value)
    {
        using Userdata = impl::Userdata<T>;

        auto userdata = (Userdata*)lua_newuserdata(L, sizeof(Userdata));
        userdata->type = impl::USERDATA_TYPE_SHARED_POINTER;
        userdata->shared_pointer = new std::shared_ptr<T>(value);

        impl::luax_newmetatable(L, LuaType<T>::user_type.c_str(), &LuaType<T>::type_pointer);
        lua_setmetatable(L, -2);
    }

    template <typename T, std::enable_if<std::is_pointer<T>::value && std::is_pointer<T>::value && !std::is_same<T, void*>::value && !std::is_same<T, lua_CFunction>::value, bool>::type = true>
    void push(lua_State* L, T value)
    {
        using PointerlessT = typename std::remove_pointer<T>::type;
        using Userdata = impl::Userdata<PointerlessT>;

        auto userdata = (Userdata*)lua_newuserdata(L, sizeof(Userdata));
        userdata->type = impl::USERDATA_TYPE_RAW_POINTER;
        userdata->raw_pointer = value;

        impl::luax_newmetatable(L, LuaType<PointerlessT>::user_type.c_str(), &LuaType<PointerlessT>::type_pointer);
        lua_setmetatable(L, -2);
    }

    template <typename T, std::enable_if<!std::is_class<T>::value && (std::is_same<T, void*>::value || std::is_same<T, lua_CFunction>::value || !std::is_pointer<T>::value), bool>::type = true>
    void push(lua_State* L, const T& value)
    {
        push_primitive<T>(L, value);
    }

    template <>
    inline void push_primitive<int>(lua_State* L, const int& value)
    {
        lua_pushinteger(L, value);
    }

    template <>
    inline void push_primitive<std::size_t>(lua_State* L, const std::size_t& value)
    {
        lua_pushinteger(L, value);
    }

    template <>
    inline void push_primitive<float>(lua_State* L, const float& value)
    {
        lua_pushnumber(L, value);
    }

    template <>
    inline void push_primitive<lua_Integer>(lua_State* L, const lua_Integer& value)
    {
        lua_pushinteger(L, value);
    }

    template <>
    inline void push_primitive<lua_Number>(lua_State* L, const lua_Number& value)
    {
        lua_pushnumber(L, value);
    }

    template <>
    inline void push_primitive<void*>(lua_State* L, void* const& value)
    {
        lua_pushlightuserdata(L, value);
    }

    template <>
    inline void push_primitive<std::string>(lua_State* L, const std::string& value)
    {
        lua_pushlstring(L, value.data(), value.size());
    }

    template <>
    inline void push_primitive<bool>(lua_State* L, const bool& value)
    {
        lua_pushboolean(L, value);
    }

    template <>
    inline void push_primitive<lua_CFunction>(lua_State* L, const lua_CFunction& value)
    {
        lua_pushcfunction(L, value);
    }

    template <typename T>
    void set_field(lua_State* L, int index, const std::string& key, const T& value)
    {
        auto absolute_index = impl::luax_toabsoluteindex(L, index);
        push(L, value);
        lua_setfield(L, absolute_index, key.c_str());
    }

    template <typename T>
    void set_field(lua_State* L, int index, const std::string& key, const std::shared_ptr<T>& value)
    {
        auto absolute_index = impl::luax_toabsoluteindex(L, index);
        push(L, value);
        lua_setfield(L, absolute_index, key.c_str());
    }

    template <typename T>
    void set_field(lua_State* L, int index, int key, const T& value)
    {
        auto absolute_index = impl::luax_toabsoluteindex(L, index);
        lua_pushnumber(L, key);
        push(L, value);
        lua_settable(L, absolute_index);
    }

    template <typename T>
    void set_field(lua_State* L, int index, int key, const std::shared_ptr<T>& value)
    {
        auto absolute_index = impl::luax_toabsoluteindex(L, index);
        lua_pushnumber(L, key);
        push(L, value);
        lua_settable(L, absolute_index);
    }

    struct TemporaryReference
    {
        lua_State* L = nullptr;
        int reference = LUA_NOREF;

        TemporaryReference() = default;
        TemporaryReference(const TemporaryReference& other);
        TemporaryReference(TemporaryReference&& other);
        TemporaryReference(lua_State* L, int reference);
        ~TemporaryReference();

		TemporaryReference& operator =(const TemporaryReference& other);
		TemporaryReference& operator =(TemporaryReference&& other);

        void push() const;
        void reset();

        int fork();

        bool is_valid() const;

        template <typename T>
        auto get()
        {
            if (!is_valid())
            {
                throw std::runtime_error("reference is invalid");
            }

            push();
            
            auto result = get<T>(L, -1);
            lua_pop(L, 1);

            return result;
        }

        template <typename T>
        auto get(const std::string& key)
        {
            if (!is_valid())
            {
                throw std::runtime_error("reference is invalid");
            }

            push();

            auto result = get_field<T>(L, -1, key);
            lua_pop(L, 1);

            return result;
        }

        template <typename T>
        auto get(int key)
        {
            if (!is_valid())
            {
                throw std::runtime_error("reference is invalid");
            }

            push();

            auto result = get_field<T>(L, -1, key);
            lua_pop(L, 1);

            return result;
        }
    };

    template <typename T>
    inline std::enable_if<std::is_same<T, TemporaryReference>::value, TemporaryReference>::type get(lua_State* L, int index)
    {
        lua_pushvalue(L, index);
        return TemporaryReference(L, luaL_ref(L, LUA_REGISTRYINDEX));
    }

    template <typename T, std::enable_if<std::is_same<T, TemporaryReference>::value, bool>::type = true>
    inline void push(lua_State* L, const TemporaryReference& value)
    {
        if (L != value.L)
        {
            luaL_error(L, "reference comes from a different Lua state or thread; did the value persist across a call boundary?");
        }

        if (value.reference == LUA_NOREF)
        {
            luaL_error(L, "reference invalid");
        }

        lua_rawgeti(L, LUA_REGISTRYINDEX, value.reference);
    }
} }

#endif
