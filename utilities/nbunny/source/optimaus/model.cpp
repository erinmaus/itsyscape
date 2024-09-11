////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/model.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "common/Module.h"
#include "common/runtime.h"
#include "modules/graphics/Graphics.h"
#include "modules/math/MathModule.h"
#include "nbunny/optimaus/common.hpp"
#include "nbunny/optimaus/model.hpp"
#include "nbunny/optimaus/renderer.hpp"

std::shared_ptr<nbunny::ResourceInstance> nbunny::ModelResource::instantiate(lua_State* L)
{
	return std::make_shared<nbunny::ModelInstance>(allocate_id(), set_weak_reference((L)));
}

static int nbunny_model_resource_instantiate(lua_State* L)
{
	auto& resource = sol::stack::get<nbunny::ModelResource&>(L, 1);
	lua_pushvalue(L, 2);
	auto instance = resource.instantiate(L);
	sol::stack::push(L, std::reinterpret_pointer_cast<nbunny::ModelInstance>(instance));
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_modelresource(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::ModelResource>("NModelResource",
		sol::base_classes, sol::bases<nbunny::Resource>(),
		sol::call_constructor, sol::factories(&nbunny_resource_create<nbunny::ModelResource>),
		"instantiate", &nbunny_model_resource_instantiate);

	sol::stack::push(L, T);

	return 1;
}

nbunny::ModelInstance::ModelInstance(int id, int reference) :
	ResourceInstance(id, reference)
{
	// Nothing.
}

void nbunny::ModelInstance::set_mesh(love::graphics::Mesh* value)
{
	mesh.set(value);
}


love::graphics::Mesh* nbunny::ModelInstance::get_mesh() const
{
	return mesh.get();
}

love::graphics::Mesh* nbunny::ModelInstance::get_per_pass_mesh(int renderer_pass_id) const
{
	auto result = per_pass_mesh.find(renderer_pass_id);
	if (result != per_pass_mesh.end())
	{
		return result->second.get();
	}

	return mesh.get();
}

void nbunny::ModelInstance::set_per_pass_mesh(int renderer_pass_id, love::graphics::Mesh* value)
{
	if (value == nullptr)
	{
		per_pass_mesh.erase(renderer_pass_id);
	}
	else
	{
		per_pass_mesh.insert_or_assign(renderer_pass_id, value);
	}
}

void nbunny::ModelInstance::set_lod_mesh(float screen_size_percent, love::graphics::Mesh* value)
{
	if (value == nullptr)
	{
		lod_mesh.erase(screen_size_percent);
	}
	else
	{
		lod_mesh.insert_or_assign(screen_size_percent, value);
	}
}

bool nbunny::ModelInstance::has_per_pass_mesh(int renderer_pass_id) const
{
	return per_pass_mesh.find(renderer_pass_id) != per_pass_mesh.end();
}

love::graphics::Mesh* nbunny::ModelInstance::get_lod_mesh(float screen_size_percent) const
{
	auto lower_bound = lod_mesh.lower_bound(screen_size_percent);
	if (lower_bound != lod_mesh.end())
	{
		return lower_bound->second.get();
	}

	return mesh.get();
}

static int nbunny_model_instance_set_mesh(lua_State* L)
{
	auto& model = sol::stack::get<nbunny::ModelInstance&>(L, 1);
	if (lua_isnil(L, 2))
	{
		model.set_mesh(nullptr);
	}
	else
	{
		auto mesh = love::luax_checktype<love::graphics::Mesh>(L, 2);
		model.set_mesh(mesh);
	}
	return 0;
}

static int nbunny_model_instance_set_per_pass_mesh(lua_State* L)
{
	auto& model = sol::stack::get<nbunny::ModelInstance&>(L, 1);
	int renderer_pass_id = luaL_checkinteger(L, 2);

	if (lua_isnil(L, 2))
	{
		model.set_per_pass_mesh(renderer_pass_id, nullptr);
	}
	else
	{
		auto mesh = love::luax_checktype<love::graphics::Mesh>(L, 3);
		model.set_per_pass_mesh(renderer_pass_id, mesh);
	}
	return 0;
}

static int nbunny_model_instance_set_lod_mesh(lua_State* L)
{
	auto& model = sol::stack::get<nbunny::ModelInstance&>(L, 1);
	auto screen_size_percent = luaL_checknumber(L, 2);

	if (lua_isnil(L, 2))
	{
		model.set_lod_mesh(screen_size_percent, nullptr);
	}
	else
	{
		auto mesh = love::luax_checktype<love::graphics::Mesh>(L, 3);
		model.set_lod_mesh(screen_size_percent, mesh);
	}
	return 0;
}

static int nbunny_model_instance_get_mesh(lua_State* L)
{
	auto& model = sol::stack::get<nbunny::ModelInstance&>(L, 1);
	auto mesh = model.get_mesh();
	if (mesh == nullptr)
	{
		lua_pushnil(L);
	}
	else
	{
		love::luax_pushtype(L, model.get_mesh());
	}

	return 1;
}

static int nbunny_model_instance_get_per_pass_mesh(lua_State* L)
{
	auto& model = sol::stack::get<nbunny::ModelInstance&>(L, 1);
	int renderer_pass_id = luaL_checkinteger(L, 2);

	auto mesh = model.get_per_pass_mesh(renderer_pass_id);
	if (mesh == nullptr)
	{
		lua_pushnil(L);
	}
	else
	{
		love::luax_pushtype(L, mesh);
	}

	return 1;
}

static int nbunny_model_instance_get_lod_mesh(lua_State* L)
{
	auto& model = sol::stack::get<nbunny::ModelInstance&>(L, 1);
	auto screen_size_percent = luaL_checknumber(L, 2);

	auto mesh = model.get_lod_mesh(screen_size_percent);
	if (mesh == nullptr)
	{
		lua_pushnil(L);
	}
	else
	{
		love::luax_pushtype(L, mesh);
	}

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_modelresourceinstance(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::ModelInstance>("NModelInstance",
		sol::base_classes, sol::bases<nbunny::ResourceInstance>(),
		sol::call_constructor, sol::constructors<nbunny::ModelInstance()>(),
		"setMesh", &nbunny_model_instance_set_mesh,
		"getMesh", &nbunny_model_instance_get_mesh,
		"setPerPassMesh", &nbunny_model_instance_set_per_pass_mesh,
		"getPerPassMesh", &nbunny_model_instance_get_per_pass_mesh,
		"setLODMesh", &nbunny_model_instance_set_lod_mesh,
		"getLODMesh", &nbunny_model_instance_get_lod_mesh);

	sol::stack::push(L, T);

	return 1;
}

const nbunny::Type<nbunny::ModelSceneNode> nbunny::ModelSceneNode::type_pointer;

const nbunny::BaseType& nbunny::ModelSceneNode::get_type() const
{
	return type_pointer;
}

nbunny::ModelSceneNode::ModelSceneNode(int reference) :
	SceneNode(reference)
{
	// Nothing.
}

void nbunny::ModelSceneNode::unset_model()
{
	model.reset();
}

void nbunny::ModelSceneNode::set_model(const std::shared_ptr<ModelInstance>& value)
{
	model = value;
}

const std::shared_ptr<nbunny::ModelInstance>& nbunny::ModelSceneNode::get_model() const
{
	return model;
}

void nbunny::ModelSceneNode::set_transforms(const std::vector<glm::mat4>& value)
{
	transforms = value;
}

void nbunny::ModelSceneNode::set_transforms(const std::shared_ptr<nbunny::SkeletonTransforms>& value)
{
	skeleton_transforms = value;
}

const std::vector<glm::mat4>& nbunny::ModelSceneNode::get_transforms() const
{
	if (skeleton_transforms)
	{
		return skeleton_transforms->get_transforms();
	}

	return transforms;
}

void nbunny::ModelSceneNode::draw(Renderer& renderer, float delta)
{
	if (!model || (!model->has_per_pass_mesh(renderer.get_current_pass_id()) && !model->get_mesh()))
	{
		return;
	}

	auto shader = renderer.get_current_shader();
	auto& shader_cache = renderer.get_shader_cache();

	auto& transforms = get_transforms();
	shader_cache.update_uniform(shader, "scape_Bones", glm::value_ptr(transforms[0]), transforms.size() * sizeof(glm::mat4));

	const auto& textures = get_material().get_textures();
	if (!textures.empty())
	{
		auto texture = textures.at(0);
		shader_cache.update_uniform(shader, "scape_DiffuseTexture", texture->get_per_pass_texture(renderer.get_current_pass_id()));

		auto specular_bound_texture = texture->get_bound_texture("Specular");
		shader_cache.update_uniform(shader, "scape_SpecularTexture", specular_bound_texture);

		auto heightmap_bound_texture = texture->get_bound_texture("Specular");
		shader_cache.update_uniform(shader, "scape_HeightmapTexture", heightmap_bound_texture);
	}
	else
	{
		shader_cache.update_uniform(shader, "scape_DiffuseTexture", nullptr);
		shader_cache.update_uniform(shader, "scape_SpecularTexture", nullptr);
		shader_cache.update_uniform(shader, "scape_HeightmapTexture", nullptr);
	}

	// This was a dumb decision a while back.
	// 3D skinned models assume a specific rotation before rendering.
	// Override the default scape_World etc with this rotated value.
	auto world_matrix = glm::rotate(get_transform().get_global(delta), (float)-LOVE_M_PI / 2.0f, glm::vec3(1, 0, 0));
	shader_cache.update_uniform(shader, "scape_WorldMatrix", glm::value_ptr(world_matrix), sizeof(glm::mat4));

	auto normal_matrix = glm::inverse(glm::transpose(world_matrix));
	shader_cache.update_uniform(shader, "scape_NormalMatrix", glm::value_ptr(normal_matrix), sizeof(glm::mat4));

	love::graphics::Mesh* mesh = nullptr;
	if (model->has_per_pass_mesh(renderer.get_current_pass_id()))
	{
		mesh = model->get_per_pass_mesh(renderer.get_current_pass_id());
	}
	else
	{
		mesh = model->get_lod_mesh(calculate_screen_size_percent(renderer.get_camera(), delta));
	}

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	love::Matrix4 matrix(glm::value_ptr(get_transform().get_global(delta)));
	matrix.rotate(1, 0, 0, -LOVE_M_PI / 2);
	graphics->draw(model->get_per_pass_mesh(renderer.get_current_pass_id()), matrix);
}

static int nbunny_model_scene_node_set_model(lua_State* L)
{
	auto& node = sol::stack::get<nbunny::ModelSceneNode&>(L, 1);
	if (lua_isnil(L, 2))
	{
		node.unset_model();
	}
	else
	{
		node.set_model(sol::stack::get<std::shared_ptr<nbunny::ModelInstance>>(L, 2));
	}
	return 0;
}

static int nbunny_model_scene_node_get_model(lua_State* L)
{
	auto& node = sol::stack::get<nbunny::ModelSceneNode&>(L, 1);
	const auto& model = node.get_model();
	if (!model)
	{
		lua_pushnil(L);
	}
	else
	{
		sol::stack::push(L, model);
	}
	return 1;
}

static int nbunny_model_scene_node_set_transforms(lua_State* L)
{
	auto& node = sol::stack::get<nbunny::ModelSceneNode&>(L, 1);

	if (lua_istable(L, 2))
	{
		std::size_t length = lua_objlen(L, 2);

		std::vector<glm::mat4> transforms;
		for (std::size_t i = 1; i <= length; ++i) {
			lua_rawgeti(L, 2, i);

			auto transform = love::luax_checktype<love::math::Transform>(L, -1);
			transforms.push_back(glm::make_mat4(transform->getMatrix().getElements()));

			lua_pop(L, 1);
		}

		node.set_transforms(transforms);
	}
	else
	{
		node.set_transforms(sol::stack::get<std::shared_ptr<nbunny::SkeletonTransforms>>(L, 2));
	}

	return 0;
}

static int nbunny_model_scene_node_get_transforms(lua_State* L)
{
	auto& node = sol::stack::get<nbunny::ModelSceneNode&>(L, 1);
	auto& transforms = node.get_transforms();

	lua_createtable(L, transforms.size(), 0);
	int index = 1;
	for (auto& transform: transforms)
	{
		auto t = love::math::Math::instance.newTransform();
		t->setMatrix(love::Matrix4(glm::value_ptr(transform)));

		love::luax_pushtype(L, t);
		lua_rawseti(L, -2, index);

		++index;
	}

	lua_pushnumber(L, index);

	return 2;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_scenenode_modelscenenode(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::ModelSceneNode>("NModelSceneNode",
		sol::base_classes, sol::bases<nbunny::SceneNode>(),
		sol::call_constructor, sol::factories(&nbunny_scene_node_create<nbunny::ModelSceneNode>),
		"setModel", &nbunny_model_scene_node_set_model,
		"getModel", &nbunny_model_scene_node_get_model,
		"setTransforms", &nbunny_model_scene_node_set_transforms,
		"getTransforms", &nbunny_model_scene_node_get_transforms);

	sol::stack::push(L, T);

	return 1;
}
