////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/decoration.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_DECORATION_HPP
#define NBUNNY_OPTIMAUS_DECORATION_HPP

#include <memory>
#include "modules/graphics/Mesh.h"
#include "nbunny/nbunny.hpp"
#include "nbunny/optimaus/resource.hpp"
#include "nbunny/optimaus/scene.hpp"
#include "nbunny/optimaus/static_mesh.hpp"

namespace nbunny
{
	struct DecorationFeature
	{
		std::string tile_id;
		glm::vec3 position = glm::vec3(0.0f);
		glm::quat rotation = glm::quat(1.0f, 0.0f, 0.0f, 0.0f);
		glm::vec3 scale = glm::vec3(1.0f);
		glm::vec4 color = glm::vec4(1.0f);

		DecorationFeature() = default;
		DecorationFeature(const DecorationFeature& other) = default;
	};

	class Decoration
	{
	private:
		std::vector<std::unique_ptr<DecorationFeature>> features;

	public:
		Decoration() = default;
		~Decoration() = default;

		DecorationFeature* add_feature(const DecorationFeature& description);
		bool remove_feature(DecorationFeature* feature);

		std::size_t get_num_features() const;
		DecorationFeature* get_feature_by_index(std::size_t index) const;
	};

	class DecorationSceneNode : public SceneNode
	{
	private:
		love::graphics::Mesh* mesh = nullptr;
		std::vector<love::graphics::Mesh::AttribFormat> mesh_attribs;

		struct Vertex
		{
			glm::vec3 position;
			glm::vec3 normal;
			glm::vec2 texture;
			glm::vec4 color;
		};

		enum
		{
			MIN_POSITION_COMPONENTS = 3,
			MIN_NORMAL_COMPONENTS = 3,
			MIN_TEXTURE_COMPONENTS = 2,
			MIN_COLOR_COMPONENTS = 4
		};

	public:
		static const Type<DecorationSceneNode> type_pointer;
		const BaseType& get_type() const override;

		DecorationSceneNode(int reference);
		virtual ~DecorationSceneNode();

		void from_decoration(Decoration& decoration, StaticMeshInstance& static_mesh);
		void from_group(const std::string& group, StaticMeshInstance& static_mesh);
		void from_lerp(
			StaticMeshInstance& static_mesh,
			const std::string& from,
			const std::string& to,
			float delta);

		bool can_lerp() const;

		static void lerp(
			DecorationSceneNode& result,
			DecorationSceneNode& from,
			DecorationSceneNode& to,
			float delta);

		void draw(Renderer& renderer, float delta) override;
	};
}

#endif
