////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/model_resource.hpp
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

#include "common/Data.h"
#include "modules/graphics/Mesh.h"
#include "nbunny/optimaus/resource.hpp"

namespace nbunny
{
    class ModelResourceInstance : public ResourceInstance
	{
	private:
		std::vector<love::graphics::Mesh::AttribFormat> model_attributes;
		std::vector<char> data_buffer;

    public:
        ModelResourceInstance(
			int reference,
			const std::vector<love::graphics::Mesh::AttribFormat>& attributes,
			const void* data,
			std::size_t data_size_bytes);
    };
}

#endif
