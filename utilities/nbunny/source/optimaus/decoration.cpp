////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/decoration.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include <algorithm>
#include "common/Module.h"
#include "modules/graphics/Graphics.h"
#include "nbunny/optimaus/decoration.hpp"
#include "nbunny/optimaus/renderer.hpp"

static int nbunny_decoration_feature_set_tile_id(lua_State* L)
{
	auto feature = nbunny::lua::get<nbunny::DecorationFeature*>(L, 1);
	feature->tile_id = luaL_checkstring(L, 2);
	return 0;
}

static int nbunny_decoration_feature_get_tile_id(lua_State* L)
{
	auto feature = nbunny::lua::get<nbunny::DecorationFeature*>(L, 1);
	lua_pushlstring(L, feature->tile_id.data(), feature->tile_id.size());
	return 1;
}

static int nbunny_decoration_feature_set_position(lua_State* L)
{
	auto feature = nbunny::lua::get<nbunny::DecorationFeature*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	feature->position = glm::vec3(x, y, z);
	return 0;
}

static int nbunny_decoration_feature_get_position(lua_State* L)
{
	auto feature = nbunny::lua::get<nbunny::DecorationFeature*>(L, 1);
	lua_pushnumber(L, feature->position.x);
	lua_pushnumber(L, feature->position.y);
	lua_pushnumber(L, feature->position.z);
	return 3;
}

static int nbunny_decoration_feature_set_rotation(lua_State* L)
{
	auto feature = nbunny::lua::get<nbunny::DecorationFeature*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	float w = (float)luaL_checknumber(L, 5);
	feature->rotation = glm::quat(w, x, y, z);
	return 0;
}

static int nbunny_decoration_feature_get_rotation(lua_State* L)
{
	auto feature = nbunny::lua::get<nbunny::DecorationFeature*>(L, 1);
	lua_pushnumber(L, feature->rotation.x);
	lua_pushnumber(L, feature->rotation.y);
	lua_pushnumber(L, feature->rotation.z);
	lua_pushnumber(L, feature->rotation.w);
	return 4;
}

static int nbunny_decoration_feature_set_scale(lua_State* L)
{
	auto feature = nbunny::lua::get<nbunny::DecorationFeature*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	feature->scale = glm::vec3(x, y, z);
	return 0;
}

static int nbunny_decoration_feature_get_scale(lua_State* L)
{
	auto feature = nbunny::lua::get<nbunny::DecorationFeature*>(L, 1);
	lua_pushnumber(L, feature->scale.x);
	lua_pushnumber(L, feature->scale.y);
	lua_pushnumber(L, feature->scale.z);
	return 3;
}

static int nbunny_decoration_feature_set_color(lua_State* L)
{
	auto feature = nbunny::lua::get<nbunny::DecorationFeature*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	float w = (float)luaL_checknumber(L, 5);
	feature->color = glm::vec4(x, y, z, w);
	return 0;
}

static int nbunny_decoration_feature_get_color(lua_State* L)
{
	auto feature = nbunny::lua::get<nbunny::DecorationFeature*>(L, 1);
	lua_pushnumber(L, feature->color.x);
	lua_pushnumber(L, feature->color.y);
	lua_pushnumber(L, feature->color.z);
	lua_pushnumber(L, feature->color.w);
	return 4;
}

static int nbunny_decoration_feature_set_texture(lua_State* L)
{
	auto feature = nbunny::lua::get<nbunny::DecorationFeature*>(L, 1);
	float texture = (float)luaL_checknumber(L, 2);
	feature->texture = texture;
	return 0;
}

static int nbunny_decoration_feature_get_texture(lua_State* L)
{
	auto feature = nbunny::lua::get<nbunny::DecorationFeature*>(L, 1);
	lua_pushnumber(L, feature->texture);
	return 1;
}

