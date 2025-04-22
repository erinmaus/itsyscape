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
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local ShipWeapon = require "ItsyScape.Game.ShipWeapon"
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
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

function BasicCannonball:_tryHit(currentIndex, nextIndex)
	local director = self:getDirector()
	local gameDB = director:getGameDB()
	local stage = director:getGameInstance():getStage()

	local a = self.currentPath[currentIndex].position
	local b = self.currentPath[nextIndex].position
	local distance = a:distance(b)
	local ray = Ray(a, a:direction(b))

	local hits = director:probe(self:getLayerName(),
		Probe.attackable(self.currentPeep),
		function(p)
			if Utility.Peep.isDisabled(p) then
				return false
			end

			local peepPosition = Utility.Peep.getAbsolutePosition(p)
			local peepSize = Utility.Peep.getSize(p)
		
			local min = Vector(-peepSize.x / 2, 0, -peepSize.z / 2) + peepPosition
			local max = Vector(peepSize.x / 2, peepSize.y, peepSize.z / 2) + peepPosition

			local s, _, t = ray:hitBounds(min, max, nil, 0.5)
			return s and t <= distance
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
			Log.info("%s dealt %d damage against peep '%s'!", self:getName(), damage, hit:getName())
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

	self:_tryHit(currentIndex, nextIndex)

	local instance = Utility.Peep.getInstance(self)
	for _, layer in instance:iterateLayers() do
		local mapScript = instance:getMapScriptByLayer(layer)
		local map = Utility.Peep.getMap(mapScript)

		local transform = Utility.Peep.getMapTransform(mapScript)
		local relativePosition = position:inverseTransform(transform)
		if relativePosition.x >= 0 and relativePosition.x <= map:getWidth() * map:getCellSize() and
		   relativePosition.z >= 0 and relativePosition.z <= map:getHeight() * map:getCellSize()
		then
			local y = map:getInterpolatedHeight(relativePosition.x, relativePosition.z)
			if relativePosition.y <= y then
				local stage = game:getStage()
				stage:fireProjectile("CannonSplosion", Vector.ZERO, Utility.Peep.getAbsolutePosition(self) + Vector(0, 2, 0), Utility.Peep.getLayer(self))
				Utility.Peep.poof(self)
				return
			end
		end
	end

	local waterPosition = Sailing.Ocean.getPositionRotation(self)
	if position.y < waterPosition.y - self.MAX_WATER_DEPTH then
		local stage = game:getStage()
		stage:fireProjectile("CannonballSplash", Vector.ZERO, Utility.Peep.getAbsolutePosition(self) + Vector(0, 2, 0), Utility.Peep.getLayer(self))
		Utility.Peep.poof(self)
		return
	end
end

function BasicCannonball:getPropState()
	return {
		time = self.currentTime,
		duration = self.currentDuration
	}
end

return BasicCannonball
