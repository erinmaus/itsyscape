--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Peep/Attackable.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local ImmortalBehavior = require "ItsyScape.Peep.Behaviors.ImmortalBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local PowerRechargeBehavior = require "ItsyScape.Peep.Behaviors.PowerRechargeBehavior"

local Attackable = {}

function Attackable:onInitiateAttack()
	-- Nothing.
end

function Attackable:onTargetFled(p)
	local mashina = self:getBehavior(MashinaBehavior)
	if mashina then
		local isCurrentStateValid = mashina.currentState
		if isCurrentStateValid then
			local isCurrentStateAttack = mashina.currentState == 'attack' or
			                             not mashina.states[mashina.currentState]

			if isCurrentStateAttack and mashina.states['idle'] then
				mashina.currentState = 'idle'
				Log.info("Target for %s fled, returning to idle.", self:getName())
			end
		end
	end
end

function Attackable:bossReceiveAttack(p)
	local aggressor = p:getAggressor()
	if not aggressor then
		return
	end

	local isPlayer = aggressor:hasBehavior(PlayerBehavior)
	if not isPlayer then
		return
	end

	local isOpen = Utility.UI.isOpen(aggressor, "BossHUD")
	if isOpen then
		return
	end

	Utility.UI.openInterface(
		aggressor,
		"BossHUD",
		false,
		self)
end

function Attackable:onReceiveAttack(p)
	local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
	local WaitCommand = require "ItsyScape.Peep.WaitCommand"
	local UninterrupibleCallbackCommand = require "ItsyScape.Peep.UninterrupibleCallbackCommand"

	local combat = self:getBehavior(CombatStatusBehavior)
	if not combat then
		return
	end
	
	local isAttackable = Utility.Peep.isAttackable(self)
	local isPlayerAggressor = p:getAggressor() and p:getAggressor():hasBehavior(PlayerBehavior)
	local isSelfPlayer = self:hasBehavior(PlayerBehavior)
	if (not isAttackable and isPlayerAggressor) or (isPlayerAggressor and isSelfPlayer) then
		return
	end

	local damage = math.max(math.min(combat.currentHitpoints, p:getDamage()), 0)

	local attack = AttackPoke({
		attackType = p:getAttackType(),
		weaponType = p:getWeaponType(),
		damageType = p:getDamageType(),
		damage = damage,
		aggressor = p:getAggressor(),
		delay = p:getDelay()
	})

	if damage > 0 then
		if p:getDelay() > 0 then
			local queue = self:getParallelCommandQueue('hit')
			local a = WaitCommand(p:getDelay(), false)
			local b = UninterrupibleCallbackCommand(function() self:poke('hit', attack) end)
			queue:push(CompositeCommand(true, a, b))
		else
			self:poke('hit', attack)
		end
	else
		if p:getDelay() > 0 then
			local queue = self:getParallelCommandQueue('hit')
			local a = WaitCommand(p:getDelay(), false)
			local b = UninterrupibleCallbackCommand(function() self:poke('miss', attack) end)
			queue:push(CompositeCommand(true, a, b))
		else
			self:poke('miss', attack)
		end
	end
end

Attackable.aggressiveOnReceiveAttack = Attackable.onReceiveAttack

function Attackable:onHeal(p)
	local combat = self:getBehavior(CombatStatusBehavior)
	if combat and combat.currentHitpoints >= 0 then
		local newHitPoints = combat.currentHitpoints + math.max(p.hitPoints or p.hitpoints or 0, 0)
		if not p.zealous then
			newHitPoints = math.min(newHitPoints, combat.maximumHitpoints)
		else
			newHitPoints = math.min(newHitPoints, combat.maximumHitpoints + (p.hitPoints or p.hitpoints or 0))
		end

		combat.currentHitpoints = newHitPoints
	end
end

function Attackable:onZeal(p)
	for effect in self:getEffects(require "ItsyScape.Peep.Effects.ZealEffect") do
		effect:modifyZealEvent(p, self)
	end

	local pendingPowers = self:getBehavior(PowerRechargeBehavior)
	if pendingPowers then
		for powerID, powerZeal in pairs(pendingPowers.powers) do
			local multiplier, offset = 1, 0
			for effect in self:getEffects(require "ItsyScape.Peep.Effects.ZealEffect") do
				local m, o = effect:modifyActiveRecharge(p, powerID)
				multiplier = multiplier + m
				offset = offset + o
			end

			local recharge = math.clamp(p:getEffectiveZeal() * multiplier + offset, 0.01, 1)
			powerZeal = powerZeal - recharge

			if powerZeal <= 0 then
				pendingPowers.powers[powerID] = nil
			else
				pendingPowers.powers[powerID] = powerZeal
			end
		end
	end

	local status = self:getBehavior(CombatStatusBehavior)
	if not status then
		return
	end

	local zeal = p:getEffectiveZeal()
	local currentZeal = status.currentZeal + zeal
	local multiplier, offset = 1, 0
	for effect in self:getEffects(require "ItsyScape.Peep.Effects.ZealEffect") do
		local m, o = effect:modifyZeal(p, self)
		multiplier = multiplier + m
		offset = offset + o
	end

	status.currentZeal = math.clamp(currentZeal * multiplier + offset, 0, status.maximumZeal)
end

