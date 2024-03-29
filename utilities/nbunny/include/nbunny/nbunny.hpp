////////////////////////////////////////////////////////////////////////////////
// nbunny/nbunny.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_HPP
#define NBUNNY_HPP

extern "C"
{
	#include "lua.h"
}

#define SOL_SAFE_USERTYPE 1
#define SOL_SAFE_FUNCTION 1
#define SOL_CHECK_ARGUMENTS 1
#define SOL_SAFE_GETTER 1
#define SOL_EXCEPTIONS_ALWAYS_UNSAFE 1
#define SOL_LUAJIT_USE_EXCEPTION_TRAMPOLINE 0

#include "deps/sol.hpp"
#include "skeleton.hpp"

#ifdef NBUNNY_BUILDING_WINDOWS
	#define NBUNNY_EXPORT __declspec(dllexport)
#else
	#define NBUNNY_EXPORT
#endif

namespace nbunny
{
	lua_State* get_lua_state(lua_State* L);
	void set_lua_state(lua_State* L);
}

#endif
