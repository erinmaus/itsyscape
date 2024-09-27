////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/particle.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include <algorithm>
#include <cmath>
#include <limits>
#include "common/Module.h"
#include "common/math.h"
#include "modules/graphics/Graphics.h"
#include "modules/math/MathModule.h"
#include "modules/timer/Timer.h"
#include "nbunny/lua_runtime.hpp"
#include "nbunny/optimaus/particle.hpp"
#include "nbunny/optimaus/renderer.hpp"

void nbunny::Particle::reset()
{
	position = glm::vec3(0.0f);
	velocity = glm::vec3(0.0f);
	acceleration = glm::vec3(0.0f);
	rotation = 0.0f;
	rotation_velocity = 0.0f;
	rotation_acceleration = 0.0f;
	scale = glm::vec2(0.0f);
	lifetime = 0.0f;
	age = 0.0f;
	texture_index = 0;
	color = glm::vec4(1.0f);
	random = 0.0f;
}

class DirectionalEmitter : public nbunny::ParticleEmitter
{
public:
	glm::vec3 direction;
	float min_speed, max_speed;

	void update_local_direction(const glm::vec3& value)
	{
		direction = glm::normalize(value);
	}

	void from_definition(lua_State* L)
	{
		auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

		auto d = table.get("direction", nbunny::lua::TemporaryReference());
		direction = glm::vec3(d.get(1, 0.0f), d.get(2, 1.0f), d.get(3, 0.0f));
		direction = glm::normalize(direction);

		auto s = table.get("speed", nbunny::lua::TemporaryReference());
		min_speed = s.get(1, 0.0f);
		max_speed = s.get(2, min_speed);
	}

	void emit(nbunny::Particle& p)
	{
		auto rng = love::math::Math::instance.getRandomGenerator();
		float speed = rng->random() * (max_speed - min_speed) + min_speed;
		p.velocity = direction * speed;
	}
};

class RadialEmitter : public nbunny::ParticleEmitter
{
public:
	glm::vec3 position = glm::vec3(0.0f);
	glm::vec3 local_position = glm::vec3(0.0f);

	float min_speed = 0.0f, max_speed = 0.0f;
	float min_acceleration = 0.0f, max_acceleration = 0.0f;
	float min_radius = 0.0f, max_radius = 0.0f;
	float x_range_center = 0.0f, x_range_width = 1.0f;
	float y_range_center = 0.0f, y_range_width = 1.0f;
	float z_range_center = 0.0f, z_range_width = 1.0f;
	float min_lifetime = 0.0f, max_lifetime = 0.0f;
	bool set_normal = false;

	void update_local_position(const glm::vec3& value)
	{
		local_position = value;
	}

	void from_definition(lua_State* L)
	{
		auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

		auto p = table.get("position", nbunny::lua::TemporaryReference());
		position = glm::vec3(p.get(1, 0.0f), p.get(2, 0.0f), p.get(3, 0.0f));

		auto s = table.get("speed", nbunny::lua::TemporaryReference());
		min_speed = s.get(1, 0.0f);
		max_speed = s.get(2, min_speed);

		auto l = table.get("lifetime", nbunny::lua::TemporaryReference());
		min_lifetime = l.get(1, 0.0f);
		max_lifetime = l.get(2, min_lifetime);

		auto r = table.get("radius", nbunny::lua::TemporaryReference());
		min_radius = r.get(1, 0.0f);
		max_radius = r.get(2, min_radius);

		auto a = table.get("acceleration", nbunny::lua::TemporaryReference());
		min_acceleration = a.get(1, 0.0f);
		max_acceleration = a.get(2, min_acceleration);

		auto x = table.get("xRange", nbunny::lua::TemporaryReference());
		x_range_center = x.get(1, 0.0f);
		x_range_width = x.get(2, 1.0f);

		auto y = table.get("yRange", nbunny::lua::TemporaryReference());
		y_range_center = y.get(1, 0.0f);
		y_range_width = y.get(2, 1.0f);

		auto z = table.get("zRange", nbunny::lua::TemporaryReference());
		z_range_center = z.get(1, 0.0f);
		z_range_width = z.get(2, 1.0f);

		set_normal = table.get("normal", nbunny::lua::TemporaryReference()).get(1, false);
	}

