--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Tinkerer/DragonValleyTinkerer.lua
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
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local Probe = require "ItsyScape.Peep.Probe"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local BaseTinkerer = require "Resources.Game.Peeps.Tinkerer.BaseTinkerer"

local BossTinkerer = Class(BaseTinkerer)
BossTinkerer.GORY_MASS_DROP = 20
BossTinkerer.MIN_BONE_BLAST_DISTANCE = 8
BossTinkerer.MAX_BONE_BLAST_DISTANCE = 16
BossTinkerer.TIME_BETWEEN_BONE_BLAST = 0.5

function BossTinkerer:new(resource, name, ...)
	BaseTinkerer.new(self, resource, name or 'Tinkerer_DragonValleyBoss', ...)

	self:listen("receiveAttack", Utility.Peep.Attackable.bossReceiveAttack)
	self:addPoke("boss")
end

function BossTinkerer:ready(...)
	BaseTinkerer.ready(self, ...)

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = 1200
	status.maximumHitpoints = 1200
	status.maxChaseDistance = math.huge
end

function BossTinkerer:onDie()
	local goryMasses = self:getDirector():probe(
		self:getLayerName(),
		Probe.resource("Peep", "GoryMass"))

	for _, g in ipairs(goryMasses) do
		g:poke("die")
	end

	local experimentX = self:getDirector():probe(
		self:getLayerName(),
		Probe.resource("Peep", "ExperimentX"))

	for _, e in ipairs(experimentX) do
		e:poke("die")
	end

	local zombi = self:getDirector():probe(
		self:getLayerName(),
		Probe.resource("Peep", "SurgeonZombi"))

	for _, z in ipairs(zombi) do
		z:poke("die")
	end

	local fleshyPillars = self:getDirector():probe(
		self:getLayerName(),
		Probe.resource("Peep", "EmptyRuins_DragonValley_FleshyPillar"))

	for _, f in ipairs(fleshyPillars) do
		f:poke("die")
	end
end

function BossTinkerer:onTransferHitpoints(e)
	local stage = self:getDirector():getGameInstance():getStage()
	stage:fireProjectile("SoulStrike", self, e.target)

	self:pushPoke(1, "healTarget", e)
end

function BossTinkerer:onHealTarget(e)
	self:poke("hit", AttackPoke({ damage = e.hitpoints }))
	e.target:poke("heal", { hitpoints = e.hitpoints })
end

function BossTinkerer:onDropGoryMass(e)
	local target = e.experiment:getBehavior(CombatTargetBehavior)
	if not target then
		return
	end

	local targetPeep = target and target.actor and target.actor:getPeep()
	if not targetPeep then
		return
	end

	local map = Utility.Peep.getMap(targetPeep)
	if not map then
		return
	end

	local position = Utility.Map.getRandomPosition(map, Utility.Peep.getPosition(targetPeep), math.sqrt(2))
	position = position + Vector.UNIT_Y * self.GORY_MASS_DROP

	local goryMass = Utility.spawnActorAtPosition(
		self,
		"GoryMass",
		position:get())
	if goryMass then
		goryMass:playAnimation(
			"x-tinkerer",
			1,
			CacheRef("ItsyScape.Graphics.AnimationResource", "Resources/Game/Animations/FX_Spawn/Script.lua"))
	end
end

function BossTinkerer:onSummonSurgeonZombi()
	local target = self:getBehavior(CombatTargetBehavior)
	if not target then
		return
	end

	local targetPeep = target and target.actor and target.actor:getPeep()
	if not targetPeep then
		return
	end

	local map = Utility.Peep.getMap(targetPeep)
	if not map then
		return
	end

	local position = Utility.Map.getRandomPosition(map, Utility.Peep.getPosition(targetPeep), math.sqrt(2))
	local zombi = Utility.spawnActorAtPosition(
		self,
		"SurgeonZombi",
		position:get())
	if zombi then
		zombi:getPeep():listen("finalize", function()
			Utility.Peep.attack(zombi:getPeep(), targetPeep)
			Utility.Peep.talk(zombi:getPeep(), "Brains....")
		end)

		zombi:playAnimation(
			"x-tinkerer",
			1,
			CacheRef("ItsyScape.Graphics.AnimationResource", "Resources/Game/Animations/FX_Spawn/Script.lua"))
	end
end

function BossTinkerer:onSummonFleshyPillar()
	local target = self:getBehavior(CombatTargetBehavior)
	if not target then
		return
	end

	local targetPeep = target and target.actor and target.actor:getPeep()
	if not targetPeep then
		return
	end

	local map = Utility.Peep.getMap(targetPeep)
	if not map then
		return
	end

	local position = Utility.Map.getRandomPosition(map, Utility.Peep.getPosition(targetPeep), 4)
	Utility.spawnActorAtPosition(
		self,
		"EmptyRuins_DragonValley_FleshyPillar",
		position.x, position.y, position.z,
		2)
