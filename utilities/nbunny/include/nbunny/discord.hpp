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
#include "deps/discord_game_sdk.h"

namespace nbunny
{
	struct Discord
	{
		struct IDiscordCore* core;
		struct IDiscordActivityManager* activities;

		~Discord();

		void tick();
		void update_activity(const std::string& details, const std::string& state);
	};
}

#endif