	void emit(nbunny::Particle& p)
	{
		auto rng = love::math::Math::instance.getRandomGenerator();

		auto normal = glm::vec3(
			(rng->random() * 2 - 1) * x_range_width + x_range_center,
			(rng->random() * 2 - 1) * y_range_width + y_range_center,
			(rng->random() * 2 - 1) * z_range_width + z_range_center);
		normal = glm::normalize(normal);

		float radius = rng->random() * (max_radius - min_radius) + min_radius;
		float velocity = rng->random() * (max_speed - min_speed) + min_speed;
		float acceleration = rng->random() * (max_acceleration - min_acceleration) + min_acceleration;

		p.position = normal * radius + position + local_position;
		p.velocity = normal * velocity;
		p.acceleration = normal * acceleration;

		if (min_lifetime > 0.0f && max_lifetime > 0.0f)
		{
			float min = std::min(min_lifetime, max_lifetime);
			float max = std::max(min_lifetime, max_lifetime);

			float delta = (radius - min_radius) / (max_radius - min_radius);
			delta *= delta;

			if (min_lifetime > max_lifetime)
			{
				delta = 1.0f - delta;
			}

			p.lifetime = delta * (max - min) + min;
		}

		if (set_normal)
		{
			p.normal = -normal;
		}
	}
};

class RandomColorEmitter : public nbunny::ParticleEmitter
{
public:
	std::vector<glm::vec4> colors;

	void from_definition(lua_State* L)
	{
		auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

		auto c = table.get("colors", nbunny::lua::TemporaryReference());
		for (auto i = 1; i <= c.size(); ++i)
		{
			auto color = c.get(i, nbunny::lua::TemporaryReference());
			colors.emplace_back(
				color.get(1, 1.0f),
				color.get(2, 1.0f),
				color.get(3, 1.0f),
				color.get(4, 1.0f)
			);
		}
	}

	void emit(nbunny::Particle& p)
	{
		if (colors.size() == 0)
		{
			p.color = glm::vec4(1.0f);
			return;
		}

		auto rng = love::math::Math::instance.getRandomGenerator();
		auto color_index = rng->rand() % colors.size();
		p.color = colors.at(color_index);
	}
};

class RandomLifetimeEmitter : public nbunny::ParticleEmitter
{
public:
	float min_lifetime, max_lifetime;

	void from_definition(lua_State* L)
	{
		auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

		auto l = table.get("lifetime", table.get("age", nbunny::lua::TemporaryReference()));
		min_lifetime = l.get(1, 1.0f);
		max_lifetime = l.get(2, min_lifetime);
	}

	void emit(nbunny::Particle& p)
	{
		if (max_lifetime == min_lifetime || min_lifetime == std::numeric_limits<float>::infinity())
		{
			p.lifetime = min_lifetime;
		}
		else
		{
			auto rng = love::math::Math::instance.getRandomGenerator();
			float lifetime = rng->random() * (max_lifetime - min_lifetime) + min_lifetime;
			p.lifetime = lifetime;
		}
	}
};

class RandomRotationEmitter : public nbunny::ParticleEmitter
{
public:
	float min_rotation, max_rotation;
	float min_acceleration, max_acceleration;
	float min_velocity, max_velocity;

	void from_definition(lua_State* L)
	{
		auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

		auto r = table.get("rotation", nbunny::lua::TemporaryReference());
		min_rotation = LOVE_TORAD(r.get(1, 0.0f));
		max_rotation = LOVE_TORAD(r.get(2, min_rotation));

		auto a = table.get("acceleration", nbunny::lua::TemporaryReference());
		min_acceleration = LOVE_TORAD(a.get(1, 0.0f));
		max_acceleration = LOVE_TORAD(a.get(2, min_acceleration));

		auto v = table.get("velocity", nbunny::lua::TemporaryReference());
		min_velocity = LOVE_TORAD(v.get(1, 0.0f));
		max_velocity = LOVE_TORAD(v.get(2, min_velocity));
	}

	void emit(nbunny::Particle& p)
	{
		auto rng = love::math::Math::instance.getRandomGenerator();
		float rotation = rng->random() * (max_rotation - min_rotation) + min_rotation;
		float acceleration = rng->random() * (max_acceleration - min_acceleration) + min_acceleration;
		float velocity = rng->random() * (max_velocity - min_velocity) + min_velocity;

		p.rotation = rotation;
		p.rotation_acceleration = acceleration;
		p.rotation_velocity = velocity;
	}
};

class RandomScaleEmitter : public nbunny::ParticleEmitter
{
public:
	float min_scale = 1.0f, max_scale = 1.0f;
	float min_scale_x = 1.0f, max_scale_x = 1.0f;
	float min_scale_y = 1.0f, max_scale_y = 1.0f;

	void from_definition(lua_State* L)
	{
		auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

		auto s = table.get("scale", nbunny::lua::TemporaryReference());
		min_scale = s.get(1, 1.0f);
		max_scale = s.get(2, min_scale);

		auto x = table.get("scaleX", nbunny::lua::TemporaryReference());
		min_scale_x = x.get(1, 1.0f);
		max_scale_x = x.get(2, min_scale_x);

		auto y = table.get("scaleY", nbunny::lua::TemporaryReference());
		min_scale_y = y.get(1, 1.0f);
		max_scale_y = y.get(2, min_scale_x);
	}

