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
local Resource = require "ItsyScape.Graphics.Resource"
local NModelResource = require "nbunny.optimaus.modelresource"
local NModelResourceInstance = require "nbunny.optimaus.modelresourceinstance"

local ModelResource = Resource(NModelResource)

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
end

function ModelResource:getIsReady()
	if self.model then
		return true
	else
		return false
	end
end

return ModelResource