end

function BossTinkerer:onSummonBoneBlast(targetPeep, count, maxCount, previousI, previousJ)
	if not targetPeep then
		local target = self:getBehavior(CombatTargetBehavior)
		if not target then
			Log.info("Tinkerer has no target; cannot summon bone blast.")
			return
		end

		targetPeep = target and target.actor and target.actor:getPeep()
		if not targetPeep then
			Log.info("Tinkerer has no target peep; cannot summon bone blast.")
			return
		end
	end

	if not count then
		local map = Utility.Peep.getMap(self)
		if not map then
			Log.info("Tinkerer has no map; cannot summon bone blast.")
			return
		end

		local selfPosition = Utility.Peep.getPosition(self)
		local targetPosition = Utility.Peep.getPosition(targetPeep)
		local distance = (selfPosition - targetPosition):getLength()
		distance = math.ceil(distance / map:getCellSize())
		distance = math.min(math.max(distance + 4, self.MIN_BONE_BLAST_DISTANCE), self.MAX_BONE_BLAST_DISTANCE)

		local selfI, selfJ = Utility.Peep.getTile(self)

		Log.info("Tinkerer summon bone blast at (%d, %d) for %d tiles!", selfI, selfJ, distance)

		self:poke("summonBoneBlast", targetPeep, 1, distance, selfI, selfJ)
	elseif count <= (maxCount or 0) then
		local map = Utility.Peep.getMap(self)
		if not map then
			Log.info("Tinkerer has no map; cannot continue bone blast.")
			return
		end

		if not (previousI and previousJ) then
			Log.info("No previous position tile position; cannot continue bone blast.")
			return
		end

		local currentPosition = map:getTileCenter(previousI, previousJ)
		local hits = self:getDirector():probe(
			self:getLayerName(),
			Probe.attackable(),
			Probe.distance(currentPosition, 2),
			function(other)
				return other ~= self
			end)

		if #hits >= 1 then
			local weapon = Utility.Peep.getEquippedWeapon(self, true)
			if weapon and Class.isCompatibleType(weapon, Weapon) then
				local hitTarget = false
				for _, hit in ipairs(hits) do
					hitTarget = hitTarget or hit == targetPeep

					weapon:onAttackHit(self, hit)
					Log.info("Tinkerer hit '%s' with bone blast!", hit:getName())
				end

				if hitTarget then
					Log.info("Tinkerer hit target '%s'; bone blast stopping.", targetPeep:getName())
					return
				end
			end
		end

		local targetPosition = Utility.Peep.getPosition(targetPeep)

		local direction = (targetPosition - currentPosition):getNormal()

		local nextI, nextJ

		local ray = Ray(currentPosition, direction)
		local canShoot = map:castRay(ray, function(_, tileI, tileJ)
			if tileI ~= previousI or tileJ ~= previousJ then
				if map:canMove(previousI, previousJ, tileI - previousI, tileJ - previousJ, true) then
					Log.info("Tinkerer bone blast next tile found at (%d, %d)!", tileI, tileJ)

					nextI = tileI
					nextJ = tileJ
					return true
				end
			end
		end)

		if canShoot and nextI and nextJ then
			Log.info("Tinkerer summoning next bone blast at (%d, %d)! %d of %d tiles hit.", nextI, nextJ, count, maxCount)

			local stage = self:getDirector():getGameInstance():getStage()
			stage:fireProjectile("Tinkerer_BoneBlast", self, map:getTileCenter(nextI, nextJ))

			self:pushPoke(self.TIME_BETWEEN_BONE_BLAST, "summonBoneBlast", targetPeep, count + 1, maxCount, nextI, nextJ)
		else
			Log.info("Tinkerer bone blast stopped!")
		end
	else
		Log.info("Tinkerer's bone blast over!")
	end
end

function BossTinkerer:onBoss(e)
	local gameDB = self:getDirector():getGameDB()

	local selfStatus = self:getBehavior(CombatStatusBehavior)
	local targetStatus = e.experiment:getBehavior(CombatStatusBehavior)
	if targetStatus and selfStatus then
		self:poke("heal", {
			hitpoints = selfStatus.maximumHitpoints - selfStatus.currentHitpoints
		})

		e.experiment:poke("hit", AttackPoke({ damage = targetStatus.currentHitpoints }))
	end

	local resource = gameDB:getResource("Tinkerer_DragonValley_Attackable", "Peep")
	if resource then
		Utility.Peep.setResource(self, resource)
	end

	Utility.UI.openInterface(
		Utility.Peep.getInstance(self),
		"BossHUD",
		false,
		self)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:fireProjectile("ExperimentX_Siphon", e.experiment, self)
end

return BossTinkerer
