////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/model.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_MODEL_HPP
#define NBUNNY_OPTIMAUS_MODEL_HPP

#include <memory>
#include "common/Object.h"
#include "modules/graphics/Mesh.h"
#include "nbunny/optimaus/resource.hpp"
#include "nbunny/optimaus/scene.hpp"
#include "nbunny/optimaus/skeleton_resource.hpp"

namespace nbunny
{
	class ModelResource : public Resource
	{
	public:
		std::shared_ptr<ResourceInstance> instantiate(lua_State* L) override;
	};

    class ModelInstance : public ResourceInstance
	{
	private:
		love::StrongRef<love::graphics::Mesh> mesh;
		std::unordered_map<int, love::StrongRef<love::graphics::Mesh>> per_pass_mesh;

    public:
		ModelInstance() = default;
        ModelInstance(int id, int reference);

		void set_mesh(love::graphics::Mesh* value);
		void set_per_pass_mesh(int renderer_pass_id, love::graphics::Mesh* value);

		love::graphics::Mesh* get_mesh() const;
		love::graphics::Mesh* get_per_pass_mesh(int renderer_pass_id) const;
    };

	class ModelSceneNode : public SceneNode
	{
	private:
		std::shared_ptr<ModelInstance> model;
		std::vector<glm::mat4> transforms;
		std::shared_ptr<SkeletonTransforms> skeleton_transforms;

	public:
		static const Type<ModelSceneNode> type_pointer;
		const BaseType& get_type() const override;

		ModelSceneNode(int reference);
		virtual ~ModelSceneNode() = default;

		void unset_model();
		void set_model(const std::shared_ptr<ModelInstance>& value);
		const std::shared_ptr<ModelInstance>& get_model() const;

		void set_transforms(const std::vector<glm::mat4>& value);
		void set_transforms(const std::shared_ptr<nbunny::SkeletonTransforms>& value);
		const std::vector<glm::mat4>& get_transforms() const;

		void draw(Renderer& renderer, float delta) override;
	};
}

#endif
