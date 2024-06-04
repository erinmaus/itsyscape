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

#include <iostream>
#include <functional>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include "modules/graphics/Shader.h"

namespace nbunny
{
	class ShaderCache
	{
	public:
		struct ShaderSource
		{
			std::string vertex;
			std::string pixel;

			inline ShaderSource(const std::string& vertex, const std::string& pixel)
			{
				std::unordered_set<std::string> vertex_filenames;
				this->vertex = parse_includes(vertex, vertex_filenames);

				std::unordered_set<std::string> pixel_filenames;
				this->pixel = parse_includes(pixel, pixel_filenames);
			}

		private:
			static std::string parse_includes(const std::string& source, std::unordered_set<std::string>& filenames);
		};

	private:
		typedef std::unordered_map<int, love::graphics::Shader*> ShaderMap;
		typedef std::unordered_map<int, ShaderMap> CacheMap;

		typedef std::unordered_map<int, ShaderSource> BaseShadeSourceMap;

		CacheMap shader_cache;
		BaseShadeSourceMap shader_source;

	public:
		typedef std::function<void(
			const std::string& base_vertex_source, const std::string& base_pixel_source,
			std::string& vertex_source, std::string& pixel_source)> BuildFunc;
		ShaderCache() = default;
		~ShaderCache();

        bool get_is_mobile() const;

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
