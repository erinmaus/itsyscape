--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicCannon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Ray = require "ItsyScape.Common.Math.Ray"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"

local BasicCannon = Class(Prop)

function BasicCannon:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 2, 1)

	self:addBehavior(PropResourceHealthBehavior)

	self:addPoke('fire')
end

function BasicCannon:ready(director, game)
	Prop.ready(self, director, game)

	local progress = self:getBehavior(PropResourceHealthBehavior)
	progress.currentProgress = 1
	progress.maxProgress = 1

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
				h.currentProgress = health:get("Health") or 1
			end
		end
	end
end

function BasicCannon:onFire(peep)
	local health = self:getBehavior(PropResourceHealthBehavior)
	health.currentProgress = health.maxProgress

	local resource = Utility.Peep.getResource(self)
	if resource then
		local gameDB = self:getDirector():getGameDB()

		do
			local p = gameDB:getRecord("GatherableProp", {
				Resource = resource
			})

			self.spawnCooldown = p:get("SpawnTime") or 10
			self.currentSpawnCooldown = self.spawnCooldown
		end

		do
			local cannon = gameDB:getRecord("Cannon", {
				Resource = resource
			})

			local range
			if cannon then
				range = math.min(cannon:get("Range"), 10)
			else
				range = 10
			end

			local director = self:getDirector()

			local direction
			do
				local rotation = self:getBehavior(RotationBehavior)
				if rotation then
					rotation = rotation.rotation
					local transform = love.math.newTransform()

					transform:applyQuaternion(rotation.x, rotation.y, rotation.z, rotation.w)
					direction = Vector(transform:transformPoint((-Vector.UNIT_Z):get()))
				else
					direction = -Vector.UNIT_Z
				end
			end

			-- TODO: Take into account 'face' from MapObjectLocation
			local ray = Ray(
				Utility.Peep.getAbsolutePosition(self) + Vector.UNIT_Y + direction,
				direction)

			local hits = director:probe(self:getLayerName(), function(peep)
				local position = Utility.Peep.getAbsolutePosition(peep)
				local size = peep:getBehavior(SizeBehavior)
				if not size then
					return false
				else
					size = size.size
				end
			
				local min = position - Vector(size.x / 2, 0, size.z / 2)
				local max = position + Vector(size.x / 2, size.y, size.z / 2)

				local s, p = ray:hitBounds(min, max)
				return s and (p - ray.origin):getLength() <= range
			end)

			local damage = math.random(cannon:get("MinDamage"), cannon:get("MaxDamage"))
			local poke = AttackPoke({
				weaponType = 'cannon',
				damage = damage,
				aggressor = Utility.Peep.getMapScript(self)
			})

			director:broadcast(hits, 'receiveAttack', poke)

			local stage = director:getGameInstance():getStage()
			stage:fireProjectile(cannon:get("Cannonball").name, ray.origin, ray:project(range))
		end
	end
end

function BasicCannon:getPropState()
	local result = {}

	local health = self:getBehavior(PropResourceHealthBehavior)
	local progress = 100 - math.floor(health.currentProgress / health.maxProgress * 100)
	result.resource = {
		progress = progress,
		ready = progress == 100
	}

	return result
end

function BasicCannon:update(director, game)
	Prop.update(self, director, game)

	if self.spawnCooldown then
		if self.currentSpawnCooldown <= 0 then
			local health = self:getBehavior(PropResourceHealthBehavior)
			if health then
				health.currentProgress = health.maxProgress
			end

			self.spawnCooldown = nil
			self.currentSpawnCooldown = nil
		else
			self.currentSpawnCooldown = self.currentSpawnCooldown - game:getDelta()

			local health = self:getBehavior(PropResourceHealthBehavior)
			if health then
				health.currentProgress = math.floor((self.currentSpawnCooldown / self.spawnCooldown) * health.maxProgress)
			end
		end
	end
end

return BasicCannon