static int nbunny_decoration_feature_constructor(lua_State* L)
{
	nbunny::lua::push(L, std::make_shared<nbunny::DecorationFeature>());
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_decorationfeature(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "setID", &nbunny_decoration_feature_set_tile_id },
		{ "getID", &nbunny_decoration_feature_get_tile_id },
		{ "setPosition", &nbunny_decoration_feature_set_position },
		{ "getPosition", &nbunny_decoration_feature_get_position },
		{ "setRotation", &nbunny_decoration_feature_set_rotation },
 		{ "getRotation", &nbunny_decoration_feature_get_rotation },
		{ "setScale", &nbunny_decoration_feature_set_scale },
		{ "getScale", &nbunny_decoration_feature_get_scale },
		{ "setColor", &nbunny_decoration_feature_set_color },
		{ "getColor", &nbunny_decoration_feature_get_color },
		{ "setTexture", &nbunny_decoration_feature_set_texture },
		{ "getTexture", &nbunny_decoration_feature_get_texture },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_type<nbunny::DecorationFeature>(L, &nbunny_decoration_feature_constructor, metatable);

	return 1;
}

std::shared_ptr<nbunny::DecorationFeature> nbunny::Decoration::add_feature(const std::shared_ptr<DecorationFeature>& description)
{
	features.push_back(description);

	return features.back();
}

bool nbunny::Decoration::remove_feature(const std::shared_ptr<DecorationFeature>& feature)
{
	auto i = std::find_if(features.begin(), features.end(), [feature](auto& f)
	{
		return f == feature;
	});

	if (i != features.end())
	{
		features.erase(i);
		return true;
	}

	return false;
}

std::size_t nbunny::Decoration::get_num_features() const
{
	return features.size();
}

std::shared_ptr<nbunny::DecorationFeature> nbunny::Decoration::get_feature_by_index(std::size_t index) const
{
	return features.at(index);
}

static int nbunny_decoration_constructor(lua_State* L)
{
	nbunny::lua::push(L, std::make_shared<nbunny::Decoration>());
	return 1;
}

static int nbunny_decoration_add_feature(lua_State* L)
{
	auto self = nbunny::lua::get<nbunny::Decoration*>(L, 1);
	auto feature = nbunny::lua::get<nbunny::DecorationFeature>(L, 2);
	nbunny::lua::push(L, self->add_feature(feature));

	return 1;
}

static int nbunny_decoration_remove_feature(lua_State* L)
{
	auto self = nbunny::lua::get<nbunny::Decoration*>(L, 1);
	auto feature = nbunny::lua::get<nbunny::DecorationFeature>(L, 2);
	nbunny::lua::push(L, self->remove_feature(feature));
	return 1;
}

static int nbunny_decoration_get_num_features(lua_State* L)
{
	auto self = nbunny::lua::get<nbunny::Decoration*>(L, 1);
	nbunny::lua::push(L, self->get_num_features());
	return 1;
}

static int nbunny_decoration_get_feature_by_index(lua_State* L)
{
	auto self = nbunny::lua::get<nbunny::Decoration*>(L, 1);
	auto feature = self->get_feature_by_index(nbunny::lua::get<lua_Number>(L, 2));
	nbunny::lua::push(L, feature);
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_decoration(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "addFeature", &nbunny_decoration_add_feature },
		{ "removeFeature", &nbunny_decoration_remove_feature },
		{ "getNumFeatures", &nbunny_decoration_get_num_features },
		{ "getFeatureByIndex", &nbunny_decoration_get_feature_by_index },
		{ nullptr, nullptr }
	};
	
	nbunny::lua::register_type<nbunny::Decoration>(L, &nbunny_decoration_constructor, metatable);

	return 1;
}

const nbunny::Type<nbunny::DecorationSceneNode> nbunny::DecorationSceneNode::type_pointer;

const nbunny::BaseType& nbunny::DecorationSceneNode::get_type() const
{
	return type_pointer;
}

nbunny::DecorationSceneNode::DecorationSceneNode(int reference) :
	SceneNode(reference),
	mesh_attribs({
		{ "FeaturePosition", love::graphics::vertex::DATA_FLOAT, 3 },
		{ "FeatureRotation", love::graphics::vertex::DATA_FLOAT, 4 },
		{ "FeatureScale", love::graphics::vertex::DATA_FLOAT, 3 },
		{ "VertexPosition", love::graphics::vertex::DATA_FLOAT, 3 },
		{ "VertexNormal", love::graphics::vertex::DATA_FLOAT, 3 },
		{ "VertexTexture", love::graphics::vertex::DATA_FLOAT, 2 },
		{ "VertexLayer", love::graphics::vertex::DATA_FLOAT, 1 },
		{ "VertexColor", love::graphics::vertex::DATA_FLOAT, 4 },
	})
{
	// Nothing.
}

