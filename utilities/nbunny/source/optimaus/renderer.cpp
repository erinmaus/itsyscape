////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/renderer.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "common/Module.h"
#include "common/Module.h"
#include "modules/graphics/Graphics.h"
#include "modules/filesystem/Filesystem.h"
#include "nbunny/optimaus/renderer.hpp"

nbunny::Renderer::Renderer(int reference) :
	reference(reference), camera(&default_camera)
{
	// Nothing.
}

void nbunny::Renderer::set_clear_color(const glm::vec4& value)
{
	clear_color = value;
}

const glm::vec4& nbunny::Renderer::get_clear_color() const
{
	return clear_color;
}

void nbunny::Renderer::set_camera(Camera& camera)
{
	this->camera = &camera;
}

nbunny::Camera& nbunny::Renderer::get_camera()
{
	return *(this->camera);
}

const nbunny::Camera& nbunny::Renderer::get_camera() const
{
	return *this->camera;
}

void nbunny::Renderer::set_current_shader(love::graphics::Shader* shader)
{
	if (shader != current_shader)
	{
		auto graphics = love::Module::getInstance<love::graphics::Graphics>(love::Module::M_GRAPHICS);
		graphics->setShader(shader);
		current_shader = shader;
	}
}

love::graphics::Shader* nbunny::Renderer::get_current_shader() const
{
	return current_shader;
}

nbunny::ShaderCache& nbunny::Renderer::get_shader_cache()
{
	return shader_cache;
}

const nbunny::ShaderCache& nbunny::Renderer::get_shader_cache() const
{
	return shader_cache;
}

void nbunny::Renderer::draw(lua_State* L, SceneNode& node, float delta, int width, int height)
{
	if (this->width != width || this->height != height)
	{
		this->width = width <= 0 ? 1 : width;
		this->height = height <= 0 ? 1 : height;

		for (auto& renderer_pass: renderer_passes)
		{
			renderer_pass->resize(width, height);
		}
	}

	for (auto& renderer_pass: renderer_passes)
	{
		renderer_pass->draw(L, node, delta);
	}
}

void nbunny::Renderer::draw_node(lua_State* L, SceneNode& node, float delta)
{
	if (!node.is_base_type())
	{
		// something
	}
}

nbunny::RendererPass::RendererPass(int renderer_pass_id) :
	renderer_pass_id(renderer_pass_id)
{
	// Nothing.
}

int nbunny::RendererPass::get_renderer_pass_id() const
{
	return renderer_pass_id;
}

nbunny::Renderer* nbunny::RendererPass::get_renderer()
{
	return renderer;
}

const nbunny::Renderer* nbunny::RendererPass::get_renderer() const
{
	return renderer;
}

void nbunny::RendererPass::attach(Renderer& renderer)
{
	this->renderer = &renderer;
}

void nbunny::RendererPass::load_builtin_shader(
	const std::string& vertex_filename,
	const std::string& pixel_filename)
{
	auto filesystem = love::Module::getInstance<love::filesystem::Filesystem>(love::Module::M_FILESYSTEM);

	auto vertex_file_data = filesystem->read(vertex_filename.c_str());
	auto pixel_file_data = filesystem->read(pixel_filename.c_str());

	std::string vertex_source(reinterpret_cast<const char*>(pixel_file_data->getData()), pixel_file_data->getSize());
	std::string pixel_source(reinterpret_cast<const char*>(pixel_file_data->getData()), pixel_file_data->getSize());

	get_renderer()->get_shader_cache().register_renderer_pass(
		get_renderer_pass_id(),
		vertex_source,
		pixel_source);
}
