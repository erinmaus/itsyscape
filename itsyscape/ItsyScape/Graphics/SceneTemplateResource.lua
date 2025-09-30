--------------------------------------------------------------------------------
-- ItsyScape/Graphics/SceneTemplate.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Resource = require "ItsyScape.Graphics.Resource"
local SceneTemplate = require "ItsyScape.Graphics.SceneTemplate"
local NResource = require "nbunny.optimaus.resource"

local SceneTemplateResource = Resource(NResource)

function SceneTemplateResource:new(scene)
	Resource.new(self)

	if scene then
		self.scene = scene
	else
		self.scene = false
	end
end

function SceneTemplateResource:getResource()
	return self.scene
end

function SceneTemplateResource:release()
	if self.scene then
		self.scene = false
	end
end

function SceneTemplateResource:loadFromFile(filename, resourceManager)
	self:release()

	local file = Resource.readLua(filename)
	self.scene = SceneTemplate(file)
end

function SceneTemplateResource:getIsReady()
	if self.scene then
		return true
	else
		return false
	end
end

return SceneTemplateResource