nbunny::DecorationSceneNode::~DecorationSceneNode()
{
	if (mesh)
	{
		mesh->release();
	}
}

static bool get_attrib(
	love::graphics::Mesh* mesh,
	const std::string& attrib_name,
	std::ptrdiff_t& attrib_offset, int& num_components)
{
	auto attribs = mesh->getVertexFormat();

	std::ptrdiff_t offset = 0;
	for (auto attrib: attribs)
	{
		if (attrib.name == attrib_name && attrib.type == love::graphics::vertex::DATA_FLOAT)
		{
			attrib_offset = offset;
			num_components = attrib.components;
			return true;
		}
		else
		{
			std::ptrdiff_t component_size;
			switch (attrib.type)
			{
				case love::graphics::vertex::DATA_UNORM8:
					component_size = 1;
					break;
				case love::graphics::vertex::DATA_UNORM16:
					component_size = 2;
					break;
				case love::graphics::vertex::DATA_FLOAT:
					component_size = 4;
					break;
				case love::graphics::vertex::DATA_MAX_ENUM:
				default:
					component_size = 0;
					break;
			}

			if (component_size == 0)
			{
				break;
			}

			offset += component_size * attrib.components;
		}
	}

	attrib_offset = 0;
	num_components = 0;
	return false;
}

void nbunny::DecorationSceneNode::from_decoration(Decoration& decoration, StaticMeshInstance& static_mesh)
{
	std::vector<Vertex> buffer;

	glm::vec3 max(-INFINITY);
	glm::vec3 min(INFINITY);

	for (std::size_t feature_index = 0; feature_index < decoration.get_num_features(); ++feature_index)
	{
		auto feature = decoration.get_feature_by_index(feature_index);

		if (!static_mesh.has_mesh(feature->tile_id))
		{
			continue;
		}

		auto static_mesh_group = static_mesh.get_mesh(feature->tile_id);
		auto data = static_mesh.get_mesh_data(feature->tile_id);

		auto translation = glm::translate(glm::mat4(1.0f), feature->position);
		auto rotation = glm::toMat4(feature->rotation);
		auto scale = glm::scale(glm::mat4(1.0f), feature->scale);

		auto transform = translation * scale * rotation;
		auto inverseTransform = glm::inverse(glm::transpose(transform));

		std::ptrdiff_t position_offset, normal_offset, texture_offset, color_offset;
		int position_num_components, normal_num_components, texture_num_components, color_num_components;

		bool has_position = get_attrib(static_mesh_group, "VertexPosition", position_offset, position_num_components);
		bool has_normal = get_attrib(static_mesh_group, "VertexNormal", normal_offset, normal_num_components);
		bool has_texture = get_attrib(static_mesh_group, "VertexTexture", texture_offset, texture_num_components);
		bool has_color = get_attrib(static_mesh_group, "VertexColor", color_offset, color_num_components);

		if ((!has_position || position_num_components < MIN_POSITION_COMPONENTS) ||
			(!has_normal || normal_num_components < MIN_NORMAL_COMPONENTS) ||
			(!has_texture || texture_num_components < MIN_TEXTURE_COMPONENTS) ||
			// This isn't a typo - color is optional, but if color is present,
			// it must at least have MIN_COLOR_COMPONENTS
			(has_color && color_num_components < MIN_COLOR_COMPONENTS))
		{
			continue;
		}

		auto start_index = buffer.size();
		buffer.resize(buffer.size() + static_mesh_group->getVertexCount());

		for (std::size_t vertex_index = 0; vertex_index < static_mesh_group->getVertexCount(); ++vertex_index)
		{
			auto input_vertex = data + static_mesh_group->getVertexStride() * vertex_index;
			auto& output_vertex = buffer.at(start_index + vertex_index);

			output_vertex.feature_position = feature->position;
			output_vertex.feature_rotation = feature->rotation;
			output_vertex.feature_scale = feature->scale;

			auto input_position = *(const glm::vec3*) (input_vertex + position_offset);
			input_position = glm::vec3(transform * glm::vec4(input_position, 1.0f));
			output_vertex.position = input_position;

			auto input_normal = *(const glm::vec3*) (input_vertex + normal_offset);
			input_normal = glm::vec3(inverseTransform * glm::vec4(input_normal, 1.0f));
			input_normal = glm::normalize(input_normal);
			output_vertex.normal = input_normal;

			auto input_texture = *(const glm::vec2*) (input_vertex + texture_offset);
			output_vertex.texture = input_texture;
			output_vertex.layer = feature->texture;

			auto input_color = feature->color;
			if (has_color)
			{
				input_color *= *(const glm::vec4*) (input_vertex + color_offset);
			}
			output_vertex.color = input_color;

			min = glm::min(min, output_vertex.position);
			max = glm::max(max, output_vertex.position);
		}
	}

	set_min(min);
	set_max(max);

	if (mesh)
	{
		mesh->release();
	}

	if (buffer.size() > 0)
	{
		auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
		mesh = graphics->newMesh(
			mesh_attribs,
			&buffer[0],
			sizeof(Vertex) * buffer.size(),
			love::graphics::PRIMITIVE_TRIANGLES,
			love::graphics::vertex::USAGE_STATIC);

		for (auto mesh_attrib: mesh_attribs)
		{
			mesh->setAttributeEnabled(mesh_attrib.name, true);
		}

		mesh->flush();
	}
}

