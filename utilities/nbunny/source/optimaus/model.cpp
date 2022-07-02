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
	sol::usertype<nbunny::ModelResource> T(
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

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_modelresourceinstance(lua_State* L)
{
	sol::usertype<nbunny::ModelInstance> T(
		sol::base_classes, sol::bases<nbunny::ResourceInstance>(),
		sol::call_constructor, sol::constructors<nbunny::ModelInstance()>(),
		"setMesh", &nbunny_model_instance_set_mesh,
		"getMesh", &nbunny_model_instance_get_mesh);

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
	if (!model || !model->get_mesh())
	{
		return;
	}

	auto shader = renderer.get_current_shader();

	auto bones_uniform = shader->getUniformInfo("scape_Bones");
	if (bones_uniform)
	{
		auto& t = get_transforms();
		std::memcpy(
			bones_uniform->floats,
			glm::value_ptr(t[0]),
			std::min(bones_uniform->dataSize, t.size() * sizeof(glm::mat4)));
		shader->updateUniform(bones_uniform, t.size());
	}

	const auto& textures = get_material().get_textures();
	auto diffuse_texture_uniform = shader->getUniformInfo("scape_DiffuseTexture");
	if (diffuse_texture_uniform && textures.size() >= 1)
	{
		auto texture = textures[0]->get_texture();
		if (texture)
		{
			shader->sendTextures(diffuse_texture_uniform, &texture, 1);
		}
	}

	auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);

	love::Matrix4 matrix(glm::value_ptr(get_transform().get_global(delta)));
	matrix.rotate(1, 0, 0, -LOVE_M_PI / 2);
	graphics->draw(model->get_mesh(), matrix);
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
	sol::usertype<nbunny::ModelSceneNode> T(
		sol::base_classes, sol::bases<nbunny::SceneNode>(),
		sol::call_constructor, sol::factories(&nbunny_scene_node_create<nbunny::ModelSceneNode>),
		"setModel", &nbunny_model_scene_node_set_model,
		"getModel", &nbunny_model_scene_node_get_model,
		"setTransforms", &nbunny_model_scene_node_set_transforms,
		"getTransforms", &nbunny_model_scene_node_get_transforms);

	sol::stack::push(L, T);

	return 1;
}
