////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/shader_cache.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_SHADER_CACHE
#define NBUNNY_OPTIMAUS_SHADER_CACHE

#include <functional>
#include <string>
#include <unordered_map>
#include "modules/graphics/Shader.h"

namespace nbunny
{
	class ShaderCache
	{
	private:
		typedef std::unordered_map<int, love::graphics::Shader*> ShaderMap;
		typedef std::unordered_map<int, ShaderMap> CacheMap;

		struct ShaderSource
		{
			std::string vertex;
			std::string pixel;

			inline ShaderSource(const std::string& vertex, const std::string& pixel) :
				vertex(vertex), pixel(pixel)
			{
				// Nothing.
			}
		};

		typedef std::unordered_map<int, ShaderSource> BaseShadeSourceMap;

		CacheMap shader_cache;
		BaseShadeSourceMap shader_source;

	public:
		typedef std::function<void(
			const std::string& base_vertex_source, const std::string& base_pixel_source,
			std::string& vertex_source, std::string& pixel_source)> BuildFunc;
		ShaderCache() = default;
		~ShaderCache();

		void release();

		void register_renderer_pass(
			int renderer_pass_id,
			const std::string& vertex_source,
			const std::string& pixel_source);

		love::graphics::Shader* build(
			int renderer_pass_id,
			int resource_id,
			const BuildFunc& build_func);
	};
}

#endif
