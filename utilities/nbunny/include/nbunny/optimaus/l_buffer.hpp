////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/l_buffer.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_L_BUFFER
#define NBUNNY_OPTIMAUS_L_BUFFER

#include <memory>
#include "common/pixelformat.h"
#include "modules/graphics/Canvas.h"
#include "nbunny/optimaus/g_buffer.hpp"

namespace nbunny
{
	class LBuffer
	{
	private:
		love::PixelFormat color_pixel_format;
		love::graphics::Canvas* color = nullptr;
		GBuffer& g_buffer;

	public:
		LBuffer(
			love::PixelFormat color_pixel_format,
			GBuffer& g_buffer);
		~LBuffer();

		GBuffer& get_g_buffer();

		int get_width();
		int get_height();

		void release();

		void resize(GBuffer& g_buffer);

		love::graphics::Canvas* get_color();
		love::graphics::Canvas* get_depth_stencil();

		void use(bool include_depth = true);
	};
}

#endif
