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
#include "nbunny/lua_runtime.hpp"
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

void nbunny::LBuffer::use(bool use_depth)
{
	love::graphics::Graphics::RenderTargets render_targets;
	render_targets.colors.emplace_back(get_color());

	if (use_depth)
	{
		render_targets.depthStencil = love::graphics::Graphics::RenderTarget(get_depth_stencil());
	}

	love::graphics::Graphics* instance = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	instance->setCanvas(render_targets);
}


int nbunny_l_buffer_constructor(lua_State* L)
{
	auto color_pixel_format_name = nbunny::lua::get<std::string>(L, 2);
	auto g_buffer = nbunny::lua::get<nbunny::GBuffer*>(L, 3);

	love::PixelFormat color_pixel_format;
	if (!love::getConstant(color_pixel_format_name.c_str(), color_pixel_format))
	{
		love::luax_enumerror(L, "pixel format", color_pixel_format_name.c_str());
	}

	nbunny::lua::push(L, std::make_shared<nbunny::LBuffer>(color_pixel_format, *g_buffer));
	return 1;
}

static int nbunny_l_buffer_get_width(lua_State* L)
{
	auto l_buffer = nbunny::lua::get<nbunny::LBuffer*>(L, 1);
	nbunny::lua::push(L, l_buffer->get_width());
	return 1;
}

static int nbunny_l_buffer_get_height(lua_State* L)
{
	auto l_buffer = nbunny::lua::get<nbunny::LBuffer*>(L, 1);
	nbunny::lua::push(L, l_buffer->get_height());
	return 1;
}

static int nbunny_l_buffer_resize(lua_State* L)
{
	auto l_buffer = nbunny::lua::get<nbunny::LBuffer*>(L, 1);
	auto g_buffer = nbunny::lua::get<nbunny::GBuffer*>(L, 2);
	
	l_buffer->resize(*g_buffer);
	return 0;
}

static int nbunny_l_buffer_release(lua_State* L)
{
	auto l_buffer = nbunny::lua::get<nbunny::LBuffer*>(L, 1);
	l_buffer->release();
	return 0;
}

static int nbunny_l_buffer_use(lua_State* L)
{
	auto l_buffer = nbunny::lua::get<nbunny::LBuffer*>(L, 1);
	
	l_buffer->use();

	return 0;
}

static int nbunny_l_buffer_get_color(lua_State* L)
{
	auto l_buffer = nbunny::lua::get<nbunny::LBuffer*>(L, 1);
	auto color = l_buffer->get_color();

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
	auto l_buffer = nbunny::lua::get<nbunny::LBuffer*>(L, 1);
	auto depth_stencil = l_buffer->get_depth_stencil();

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
	static const luaL_Reg metatable[] = {
		{ "getWidth", &nbunny_l_buffer_get_width },
		{ "getHeight", &nbunny_l_buffer_get_height },
		{ "resize", &nbunny_l_buffer_resize },
		{ "release", &nbunny_l_buffer_release },
		{ "release", &nbunny_l_buffer_release },
		{ "getColor", &nbunny_l_buffer_get_color },
		{ "getDepthStencil", &nbunny_l_buffer_get_depth_stencil },
		{ "use", &nbunny_l_buffer_use },
		{ nullptr, nullptr }
	};
	
	nbunny::lua::register_type<nbunny::LBuffer>(L, &nbunny_l_buffer_constructor, metatable);

	return 1;
}
	