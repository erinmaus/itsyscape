--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ShaderResource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Resource = require "ItsyScape.Graphics.Resource"

-- Basic ShaderResource resource class.
--
-- This object can be sorted by values returned by getID.
local ShaderResource = Resource()

ShaderResource.Source = Class()
function ShaderResource.Source:new(pixel, vertex)
	self.pixel = pixel
	self.vertex = vertex
end

function ShaderResource.Source:getPixelSource()
	return self.pixel
end

function ShaderResource.Source:getVertexSource()
	return self.vertex
end

-- Constructs a new shader from the provided pixel and vertex shaders.
function ShaderResource:new(pixel, vertex)
	Resource.new(self)

	if pixel and vertex then
		self.shader = ShaderResource.Source(pixel, vertex)
	else
		self.shader = false
	end
end

-- Gets the underlying shader source, as a ShaderResource.Source object.
function ShaderResource:getResource()
	return self.shader
end

-- Releases the underlying shader.
--
-- Since a ShaderResource allocates no GPU resources, this doesn't do much.
function ShaderResource:release()
	self.shader = false
end

-- Loads the resource from the file.
--
-- A shader is composed of two files: a fragment (pixel) shader and a vertex
-- shader. 'filename' is expected to be the name of the shader without
-- extensions.
--
-- Two files are expected to exist:
--  * `filename .. ".frag.glsl"` (pixel shader)
--  * `filename .. ".vert.glsl"` (vertex shader)
--
-- For example, "Resources/Shaders/SkinnedModel" would load the two shaders:
--  * Resources/Shaders/SkinnedModel.frag.glsl
--  * Resources/Shaders/SkinnedModel.vert.glsl
function ShaderResource:loadFromFile(filename)
	local pixelFilename = filename .. ".frag.glsl"
	local vertexFilename = filename .. ".vert.glsl"

	self:release()

	self.shader = ShaderResource.Source(
		love.filesystem.read(pixelFilename),
		love.filesystem.read(vertexFilename))
end

function ShaderResource:getIsReady()
	if self.shader then
		return true
	else
		return false
	end
end

return ShaderResource