function Attackable:onHit(p)
	if self:hasBehavior(DisabledBehavior) then
		return
	end

	local combat = self:getBehavior(CombatStatusBehavior)
	if not combat then
		return
	end

	if combat.currentHitpoints == 0 or combat.isDead then
		return
	end

	combat.currentHitpoints = math.max(combat.currentHitpoints - p:getDamage(), 0)
	if combat.currentHitpoints <= 0 and self:hasBehavior(ImmortalBehavior) then
		combat.currentHitpoints = 1
	end

	if math.floor(combat.currentHitpoints) == 0 then
		self:pushPoke('die', p)
	end
end

function Attackable:onMiss(p)
	-- Nothing.
end

function Attackable:onDie(p)
	local CombatCortex = require "ItsyScape.Peep.Cortexes.CombatCortex2"
	self:getCommandQueue():clear()
	self:getCommandQueue(CombatCortex.QUEUE):clear()
	self:removeBehavior(CombatTargetBehavior)

	local mashina = self:getBehavior(MashinaBehavior)
	if mashina then
		mashina.currentState = false
	end

	local movement = self:getBehavior(MovementBehavior)
	movement.velocity = Vector.ZERO
	movement.acceleration = Vector.ZERO

	local xp = Utility.Combat.getCombatXP(self)
	local slayers = {}
	do
		local actor = self:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			local status = self:getBehavior(CombatStatusBehavior)
			if status then
				local currentSlayerDamage = 0
				for peep, d in pairs(status.damage) do
					if peep:hasBehavior(PlayerBehavior) then
						slayers[peep] = d
					end

					local damage = d / status.maximumHitpoints
					Log.info("%s gets %d%% XP for slaying %s (dealt %d damage).", peep:getName(), damage * 100, self:getName(), d)

					if peep:hasBehavior(PlayerBehavior) then
						Analytics:killedNPC(peep, self, math.floor(xp * damage))
					end

					Utility.Combat.giveCombatXP(peep, xp * damage)
				end

				status.dead = true
			end
		end
	end

	do
		local s = {}
		for slayer in pairs(slayers) do
			table.insert(s, slayer)
		end

		table.sort(s, function(a, b)
			return slayer[a] > slayer[b]
		end)

		slayers = s
	end

	if Utility.Boss.isBoss(self) then
		local gameDB = self:getDirector():getGameDB()

		local isDead = true
		do
			local mapObject = Utility.Peep.getMapObject(self)
			if mapObject then
				local group = gameDB:getRecord("MapObjectGroup", {
					MapObject = mapObject,
					Map = Utility.Peep.getMapResource(self)
				})

				if group then
					local Probe = require "ItsyScape.Peep.Probe"
					local hits = self:getDirector():probe(
						self:getLayerName(),
						function(peep)
							local m = Utility.Peep.getMapObject(peep)
							local g = m and gameDB:getRecord("MapObjectGroup", {
								MapObject = m,
								Map = Utility.Peep.getMapResource(peep),
								MapObjectGroup = group:get("MapObjectGroup")
							})

							return m and g
						end)

					isDead = true
					for _, hit in ipairs(hits) do
						local status = hit:getBehavior(CombatStatusBehavior)

						if not status or not status.dead then
							isDead = false
							break
						end
					end
				end
			end
		end

		if isDead then
			local instance = Utility.Peep.getInstance(self)
			if instance and instance:getIsGlobal() and #slayers >= 1 then
				Utility.Boss.recordKill(slayers[1], self)
			elseif instance and instance:getIsLocal() then
				for _, player in instance:iteratePlayers() do
					Utility.Boss.recordKill(player:getActor():getPeep(), self)
				end
			end
		end
	end
end

function Attackable:onResurrect()
	local status = self:getBehavior(CombatStatusBehavior)
	if status then
		status.damage = {}
		status.dead = false
	end

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor.actor:stopAnimation("combat-die")
	end
end

function Attackable:onReady(director)
	local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
	local EquipmentBonusesBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBonusesBehavior"

	local function setEquipmentBonuses(record)
		if not record then
			return false
		else
			self:addBehavior(EquipmentBonusesBehavior)
		end

		local bonuses = self:getBehavior(EquipmentBonusesBehavior).bonuses
		for i = 1, #EquipmentInventoryProvider.STATS do
			local stat = EquipmentInventoryProvider.STATS[i]
			bonuses[stat] = record:get(stat) or 0
		end

		return true
	end
	
	local gameDB = director:getGameDB()
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)

	local success = false
	if mapObject then
		success = setEquipmentBonuses(gameDB:getRecord("Equipment", { Resource = mapObject, Name = "" }))
	end

	if not success and resource then
		success = setEquipmentBonuses(gameDB:getRecord("Equipment", { Resource = resource, Name = "" }))
	end

	if success then
		Log.info("Peep '%s' has bonuses.", self:getName())
	end
end

function Attackable:onPostReady(director)
	local gameDB = director:getGameDB()
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)

	local mapObjectHealth = mapObject and gameDB:getRecord("PeepHealth", { Resource = mapObject })
	local resourceHealth = resource and gameDB:getRecord("PeepHealth", { Resource = resource })

	local health = (mapObjectHealth and mapObjectHealth:get("Hitpoints")) or (resourceHealth and resourceHealth:get("Hitpoints"))

	if health then
		local _, status = self:addBehavior(CombatStatusBehavior)
		status.currentHitpoints = health
		status.maximumHitpoints = health
	end
end

return Attackable