void nbunny::DecorationSceneNode::from_group(const std::string& group, StaticMeshInstance& static_mesh)
{
	Decoration decoration;
	DecorationFeature feature;
	feature.tile_id = group;

	decoration.add_feature(std::make_shared<DecorationFeature>(feature));

	from_decoration(decoration, static_mesh);
}

void nbunny::DecorationSceneNode::from_lerp(
	StaticMeshInstance& static_mesh,
	const std::string& from,
	const std::string& to,
	float delta)
{
	DecorationSceneNode a(0);
	DecorationSceneNode b(0);

	a.from_group(from, static_mesh);
	b.from_group(to, static_mesh);

	lerp(*this, a, b, delta);
}

bool nbunny::DecorationSceneNode::can_lerp() const
{
	return mesh != nullptr;
}

void nbunny::DecorationSceneNode::lerp(
	DecorationSceneNode& result,
	DecorationSceneNode& from,
	DecorationSceneNode& to,
	float delta)
{
	if (!from.can_lerp() || !to.can_lerp())
	{
		return;
	}

	if (from.mesh->getVertexCount() != to.mesh->getVertexCount())
	{
		return;
	}

	if (from.mesh->getVertexCount() == 0 || to.mesh->getVertexCount() == 0)
	{
		return;
	}

	std::size_t num_vertices = from.mesh->getVertexCount();

	std::vector<Vertex> buffer;
	buffer.resize(num_vertices);

	auto from_vertices = (const Vertex*)from.mesh->mapVertexData();
	auto to_vertices = (const Vertex*)to.mesh->mapVertexData();

	for (std::size_t i = 0; i < num_vertices; ++i)
	{
		auto from_vertex = from_vertices[i];
		auto to_vertex = to_vertices[i];

		auto output_vertex = buffer[i];
		output_vertex.position = glm::mix(from_vertex.position, to_vertex.position, delta);
		output_vertex.normal = glm::normalize(glm::mix(from_vertex.normal, to_vertex.normal, delta));
		output_vertex.texture = glm::mix(from_vertex.texture, to_vertex.texture, delta);
		output_vertex.color = glm::mix(from_vertex.color, to_vertex.color, delta);
	}

	from.mesh->unmapVertexData(0, 0);
	to.mesh->unmapVertexData(0, 0);

	if (!result.mesh || result.mesh->getVertexCount() != num_vertices)
	{
		if (result.mesh)
		{
			result.mesh->release();
		}

		auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
		result.mesh = graphics->newMesh(
			result.mesh_attribs,
			&buffer[0],
			sizeof(Vertex) * buffer.size(),
			love::graphics::PRIMITIVE_TRIANGLES,
			love::graphics::vertex::USAGE_STREAM);

		for (auto mesh_attrib: result.mesh_attribs)
		{
			result.mesh->setAttributeEnabled(mesh_attrib.name, true);
		}
	}
	else
	{
		auto p = result.mesh->mapVertexData();
		std::memcpy(p, &buffer[0], sizeof(Vertex) * buffer.size());
		result.mesh->unmapVertexData();
	}

	result.set_min(glm::mix(from.get_min(), to.get_min(), delta));
	result.set_max(glm::mix(from.get_max(), to.get_max(), delta));

	result.mesh->flush();
}

