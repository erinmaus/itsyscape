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
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Ray = require "ItsyScape.Common.Math.Ray"
local CacheRef = require "ItsyScape.Game.CacheRef"
local ShipWeapon = require "ItsyScape.Game.ShipWeapon"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Probe = require "ItsyScape.Peep.Probe"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"
local ShipMovementCortex = require "ItsyScape.Peep.Cortexes.ShipMovementCortex"

local BasicCannon = Class(Prop)

function BasicCannon:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 2, 3.5)

	self:addBehavior(PropResourceHealthBehavior)

	self:addPoke('fire')
	self:addPoke('cooldown')
end

function BasicCannon:spawnOrPoof(mode)
	local i, j, layer = Utility.Peep.getTile(self)
	local map = self:getDirector():getMap(layer)
	if map then
		local tile = map:getTile(i, j)
		self:spawnOrPoofTile(tile, i, j, mode)
	end
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

function BasicCannon:onFire(peep, item)
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

			local direction = -Vector.UNIT_Z
			do
				local selfRotation = Utility.Peep.getRotation(self)
				direction = selfRotation:transformVector(direction):getNormal()

				local ship = Utility.Peep.getMapScript(self)
				local shipMovement = ship and ship:getBehavior(ShipMovementBehavior)
				local shipRotation = ship and Utility.Peep.getRotation(ship)
				if shipMovement then
					direction = (shipMovement.rotation):transformVector(direction):getNormal()
				elseif shipRotation then
					direction = shipRotation:transformVector(direction):getNormal()
				end
			end

			-- TODO: Take into account 'face' from MapObjectLocation
			local ray = Ray(
				Utility.Peep.getAbsolutePosition(self) + Vector.UNIT_Y + direction,
				direction)

			local hits = director:probe(self:getLayerName(),
				Probe.attackable(),
				function(peep)
					if Utility.Peep.getLayer(peep) == Utility.Peep.getLayer(self) then
						return false
					end

					if peep:hasBehavior(DisabledBehavior) then
						return false
					end

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
			for i = 1, #ships do
				if ships[i].peep == Utility.Peep.getMapScript(self) then
					table.remove(ships, i)
					break
				end
			end

			local logic
			do
				if item then
					logic = self:getDirector():getItemManager():getLogic(item)
				end

				if not Class.isCompatibleType(logic, ShipWeapon) then
					logic = ShipWeapon(item:getID(), self:getDirector():getItemManager())
				end
			end

			local stage = director:getGameInstance():getStage()
			stage:fireProjectile(
				item:getID(),
				self,
				ray:project(range),
				Utility.Peep.getLayer(self))

			for i = 1, #hits do
				local damageRoll = logic:rollDamage(peep, Weapon.PURPOSE_TOOL, hits[i])
				local damage = damageRoll:roll()

				local poke = AttackPoke({
					weaponType = 'cannon',
					damage = damage,
					aggressor = Utility.Peep.getMapScript(self)
				})

				hits[i]:poke("receiveAttack", poke, player)
				Log.info("Dealt %d damage against peep '%s'!", damage, hits[i]:getName())

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

				local hitPosition = closePoint + Vector.UNIT_Y * y
				stage:fireProjectile("CannonSplosion", self, hitPosition, layer)

				local damageRoll = logic:rollDamage(peep, Weapon.PURPOSE_TOOL)
				local damage = damageRoll:roll()

				local poke = AttackPoke({
					weaponType = 'cannon',
					damage = damage,
					aggressor = Utility.Peep.getMapScript(self)
				})

				ship:poke("hit", poke)
				Log.info("Dealt %d damage against ship '%s'!", damage, ship:getName())
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