	void emit(nbunny::Particle& p)
	{
		auto rng = love::math::Math::instance.getRandomGenerator();
		float scale = rng->random() * (max_scale - min_scale) + min_scale;
		float scale_x = rng->random() * (max_scale_x - min_scale_x) + min_scale_x;
		float scale_y = rng->random() * (max_scale_y - min_scale_y) + min_scale_y;

		p.scale = glm::vec2(scale * scale_x, scale * scale_y);
	}
};

class RandomTextureIndexEmitter : public nbunny::ParticleEmitter
{
public:
	int min_texture_index = 1, max_texture_index = 1;

	void from_definition(lua_State* L)
	{
		auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

		auto t = table.get("textures", nbunny::lua::TemporaryReference());
		min_texture_index = t.get(1, 1);
		max_texture_index = t.get(2, min_texture_index);
	}

	void emit(nbunny::Particle& p)
	{
		auto rng = love::math::Math::instance.getRandomGenerator();
		int index = rng->rand() % (max_texture_index - min_texture_index) + min_texture_index;

		p.texture_index = index - 1;
	}
};

bool nbunny::ParticleEmissionStrategy::running() const
{
	return current_time < duration;
}

int nbunny::ParticleEmissionStrategy::roll() const
{
	if (min_count == max_count)
	{
		return min_count;
	}

	auto rng = love::math::Math::instance.getRandomGenerator();
	return rng->rand() % (max_count - min_count) + min_count;
}

void nbunny::ParticleEmissionStrategy::from_definition(lua_State* L)
{
	auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

	auto c = table.get("count", nbunny::lua::TemporaryReference());
	min_count = c.get(1, 1.0f);
	max_count = c.get(2, min_count);

	auto infinity = std::numeric_limits<float>::infinity();
	auto d = table.get("duration", nbunny::lua::TemporaryReference());
	auto min_duration = d.get(1, 0);
	auto max_duration = d.get(2, d.get(1, infinity));

	if (min_duration == infinity || max_duration == infinity)
	{
		duration = infinity;
	}

	auto rng = love::math::Math::instance.getRandomGenerator();
	duration = rng->random() * (max_duration - min_duration) + min_duration;
}

int nbunny::ParticleEmissionStrategy::update(float delta)
{
	current_time += delta;

	return 0;
}

class BurstEmissionStrategy : public nbunny::ParticleEmissionStrategy
{
public:
	float delay = 0.0f;

	void from_definition(lua_State* L)
	{
		nbunny::ParticleEmissionStrategy::from_definition(L);

		auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

		auto d = table.get("delay", nbunny::lua::TemporaryReference());
		auto min_delay = d.get(1, 0.0f);

		auto max_delay = d.get(2, min_delay);

		auto rng = love::math::Math::instance.getRandomGenerator();
		delay = rng->random() * (max_delay - min_delay) + min_delay;
	}

	int update(float delta)
	{
		auto previous_delay = delay;
		auto current_delay = previous_delay - delta;

		auto count = 0;
		if (running() && current_delay < 0.0f and previous_delay > 0.0f)
		{
			count = roll();
		}

		delay = current_delay;

		return count;
	}
};

class RandomDelayEmissionStrategy : public nbunny::ParticleEmissionStrategy
{
public:
	float min_delay = 0.0f, max_delay = 0.0f;
	float current_delay = 0.0f;

	void from_definition(lua_State* L)
	{
		nbunny::ParticleEmissionStrategy::from_definition(L);

		auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

		auto d = table.get("delay", nbunny::lua::TemporaryReference());
		min_delay = d.get(1, 0.0f);
		max_delay = d.get(2, min_delay);

		tick();
	}

	void tick()
	{
		auto rng = love::math::Math::instance.getRandomGenerator();
		auto interval = rng->random() * (max_delay - min_delay) + min_delay;

		current_delay = interval;
	}

	int update(float delta)
	{
		nbunny::ParticleEmissionStrategy::update(delta);

		int count = 0;

		if (running())
		{
			current_delay -= delta;
			if (current_delay <= 0.0f)
			{
				tick();
				count = roll();
			}
		}

		return count;
	}
};

float sine_ease_out(float t)
{
	return std::sin(t * LOVE_M_PI_2);
}

class FadeInOutPath : public nbunny::ParticlePath
{
public:
	float fade_in_percent = 0.0f, fade_out_percent = 1.0f;

