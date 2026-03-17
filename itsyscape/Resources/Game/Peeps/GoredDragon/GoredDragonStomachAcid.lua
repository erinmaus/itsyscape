--------------------------------------------------------------------------------
-- Resources/Peeps/GoredDragon/GoredDragonStomachAcid.lua
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
local Probe = require "ItsyScape.Peep.Probe"
local PassableProp = require "Resources.Game.Peeps.Props.PassableProp"

local StomachAcid = Class(PassableProp)

StomachAcid.MIN_SCALE = Vector(8)
StomachAcid.MAX_SCALE = Vector(10)
StomachAcid.CENTER = 7

function StomachAcid:new(...)
	PassableProp.new(self, ...)

	self.fires = {}
end

function StomachAcid:ready(...)
	PassableProp.ready(self, ...)

	local map = Utility.Peep.getMap(self)
	self.fires = {}
	for j = 1, map:getHeight() do
		local tile = map:getTile(self.CENTER, j)

		local sign = love.math.random(0, 1) == 1 and -1 or 1
		local width = love.math.random() * 2 + 1
		local position = map:getTileCenter(self.CENTER, j) + Vector(sign * width, 0, 0)

		local fireProp = Utility.spawnPropAtPosition(self, "GoredDragonStomachAcidFire", position.x, position.y, position.z)
		local firePeep = fireProp and fireProp:getPeep()
		if firePeep then
			Utility.Peep.setScale(firePeep, self.MIN_SCALE:lerp(self.MAX_SCALE, love.math.random()))

			table.insert(self.fires, firePeep)
		end
	end
end

function StomachAcid:poof()
	for _, fire in ipairs(self.fires) do
		Utility.Peep.poof(fire)
	end

	PassableProp.poof(self)
end

return StomachAcid
