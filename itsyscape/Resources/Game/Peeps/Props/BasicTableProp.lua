--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicTableProp.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local BasicTableProp = Class(Prop) 

function BasicTableProp:new(...)
	Prop.new(self, ...)

	self.hasFood = true
	self.hasPlates = true

	self:addPoke('eat')
	self:addPoke('serve')
end

function BasicTableProp:spawnOrPoofTile(tile, i, j, mode)
	if mode == 'spawn' then
		tile:pushFlag('impassable')
		tile:pushFlag('shoot')
	elseif mode == 'poof' then
		tile:popFlag('impassable')
		tile:popFlag('shoot')
	end
end

function BasicTableProp:onServe(...)
	self.hasFood = true
	self.hasPlates = true
end

function BasicTableProp:onEat(p)
	if self.hasFood then
		local gameDB = self:getDirector():getGameDB()
		local healingPower = gameDB:getRecord("HealingPower", { Action = p.action })
		if healingPower then
			local hitPoints = healingPower:get("HitPoints")
			p.target:poke('heal', { prop = self, hitPoints = hitPoints or 1})
		end
	end

	self.hasFood = false
end

function BasicTableProp:getPropState()
	return {
		hasFood = self.hasFood,
		hasPlates = self.hasPlates
	}
end

return BasicTableProp
