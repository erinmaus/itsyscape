////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/l_buffer.cpp
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
#include "nbunny/optimaus/l_buffer.hpp"

nbunny::LBuffer::LBuffer(
	love::PixelFormat color_pixel_format,
	GBuffer& g_buffer) :
	color_pixel_format(color_pixel_format),
	g_buffer(g_buffer)
{
	resize(g_buffer);
}

nbunny::LBuffer::~LBuffer()
{
	release();
}

nbunny::GBuffer& nbunny::LBuffer::get_g_buffer()
{
	return g_buffer;
}

int nbunny::LBuffer::get_width()
{
	return g_buffer.get_width();
}

int nbunny::LBuffer::get_height()
{
	return g_buffer.get_height();
}

void nbunny::LBuffer::release()
{
	if (color)
	{
		color->release();
		color = nullptr;
	}
}

void nbunny::LBuffer::resize(GBuffer& g_buffer)
{
	release();

	this->g_buffer = g_buffer;

	love::graphics::Graphics* instance = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	if (get_width() > 0 && get_height() > 0)
	{
		love::graphics::Canvas::Settings settings;
		settings.width = get_width();
		settings.height = get_height();
		settings.dpiScale = instance->getScreenDPIScale();
		settings.format = color_pixel_format;
		color = instance->newCanvas(settings);
	}
}

love::graphics::Canvas* nbunny::LBuffer::get_color()
{
	return color;
}

love::graphics::Canvas* nbunny::LBuffer::get_depth_stencil()
{
	return g_buffer.get_canvas(0);
}

void nbunny::LBuffer::use()
{
	love::graphics::Graphics::RenderTargets render_targets;
	render_targets.colors.emplace_back(get_color());
	render_targets.depthStencil = love::graphics::Graphics::RenderTarget(get_depth_stencil());

	love::graphics::Graphics* instance = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	instance->setCanvas(render_targets);
}


nbunny::LBuffer* nbunny_l_buffer_create(
	const std::string& color_pixel_format_name,
	nbunny::GBuffer& g_buffer,
	sol::this_state S)
{
	lua_State* L = S;

	love::PixelFormat color_pixel_format;
	if (!love::getConstant(color_pixel_format_name.c_str(), color_pixel_format))
	{
		love::luax_enumerror(L, "pixel format", color_pixel_format_name.c_str());
	}

	return new nbunny::LBuffer(color_pixel_format, g_buffer);
}

static int nbunny_l_buffer_get_color(lua_State* L)
{
	auto& l_buffer = sol::stack::get<nbunny::LBuffer>(L, 1);
	auto color = l_buffer.get_color();

	if (color == nullptr)
	{
		lua_pushnil(L);
	}
	else
	{
		love::luax_pushtype(L, color);
	}

	return 1;
}

static int nbunny_l_buffer_get_depth_stencil(lua_State* L)
{
	auto& l_buffer = sol::stack::get<nbunny::LBuffer>(L, 1);
	auto depth_stencil = l_buffer.get_depth_stencil();

	if (depth_stencil == nullptr)
	{
		lua_pushnil(L);
	}
	else
	{
		love::luax_pushtype(L, depth_stencil);
	}

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_lbuffer(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::LBuffer>("NLBuffer",
		sol::call_constructor, sol::factories(&nbunny_l_buffer_create),
		"getWidth", &nbunny::LBuffer::get_width,
		"getHeight", &nbunny::LBuffer::get_height,
		"resize", &nbunny::LBuffer::resize,
		"release", &nbunny::LBuffer::release,
		"getGBuffer", &nbunny::LBuffer::get_g_buffer,
		"getColor", &nbunny_l_buffer_get_color,
		"getDepthStencil", &nbunny_l_buffer_get_depth_stencil,
		"use", &nbunny::LBuffer::use);

	sol::stack::push(L, T);

	return 1;
}
	