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

nbunny::FungalWeather::FungalWeather() :
	quad({
		{ {-1, -1,  0 }, { 0, 0 }, { 1, 1, 1, 1 } },
		{ { 1, -1,  0 }, { 1, 0 }, { 1, 1, 1, 1 } },
		{ { 1,  1,  0 }, { 1, 1 }, { 1, 1, 1, 1 } },
		{ {-1, -1,  0 }, { 0, 0 }, { 1, 1, 1, 1 } },
		{ { 1,  1,  0 }, { 1, 1 }, { 1, 1, 1, 1 } },
		{ {-1,  1,  0 }, { 0, 1 }, { 1, 1, 1, 1 } },

		{ { 0, -1, -1 }, { 0, 0 }, { 1, 1, 1, 1 } },
		{ { 0,  1, -1 }, { 1, 0 }, { 1, 1, 1, 1 } },
		{ { 0,  1,  1 }, { 1, 1 }, { 1, 1, 1, 1 } },
		{ { 0, -1, -1 }, { 0, 0 }, { 1, 1, 1, 1 } },
		{ { 0,  1,  1 }, { 1, 1 }, { 1, 1, 1, 1 } },
		{ { 0, -1,  1 }, { 0, 1 }, { 1, 1, 1, 1 } },
	}),
	mesh_attribs({
		{ "VertexPosition", love::graphics::vertex::DATA_FLOAT, 3 },
		{ "VertexTexture", love::graphics::vertex::DATA_FLOAT, 2 },
		{ "VertexColor", love::graphics::vertex::DATA_FLOAT, 4 },
	})
{
	// Nothing.
}

nbunny::FungalWeather::~FungalWeather()
{
	if (mesh)
	{
		mesh->release();
		mesh = nullptr;
	}
}

love::graphics::Mesh* nbunny::FungalWeather::get_mesh()
{
	return mesh;
}

void nbunny::FungalWeather::set_gravity(const glm::vec3& value)
{
	gravity = value;
}

const glm::vec3& nbunny::FungalWeather::get_gravity() const
{
	return gravity;
}

void nbunny::FungalWeather::set_wind(const glm::vec3& value)
{
	wind = value;
}

const glm::vec3& nbunny::FungalWeather::get_wind() const
{
	return wind;
}

void nbunny::FungalWeather::set_heaviness(float value)
{
	heaviness = value;
}

float nbunny::FungalWeather::get_heaviness() const
{
	return heaviness;
}

void nbunny::FungalWeather::set_min_height(float value)
{
	min_height = value;
}

float nbunny::FungalWeather::get_min_height() const
{
	return min_height;
}

void nbunny::FungalWeather::set_max_height(float value)
{
	max_height = value;
}

float nbunny::FungalWeather::get_max_height() const
{
	return max_height;
}

void nbunny::FungalWeather::set_min_size(float value)
{
	min_size = value;
}

float nbunny::FungalWeather::get_min_size() const
{
	return min_size;
}

void nbunny::FungalWeather::set_max_size(float value)
{
	max_size = value;
}

float nbunny::FungalWeather::get_max_size() const
{
	return max_size;
}

void nbunny::FungalWeather::set_ceiling(float value)
{
	ceiling = value;
}

float nbunny::FungalWeather::get_ceiling() const
{
	return ceiling;
}

void nbunny::FungalWeather::set_colors(const std::vector<glm::vec4>& value)
{
	colors = value;
}

const std::vector<glm::vec4>& nbunny::FungalWeather::get_colors() const
{
	return colors;
}

