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
#include "nbunny/lua_runtime.hpp"
#include "nbunny/optimaus/g_buffer.hpp"

nbunny::GBuffer::GBuffer(const std::vector<love::PixelFormat>& pixel_formats)
{
	this->pixel_formats.push_back(love::PIXELFORMAT_DEPTH24);
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
	if (this->width == width && this->height == height)
	{
		return;
	}

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
		settings.readable = true;

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

int nbunny_g_buffer_constructor(lua_State* L)
{
	std::vector<love::PixelFormat> pixel_formats;

	for (int i = 2; i <= lua_gettop(L); ++i)
	{
		auto pixel_format_name = nbunny::lua::get<std::string>(L, i).c_str();

		love::PixelFormat pixel_format;
		if (!love::getConstant(pixel_format_name, pixel_format))
		{
			love::luax_enumerror(L, "pixel format", pixel_format_name);
		}

		pixel_formats.push_back(pixel_format);
	}
	
	nbunny::lua::push(L, std::make_shared<nbunny::GBuffer>(pixel_formats));

	return 1;
}

static int nbunny_g_buffer_get_width(lua_State* L)
{
	auto g_buffer = nbunny::lua::get<nbunny::GBuffer*>(L, 1);
	nbunny::lua::push(L, g_buffer->get_width());
	return 1;
}

static int nbunny_g_buffer_get_height(lua_State* L)
{
	auto g_buffer = nbunny::lua::get<nbunny::GBuffer*>(L, 1);
	nbunny::lua::push(L, g_buffer->get_height());
	return 1;
}

static int nbunny_g_buffer_resize(lua_State* L)
{
	auto g_buffer = nbunny::lua::get<nbunny::GBuffer*>(L, 1);
	auto width = luaL_optinteger(L, 2, 0);
	auto height = luaL_optinteger(L, 3, 0);
	
	g_buffer->resize(width, height);

	return 0;
}

static int nbunny_g_buffer_release(lua_State* L)
{
	auto g_buffer = nbunny::lua::get<nbunny::GBuffer*>(L, 1);
	g_buffer->release();
	return 0;
}

static int nbunny_g_buffer_use(lua_State* L)
{
	auto g_buffer = nbunny::lua::get<nbunny::GBuffer*>(L, 1);
	
	g_buffer->use();

	return 0;
}

static int nbunny_g_buffer_get_canvas(lua_State* L)
{
	auto g_buffer = nbunny::lua::get<nbunny::GBuffer*>(L, 1);
	auto index = luaL_checkinteger(L, 2);

	auto canvas = g_buffer->get_canvas(index);
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
	auto g_buffer = nbunny::lua::get<nbunny::GBuffer*>(L, 1);

	auto canvas = g_buffer->get_canvas(0);
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
	static const luaL_Reg metatable[] = {
		{ "getWidth", &nbunny_g_buffer_get_width },
		{ "getHeight", &nbunny_g_buffer_get_height },
		{ "resize", &nbunny_g_buffer_resize },
		{ "release", &nbunny_g_buffer_release },
		{ "release", &nbunny_g_buffer_release },
		{ "getCanvas", &nbunny_g_buffer_get_canvas },
		{ "getDepthStencil", &nbunny_g_buffer_get_depth_stencil },
		{ "use", &nbunny_g_buffer_use },
		{ nullptr, nullptr }
	};
	
	nbunny::lua::register_type<nbunny::GBuffer>(L, &nbunny_g_buffer_constructor, metatable);

	return 1;
}
