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

#include "common/Object.h"
#include "modules/graphics/Mesh.h"
#include "nbunny/optimaus/resource.hpp"

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

    public:
		ModelInstance() = default;
        ModelInstance(int id, int reference);

		void setMesh(love::graphics::Mesh* value);
		love::graphics::Mesh* getMesh() const;
    };
}

#endif
