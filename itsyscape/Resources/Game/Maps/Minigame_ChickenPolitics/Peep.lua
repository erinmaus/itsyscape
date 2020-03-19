--------------------------------------------------------------------------------
-- Resources/Game/Maps/Rumbridge_Port/Peep.lua
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
local Map = require "ItsyScape.Peep.Peeps.Map"

local Minigame = Class(Map)
Minigame.MIN_TICK = 1
Minigame.MAX_TICK = 10
Minigame.SPAWN_ELEVATION = 50

function Minigame:spawnChicken()
	local map = self:getDirector():getMap(self:getLayer())

	local center
	repeat
		local testI = math.random(1, map:getWidth())
		local testJ = math.random(1, map:getHeight())
		local tile = map:getTile(testI, testJ)

		if not tile:hasFlag('blocking') and not tile:hasFlag('impassable') then
			center = map:getTileCenter(testI, testJ)
		end
	until center
	center = center + Vector.UNIT_Y * Minigame.SPAWN_ELEVATION

	local gameDB = self:getDirector():getGameDB()
	local resource = gameDB:getResource("Chicken_Haru", "Peep")

	Utility.spawnActorAtPosition(self, resource, center:get())

	self.nextTick = math.random(Minigame.MIN_TICK, Minigame.MAX_TICK)
end

function Minigame:update(director, game)
	Map.update(self, director, game)

	self.nextTick = (self.nextTick or 0) - game:getDelta()
	if self.nextTick <= 0 then
		self:spawnChicken()
	end
end

return Minigame