	void from_definition(lua_State* L)
	{
		auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

		fade_in_percent = table.get("fadeInPercent", nbunny::lua::TemporaryReference()).get(1, fade_in_percent);
		fade_out_percent = table.get("fadeOutPercent", nbunny::lua::TemporaryReference()).get(1, fade_out_percent);
	}

	void update(nbunny::Particle& p, float delta)
	{
		auto percent_age = p.age / p.lifetime;
		if (percent_age <= fade_in_percent)
		{
			p.color.a = sine_ease_out(percent_age / fade_in_percent);
		}
		else if (percent_age >= fade_out_percent)
		{
			auto difference = percent_age - fade_out_percent;
			auto range = 1.0f - fade_out_percent;
			p.color.a = sine_ease_out(1.0f - difference / range);
		}
		else
		{
			p.color.a = 1.0f;
		}
	}
};

class ColorPath : public nbunny::ParticlePath
{
public:
	float fade_in_percent = 0.0f, fade_out_percent = 1.0f;
	glm::vec4 fade_in_color = glm::vec4(1.0f), fade_out_color = glm::vec4(glm::vec3(1.0f), 0.0f);

	void from_definition(lua_State* L)
	{
		auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

		fade_in_percent = table.get("fadeInPercent", nbunny::lua::TemporaryReference()).get(1, fade_in_percent);
		fade_out_percent = table.get("fadeOutPercent", nbunny::lua::TemporaryReference()).get(1, fade_out_percent);

		auto i = table.get("fadeInColor", nbunny::lua::TemporaryReference());
		fade_in_color = glm::vec4(i.get(1, 1.0f), i.get(2, 1.0f), i.get(3, 1.0f), i.get(4, 1.0f));

		auto o = table.get("fadeOutColor", nbunny::lua::TemporaryReference());
		fade_out_color = glm::vec4(o.get(1, 1.0f), o.get(2, 1.0f), o.get(3, 1.0f), o.get(4, 1.0f));
	}

	void update(nbunny::Particle& p, float delta)
	{
		float mu;

		auto percent_age = p.age / p.lifetime;
		if (percent_age <= fade_in_percent)
		{
			mu = sine_ease_out(percent_age / fade_in_percent);
		}
		else if (percent_age >= fade_out_percent)
		{
			auto difference = percent_age - fade_out_percent;
			auto range = 1.0f - fade_out_percent;
			mu = sine_ease_out(1.0f - difference / range);
		}
		else
		{
			mu = 0.0f;
		}

		p.color = glm::mix(fade_in_color, fade_out_color, mu);
	}
};

class TwinklePath : public nbunny::ParticlePath
{
public:
	float speed = 1.0f;
	float min_alpha = 0.0f;
	float max_alpha = 1.0f;
	bool multiply = true;

	void from_definition(lua_State* L)
	{
		auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

		speed = table.get("speed", nbunny::lua::TemporaryReference()).get(1, 1.0f);

		auto a = table.get("alpha", nbunny::lua::TemporaryReference());
		min_alpha = a.get(1, 0.0f);
		max_alpha = a.get(2, 1.0f);

		auto m = table.get("multiply", nbunny::lua::TemporaryReference());
		multiply = m.get(1, true);
	}

	void update(nbunny::Particle& p, float delta)
	{
		auto alpha = std::abs(std::sin(p.age * speed + p.random * LOVE_M_PI_2));
		alpha = alpha * (max_alpha - min_alpha) + min_alpha;

		if (multiply)
		{
			p.color.a *= alpha;
		}
		else
		{
			p.color.a = alpha;
		}
	}
};

class GravityPath : public nbunny::ParticlePath
{
public:
	glm::vec3 gravity = glm::vec3(0.0f, -10.0f, 0.0f);

	void from_definition(lua_State* L)
	{
		auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

		auto g = table.get("gravity", nbunny::lua::TemporaryReference());
		gravity = glm::vec3(g.get(1, 0.0f), g.get(2, -10.0f), g.get(3, 0.0f));
	}

	void update(nbunny::Particle& p, float delta)
	{
		p.velocity += gravity * delta;
	}
};

class SingularityPath : public nbunny::ParticlePath
{
public:
	glm::vec3 position = glm::vec3(0.0f, -10.0f, 0.0f);
	float speed = 10.0f;

	void from_definition(lua_State* L)
	{
		auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

		auto g = table.get("position", nbunny::lua::TemporaryReference());
		position = glm::vec3(g.get(1, 0.0f), g.get(2, -10.0f), g.get(3, 0.0f));
		speed = table.get("speed", 10.0f);
	}

	void update(nbunny::Particle& p, float delta)
	{
		auto acceleration = glm::normalize(position - p.position) * speed;
		p.velocity += acceleration * delta;
	}
};

