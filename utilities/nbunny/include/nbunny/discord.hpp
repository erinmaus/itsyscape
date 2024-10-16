////////////////////////////////////////////////////////////////////////////////
// nbunny/discord.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_DISCORD_HPP
#define NBUNNY_DISCORD_HPP

#include <string>

#ifdef NBUNNY_BUILDING_WINDOWS
#include "deps/discord_game_sdk.h"
#endif

namespace nbunny
{
	#ifdef NBUNNY_BUILDING_WINDOWS
	struct Discord
	{
		struct IDiscordCore* core = nullptr;

		~Discord();

		void tick();
		void update_activity(const std::string& details, const std::string& state);
	};
	#else
	struct Discord
	{
		~Discord() { };

		void tick() { }
		void update_activity(const std::string& details, const std::string& state) { };
	};
	#endif
}

#endif
