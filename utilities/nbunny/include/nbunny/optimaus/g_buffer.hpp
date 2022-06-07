////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/g_buffer.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_G_BUFFER
#define NBUNNY_OPTIMAUS_G_BUFFER

#include <vector>
#include "common/pixelformat.h"
#include "modules/graphics/Canvas.h"

namespace nbunny
{
	class GBuffer
	{
	private:
		std::vector<love::PixelFormat> pixel_formats;
		std::vector<love::graphics::Canvas*> canvases;
		int width = 0, height = 0;

	public:
		GBuffer(const std::vector<love::PixelFormat>& formats);
		~GBuffer();

		int get_width() const;
		int get_height() const;

		void resize(int width, int height);
		void release();

		// First index (0) is the depth buffer
		// Index 1 and up are the canvases
		love::graphics::Canvas* get_canvas(int index);

		void use();
	};
}

#endif
