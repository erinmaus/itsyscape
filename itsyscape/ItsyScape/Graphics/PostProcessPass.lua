--------------------------------------------------------------------------------
-- ItsyScape/Graphics/PostProcessPass.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local NShaderCache = require "nbunny.optimaus.shadercache"

local PostProcessPass = Class()
local DEFAULT_VERTEX_SHADER_SOURCE = [[
	vec4 position(mat4 modelViewProjection, vec4 localPosition)
	{
		return modelViewProjection * localPosition;
	}
]]

local currentID = 0
function PostProcessPass.newID()
	currentID = currentID + 1
	return currentID
end

function PostProcessPass:new(renderer, id)
	self.renderer = renderer
	self.id = id or self.ID or PostProcessPass.newID()
	self.shaders = {}
end

function PostProcessPass:load(resources)
	self.resources = resources
	self.shaderCache = NShaderCache()
	self.shaderCache:registerRendererPass(self:getID(), "", "")
end

function PostProcessPass:_loadShader(filename)
	if self.shaders[filename] then
		return self.shaders[filename]
	end

	local shaderResource = self.resources:load(ShaderResource, filename)
	local shaderSource = shaderResource:getResource()

	local fragmentSource = shaderSource:getPixelSource()
	local vertexSource = shaderSource:getVertexSource()
	if #vertexSource == 0 then
		vertexSource = DEFAULT_VERTEX_SHADER_SOURCE
	end

	local success, result = pcall(self.shaderCache.buildComposite, self.shaderCache, self:getID(), shaderResource:getHandle(), vertexSource, fragmentSource)
	if not success then
		Log.warn("Couldn't build shader '%s'!", filename)
		error(result, 2)
	end

	if coroutine.running() then
		coroutine.yield()
	end

	return result
end

function PostProcessPass:loadPostProcessShader(filename)
	local postProcessFilename = string.format("Resources/Renderers/PostProcess/%s", filename)
	return self:_loadShader(postProcessFilename)
end

function PostProcessPass:loadShader(filename)
	return self:_loadShader(filename)
end

function PostProcessPass:_bindShader(shader, uniform, value, ...)
	if uniform and value then
		if shader:hasUniform(uniform) then
			shader:send(uniform, value)
		end

		self:_bindShader(shader, ...)
	end
end

function PostProcessPass:bindShader(shader, ...)
	if love.graphics.getShader() ~= shader then
		love.graphics.setShader(shader)
	end

	self:_bindShader(shader, ...)
end

function PostProcessPass:getID()
	return self.id
end

function PostProcessPass:getResources()
	return self.resources
end

function PostProcessPass:getRenderer()
	return self.renderer
end

function PostProcessPass:draw(width, height)
	-- Nothing.
end

return PostProcessPass
