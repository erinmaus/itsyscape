////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/g_buffer.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "common/Module.h"
#include "common/runtime.h"
#include "modules/graphics/Graphics.h"
#include "nbunny/nbunny.hpp"
#include "nbunny/optimaus/g_buffer.hpp"

nbunny::GBuffer::GBuffer(const std::vector<love::PixelFormat>& pixel_formats)
{
	this->pixel_formats.push_back(love::PIXELFORMAT_DEPTH24_STENCIL8);
	this->pixel_formats.insert(this->pixel_formats.end(), pixel_formats.begin(), pixel_formats.end());
}

nbunny::GBuffer::~GBuffer()
{
	release();
}

int nbunny::GBuffer::get_width() const
{
	return width;
}

int nbunny::GBuffer::get_height() const
{
	return height;
}

void nbunny::GBuffer::resize(int width, int height)
{
	release();

	this->width = width < 1 ? 1 : width;
	this->height = height < 1 ? 1 : height;

	love::graphics::Graphics* instance = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	for (const auto& pixel_format: pixel_formats)
	{
		love::graphics::Canvas::Settings settings;
		settings.width = this->width;
		settings.height = this->height;
		settings.dpiScale = instance->getScreenDPIScale();
		settings.format = pixel_format;

		love::graphics::Canvas* canvas = instance->newCanvas(settings);
		canvases.push_back(canvas);
	}
}

void nbunny::GBuffer::release()
{
	for (auto& canvas: canvases)
	{
		canvas->release();
	}
	canvases.clear();
}

love::graphics::Canvas* nbunny::GBuffer::get_canvas(int index)
{
	if (index < 0 || index >= canvases.size())
	{
		return nullptr;
	}

	return canvases.at(index);
}

void nbunny::GBuffer::use()
{
	love::graphics::Graphics::RenderTargets render_targets;

	for (std::size_t i = 1; i < pixel_formats.size(); ++i)
	{
		render_targets.colors.emplace_back(get_canvas(i));
	}

	render_targets.depthStencil = love::graphics::Graphics::RenderTarget(get_canvas(0));

	love::graphics::Graphics* instance = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	instance->setCanvas(render_targets);
}

nbunny::GBuffer* nbunny_g_buffer_create(sol::variadic_args pixel_format_names, sol::this_state S)
{
	lua_State* L = S;

	std::vector<love::PixelFormat> pixel_formats;

	for (auto i: pixel_format_names)
	{
		auto pixel_format_name = i.as<const char*>();

		love::PixelFormat pixel_format;
		if (!love::getConstant(pixel_format_name, pixel_format))
		{
			love::luax_enumerror(L, "pixel format", pixel_format_name);
		}

		pixel_formats.push_back(pixel_format);
	}

	return new nbunny::GBuffer(pixel_formats);
}

static int nbunny_g_buffer_get_canvas(lua_State* L)
{
	auto& g_buffer = sol::stack::get<nbunny::GBuffer>(L, 1);
	auto index = luaL_checkinteger(L, 2);

	auto canvas = g_buffer.get_canvas(index);
	if (canvas == nullptr)
	{
		lua_pushnil(L);
	}
	else
	{
		love::luax_pushtype(L, canvas);
	}

	return 1;
}

static int nbunny_g_buffer_get_depth_stencil(lua_State* L)
{
	auto& g_buffer = sol::stack::get<nbunny::GBuffer>(L, 1);

	auto canvas = g_buffer.get_canvas(0);
	if (canvas == nullptr)
	{
		lua_pushnil(L);
	}
	else
	{
		love::luax_pushtype(L, canvas);
	}

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_gbuffer(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::GBuffer>("NGBuffer",
		sol::call_constructor, sol::factories(&nbunny_g_buffer_create),
		"getWidth", &nbunny::GBuffer::get_width,
		"getHeight", &nbunny::GBuffer::get_height,
		"resize", &nbunny::GBuffer::resize,
		"release", &nbunny::GBuffer::release,
		"getCanvas", &nbunny_g_buffer_get_canvas,
		"getDepthStencil", &nbunny_g_buffer_get_depth_stencil,
		"use", &nbunny::GBuffer::use);

	sol::stack::push(L, T);

	return 1;
}