class SizePath : public nbunny::ParticlePath
{
public:
	float in_percent = 0.0f, out_percent = 1.0f;
	float size = 1.0f;
	float size_x = 1.0f, size_y = 1.0f;

	void from_definition(lua_State* L)
	{
		auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

		in_percent = table.get("inPercent", nbunny::lua::TemporaryReference()).get(1, in_percent);
		out_percent = table.get("outPercent", nbunny::lua::TemporaryReference()).get(1, out_percent);

		size = table.get("size", nbunny::lua::TemporaryReference()).get(1, 1.0f);
		size_x = table.get("sizeX", nbunny::lua::TemporaryReference()).get(1, 1.0f);
		size_y = table.get("sizeY", nbunny::lua::TemporaryReference()).get(1, 1.0f);
	}

	void update(nbunny::Particle& p, float delta)
	{
		auto percent_age = p.age / p.lifetime;
		if (percent_age <= in_percent)
		{
			auto mu = sine_ease_out(percent_age / in_percent);
			p.scale = glm::vec2(size * size_x * mu, size * size_y * mu);
		}
		else if (percent_age >= out_percent)
		{
			auto difference = percent_age - out_percent;
			auto range = 1.0f - out_percent;
			auto mu = sine_ease_out(1.0f - difference / range);
			p.scale = glm::vec2(size * size_x * mu, size * size_y * mu);
		}
		else
		{
			p.scale = glm::vec2(size * size_x, size * size_y);
		}
	}
};

class TextureIndexPath : public nbunny::ParticlePath
{
public:
	int min_texture_index = 1, max_texture_index = 1;

	void from_definition(lua_State* L)
	{
		auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

		auto t = table.get("textures", nbunny::lua::TemporaryReference());
		min_texture_index = t.get(1, 1);
		max_texture_index = t.get(2, min_texture_index);
	}

	void update(nbunny::Particle& p, float delta)
	{
		auto percent_age = p.age / p.lifetime;
		int index = percent_age * (max_texture_index - min_texture_index) + min_texture_index;

		p.texture_index = index - 1; // Lua is 1..n, while C++ is 0..n-1
	}
};

nbunny::ParticleSceneNode::ParticleSceneNode(int reference) :
	SceneNode(reference),
	mesh_attribs({
		{ "VertexPosition", love::graphics::vertex::DATA_FLOAT, 3 },
		{ "VertexNormal", love::graphics::vertex::DATA_FLOAT, 3 },
		{ "VertexTexture", love::graphics::vertex::DATA_FLOAT, 2 },
		{ "VertexColor", love::graphics::vertex::DATA_FLOAT, 4 },
	}),
	quad({
		{ glm::vec3( 1.0f, -1.0f, 0.0f), glm::vec3(0.0f, 0.0f, 1.0f), glm::vec2(1.0f, 0.0f), glm::vec4(1.0f) },
		{ glm::vec3(-1.0f, -1.0f, 0.0f), glm::vec3(0.0f, 0.0f, 1.0f), glm::vec2(0.0f, 0.0f), glm::vec4(1.0f) },
		{ glm::vec3( 1.0f,  1.0f, 0.0f), glm::vec3(0.0f, 0.0f, 1.0f), glm::vec2(1.0f, 1.0f), glm::vec4(1.0f) },
		{ glm::vec3(-1.0f, -1.0f, 0.0f), glm::vec3(0.0f, 0.0f, 1.0f), glm::vec2(0.0f, 0.0f), glm::vec4(1.0f) },
		{ glm::vec3(-1.0f,  1.0f, 0.0f), glm::vec3(0.0f, 0.0f, 1.0f), glm::vec2(0.0f, 1.0f), glm::vec4(1.0f) },
		{ glm::vec3( 1.0f,  1.0f, 0.0f), glm::vec3(0.0f, 0.0f, 1.0f), glm::vec2(1.0f, 1.0f), glm::vec4(1.0f) }
	})
{
	// Nothing.
}

nbunny::ParticleSceneNode::~ParticleSceneNode()
{
	if (mesh)
	{
		mesh->release();
	}
}

const nbunny::Type<nbunny::ParticleSceneNode> nbunny::ParticleSceneNode::type_pointer;

const nbunny::BaseType& nbunny::ParticleSceneNode::get_type() const
{
	return type_pointer;
}