void nbunny::FungalWeather::update(const WeatherMap& weather_map, float delta)
{
	int num_particles = (int)(weather_map.get_width() * weather_map.get_height() * heaviness);
	particles.resize(num_particles);
	vertices.resize(num_particles * quad.size());

	auto velocity = (gravity + wind) * delta;
	auto speed = glm::length(velocity);
	auto direction = velocity / speed;

	auto rng = love::math::Math::instance.getRandomGenerator();

	std::size_t vertex_index = 0;
	for (auto& particle: particles)
	{
		if (particle.alpha >= particle.size)
		{
			auto s = rng->random() * weather_map.get_cell_size();
			auto t = rng->random() * weather_map.get_cell_size();

			auto i = (int)rng->random(weather_map.get_position_i(), weather_map.get_position_i() + weather_map.get_width());
			auto j = (int)rng->random(weather_map.get_position_j(), weather_map.get_position_j() + weather_map.get_height());

			auto x = (i - 1) * weather_map.get_cell_size() + s;
			auto y = rng->random(min_height, max_height);
			auto z = (j - 1) * weather_map.get_cell_size() + t;
			auto size = rng->random(min_size, max_size);
			auto index = rng->rand() % colors.size();

			particle.position = glm::vec3(x, y, z);
			particle.alpha = 0.0f;
			particle.age = 0.0f;
			particle.size = size / 10.0f;
			particle.color = colors[index];
			particle.is_moving = true;
		}
		else
		{
			particle.age += delta;

			if (particle.is_moving)
			{
				int i, j;
				weather_map.get_tile(particle.position, i, j);

				auto height = std::max(weather_map.get_height_at_tile(i, j), 0.0f);
				if (particle.position.y <= height && gravity.y <= 0.0f)
				{
					particle.is_moving = false;
				}
				else if (particle.position.y >= height + ceiling && gravity.y >= 0.0f)
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
				particle.alpha += speed;
			}
		}

		auto position_offset = glm::vec3(
			std::cos(particle.age) * particle.size * 2.0f,
			std::sin(particle.age) * particle.size * 2.0f,
			0.0f);
		auto color = glm::vec4(
			particle.color.r,
			particle.color.g,
			particle.color.b,
			1.0f - std::max(std::min(particle.alpha / particle.size, 1.0f), 0.0f));
		for (auto& input_vertex: quad)
		{
			auto& output_vertex = vertices.at(vertex_index++);

			output_vertex.position = input_vertex.position * particle.size + particle.position + position_offset;
			output_vertex.texture = input_vertex.texture;
			output_vertex.color = color;
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
			sizeof(Vertex) * vertices.size(),
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

static int nbunny_fungal_weather_get_mesh(lua_State* L)
{
	auto& fungal = sol::stack::get<nbunny::FungalWeather&>(L, 1);
	auto mesh = fungal.get_mesh();
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

static int nbunny_fungal_weather_set_gravity(lua_State* L)
{
	auto& fungal = sol::stack::get<nbunny::FungalWeather&>(L, 1);
	auto x = (float)luaL_checknumber(L, 2);
	auto y = (float)luaL_checknumber(L, 3);
	auto z = (float)luaL_checknumber(L, 4);
	fungal.set_gravity(glm::vec3(x, y, z));
	return 0;
}

static int nbunny_fungal_weather_get_gravity(lua_State* L)
{
	auto& fungal = sol::stack::get<nbunny::FungalWeather&>(L, 1);
	auto gravity = fungal.get_gravity();
	lua_pushnumber(L, gravity.x);
	lua_pushnumber(L, gravity.y);
	lua_pushnumber(L, gravity.z);
	return 3;
}

static int nbunny_fungal_weather_set_wind(lua_State* L)
{
	auto& fungal = sol::stack::get<nbunny::FungalWeather&>(L, 1);
	auto x = (float)luaL_checknumber(L, 2);
	auto y = (float)luaL_checknumber(L, 3);
	auto z = (float)luaL_checknumber(L, 4);
	fungal.set_wind(glm::vec3(x, y, z));
	return 0;
}

static int nbunny_fungal_weather_get_wind(lua_State* L)
{
	auto& fungal = sol::stack::get<nbunny::FungalWeather&>(L, 1);
	auto wind = fungal.get_wind();
	lua_pushnumber(L, wind.x);
	lua_pushnumber(L, wind.y);
	lua_pushnumber(L, wind.z);
	return 3;
}

static int nbunny_fungal_weather_set_colors(lua_State* L)
{
	auto& fungal = sol::stack::get<nbunny::FungalWeather&>(L, 1);

	auto num_colors = lua_objlen(L, 2);
	std::vector<glm::vec4> colors;
	colors.resize(num_colors);

	for (auto i = 1; i <= num_colors; ++i)
	{
		lua_rawgeti(L, 2, i);

		if (lua_istable(L, -1))
		{
			lua_rawgeti(L, -1, 1);
			auto r = (float) luaL_checknumber(L, -1);
			lua_pop(L, 1);

			lua_rawgeti(L, -1, 2);
			auto g = (float) luaL_checknumber(L, -1);
			lua_pop(L, 1);

			lua_rawgeti(L, -1, 3);
			auto b = (float) luaL_checknumber(L, -1);
			lua_pop(L, 1);

			lua_rawgeti(L, -1, 4);
			auto a = (float) luaL_checknumber(L, -1);
			lua_pop(L, 1);

			auto color = glm::vec4(r, g, b, a);
			colors[i - 1] = color;
		}

		lua_pop(L, 1);
	}

	fungal.set_colors(colors);

	return 0;
}

static int nbunny_fungal_weather_get_colors(lua_State* L)
{
	auto& fungal = sol::stack::get<nbunny::FungalWeather&>(L, 1);
	auto& colors = fungal.get_colors();

	lua_createtable(L, colors.size(), 0);
	for (std::size_t i = 1; i <= colors.size(); ++i)
	{
		auto color = colors[i - 1];
		lua_createtable(L, 4, 0);

		lua_pushnumber(L, color.r);
		lua_rawseti(L, -2, 1);
		lua_pushnumber(L, color.g);
		lua_rawseti(L, -2, 2);
		lua_pushnumber(L, color.b);
		lua_rawseti(L, -2, 3);
		lua_pushnumber(L, color.a);
		lua_rawseti(L, -2, 4);

		lua_rawseti(L, -2, i);
	}

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_fungalweather(lua_State* L)
{
	sol::usertype<nbunny::FungalWeather> T(
		sol::call_constructor, sol::constructors<nbunny::FungalWeather()>(),
		"getMesh", &nbunny_fungal_weather_get_mesh,
		"setGravity", &nbunny_fungal_weather_set_gravity,
		"getGravity", &nbunny_fungal_weather_get_gravity,
		"setWind", &nbunny_fungal_weather_set_wind,
		"getWind", &nbunny_fungal_weather_get_wind,
		"setHeaviness", &nbunny::FungalWeather::set_heaviness,
		"getHeaviness", &nbunny::FungalWeather::get_heaviness,
		"setMinHeight", &nbunny::FungalWeather::set_min_height,
		"getMinHeight", &nbunny::FungalWeather::get_min_height,
		"setMaxHeight", &nbunny::FungalWeather::set_max_height,
		"getMaxHeight", &nbunny::FungalWeather::get_max_height,
		"setMinSize", &nbunny::FungalWeather::set_min_size,
		"getMinSize", &nbunny::FungalWeather::get_min_size,
		"setMaxSize", &nbunny::FungalWeather::set_max_size,
		"getMaxSize", &nbunny::FungalWeather::get_max_size,
		"setCeiling", &nbunny::FungalWeather::set_ceiling,
		"getCeiling", &nbunny::FungalWeather::get_ceiling,
		"setColors", &nbunny_fungal_weather_set_colors,
		"getColors", &nbunny_fungal_weather_get_colors,
		"update", &nbunny::FungalWeather::update);

	sol::stack::push(L, T);

	return 1;
}

