--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicCannonball.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ShipWeapon = require "ItsyScape.Game.ShipWeapon"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local Utility = require "ItsyScape.Game.Utility"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local Probe = require "ItsyScape.Peep.Probe"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local SailingResourceBehavior = require "ItsyScape.Peep.Behaviors.SailingResourceBehavior"
local PassableProp = require "Resources.Game.Peeps.Props.PassableProp"

local BasicCannonball = Class(PassableProp)

BasicCannonball.MAX_WATER_DEPTH = 0.5

function BasicCannonball:new(...)
	PassableProp.new(self, ...)

	self:addPoke('launch')
end

function BasicCannonball:onLaunch(peep, cannon, path, duration)
	if self.isLaunched then
		return
	end

	self.currentPeep = peep
	self.currentCannon = cannon
	self.currentPath = path
	self.currentDuration = duration
	self.currentTime = 0
	self.isLaunched = true
	self.currentHits = {}
end

function BasicCannonball:_tryHit()
	local director = self:getDirector()
	local gameDB = director:getGameDB()
	local stage = director:getGameInstance():getStage()

	local position = Utility.Peep.getAbsolutePosition(self)
	local hits = director:probe(self:getLayerName(),
		Probe.attackable(self.currentPeep),
		function(p)
			if p:hasBehavior(DisabledBehavior) then
				return false
			end

			local peepPosition = Utility.Peep.getAbsolutePosition(p)
			local peepSize = Utility.Peep.getSize(p)
		
			local min = Vector(-peepSize.x / 2, 0, -peepSize.z / 2)
			local max = Vector(peepSize.x / 2, peepSize.y, peepSize.z / 2)

			local relativePosition = position - peepPosition
			return relativePosition.x >= min.x and relativePosition.y >= min.y and relativePosition.z >= min.z and
			       relativePosition.x <= max.x and relativePosition.y <= max.y and relativePosition.z <= max.z
		end)

	if #hits == 0 then
		return
	end

	local logic
	do
		local sailingResource = self:getBehavior(SailingResourceBehavior)
		if not (sailingResource and sailingResource.resource) then
			return
		end

		local ammoItemMappingRecord = gameDB:getRecord("ItemSailingItemMapping", { SailingItem = sailingResource.resource })
		if not ammoItemMappingRecord then
			return
		end

		local itemID = ammoItemMappingRecord:get("Item").name

		logic = director:getItemManager():getLogic(itemID)
		if not Class.isCompatibleType(logic, ShipWeapon) then
			logic = ShipWeapon(itemID, self:getDirector():getItemManager())
		end
	end

	local aggressor = Utility.Peep.getMapScript(self.currentCannon)
	local shouldFireProjectile = false
	for _, hit in ipairs(hits) do
		if not self.currentHits[hit] then
			self.currentHits[hit] = true
			shouldFireProjectile = true

			local damageRoll = logic:rollDamage(self.currentPeep, ShipWeapon.PURPOSE_TOOL, hit)
			local damage = damageRoll:roll()

			local poke = AttackPoke({
				weaponType = "cannon",
				damage = damage,
				aggressor = self.currentPeep
			})

			hit:poke("receiveAttack", poke, self.currentPeep)
			Log.info("Dealt %d damage against peep '%s'!", damage, hit:getName())
		end
	end

	if shouldFireProjectile then
		stage:fireProjectile("CannonSplosion", self, Utility.Peep.getAbsolutePosition(self), Utility.Peep.getLayer(self))
	end
end

function BasicCannonball:update(director, game)
	PassableProp.update(self, director, game)

	if not self.isLaunched then
		return
	end

	local delta = game:getDelta()
	self.currentTime = math.min(self.currentTime + delta, self.currentDuration)

	local percent = self.currentTime / self.currentDuration
	local currentIndex = math.floor(math.lerp(1, #self.currentPath, math.min(percent, 1)))
	local nextIndex = math.min(currentIndex + 1, #self.currentPath)

	local currentPath = self.currentPath[currentIndex]
	local nextPath = self.currentPath[nextIndex]

	local timestep = nextPath.time - currentPath.time
	local stepDelta = (self.currentTime - currentPath.time) / timestep

	local position = currentPath.position:lerp(nextPath.position, math.clamp(stepDelta))
	Utility.Peep.setPosition(self, position)

	local waterPosition = Sailing.Ocean.getPositionRotation(self)
	if position.y < waterPosition.y - self.MAX_WATER_DEPTH then
		local stage = game:getStage()
		stage:fireProjectile("CannonballSplash", Vector.ZERO, Utility.Peep.getAbsolutePosition(self) + Vector(0, 2, 0), Utility.Peep.getLayer(self))

		Utility.Peep.poof(self)
	else
		self:_tryHit()
	end
end

function BasicCannonball:getPropState()
	return {
		time = self.currentTime,
		duration = self.currentDuration
	}
end

return BasicCannonball
