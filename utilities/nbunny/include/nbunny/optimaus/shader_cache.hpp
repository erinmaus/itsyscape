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

#include <cstdint>
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
			std::string vertex_prologue;
			std::string pixel_prologue;

			inline ShaderSource(const std::string& vertex, const std::string& pixel, bool parse = false)
			{
				if (parse)
				{
					std::unordered_set<std::string> vertex_filenames;
					this->vertex = parse_pragmas(parse_includes(vertex, vertex_filenames), vertex_prologue);

					std::unordered_set<std::string> pixel_filenames;
					this->pixel = parse_pragmas(parse_includes(pixel, pixel_filenames), pixel_prologue);
				}
				else
				{
					this->vertex = vertex;
					this->pixel = pixel;
				}
			}

			void combine(
				const std::string& version,
				const std::string& base_vertex_source,
				const std::string& base_pixel_source,
				std::string& result_vertex_source,
				std::string& result_pixel_source);

		private:
			static std::string parse_includes(const std::string& source, std::unordered_set<std::string>& filenames);
			static std::string parse_pragmas(const std::string& source, std::string& prologue);
		};

	private:
		typedef std::unordered_map<int, love::graphics::Shader*> ShaderMap;
		typedef std::unordered_map<int, ShaderMap> CacheMap;

		typedef std::unordered_map<int, ShaderSource> BaseShadeSourceMap;

		typedef std::unordered_map<std::string, std::vector<std::uint8_t>> ShaderValueUniformsMap;
		typedef std::unordered_map<std::string, love::StrongRef<love::graphics::Texture>> ShaderTextureUniformsMap;
		typedef std::unordered_map<love::graphics::Shader*, ShaderValueUniformsMap> ShaderValues;
		typedef std::unordered_map<love::graphics::Shader*, ShaderTextureUniformsMap> ShaderTextures;

		CacheMap shader_cache;
		BaseShadeSourceMap shader_source;

		ShaderValues shader_value_uniforms;
		ShaderTextures shader_texture_uniforms;

	public:
		typedef std::function<void(
			const std::string& base_vertex_source, const std::string& base_pixel_source,
			std::string& vertex_source, std::string& pixel_source)> BuildFunc;
		ShaderCache() = default;
		ShaderCache(const ShaderCache& other) = delete;
		~ShaderCache();

		ShaderCache& operator =(const ShaderCache& other) = delete;

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

		love::graphics::Shader* get(int renderer_pass_id, int resource_id);

		void update_uniform(love::graphics::Shader* shader, const std::string& uniform_name, const std::vector<std::uint8_t>& data);
		void update_uniform(love::graphics::Shader* shader, const std::string& uniform_name, const void* data, std::size_t data_size);
		void update_uniform(love::graphics::Shader* shader, const std::string& uniform_name, love::graphics::Texture* texture);
	};
}

#endif
