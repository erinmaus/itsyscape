--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicRock.lua
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

local BasicRock = Class(Prop)

function BasicRock:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 2, 1)

	self:addBehavior(PropResourceHealthBehavior)

	self:addPoke('mined')
	self:addPoke('resourceObtained')
	self:addPoke('resourceHit')
end

function BasicRock:spawnOrPoofTile(tile, i, j, mode)
	if mode == 'spawn' then
		tile:pushFlag('impassable')
		tile:pushFlag('shoot')
	elseif mode == 'poof' then
		tile:popFlag('impassable')
		tile:popFlag('shoot')
	end
end

function BasicRock:ready(director, game)
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

function BasicRock:onResourceHit(e)
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

		local e = { peep = e.peep }
		self:poke('mined', e)
		self:poke('resourceObtained', e)
	end
end

function BasicRock:getPropState()
	local result = {}

	local health = self:getBehavior(PropResourceHealthBehavior)
	local progress = math.floor(health.currentProgress / health.maxProgress * 100)
	result.resource = {
		progress = progress,
		depleted = progress >= 100
	}

	return result
end

function BasicRock:update(director, game)
	Prop.update(self, director, game)

	if self.spawnCooldown then
		if self.spawnCooldown <= 0 then
			local health = self:getBehavior(PropResourceHealthBehavior)
			if health then
				health.currentProgress = 0
			end

			self.spawnCooldown = nil
		else
			self.spawnCooldown = self.spawnCooldown - game:getDelta()
		end
	end
end

return BasicRock
