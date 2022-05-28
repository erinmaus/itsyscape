////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/map.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "common/runtime.h"
#include "common/Module.h"
#include "modules/graphics/Graphics.h"
#include "modules/math/MathModule.h"
#include "nbunny/nbunny.hpp"
#include "nbunny/optimaus/map.hpp"

void nbunny::WeatherMap::resize(int width, int height)
{
	tiles.clear();
	tiles.resize(width * height, -INFINITY);
	this->width = width;
	this->height = height;
}

int nbunny::WeatherMap::get_width() const
{
	return width;
}

int nbunny::WeatherMap::get_height() const
{
	return height;
}

void nbunny::WeatherMap::move(int i, int j)
{
	real_i = i;
	real_j = j;
}

void nbunny::WeatherMap::get_tile(const glm::vec3& position, int& result_i, int& result_j) const
{
	int i = std::floor(position.x / cell_size);
	int j = std::floor(position.z / cell_size);

	result_i = std::min(std::max(i - real_i, 0), width);
	result_j = std::min(std::max(j - real_j, 0), height);
}

int nbunny::WeatherMap::get_position_i() const
{
	return real_i;
}

int nbunny::WeatherMap::get_position_j() const
{
	return real_j;
}

void nbunny::WeatherMap::set_cell_size(float value)
{
	cell_size = value;
}

float nbunny::WeatherMap::get_cell_size() const
{
	return cell_size;
}

void nbunny::WeatherMap::set_height_at_tile(int i, int j, float height)
{
	tiles.at(j * width + i) = height;
}