void nbunny::ParticleSceneNode::update(float time_delta)
{
	int count = 0;
	if (emission_strategy)
	{
		count = emission_strategy->update(time_delta);
	}

	emit(count);

	auto min = glm::vec3(std::numeric_limits<float>::infinity());
	auto max = glm::vec3(-std::numeric_limits<float>::infinity());

	std::size_t i = 0;
	while (i < particles.size())
	{
		auto& p = particles.at(i);
		auto is_alive = p.age < p.lifetime;

		if (is_alive)
		{
			p.velocity += p.acceleration * time_delta;
			p.position += p.velocity * time_delta;
			p.rotation_velocity += p.rotation_acceleration * time_delta;
			p.rotation += p.rotation_velocity * time_delta;
			p.age += time_delta;

			for(auto& path: paths)
			{
				path->update(p, time_delta);
			}

			min = glm::min(min, p.position);
			max = glm::max(max, p.position);

			++i;
		}
		else
		{
			std::swap(particles[i], particles[particles.size() - 1]);
			particles.pop_back();
		}
	}

	set_min(min);
	set_max(max);
}

void nbunny::ParticleSceneNode::emit(int count)
{
	while (count > 0 && particles.size() < max_num_particles)
	{
		Particle p;

		auto rng = love::math::Math::instance.getRandomGenerator();
		p.random = rng->random();

		for (auto& emitter: emitters)
		{
			emitter->emit(p);
		}

		particles.push_back(p);

		--count;
	}
}

glm::quat nbunny::ParticleSceneNode::get_global_rotation(float delta) const
{
	const SceneNode* parent = this;
	glm::quat current_rotation = glm::quat(1.0f, 0.0f, 0.0f, 0.0f);
	glm::quat previous_rotation = glm::quat(1.0f, 0.0f, 0.0f, 0.0f);

	while(parent)
	{
		auto transform = parent->get_transform();
		auto parent_current_rotation = transform.get_current_rotation();
		auto parent_previous_rotation = transform.get_previous_rotation();

		current_rotation = parent_current_rotation * current_rotation;
		previous_rotation = parent_previous_rotation * previous_rotation;

		parent = parent->get_parent();
	}

	return glm::slerp(previous_rotation, current_rotation, delta);
}

void nbunny::ParticleSceneNode::build(const glm::quat& inverse_rotation, const glm::quat& self_rotation, const glm::mat4& view, float delta)
{
	vertices.clear();

	auto view_world_transform = view * get_transform().get_global(delta);
	std::stable_sort(particles.begin(), particles.end(), [&](auto& a, auto& b)
	{
		auto a_position = view_world_transform * glm::vec4(a.position, 1.0f);
		auto b_position = view_world_transform * glm::vec4(b.position, 1.0f);

		return a_position.z > b_position.z;
	});

	for (auto& particle: particles)
	{
		push_particle_quad(particle, inverse_rotation, self_rotation);
	}

	if (vertices.size() > 0)
	{
		if (mesh && vertices.size() <= mesh->getVertexCount())
		{
			auto p = mesh->mapVertexData();
			std::memcpy(p, &vertices[0], sizeof(Vertex) * vertices.size());
			mesh->unmapVertexData();

			mesh->setDrawRange(0, vertices.size());
		}
		else
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

			for (auto& mesh_attrib: mesh_attribs) {
				mesh->setAttributeEnabled(mesh_attrib.name, true);
			}
		}
	}
}

void nbunny::ParticleSceneNode::push_particle_quad(const Particle& p, const glm::quat& inverse_rotation, const glm::quat& self_rotation)
{
	for (auto& template_vertex: quad)
	{
		Vertex vertex;
		vertex.position = glm::vec3(
			template_vertex.position.x * p.scale.x,
			template_vertex.position.y * p.scale.y,
			template_vertex.position.z
		);
		vertex.position = glm::rotate(
			inverse_rotation * glm::angleAxis(p.rotation, glm::vec3(0.0f, 0.0f, 1.0f)),
			vertex.position
		);

		vertex.normal = glm::normalize(glm::rotate(self_rotation, glm::normalize(p.normal)));
		vertex.position += p.position;
		vertex.color = p.color;

		if (!textures.empty())
		{
			auto texture = textures.at(p.texture_index % textures.size());

			if (template_vertex.texture.x == 0)
			{
				vertex.texture.x = texture.x;
			}
			else
			{
				vertex.texture.x = texture.y;
			}

			if (template_vertex.texture.y == 0)
			{
				vertex.texture.y = texture.z;
			}
			else
			{
				vertex.texture.y = texture.w;
			}
		}

		vertices.push_back(vertex);
	}
}

void nbunny::ParticleSceneNode::clear()
{
	vertices.clear();
	particles.clear();
}

