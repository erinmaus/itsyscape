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
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

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

		local shadow = gameDB:getRecord("ShadowCastingDirectionalLight", {
			Resource = resource
		})

		local min, max
		if not shadow then
			local map = Utility.Peep.getMap(self)
			min = Vector(0, -1000, 0)
			max = Vector(map:getWidth() * map:getCellSize(), 1000, map:getHeight() * map:getCellSize())
		else
			min = Vector(shadow:get("MinX"), shadow:get("MinY"), shadow:get("MinZ"))
			max = Vector(shadow:get("MaxX"), shadow:get("MaxY"), shadow:get("MaxZ"))
		end

		local size = self:getBehavior(SizeBehavior)
		if size then
			size.size = max - min
			size.offset = (max - min) / 2 * Vector.PLANE_XZ
		end
	end

	self:makeGlobal()
end

function BasicDirectionalLight:getPropState()
	local result = BasicLight.getPropState(self)
	result.direction = { self.direction.x, self.direction.y, self.direction.z }

	return result
end

return BasicDirectionalLight
