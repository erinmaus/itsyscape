--------------------------------------------------------------------------------
-- ItsyScape/Graphics/RendererPass.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"

-- Base renderer pass type. Manages logic for a specific pass.
local RendererPass = Class()

-- Constructs a new RendererPass, using the provided Renderer.
function RendererPass:new(renderer)
	self.renderer = renderer
	self.pixelSource = ""
	self.vertexSource = ""
	self.shaders = {}
end

-- Sets the base shader.
--
-- The base shader is combined with Material shaders to form a complete shader.
--
-- Material shaders are expected to have the following methods:
--
-- ```
-- // in the vertex shader
-- vec4 performTransform(mat4 modelViewProjectionMatrix, vec4 position, out vec3 worldPosition);
--
-- // in the pixel shader
-- vec4 performEffect(vec4 color, vec2 textureCoordinates);
-- ```
function RendererPass:setBaseShader(pixel, vertex)
	self.pixelSource = pixel or self.pixelSource
	self.vertexSource = vertex or self.vertexSource
end

-- Loads the base shader from a file.
--
-- See RendererPass.setBaseShader.
function RendererPass:loadBaseShaderFromFile(pixel, vertex)
	self:setBaseShader(
		love.filesystem.read(pixel),
		love.filesystem.read(vertex))
end

-- Gets the renderer this RendererPass belongs to.
function RendererPass:getRenderer()
	return self.renderer
end

-- Begins rendering. Called before RendererPass.draw.
function RendererPass:beginDraw(delta)
	-- Nothing.
end

-- Begins rendering. Called after RendererPass.draw.
function RendererPass:endDraw(delta)
	-- Nothing.
end

-- Actually performs rendering.
function RendererPass:draw(delta)
	-- Nothing.
end

-- Called before RendererPass.begin if the window was resized.
function RendererPass:resize(width, height)
	-- Nothing.
end

-- Uses the provided ShaderResource.
--
-- Generates a Shader from the provided ShaderResource, if necessary.
function RendererPass:useShader(shader)
	local s = self.renderer:getCachedShader(self:getType(), shader)
	if not s then
		local source = shader:getResource()
		local finalPixelSource = self.pixelSource .. source:getPixelSource()
		local finalVertexSource = self.vertexSource .. source:getVertexSource()

		s = self.renderer:addCachedShader(
			self:getType(), shader,
			finalPixelSource, finalVertexSource)
	end

	self.renderer:setCurrentShader(s)

	return shader
end

return RendererPass