void nbunny::DecorationSceneNode::draw(Renderer& renderer, float delta)
{
	if (!mesh)
	{
		return;
	}

	auto shader = renderer.get_current_shader();
	auto& shader_cache = renderer.get_shader_cache();

	const auto textures = get_material().get_textures();
	if (!textures.empty())
	{
		auto texture = textures.at(0);
		shader_cache.update_uniform(shader, "scape_DiffuseTexture", texture->get_per_pass_texture(renderer.get_current_pass_id()));

		auto specular_bound_texture = texture->get_bound_texture("Specular");
		shader_cache.update_uniform(shader, "scape_SpecularTexture", specular_bound_texture);

		auto heightmap_bound_texture = texture->get_bound_texture("Heightmap");
		shader_cache.update_uniform(shader, "scape_HeightmapTexture", heightmap_bound_texture);
	}
	else
	{
		shader_cache.update_uniform(shader, "scape_DiffuseTexture", nullptr);
		shader_cache.update_uniform(shader, "scape_SpecularTexture", nullptr);
		shader_cache.update_uniform(shader, "scape_HeightmapTexture", nullptr);
	}

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
	love::Matrix4 matrix(glm::value_ptr(get_transform().get_global(delta)));
	graphics->draw(mesh, matrix);
}

static int nbunny_decoration_scene_node_from_decoration(lua_State* L)
{
	auto self = nbunny::lua::get<nbunny::DecorationSceneNode*>(L, 1);
	auto decoration = nbunny::lua::get<nbunny::Decoration*>(L, 2);
	auto static_mesh = nbunny::lua::get<nbunny::StaticMeshInstance*>(L, 3);

	self->from_decoration(*decoration, *static_mesh);

	return 0;
}

static int nbunny_decoration_scene_node_from_group(lua_State* L)
{
	auto self = nbunny::lua::get<nbunny::DecorationSceneNode*>(L, 1);
	auto group = nbunny::lua::get<std::string>(L, 2);
	auto static_mesh = nbunny::lua::get<nbunny::StaticMeshInstance*>(L, 3);

	self->from_group(group, *static_mesh);

	return 0;
}

static int nbunny_decoration_scene_node_from_lerp(lua_State* L)
{
	auto self = nbunny::lua::get<nbunny::DecorationSceneNode*>(L, 1);
	auto static_mesh = nbunny::lua::get<nbunny::StaticMeshInstance*>(L, 2);
	auto from_group = nbunny::lua::get<std::string>(L, 3);
	auto to_group = nbunny::lua::get<std::string>(L, 4);
	auto delta = nbunny::lua::get<lua_Number>(L, 5);

	self->from_lerp(*static_mesh, from_group, to_group, delta);

	return 0;
}

static int nbunny_decoration_scene_node_can_lerp(lua_State* L)
{
	auto self = nbunny::lua::get<nbunny::DecorationSceneNode*>(L, 1);
	
	nbunny::lua::push(L, self->can_lerp());
	
	return 1;
}

static int nbunny_decoration_scene_node_lerp(lua_State* L)
{
	auto self = nbunny::lua::get<nbunny::DecorationSceneNode*>(L, 1);
	auto from = nbunny::lua::get<nbunny::DecorationSceneNode*>(L, 2);
	auto to = nbunny::lua::get<nbunny::DecorationSceneNode*>(L, 3);
	auto delta = nbunny::lua::get<lua_Number>(L, 4);

	nbunny::DecorationSceneNode::lerp(*self, *from, *to, delta);

	return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_scenenode_decorationscenenode(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "fromDecoration", &nbunny_decoration_scene_node_from_decoration },
		{ "fromGroup", &nbunny_decoration_scene_node_from_group },
		{ "fromLerp", &nbunny_decoration_scene_node_from_lerp },
		{ "canLerp", &nbunny_decoration_scene_node_can_lerp },
		{ "lerp", &nbunny_decoration_scene_node_lerp },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_child_type<nbunny::DecorationSceneNode, nbunny::SceneNode>(L, &nbunny_scene_node_constructor<nbunny::DecorationSceneNode>, metatable);

	return 1;
}
