////////////////////////////////////////////////////////////////////////////////
// nbunny/pooled_buffer.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_POOLED_BUFFER_HPP
#define NBUNNY_POOLED_BUFFER_HPP

namespace nbunny
{
	struct PooledBuffer
	{
		int max_depth = 100;

		GameManagerBuffer buffer;
		std::size_t pointer = 0;

		std::vector<std::uint8_t> string;

		lua_CFunction table_clear_func = nullptr;
	};
}

#endif