void nbunny::ParticleSceneNode::set_paths(lua_State* L, const lua::TemporaryReference& path_definitions)
{
	paths.clear();

	for (auto i = 1; i <= path_definitions.size(); ++i)
	{
		auto definition = path_definitions.get<lua::TemporaryReference>(i, lua::TemporaryReference());
		auto type = definition.get("type", std::string());

		std::shared_ptr<ParticlePath> path;
		if (type == "FadeInOutPath")
		{
			path = std::make_shared<FadeInOutPath>();
		}
		else if (type == "TwinklePath")
		{
			path = std::make_shared<TwinklePath>();
		}
		else if (type == "GravityPath")
		{
			path = std::make_shared<GravityPath>();
		}
		else if (type == "SingularityPath")
		{
			path = std::make_shared<SingularityPath>();
		}
		else if (type == "ColorPath")
		{
			path = std::make_shared<ColorPath>();
		}
		else if (type == "SizePath")
		{
			path = std::make_shared<SizePath>();
		}
		else if (type == "TextureIndexPath")
		{
			path = std::make_shared<TextureIndexPath>();
		}

		if (path)
		{
			definition.push();
			path->from_definition(L);
			lua_pop(L, 1);

			paths.push_back(path);
		}
	}
}

void nbunny::ParticleSceneNode::set_emitters(lua_State* L, const lua::TemporaryReference& emitter_definitions)
{
	emitters.clear();

	for (auto i = 1; i <= emitter_definitions.size(); ++i)
	{
		auto definition = emitter_definitions.get(i, lua::TemporaryReference());
		auto type = definition.get("type", std::string());

		std::shared_ptr<ParticleEmitter> emitter;
		if (type == "DirectionalEmitter")
		{
			emitter = std::make_shared<DirectionalEmitter>();
		}
		else if (type == "RadialEmitter")
		{
			emitter = std::make_shared<RadialEmitter>();
		}
		else if (type == "RandomColorEmitter")
		{
			emitter = std::make_shared<RandomColorEmitter>();
		}
		else if (type == "RandomLifetimeEmitter")
		{
			emitter = std::make_shared<RandomLifetimeEmitter>();
		}
		else if (type == "RandomRotationEmitter")
		{
			emitter = std::make_shared<RandomRotationEmitter>();
		}
		else if (type == "RandomScaleEmitter")
		{
			emitter = std::make_shared<RandomScaleEmitter>();
		}
		else if (type == "RandomTextureIndexEmitter")
		{
			emitter = std::make_shared<RandomTextureIndexEmitter>();
		}

		if (emitter)
		{
			definition.push();
			emitter->from_definition(L);
			lua_pop(L, 1);

			emitters.push_back(emitter);
		}
	}
}

void nbunny::ParticleSceneNode::set_emission_strategy(lua_State* L, const lua::TemporaryReference& emission_strategy_definition)
{
	if (emission_strategy)
	{
		emission_strategy.reset();
	}

	auto type = emission_strategy_definition.get("type", std::string());
	if (type == "BurstEmissionStrategy")
	{
		emission_strategy = std::make_shared<BurstEmissionStrategy>();
	}
	else if (type == "RandomDelayEmissionStrategy")
	{
		emission_strategy = std::make_shared<RandomDelayEmissionStrategy>();
	}

	if (emission_strategy)
	{
		emission_strategy_definition.push();
		emission_strategy->from_definition(L);
		lua_pop(L, 1);
	}
}

void nbunny::ParticleSceneNode::from_definition(lua_State* L)
{
	auto table = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, -1, nbunny::lua::TemporaryReference());

	max_num_particles = table.get("numParticles", max_num_particles);

	auto rows = table.get("rows", 1);
	auto columns = table.get("columns", 1);

	textures.clear();
	for (auto i = 0; i < rows; ++i)
	{
		for (auto j = 0; j < columns; ++j)
		{
			auto left = 1.0f / columns * j;
			auto right = 1.0f / columns * (j + 1);
			auto top = 1.0f / rows * i;
			auto bottom = 1.0f / rows * (i + 1);

			textures.emplace_back(left, right, top, bottom);
		}
	}

	auto emitter_definitions = table.get("emitters", nbunny::lua::TemporaryReference());
	set_emitters(L, emitter_definitions);

	auto path_definitions = table.get("paths", nbunny::lua::TemporaryReference());
	set_paths(L, path_definitions);

	auto emission_strategy_definition = table.get("emissionStrategy", nbunny::lua::TemporaryReference());
	set_emission_strategy(L, emission_strategy_definition);
}

void nbunny::ParticleSceneNode::update_local_position(const glm::vec3& position)
{
	for (auto& emitter: emitters)
	{
		emitter->update_local_position(position);
	}
}

void nbunny::ParticleSceneNode::update_local_direction(const glm::vec3& direction)
{
	for (auto& emitter: emitters)
	{
		emitter->update_local_direction(direction);
	}
}

void nbunny::ParticleSceneNode::pause()
{
	is_playing = false;
}

void nbunny::ParticleSceneNode::play()
{
	is_playing = true;
}

