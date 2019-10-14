--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicAmbientLight.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local BasicLight = require "Resources.Game.Peeps.Props.BasicLight"

local BasicAmbientLight = Class(BasicLight)

function BasicAmbientLight:new(...)
	BasicLight.new(self, ...)

	self.ambience = 0.5
end

function BasicAmbientLight:getAmbience()
	return self.ambience
end

function BasicLight:setAmbience(value)
	self.ambience = value or self.ambience
end

function BasicAmbientLight:ready(director, game)
	BasicLight.ready(self, director, game)

	local resource = Utility.Peep.getMapObject(self)
	if resource then
		local gameDB = director:getGameDB()
		local light = gameDB:getRecord("AmbientLight", {
			Resource = resource
		})

		self.ambience = light:get("Ambience") or 0.5
	end
end

function BasicAmbientLight:getPropState()
	local result = BasicLight.getPropState(self)
	result.ambience = self.ambience

	return result
end

return BasicAmbientLight
