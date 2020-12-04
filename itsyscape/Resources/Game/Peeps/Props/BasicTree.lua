--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicTree.lua
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
local GatheredResourceBehavior = require "ItsyScape.Peep.Behaviors.GatheredResourceBehavior"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local BasicTree = Class(Prop)

function BasicTree:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 2, 1)

	self:addBehavior(PropResourceHealthBehavior)

	self:addPoke('chopped')
	self:addPoke('shake')
	self:addPoke('resourceObtained')
end

function BasicTree:ready(director, game)
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

function BasicTree:onResourceHit(e)
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

			if p then
				self.spawnCooldown = p:get("SpawnTime") or 60
			else
				self.spawnCooldown = 60
			end
		end

		local e = { peep = e.peep }
		self:poke('chopped', e)
		self:poke('resourceObtained', e)
	end
end

function BasicTree:previewShake()
	local _, g = self:addBehavior(GatheredResourceBehavior)
	g.count = g.count + 1
end

function BasicTree:getPropState()
	local result = {}

	local health = self:getBehavior(PropResourceHealthBehavior)
	local shakeCount
	do
		local shaken = self:getBehavior(GatheredResourceBehavior)
		if shaken then
			shakeCount = shaken.count
		end
	end

	local progress = math.floor(health.currentProgress / health.maxProgress * 100)
	result.resource = {
		progress = progress,
		depleted = progress >= 100,
		shaken = shakeCount or 0
	}

	return result
end

function BasicTree:update(director, game)
	Prop.update(self, director, game)

	if self.spawnCooldown then
		if self.spawnCooldown <= 0 then
			local health = self:getBehavior(PropResourceHealthBehavior)
			if health then
				health.currentProgress = 0
			end

			self.spawnCooldown = nil
			
			self:removeBehavior(GatheredResourceBehavior)
		else
			self.spawnCooldown = self.spawnCooldown - game:getDelta()
		end
	end
end

return BasicTree
