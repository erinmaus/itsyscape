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

local ModelResource = Resource()

function ModelResource:new(skeleton, model)
	Resource.new(self)

	self.skeleton = skeleton or false
	self.model = model or false
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

function ModelResource:loadFromFile(filename, _, skeleton)
	self.model = Model(filename, skeleton or self.skeleton)
end

function ModelResource:getIsReady()
	if self.model then
		return true
	else
		return false
	end
end

return ModelResource
