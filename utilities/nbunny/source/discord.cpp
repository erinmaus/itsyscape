////////////////////////////////////////////////////////////////////////////////
// source/scene.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include <cstdlib>
#include <algorithm> 
#include <cctype>
#include <locale>
#include "nbunny/nbunny.hpp"

#include "nbunny/discord.hpp"

#if !defined(__APPLE__) && !defined(__linux__)
nbunny::Discord::~Discord()
{
	core->destroy(core);
}

void nbunny::Discord::tick()
{
	core->run_callbacks(core);
}

#define LENGTH 128
static const std::string TRIM = "...";

void trim_copy(const std::string& value, char* buffer)
{
	std::string trimmed_value;

	if (value.length() >= LENGTH - 1)
	{
		trimmed_value = value.substr(0, LENGTH - TRIM.length() - 1);
		trimmed_value.erase(
			std::find_if(trimmed_value.rbegin(), trimmed_value.rend(), [](unsigned char ch) {
				return !std::isspace(ch);
			}).base(), trimmed_value.end());
		trimmed_value += TRIM;
	}
	else
	{
		trimmed_value = value;
	}

	std::memcpy(buffer, trimmed_value.c_str(), trimmed_value.length() + 1);
}

static void update_activity_callback(void* event_data, EDiscordResult result)
{
	// Nothing.
}

void nbunny::Discord::update_activity(const std::string& details, const std::string& state)
{
	DiscordActivity activity = {};

	trim_copy(details, activity.details);
	trim_copy(state, activity.state);
	trim_copy("logo", activity.assets.large_image);
	trim_copy("ItsyRealm", activity.assets.large_text);

	auto activity_manager = core->get_activity_manager(core);
	activity_manager->update_activity(activity_manager, &activity, nullptr, &update_activity_callback);
}

static std::shared_ptr<nbunny::Discord> nbunny_discord_create(sol::this_state S)
{
	lua_State* L = S;
	auto discord = std::make_shared<nbunny::Discord>();

	DiscordCreateParams params;
	DiscordCreateParamsSetDefault(&params);
	params.client_id = 792801411699703818;
	params.flags = DiscordCreateFlags_NoRequireDiscord;

	auto result = DiscordCreate(DISCORD_VERSION, &params, &discord->core);
	if (result != DiscordResult_Ok)
	{
		luaL_error(L, "Could not intialize Discord: error code %d.", result);
	}

	return discord;
}
#else
static std::shared_ptr<nbunny::Discord> nbunny_discord_create(sol::this_state S)
{
	return std::make_shared<nbunny::Discord>();
}
#endif

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_discord(lua_State* L)
{
	sol::usertype<nbunny::Discord> T(
		sol::call_constructor, sol::factories(&nbunny_discord_create),
		"tick", &nbunny::Discord::tick,
		"updateActivity", &nbunny::Discord::update_activity);

	sol::stack::push(L, T);

	return 1;
}
