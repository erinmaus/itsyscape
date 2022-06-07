////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/light.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_LIGHT_HPP
#define NBUNNY_OPTIMAUS_LIGHT_HPP

#include "nbunny/optimaus/common.hpp"
#include "nbunny/optimaus/scene.hpp"

namespace nbunny
{
	struct Light
	{
	public:
		glm::vec4 position = glm::vec4(0.0f, 1.0f, 0.0f, 0.0f);
		glm::vec3 color = glm::vec3(1.0f);
		float attenuation = 1.0f;
		float ambient_coefficient = 0.0f;
		float cone_angle = 360.0f;
		glm::vec3 cone_direction = glm::vec3(0, 1, 0);
		float near_distance = 0.0f;
		float far_distance = 0.0f;
	};

	class LightSceneNode : public SceneNode
	{
	private:
		glm::vec3 current_color = glm::vec3(1.0f);
		glm::vec3 previous_color = glm::vec3(1.0f);

		bool is_global = false;

	public:
		static const Type<LightSceneNode> type_pointer;
		virtual const BaseType& get_type() const override;

		LightSceneNode(int reference);
		virtual ~LightSceneNode() = default;

		const bool is_base_light_type() const;

		void set_current_color(const glm::vec3& value);
		const glm::vec3& get_current_color() const;
		void set_previous_color(const glm::vec3& value);
		const glm::vec3& get_previous_color() const;

		void set_is_global(bool value);
		bool get_is_global() const;

		virtual void to_light(Light& light, float delta) const;

		void tick() override;
	};

	class AmbientLightSceneNode : public LightSceneNode
	{
	private:
		float current_ambience = 0.0f;
		float previous_ambience = 0.0f;

	public:
		static const Type<AmbientLightSceneNode> type_pointer;
		const BaseType& get_type() const override;

		AmbientLightSceneNode(int reference);
		virtual ~AmbientLightSceneNode() = default;

		void set_current_ambience(float value);
		float get_current_ambience() const;
		void set_previous_ambience(float value);
		float get_previous_ambience() const;

		void to_light(Light& light, float delta) const override;

		void tick() override;
	};

	class DirectionalLightSceneNode : public LightSceneNode
	{
	private:
		glm::vec3 current_direction = glm::vec3(0.0f, 1.0f, 0.0f);
		glm::vec3 previous_direction = glm::vec3(0.0f, 1.0f, 0.0f);

	public:
		static const Type<DirectionalLightSceneNode> type_pointer;
		const BaseType& get_type() const override;

		DirectionalLightSceneNode(int reference);
		virtual ~DirectionalLightSceneNode() = default;

		void set_current_direction(const glm::vec3& value);
		const glm::vec3& get_current_direction() const;
		void set_previous_direction(const glm::vec3& value);
		const glm::vec3& get_previous_direction() const;

		void to_light(Light& light, float delta) const override;

		void tick() override;
	};

	class PointLightSceneNode : public LightSceneNode
	{
	private:
		float current_attenuation = 0.0f;
		float previous_attenuation = 0.0f;

	public:
		static const Type<PointLightSceneNode> type_pointer;
		const BaseType& get_type() const override;

		PointLightSceneNode(int reference);
		virtual ~PointLightSceneNode() = default;

		void set_current_attenuation(float value);
		float get_current_attenuation() const;
		void set_previous_attenuation(float value);
		float get_previous_attenuation() const;

		void to_light(Light& light, float delta) const override;

		void tick() override;
	};

	class FogSceneNode : public LightSceneNode
	{
	public:
		enum FollowMode
		{
			FOLLOW_MODE_EYE    = 0,
			FOLLOW_MODE_TARGET = 1
		};

	private:
		float current_near_distance = 0.0f;
		float previous_near_distance = 0.0f;
		float current_far_distance = 100.0f;
		float previous_far_distance = 100.0f;
		FollowMode follow_mode = FOLLOW_MODE_EYE;

	public:
		static const Type<FogSceneNode> type_pointer;
		const BaseType& get_type() const override;

		FogSceneNode(int reference);
		virtual ~FogSceneNode() = default;

		void set_current_near_distance(float value);
		float get_current_near_distance() const;
		void set_previous_near_distance(float value);
		float get_previous_near_distance() const;

		void set_current_far_distance(float value);
		float get_current_far_distance() const;
		void set_previous_far_distance(float value);
		float get_previous_far_distance() const;

		void set_follow_mode(FollowMode value);
		FollowMode get_follow_mode() const;

		void to_light(Light& light, float delta) const override;

		void tick() override;
	};
}

#endif
