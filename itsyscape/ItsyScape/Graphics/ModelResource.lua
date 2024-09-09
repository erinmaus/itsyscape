--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ShaderResource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Model = require "ItsyScape.Graphics.Model"
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local Resource = require "ItsyScape.Graphics.Resource"
local NModelResource = require "nbunny.optimaus.modelresource"
local NModelResourceInstance = require "nbunny.optimaus.modelresourceinstance"

local ModelResource = Resource(NModelResource)

ModelResource.PASSES = {
	["Deferred"] = RendererPass.PASS_DEFERRED,
	["Forward"] = RendererPass.PASS_FORWARD,
	["Mobile"] = RendererPass.PASS_MOBILE,
	["Outline"] = RendererPass.PASS_OUTLINE,
	["Reflection"] = RendererPass.PASS_REFLECTION,
	["Shadow"] = RendererPass.PASS_SHADOW
}

function ModelResource:new(model)
	Resource.new(self)

	self:setResource(model)
end

function ModelResource:getResource()
	return self.model
end

function ModelResource:release()
	if self.model then
		self.model:release()
		self.model = false
	end
end

function ModelResource:setResource(value)
	self:release()

	if value then
		self:getHandle():setMesh(value:getMesh())
	end

	self.model = value or false
end

function ModelResource:loadFromFile(filename, _, skeleton)
	local file = Resource.readLua(filename)
	self:setResource(Model(file, skeleton or self.skeleton))

	for passFilename, passID in pairs(self.PASSES) do
		local perPassModelFilename = filename:gsub(
			"(.*)(%..+)$",
			string.format("%%1@%s%%2", passFilename))

		if perPassModelFilename ~= filename and love.filesystem.getInfo(perPassModelFilename) then
			local perPassMesh = Resource.readLua(perPassModelFilename)
			local model = Model(perPassMesh, skeleton or self.skeleton)

			self:getHandle():setPerPassMesh(passID, model:getMesh())

			if coroutine.running() then
				coroutine.yield()
			end
		end
	end
end

function ModelResource:getIsReady()
	if self.model then
		return true
	else
		return false
	end
end

return ModelResource
