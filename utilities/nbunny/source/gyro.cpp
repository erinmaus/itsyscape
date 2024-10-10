////////////////////////////////////////////////////////////////////////////////
// source/gyro.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include <JoyShockLibrary.h>
#include "nbunny/nbunny.hpp"

static int nbunny_gyro_connect(lua_State* L)
{
	int device_count = JslConnectDevices();
	lua_pushinteger(L, device_count);

	return 1;
}

static int nbunny_gyro_get_device_ids(lua_State* L)
{
	int device_count = 0;
	if (lua_gettop(L) >= 1)
	{
		device_count = luaL_checkinteger(L, 1);
	}
	else
	{
		device_count = JslConnectDevices();
	}

	std::vector<int> device_ids;
	device_ids.resize(device_count);

	JslGetConnectedDeviceHandles(&device_ids[0], device_count);

	for (auto device_id: device_ids)
	{
		lua_pushinteger(L, device_id);
	}

	return device_ids.size();
}

static int nbunny_gyro_is_connected(lua_State* L)
{
	auto is_connected = JslStillConnected(luaL_checkinteger(L, 1));
	lua_pushboolean(L, is_connected);

	return 1;
}

static int nbunny_gyro_disconnect_all(lua_State* L)
{
	JslDisconnectAndDisposeAll();

	return 0;
}

static int nbunny_gyro_get_is_button_down(lua_State* L)
{
	auto device_id = luaL_checkinteger(L, 1);
	auto button_index = luaL_checkinteger(L, 2);

	int buttons = JslGetButtons(device_id);
	lua_pushboolean(L, buttons & (1 << button_index));

	return 1;
}

static int nbunny_gyro_get_left_axis(lua_State* L)
{
	auto device_id = luaL_checkinteger(L, 1);

	float x = JslGetLeftX(device_id);
	float y = JslGetLeftY(device_id);

	lua_pushnumber(L, x);
	lua_pushnumber(L, y);

	return 2;
}

static int nbunny_gyro_get_right_axis(lua_State* L)
{
	auto device_id = luaL_checkinteger(L, 1);

	float x = JslGetRightX(device_id);
	float y = JslGetRightY(device_id);

	lua_pushnumber(L, x);
	lua_pushnumber(L, y);

	return 2;
}

static int nbunny_gyro_get_axis_step(lua_State* L)
{
	auto device_id = luaL_checkinteger(L, 1);

	lua_pushnumber(L, JslGetStickStep(device_id));

	return 1;
}

static int nbunny_gyro_get_left_trigger(lua_State* L)
{
	auto device_id = luaL_checkinteger(L, 1);

	float value = JslGetLeftTrigger(device_id);

	lua_pushnumber(L, value);

	return 1;
}

static int nbunny_gyro_get_right_trigger(lua_State* L)
{
	auto device_id = luaL_checkinteger(L, 1);

	float value = JslGetRightTrigger(device_id);

	lua_pushnumber(L, value);

	return 1;
}

static int nbunny_gyro_get_trigger_step(lua_State* L)
{
	auto device_id = luaL_checkinteger(L, 1);

	lua_pushnumber(L, JslGetTriggerStep(device_id));

	return 1;
}

static int nbunny_gyro_get_gyro(lua_State* L)
{
	auto device_id = luaL_checkinteger(L, 1);

	float x = JslGetGyroX(device_id);
	float y = JslGetGyroY(device_id);
	float z = JslGetGyroZ(device_id);

	lua_pushnumber(L, x);
	lua_pushnumber(L, y);
	lua_pushnumber(L, x);

	return 3;
}

static int nbunny_gyro_get_average_gyro(lua_State* L)
{
	auto device_id = luaL_checkinteger(L, 1);

	float x, y, z;
	JslGetAndFlushAccumulatedGyro(device_id, x, y, z);

	lua_pushnumber(L, x);
	lua_pushnumber(L, y);
	lua_pushnumber(L, x);

	return 3;
}

static int nbunny_gyro_get_acceleration(lua_State* L)
{
	auto device_id = luaL_checkinteger(L, 1);

	float x = JslGetAccelX(device_id);
	float y = JslGetAccelY(device_id);
	float z = JslGetAccelZ(device_id);

	lua_pushnumber(L, x);
	lua_pushnumber(L, y);
	lua_pushnumber(L, x);

	return 3;
}

static int nbunny_gyro_init(lua_State* L)
{
	auto device_id = luaL_checkinteger(L, 1);

	JslSetGyroSpace(device_id, 2);
	JslSetAutomaticCalibration(device_id, true);
	JslSetPlayerNumber(device_id, 1);

	return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_gyro(lua_State* L)
{
	lua_newtable(L);

	lua_pushcfunction(L, &nbunny_gyro_connect);
	lua_setfield(L, -2, "connect");

	lua_pushcfunction(L, &nbunny_gyro_init);
	lua_setfield(L, -2, "initialize");

	lua_pushcfunction(L, &nbunny_gyro_get_device_ids);
	lua_setfield(L, -2, "getDeviceIDs");

	lua_pushcfunction(L, &nbunny_gyro_is_connected);
	lua_setfield(L, -2, "isConnected");

	lua_pushcfunction(L, &nbunny_gyro_disconnect_all);
	lua_setfield(L, -2, "disconnect");

	lua_pushcfunction(L, &nbunny_gyro_get_is_button_down);
	lua_setfield(L, -2, "isDown");

	lua_pushcfunction(L, &nbunny_gyro_get_left_axis);
	lua_setfield(L, -2, "getLeftAxis");

	lua_pushcfunction(L, &nbunny_gyro_get_right_axis);
	lua_setfield(L, -2, "getRightAxis");

	lua_pushcfunction(L, &nbunny_gyro_get_axis_step);
	lua_setfield(L, -2, "getAxisStep");

	lua_pushcfunction(L, &nbunny_gyro_get_left_trigger);
	lua_setfield(L, -2, "getLeftTrigger");

	lua_pushcfunction(L, &nbunny_gyro_get_right_trigger);
	lua_setfield(L, -2, "getRightTrigger");

	lua_pushcfunction(L, &nbunny_gyro_get_trigger_step);
	lua_setfield(L, -2, "getTriggerStep");

	lua_pushcfunction(L, &nbunny_gyro_get_gyro);
	lua_setfield(L, -2, "getGyro");

	lua_pushcfunction(L, &nbunny_gyro_get_average_gyro);
	lua_setfield(L, -2, "getAverageGyro");

	lua_pushcfunction(L, &nbunny_gyro_get_acceleration);
	lua_setfield(L, -2, "getAcceleration");

	return 1;
}
