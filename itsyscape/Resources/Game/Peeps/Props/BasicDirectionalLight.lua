--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicDirectionalLight.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local BasicLight = require "Resources.Game.Peeps.Props.BasicLight"

local BasicDirectionalLight = Class(BasicLight)

function BasicDirectionalLight:new(...)
	BasicLight.new(self, ...)

	self.direction = Vector(0, 0, 1)
end

function BasicDirectionalLight:ready(director, game)
	BasicLight.ready(self, director, game)

	local resource = Utility.Peep.getMapObject(self)
	if resource then
		local gameDB = director:getGameDB()
		local light = gameDB:getRecord("DirectionalLight", {
			Resource = resource
		})

		local x = light:get("DirectionX") or 0
		local y = light:get("DirectionY") or 0
		local z = light:get("DirectionZ") or 0

		if not (x == 0 and y == 0 and z == 0) then
			self.direction = Vector(x or 0, y or 0, z or 0)
		end
	end
end

function BasicDirectionalLight:getPropState()
	local result = BasicLight.getPropState(self)
	result.direction = { self.direction.x, self.direction.y, self.direction.z }

	return result
end

return BasicDirectionalLight
