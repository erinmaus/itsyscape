--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicFish.lua
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
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"

local BasicFish = Class(Prop)

function BasicFish:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(5.5, 0.5, 5.5)

	self:addBehavior(PropResourceHealthBehavior)

	self:addPoke('fished')
	self:addPoke('resourceObtained')
end

function BasicFish:spawnOrPoof()
	-- Nothing.
end

function BasicFish:ready(director, game)
	Prop.ready(self, director, game)

	local resource = Utility.Peep.getResource(self)
	if resource then
		local gameDB = director:getGameDB()
		local health = gameDB:getRecord("GatherableProp", {
			Resource = resource
		})

		if health then
			local h = self:getBehavior(PropResourceHealthBehavior)
			if h then
				h.maxProgress = health:get("Health") or 1
			end
		end
	end
end

function BasicFish:onResourceHit(e)
	local health = self:getBehavior(PropResourceHealthBehavior)
	health.currentProgress = health.currentProgress + e.damage
	if health.currentProgress >= health.maxProgress then
		health.currentProgress = math.min(
			health.maxProgress,
			health.currentProgress)

		local resource = Utility.Peep.getResource(self)
		if resource then
			local gameDB = self:getDirector():getGameDB()
			local p = gameDB:getRecord("GatherableProp", {
				Resource = resource
			})

			self.spawnCooldown = p:get("SpawnTime") or 60
		end

		local size = self:getBehavior(SizeBehavior)
		size.size = Vector(0, 0, 0)

		local e = { peep = e.peep }
		self:poke('fished', e)
		self:poke('resourceObtained', e)
	end
end

function BasicFish:getPropState()
	local result = {}

	local health = self:getBehavior(PropResourceHealthBehavior)
	local progress = math.floor(health.currentProgress / health.maxProgress * 100)
	result.resource = {
		progress = progress,
		depleted = progress >= 100
	}

	return result
end

function BasicFish:update(director, game)
	Prop.update(self, director, game)

	if self.spawnCooldown then
		if self.spawnCooldown <= 0 then
			local health = self:getBehavior(PropResourceHealthBehavior)
			if health then
				health.currentProgress = 0
			end

			self.spawnCooldown = nil

			local size = self:getBehavior(SizeBehavior)
			size.size = Vector(5.5, 0.5, 5.5)
		else
			self.spawnCooldown = self.spawnCooldown - game:getDelta()
		end
	end
end

return BasicFish