float nbunny::WeatherMap::get_height_at_tile(int i, int j) const
{
	return tiles.at(j * width + i);
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_weathermap(lua_State* L)
{
	sol::usertype<nbunny::WeatherMap> T(
		sol::call_constructor, sol::constructors<nbunny::WeatherMap()>(),
		"resize", &nbunny::WeatherMap::resize,
		"getWidth", &nbunny::WeatherMap::get_width,
		"getHeight", &nbunny::WeatherMap::get_height,
		"move", &nbunny::WeatherMap::move,
		"getPositionI", &nbunny::WeatherMap::get_position_i,
		"getPositionJ", &nbunny::WeatherMap::get_position_j,
		"setCellSize", &nbunny::WeatherMap::set_cell_size,
		"getCellSize", &nbunny::WeatherMap::get_cell_size,
		"setHeightAt", &nbunny::WeatherMap::set_height_at_tile,
		"getHeightAt", &nbunny::WeatherMap::get_height_at_tile);

	sol::stack::push(L, T);

	return 1;
}

nbunny::RainWeather::RainWeather() :
	quad({
		{ -1,  0,  0 },
		{  1,  0,  0 },
		{  1,  1,  0 },
		{ -1,  0,  0 },
		{  1,  1,  0 },
		{ -1,  1,  0 },
		{  0,  0, -1 },
		{  0,  1, -1 },
		{  0,  1,  1 },
		{  0,  0, -1 },
		{  0,  1,  1 },
		{  0,  0,  1 },
	}),
	mesh_attribs({
		{ "VertexPosition", love::graphics::vertex::DATA_FLOAT, 3 },
	})
{
	// Nothing.
}

nbunny::RainWeather::~RainWeather()
{
	if (mesh)
	{
		mesh->release();
		mesh = nullptr;
	}
}

love::graphics::Mesh* nbunny::RainWeather::get_mesh()
{
	return mesh;
}

void nbunny::RainWeather::set_gravity(const glm::vec3& value)
{
	gravity = value;
}

const glm::vec3& nbunny::RainWeather::get_gravity() const
{
	return gravity;
}

void nbunny::RainWeather::set_wind(const glm::vec3& value)
{
	wind = value;
}

const glm::vec3& nbunny::RainWeather::get_wind() const
{
	return wind;
}

void nbunny::RainWeather::set_heaviness(float value)
{
	heaviness = value;
}

float nbunny::RainWeather::get_heaviness() const
{
	return heaviness;
}

void nbunny::RainWeather::set_min_height(float value)
{
	min_height = value;
}

float nbunny::RainWeather::get_min_height() const
{
	return min_height;
}

void nbunny::RainWeather::set_max_height(float value)
{
	max_height = value;
}

float nbunny::RainWeather::get_max_height() const
{
	return max_height;
}

void nbunny::RainWeather::set_min_length(float value)
{
	min_length = value;
}

float nbunny::RainWeather::get_min_length() const
{
	return min_length;
}

void nbunny::RainWeather::set_max_length(float value)
{
	max_length = value;
}

float nbunny::RainWeather::get_max_length() const
{
	return max_length;
}

void nbunny::RainWeather::set_size(float value)
{
	size = value;
}

float nbunny::RainWeather::get_size() const
{
	return size;
}

void nbunny::RainWeather::set_color(const glm::vec4& value)
{
	color = value;
}

const glm::vec4& nbunny::RainWeather::get_color() const
{
	return color;
}

void nbunny::RainWeather::update(const WeatherMap& weather_map, float delta)
{
	int num_particles = (int)(weather_map.get_width() * weather_map.get_height() * heaviness);
	particles.resize(num_particles);
	vertices.resize(num_particles * quad.size());

	auto velocity = (gravity + wind) * delta;
	auto speed = -glm::length(velocity);
	auto direction = velocity / speed;

	auto rng = love::math::Math::instance.getRandomGenerator();

	std::size_t vertex_index = 0;
	for (auto& particle: particles)
	{
		if (particle.length <= 0)
		{
			auto s = rng->random() * weather_map.get_cell_size();
			auto t = rng->random() * weather_map.get_cell_size();

			auto i = (int)rng->random(weather_map.get_position_i(), weather_map.get_position_i() + weather_map.get_width());
			auto j = (int)rng->random(weather_map.get_position_j(), weather_map.get_position_j() + weather_map.get_height());

			auto x = (i - 1) * weather_map.get_cell_size() + s;
			auto y = rng->random(min_height, max_height);
			auto z = (j - 1) * weather_map.get_cell_size() + t;
			auto length = rng->random(min_length, max_length);

			particle.position = glm::vec3(x, y, z);
			particle.length = length;
			particle.is_moving = true;
		}
		else
		{
			if (particle.is_moving)
			{
				int i, j;
				weather_map.get_tile(particle.position, i, j);

				auto height = std::max(weather_map.get_height_at_tile(i, j), 0.0f);
				if (particle.position.y <= height)
				{
					particle.is_moving = false;
				}
				else
				{
					particle.position += velocity;
				}
			}
			else
			{
				particle.length += speed;
			}
		}

		for (auto& position: quad)
		{
			vertices.at(vertex_index++) = position * size + particle.position + position.y * direction * particle.length;
		}
	}

	if (mesh == nullptr || mesh->getVertexCount() != vertices.size())
	{
		if (mesh)
		{
			mesh->release();
		}

		auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
		mesh = graphics->newMesh(
			mesh_attribs,
			&vertices[0],
			sizeof(glm::vec3) * vertices.size(),
			love::graphics::PRIMITIVE_TRIANGLES,
			love::graphics::vertex::USAGE_STREAM);
		mesh->flush();
	}
	else
	{
		auto p = mesh->mapVertexData();
		std::memcpy(p, &vertices[0], mesh->getVertexCount() * mesh->getVertexStride());
		mesh->unmapVertexData();
		mesh->flush();
	}
}

static int nbunny_rain_weather_get_mesh(lua_State* L)
{
	auto& rain = sol::stack::get<nbunny::RainWeather&>(L, 1);
	auto mesh = rain.get_mesh();
	if (mesh == nullptr)
	{
		lua_pushnil(L);
	}
	else
	{
		love::luax_pushtype(L, mesh);
	}

	return 1;
}

static int nbunny_rain_weather_set_gravity(lua_State* L)
{
	auto& rain = sol::stack::get<nbunny::RainWeather&>(L, 1);
	auto x = (float)luaL_checknumber(L, 2);
	auto y = (float)luaL_checknumber(L, 3);
	auto z = (float)luaL_checknumber(L, 4);
	rain.set_gravity(glm::vec3(x, y, z));
	return 0;
}

static int nbunny_rain_weather_get_gravity(lua_State* L)
{
	auto& rain = sol::stack::get<nbunny::RainWeather&>(L, 1);
	auto gravity = rain.get_gravity();
	lua_pushnumber(L, gravity.x);
	lua_pushnumber(L, gravity.y);
	lua_pushnumber(L, gravity.z);
	return 3;
}

static int nbunny_rain_weather_set_wind(lua_State* L)
{
	auto& rain = sol::stack::get<nbunny::RainWeather&>(L, 1);
	auto x = (float)luaL_checknumber(L, 2);
	auto y = (float)luaL_checknumber(L, 3);
	auto z = (float)luaL_checknumber(L, 4);
	rain.set_wind(glm::vec3(x, y, z));
	return 0;
}

static int nbunny_rain_weather_get_wind(lua_State* L)
{
	auto& rain = sol::stack::get<nbunny::RainWeather&>(L, 1);
	auto wind = rain.get_wind();
	lua_pushnumber(L, wind.x);
	lua_pushnumber(L, wind.y);
	lua_pushnumber(L, wind.z);
	return 3;
}

static int nbunny_rain_weather_set_color(lua_State* L)
{
	auto& rain = sol::stack::get<nbunny::RainWeather&>(L, 1);
	auto r = (float)luaL_checknumber(L, 2);
	auto g = (float)luaL_checknumber(L, 3);
	auto b = (float)luaL_checknumber(L, 4);
	auto a = (float)luaL_checknumber(L, 5);
	rain.set_color(glm::vec4(r, g, b, a));
	return 0;
}

static int nbunny_rain_weather_get_color(lua_State* L)
{
	auto& rain = sol::stack::get<nbunny::RainWeather&>(L, 1);
	auto color = rain.get_color();
	lua_pushnumber(L, color.r);
	lua_pushnumber(L, color.g);
	lua_pushnumber(L, color.b);
	lua_pushnumber(L, color.a);
	return 4;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_rainweather(lua_State* L)
{
	sol::usertype<nbunny::RainWeather> T(
		sol::call_constructor, sol::constructors<nbunny::RainWeather()>(),
		"getMesh", &nbunny_rain_weather_get_mesh,
		"setGravity", &nbunny_rain_weather_set_gravity,
		"getGravity", &nbunny_rain_weather_get_gravity,
		"setWind", &nbunny_rain_weather_set_wind,
		"getWind", &nbunny_rain_weather_get_wind,
		"setHeaviness", &nbunny::RainWeather::set_heaviness,
		"getHeaviness", &nbunny::RainWeather::get_heaviness,
		"setMinHeight", &nbunny::RainWeather::set_min_height,
		"getMinHeight", &nbunny::RainWeather::get_min_height,
		"setMaxHeight", &nbunny::RainWeather::set_max_height,
		"getMaxHeight", &nbunny::RainWeather::get_max_height,
		"setMinLength", &nbunny::RainWeather::set_min_length,
		"getMinLength", &nbunny::RainWeather::get_min_length,
		"setMaxLength", &nbunny::RainWeather::set_max_length,
		"getMaxLength", &nbunny::RainWeather::get_max_length,
		"setSize", &nbunny::RainWeather::set_size,
		"getSize", &nbunny::RainWeather::get_size,
		"setColor", &nbunny_rain_weather_set_color,
		"getColor", &nbunny_rain_weather_get_color,
		"update", &nbunny::RainWeather::update);

	sol::stack::push(L, T);

	return 1;
}
