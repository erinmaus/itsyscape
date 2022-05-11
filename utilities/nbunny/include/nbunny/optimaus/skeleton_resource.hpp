////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/skeleton_resource.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_MODEL_RESOURCE_HPP
#define NBUNNY_OPTIMAUS_MODEL_RESOURCE_HPP

#include <string>
#include <unordered_map>
#include "nbunny/optimaus/resource.hpp"

namespace nbunny
{
	class SkeletonResource : public Resource
	{
	public:
		std::shared_ptr<ResourceInstance> instantiate(lua_State* L) override;
	};

	struct SkeletonBone
	{
		enum
		{
			NO_PARENT = -1,
			NO_INDEX  = -1
		};

		int parent_index = NO_PARENT;
		std::string parent_name;

		std::string name;
		int index = NO_INDEX;

		glm::mat4 inverse_bind_pose = glm::mat4(1.0f);
	};

	class SkeletonInstance : public ResourceInstance
	{
	private:
		std::vector<SkeletonBone> bones;
		std::unordered_map<std::string, int> bone_to_index;

    public:
		SkeletonInstance() = default;
		SkeletonInstance(int id, int reference);

		void add_bone(
			const std::string& name,
			const std::string& parent_name,
			const glm::mat4& inverse_bind_pose);

		const SkeletonBone& get_bone_by_index(int index) const;
		const SkeletonBone& get_bone_by_name(const std::string& name) const;
		int get_bone_index(const std::string& name);
		std::size_t get_num_bones() const;
		bool has_bone(const std::string& name);
	};
}

#endif
