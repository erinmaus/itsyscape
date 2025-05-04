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
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"

local BasicFish = Class(Prop)
BasicFish.RADIUS = 1
BasicFish.MAX_TIME_OFFSET = 100
BasicFish.Y_OFFSET = 0.25
BasicFish.DEFAULT_SIZE = Vector(2.5, 0.5, 2.5)

function BasicFish:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = self.DEFAULT_SIZE

	self:addBehavior(PropResourceHealthBehavior)

	self:addPoke('fished')
	self:addPoke('resourceObtained')

	self.center = Vector.ZERO
	self.previousPosition = Vector.ZERO
	self.timeOffset = love.math.random() * BasicFish.MAX_TIME_OFFSET
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

	if _EDITOR then
		return
	end

	local currentPosition = Utility.Peep.getPosition(self)
	local time = love.timer.getTime() + self.timeOffset

	local oceanWorldPosition, oceanRotation
	if Sailing.Ocean.hasOcean(self) then
		oceanWorldPosition, oceanRotation = Sailing.Ocean.getPositionRotation(self)
	else
		oceanWorldPosition = Vector(0, currentPosition.y, 0)
		oceanRotation = Quaternion.IDENTITY
	end

	local rotation
	do
		local xWobble = math.sin(time * math.pi * 2) * math.pi / 4
		local xRotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, xWobble)
		local yRotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, time * math.pi / 2)

		rotation = yRotation * xRotation * oceanRotation
	end

	local translation
	do
		local x = math.sin(time * math.pi / 2) * self.RADIUS - 1
		local z = math.cos(time * math.pi / 2) * self.RADIUS - 1
		translation = Vector(x, oceanWorldPosition.y + self.Y_OFFSET, z)
	end

	if currentPosition ~= self.previousPosition then
		self.center = currentPosition
	end

	self.previousPosition = Vector(self.center.x + translation.x, translation.y, self.center.z + translation.z)
	Utility.Peep.setPosition(self, self.previousPosition)
	Utility.Peep.setRotation(self, rotation)

	if self.spawnCooldown then
		if self.spawnCooldown <= 0 then
			local health = self:getBehavior(PropResourceHealthBehavior)
			if health then
				health.currentProgress = 0
			end

			self.spawnCooldown = nil

			local size = self:getBehavior(SizeBehavior)
			size.size = self.DEFAULT_SIZE
		else
			self.spawnCooldown = self.spawnCooldown - game:getDelta()
		end
	end
end

return BasicFish
