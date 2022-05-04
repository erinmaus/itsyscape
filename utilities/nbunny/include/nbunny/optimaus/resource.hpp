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

#ifndef NBUNNY_OPTIMAUS_RESOURCE_HPP
#define NBUNNY_OPTIMAUS_RESOURCE_HPP

#include <memory>
#include "nbunny/nbunny.hpp"

namespace nbunny
{
	class ResourceInstance;

	class Resource
	{
	private:
		int current_id = 1;

	public:
		Resource() = default;

		int get_current_id() const;
		int allocate_id();

		std::shared_ptr<ResourceInstance> instantiate(lua_State* L);
	};

	class ResourceInstance
	{
	private:
		lua_State* L = nullptr;
		int reference = 0;
		int id = 0;

	public:
		ResourceInstance(lua_State* L, int id, int reference);

		int get_id() const;
		int get_reference_key() const;
		bool get_reference() const;
	};
}

#endif
