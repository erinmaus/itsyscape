--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicArtisanStation.lua
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
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StaticBehavior = require "ItsyScape.Peep.Behaviors.StaticBehavior"

local BasicArtisanStation = Class(Prop)

BasicArtisanStation.COLLISION_IS_TALL = false
BasicArtisanStation.COLLISION_IS_BLOCKING = false

function BasicArtisanStation:new(...)
	Prop.new(self, ...)

	Utility.Peep.makeArtisanStation(self)

	if self.COLLISION_IS_BLOCKING then
		local static = self:getBehavior(StaticBehavior)
		static.type = StaticBehavior.PASSABLE
	end

	self.craftGeneration = 0
end

function BasicArtisanStation:getCraftGeneration()
	return self.craftGeneration
end

function BasicArtisanStation:incrementCraftGeneration()
	self.craftGeneration = self.craftGeneration + 1
end

function BasicArtisanStation:onCraft()
	self:incrementCraftGeneration()
end

function BasicArtisanStation:spawnOrPoofTile(tile, i, j, mode)
	local flag
	if self.COLLISION_IS_BLOCKING then
		flag = "blocking"
	else
		flag = "impassable"
	end

	if mode == "spawn" then
		tile:pushFlag(flag)
	elseif mode == "poof" then
		tile:popFlag(flag)
	end

	if not self.COLLISION_IS_TALL then
		if mode == "spawn" then
			tile:pushFlag("shoot")
		elseif mode == "poof" then
			tile:popFlag("shoot")
		end
	end
end

function BasicArtisanStation:getPropState()
	return {
		generation = self.craftGeneration
	}
end

return BasicArtisanStation
