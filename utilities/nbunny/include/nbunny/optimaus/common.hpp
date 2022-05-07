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

#define GLM_ENABLE_EXPERIMENTAL
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/quaternion.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <glm/gtx/quaternion.hpp>

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

	struct BaseType
	{
	public:
		BaseType() = default;
		virtual ~BaseType() = default;

		virtual const int* get_type_pointer() const = 0;

		virtual bool operator ==(const BaseType& other);
		virtual bool operator !=(const BaseType& other);
	};

	template <typename Object>
	class Type : public BaseType
	{
	private:
		static const int internal_type_pointer = 0;

	public:
		virtual const int* get_type_pointer() const override
		{
			return &internal_type_pointer;
		}
	};

	template <typename Object>
	const int Type<Object>::internal_type_pointer;

	template <typename Object>
	bool operator ==(const Type<Object>& a, const BaseType& b)
	{
		return a.get_type_pointer() == b.get_type_pointer();
	}

	template <typename Object>
	bool operator ==(const BaseType& a, const Type<Object>& b)
	{
		return a.get_type_pointer() == b.get_type_pointer();
	}
}

#endif
