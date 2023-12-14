////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/particle.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_PARTICLE_HPP
#define NBUNNY_OPTIMAUS_PARTICLE_HPP

#include "modules/graphics/Mesh.h"
#include "nbunny/nbunny.hpp"
#include "nbunny/optimaus/scene.hpp"

namespace nbunny
{
	struct Particle
	{
	public:
		glm::vec3 position = glm::vec3(0.0f);
		glm::vec3 velocity = glm::vec3(0.0f);
		glm::vec3 acceleration = glm::vec3(0.0f);
		float rotation = 0.0f;
		float rotation_velocity = 0.0f;
		float rotation_acceleration = 0.0f;
		glm::vec2 scale = glm::vec2(0.0f);
		float lifetime = 0.0f;
		float age = 0.0f;
		int texture_index = 0;
		glm::vec4 color = glm::vec4(1.0f);

		void reset();
	};

	class ParticleEmitter
	{
	public:
		virtual ~ParticleEmitter() = default;

		virtual void update_local_position(const glm::vec3& position) {};

		virtual void from_definition(lua_State* L) = 0;
		virtual void emit(Particle& p) = 0;
	};

	class ParticleEmissionStrategy
	{
	public:
		int min_count = 0, max_count = 0;
		float duration = 0.0f;
		float current_time = 0.0f;

		bool running() const;
		int roll() const;

		virtual ~ParticleEmissionStrategy() = default;

		virtual void from_definition(lua_State* L);
		virtual int update(float delta) = 0;
	};

	class ParticlePath
	{
	public:
		virtual ~ParticlePath() = default;

		virtual void from_definition(lua_State* L) = 0;
		virtual void update(Particle& p, float delta) = 0;
	};

	class ParticleSceneNode : public SceneNode
	{
	private:
		struct Vertex
		{
			glm::vec3 position;
			glm::vec3 normal;
			glm::vec2 texture;
			glm::vec4 color;
		};

		love::graphics::Mesh* mesh = nullptr;
		std::vector<love::graphics::Mesh::AttribFormat> mesh_attribs;
		std::vector<Vertex> quad;

		std::vector<std::shared_ptr<ParticleEmitter>> emitters;
		std::vector<std::shared_ptr<ParticlePath>> paths;
		std::shared_ptr<ParticleEmissionStrategy> emission_strategy;

		std::vector<Particle> particles;
		std::vector<Vertex> vertices;

		std::vector<glm::vec4> textures;

		bool is_playing = true;

		void update(float time_delta);
		void emit(int count);

		glm::quat get_global_rotation(float frame_delta) const;
		void build(float frame_delta);
		void push_particle_quad(const Particle& p, glm::quat rotation);

	public:
		static const Type<ParticleSceneNode> type_pointer;
		const BaseType& get_type() const override;

		ParticleSceneNode(int reference);
		virtual ~ParticleSceneNode();

		void clear();
		void set_emission_strategy(lua_State* L, sol::table& def);
		void set_emitters(lua_State* L, sol::table& def);
		void set_paths(lua_State* L, sol::table& def);

		void from_definition(lua_State* L);
		void update_local_position(const glm::vec3& position);

		void pause();
		void play();
		bool get_is_playing() const;

		void frame(float frame_delta, float time_delta);
		void draw(Renderer& renderer, float delta) override;
	};
}

#endif
