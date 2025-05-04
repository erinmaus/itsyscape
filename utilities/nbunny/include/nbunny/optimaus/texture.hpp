////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/texture.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_TEXTURE_HPP
#define NBUNNY_OPTIMAUS_TEXTURE_HPP

#include <map>
#include <memory>
#include "common/Object.h"
#include "modules/graphics/Texture.h"
#include "nbunny/optimaus/resource.hpp"

namespace nbunny
{
	class TextureResource : public Resource
	{
	public:
		std::shared_ptr<ResourceInstance> instantiate(lua_State* L) override;
	};

    class TextureInstance : public ResourceInstance
	{
	private:
		love::StrongRef<love::graphics::Texture> texture;
		std::map<int, love::StrongRef<love::graphics::Texture>> per_pass_textures;
		std::map<std::string, love::StrongRef<love::graphics::Texture>> bound_textures;

    public:
		TextureInstance() = default;
        TextureInstance(int id, int reference);

		void set_texture(love::graphics::Texture* value);
		void set_per_pass_texture(int pass_id, love::graphics::Texture* value);
		void set_bound_texture(const std::string& name, love::graphics::Texture* value);

		love::graphics::Texture* get_texture() const;
		love::graphics::Texture* get_per_pass_texture(int pass_id) const;
		love::graphics::Texture* get_bound_texture(const std::string& name) const;

		bool has_per_pass_texture(int pass_id) const;
		bool has_bound_texture(const std::string& name) const;
    };
}

#endif
