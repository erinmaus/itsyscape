////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/static_mesh.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_STATIC_MESH_HPP
#define NBUNNY_OPTIMAUS_STATIC_MESH_HPP

#include <memory>
#include "common/Object.h"
#include "modules/graphics/Graphics.h"
#include "nbunny/nbunny.hpp"
#include "nbunny/optimaus/resource.hpp"

namespace nbunny
{
	class StaticMeshResource : public Resource
	{
	public:
		std::shared_ptr<ResourceInstance> instantiate(lua_State* L) override;
	};

	class StaticMeshInstance : public ResourceInstance
	{
	private:
		std::unordered_map<std::string, love::StrongRef<love::graphics::Mesh>> meshes;
		std::vector<std::string> groups;

	public:
		StaticMeshInstance() = default;
		StaticMeshInstance(int id, int reference);

		void set_mesh(const std::string& group, love::graphics::Mesh* mesh);
		love::graphics::Mesh* get_mesh(const std::string& group) const;
		bool has_mesh(const std::string& group) const;

		const std::vector<std::string>& get_mesh_groups() const;
	};
}

#endif
