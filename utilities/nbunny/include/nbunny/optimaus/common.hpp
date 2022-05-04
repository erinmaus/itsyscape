////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/resource.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_COMMON_HPP
#define NBUNNY_OPTIMAUS_COMMON_HPP

#include "nbunny/nbunny.hpp"

namespace nbunny
{
	// The reference, if available, is at the top of the stack
	// A nil value means the reference was collected
	void get_weak_reference(lua_State* L, int key);

	// The value is kept at the top of the stack
	int set_weak_reference(lua_State* L);

	// Gets the weak reference table
	static void get_weak_reference_table(lua_State* L);
}

#endif