bool nbunny::ParticleSceneNode::get_is_playing() const
{
	return is_playing;
}

void nbunny::ParticleSceneNode::frame(float delta)
{
	if (!is_playing)
	{
		return;
	}

	auto timer_instance = love::Module::getInstance<love::timer::Timer>(love::Module::M_TIMER);
	auto time_delta = timer_instance->getDelta();

	update(time_delta);
	is_pending = true;
}

void nbunny::ParticleSceneNode::draw(Renderer& renderer, float delta)
{
	if (is_pending)
	{
		auto self_rotation = get_global_rotation(delta);
		build(
			glm::conjugate(renderer.get_camera().get_rotation() * self_rotation),
			self_rotation,
			renderer.get_camera().get_view(),
			delta);
		is_pending = false;
	}

	if (!mesh)
	{
		return;
	}

	auto shader = renderer.get_current_shader();

	const auto& textures = get_material().get_textures();
	auto diffuse_texture_uniform = shader->getUniformInfo("scape_DiffuseTexture");
	if (diffuse_texture_uniform && textures.size() >= 1)
	{
		auto texture = textures[0]->get_per_pass_texture(renderer.get_current_pass_id());
		if (texture)
		{
			shader->sendTextures(diffuse_texture_uniform, &texture, 1);
		}
	}

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	love::Matrix4 matrix(glm::value_ptr(get_transform().get_global(delta)));
	graphics->draw(mesh, matrix);
}

int nbunny_particle_scene_node_clear(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::ParticleSceneNode*>(L, 1);
	node->clear();
	return 0;
}

int nbunny_particle_scene_node_play(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::ParticleSceneNode*>(L, 1);
	node->play();
	return 0;
}

int nbunny_particle_scene_node_pause(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::ParticleSceneNode*>(L, 1);
	node->pause();
	return 0;
}

int nbunny_particle_scene_node_get_is_playing(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::ParticleSceneNode*>(L, 1);
	nbunny::lua::push(L, node->get_is_playing());
	return 0;
}

int nbunny_particle_scene_node_init_particle_system_from_def(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::ParticleSceneNode*>(L, 1);
	node->from_definition(L);

	return 0;
}

int nbunny_particle_scene_node_update_local_position(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::ParticleSceneNode*>(L, 1);
	auto x = luaL_checknumber(L, 2);
	auto y = luaL_checknumber(L, 3);
	auto z = luaL_checknumber(L, 4);

	node->update_local_position(glm::vec3(x, y, z));

	return 0;
}

int nbunny_particle_scene_node_update_local_direction(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::ParticleSceneNode*>(L, 1);
	auto x = luaL_checknumber(L, 2);
	auto y = luaL_checknumber(L, 3);
	auto z = luaL_checknumber(L, 4);

	node->update_local_direction(glm::vec3(x, y, z));

	return 0;
}

int nbunny_particle_scene_node_init_emitters_from_def(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::ParticleSceneNode*>(L, 1);
	auto def = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, 2, nbunny::lua::TemporaryReference());

	node->set_emitters(L, def);

	return 0;
}

int nbunny_particle_scene_node_init_paths_from_def(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::ParticleSceneNode*>(L, 1);
	auto def = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, 2, nbunny::lua::TemporaryReference());

	node->set_paths(L, def);

	return 0;
}

int nbunny_particle_scene_node_init_emission_strategy_from_def(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::ParticleSceneNode*>(L, 1);
	auto def = nbunny::lua::get_or<nbunny::lua::TemporaryReference>(L, 2, nbunny::lua::TemporaryReference());

	node->set_emission_strategy(L, def);

	return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_scenenode_particlescenenode(lua_State* L)
{
	const luaL_Reg metatable[] = {
		{ "initParticleSystemFromDef", &nbunny_particle_scene_node_init_particle_system_from_def },
		{ "clear", &nbunny_particle_scene_node_clear },
		{ "initEmittersFromDef", &nbunny_particle_scene_node_init_emitters_from_def },
		{ "initPathsFromDef", &nbunny_particle_scene_node_init_paths_from_def },
		{ "initEmissionStrategyFromDef", &nbunny_particle_scene_node_init_emission_strategy_from_def },
		{ "updateLocalPosition", &nbunny_particle_scene_node_update_local_position },
		{ "updateLocalDirection", &nbunny_particle_scene_node_update_local_direction },
		{ "pause", &nbunny_particle_scene_node_pause },
		{ "play", &nbunny_particle_scene_node_play },
		{ "getIsPlaying", &nbunny_particle_scene_node_get_is_playing },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_child_type<nbunny::ParticleSceneNode, nbunny::SceneNode>(L, &nbunny_scene_node_constructor<nbunny::ParticleSceneNode>, metatable);

	return 1;
}
