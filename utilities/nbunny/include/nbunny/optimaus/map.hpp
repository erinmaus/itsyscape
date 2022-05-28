////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/map.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_MAP_HPP
#define NBUNNY_OPTIMAUS_MAP_HPP

#include <vector>
#include "modules/graphics/Mesh.h"
#include "nbunny/nbunny.hpp"

namespace nbunny
{
	class WeatherMap
	{
	private:
		std::vector<float> tiles;

		int width = 0, height = 0;
		int real_i = 0, real_j = 0;
		float cell_size = 2.0f;

	public:
		WeatherMap() = default;
		~WeatherMap() = default;

		void resize(int width, int height);

		int get_width() const;
		int get_height() const;

		void move(int i, int j);
		void get_tile(const glm::vec3& position, int& result_i, int& result_j) const;

		int get_position_i() const;
		int get_position_j() const;

		void set_cell_size(float value);
		float get_cell_size() const;

		void set_height_at_tile(int i, int j, float height);
		float get_height_at_tile(int i, int j) const;
	};

	class RainWeather
	{
	private:
		std::vector<love::graphics::Mesh::AttribFormat> mesh_attribs;
		love::graphics::Mesh* mesh = nullptr;

		std::vector<glm::vec3> vertices;
		std::vector<glm::vec3> quad;

		struct Particle
		{
			glm::vec3 position = glm::vec3(0.0f);
			float length = 0.0f;
			bool is_moving = false;
		};

		std::vector<Particle> particles;

		glm::vec3 gravity = glm::vec3(0.0f, -20.0f, 0.0f);
		glm::vec3 wind = glm::vec3(0.0f);
		float heaviness = 0.0f;
		float min_height = 30.0f;
		float max_height = 50.0f;
		float min_length = 2.0f;
		float max_length = 4.0f;
		float size = 1.0f / 32.0f;
		glm::vec4 color = glm::vec4(0.0f, 0.6f, 0.8f, 0.4f);

	public:
		RainWeather();
		~RainWeather();

		love::graphics::Mesh* get_mesh();

		void set_gravity(const glm::vec3& value);
		const glm::vec3& get_gravity() const;

		void set_wind(const glm::vec3& value);
		const glm::vec3& get_wind() const;

		void set_heaviness(float value);
		float get_heaviness() const;

		void set_min_height(float value);
		float get_min_height() const;

		void set_max_height(float value);
		float get_max_height() const;

		void set_min_length(float value);
		float get_min_length() const;

		void set_max_length(float value);
		float get_max_length() const;

		void set_size(float value);
		float get_size() const;

		void set_color(const glm::vec4& value);
		const glm::vec4& get_color() const;

		void update(const WeatherMap& weather_map, float delta);
	};
}

#endif
