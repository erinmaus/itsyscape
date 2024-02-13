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
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"
local ShipMovementCortex = require "ItsyScape.Peep.Cortexes.ShipMovementCortex"

local BasicCannon = Class(Prop)

function BasicCannon:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 2, 1)

	self:addBehavior(PropResourceHealthBehavior)

	self:addPoke('fire')
	self:addPoke('cooldown')
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

function BasicCannon:onCooldown(peep)
	local health = self:getBehavior(PropResourceHealthBehavior)
	health.currentProgress = health.maxProgress

	if peep then
		local fireAnimation = CacheRef(
			"ItsyScape.Graphics.AnimationResource",
			"Resources/Game/Animations/Action_FireCannon/Script.lua")
		local actor = peep:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			actor = actor.actor
			actor:playAnimation('x-cannon-fire', 1, fireAnimation, true)
		end
	end

	local gameDB = self:getDirector():getGameDB()
	local resource = Utility.Peep.getResource(self)
	if resource then
		local gatherable = gameDB:getRecord("GatherableProp", {
			Resource = resource
		})

		self.spawnCooldown = gatherable:get("SpawnTime") or 10
		self.currentSpawnCooldown = self.spawnCooldown
	end
end

function BasicCannon:canFire()
	return (self.currentSpawnCooldown or 0) == 0
end

function BasicCannon:onFire(peep)
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)
	if resource then
		local gameDB = self:getDirector():getGameDB()

		self:onCooldown(peep)

		do
			local cannon
			do
				if mapObject then
					cannon = gameDB:getRecord("Cannon", {
						Resource = mapObject
					})
				end

				cannon = cannon or gameDB:getRecord("Cannon", {
					Resource = resource
				})
			end

			local range
			if cannon then
				range = math.max(cannon:get("Range"), 10)
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

			local ships = director:getCortex(ShipMovementCortex):projectRay(ray, self:getLayerName())

			local damage = math.random(cannon:get("MinDamage"), cannon:get("MaxDamage"))
			local poke = AttackPoke({
				weaponType = 'cannon',
				damage = damage,
				aggressor = Utility.Peep.getMapScript(self)
			})

			director:broadcast(hits, 'receiveAttack', poke)

			local stage = director:getGameInstance():getStage()
			stage:fireProjectile(
				cannon:get("Cannonball").name,
				self,
				ray:project(range),
				Utility.Peep.getLayer(self))

			for i = 1, #hits do
				local hitCenter = Utility.Peep.getAbsolutePosition(hits[i])
				local hitSize = Utility.Peep.getSize(hits[i])

				local min = hitCenter - Vector(hitSize.x / 2, 0, -0.5)
				local max = hitCenter + Vector(hitSize.x / 2, hitSize.y, 0.5)

				local s, p = ray:hitBounds(min, max)
				if s then
					stage:fireProjectile("CannonSplosion", self, p, Utility.Peep.getLayer(hits[i]))
				end
			end

			for i = 1, #ships do
				local ship = ships[i].peep
				local closePoint = ships[i].closePoint

				local layer = (ship:hasBehavior(PositionBehavior) and ship:getBehavior(PositionBehavior).layer) or Utility.Peep.getLayer(ship)
				local y = Utility.Peep.getAbsolutePosition(self).y

				stage:fireProjectile("CannonSplosion", self, closePoint + Vector.UNIT_Y * y, layer)
				ship:poke("hit", poke)
			end
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
