--------------------------------------------------------------------------------
-- Resources/Peeps/Player/Player.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local PlayerEquipmentStateProvider = require "ItsyScape.Game.PlayerEquipmentStateProvider"
local PlayerInventoryStateProvider = require "ItsyScape.Game.PlayerInventoryStateProvider"
local PlayerStatsStateProvider = require "ItsyScape.Game.PlayerStatsStateProvider"
local Equipment = require "ItsyScape.Game.Equipment"
local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
local PlayerInventoryProvider = require "ItsyScape.Game.PlayerInventoryProvider"
local Stats = require "ItsyScape.Game.Stats"
local Peep = require "ItsyScape.Peep.Peep"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local Player = Class(Peep)

function Player:new(resource, ...)
	Peep.new(self, ...)

	self:addBehavior(ActorReferenceBehavior)
	self:addBehavior(EquipmentBehavior)
	self:addBehavior(HumanoidBehavior)
	self:addBehavior(MovementBehavior)
	self:addBehavior(InventoryBehavior)
	self:addBehavior(PositionBehavior)
	self:addBehavior(SizeBehavior)
	self:addBehavior(StanceBehavior)
	self:addBehavior(StatsBehavior)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 16
	movement.maxAcceleration = 16
	movement.decay = 0.6
	movement.velocityMultiplier = 1
	movement.accelerationMultiplier = 1
	movement.stoppingForce = 3

	local inventory = self:getBehavior(InventoryBehavior)
	inventory.inventory = PlayerInventoryProvider(self)

	local equipment = self:getBehavior(EquipmentBehavior)
	equipment.equipment = EquipmentInventoryProvider(self)

	self.resource = resource or false
	self.mapObject = false
end

function Player:getGameDBResource()
	return self.resource
end

function Player:setMapObject(value)
	self.mapObject = value or false
end

function Player:getMapObject()
	return self.mapObject
end

function Player:ready(director, game)
	Peep.ready(self, director, game)

	if self.resource then
		local gameDB = game:getGameDB()

		do
			local name
			if self.mapObject then
				name = Utility.getName(self.mapObject, gameDB)
			end

			if not name and self.resource then
				name = Utility.getName(self.resource, gameDB)
			end

			if name then
				self:setName(name)
			else
				self:setName("*" .. self.resource.name)
			end
		end

		local stats = self:getBehavior(StatsBehavior)
		if stats and stats.stats then
			stats = stats.stats
			local function setStats(records)
				for i = 1, #records do
					local skill = records[i]:get("Skill").name
					local xp = records[i]:get("Value")

					if stats:hasSkill(skill) then
						stats:getSkill(skill):setXP(xp)
					else
						Log.warn("Skill %s not found on Peep %s.", skill, self:getName())
					end
				end
			end

			setStats(gameDB:getRecords("PeepStat", { Resource = self.resource }))
			if self.mapObject then
				setStats(gameDB:getRecords("PeepStat", { Resource = self.mapObject }))
			end
		end

		local combat = self:getBehavior(CombatStatusBehavior)
		if combat and stats then
			combat.maximumHitpoints = stats:getSkill("Constitution"):getBaseLevel()
			combat.currentHitpoints = stats:getSkill("Constitution"):getBaseLevel()
		end

		do
			local function setMashinaStates(records)
				if #records > 0 then
					local s, m = self:addBehavior(MashinaBehavior)
					if s then
						for i = 1, #records do
							local record = records[i]
							local state = record:get("State")
							local tree = record:get("Tree")
							m.states[state] = love.filesystem.load(tree)()

							local default = record:get("IsDefault")
							if default and default ~= 0 then
								m.currentState = state
							end
						end
					end
				end
			end

			setMashinaStates(gameDB:getRecords("PeepMashinaState", { Resource = self.resource }))
			if self.mapObject then
				setMashinaStates(gameDB:getRecords("PeepMashinaState", { Resource = self.mapObject }))
			end
		end

		do
			local broker = director:getItemBroker()
			local function equipItems(records)
				local equipment = self:getBehavior(EquipmentBehavior)
				if equipment and equipment.equipment then
					equipment = equipment.equipment
					for i = 1, #records do
						local record = records[i]
						local item = record:get("Item")
						local count = record:get("Count") or 1

						local transaction = broker:createTransaction()
						transaction:addParty(equipment)
						transaction:spawn(equipment, item.name, count, false)
						local s, r = transaction:commit()
						if not s then
							Log.error("Failed to equip item: %s", r)
						end
					end
				end
			end

			equipItems(gameDB:getRecords("PeepEquipmentItem", { Resource = self.resource }))
			if self.mapObject then
				equipItems(gameDB:getRecords("PeepEquipmentItem", { Resource = self.mapObject }))
			end
		end
	end
end

function Player:assign(director)
	Peep.assign(self, director)

	local inventory = self:getBehavior(InventoryBehavior)
	director:getItemBroker():addProvider(inventory.inventory)

	local equipment = self:getBehavior(EquipmentBehavior)
	director:getItemBroker():addProvider(equipment.equipment)

	local stats = self:getBehavior(StatsBehavior)
	stats.stats = Stats(self:getName(), director:getGameDB())
	stats.stats:getSkill("Constitution").onLevelUp:register(function(skill, oldLevel)
		local difference = math.max(skill:getLevel() - oldLevel, 0)

		local combat = self:getBehavior(CombatStatusBehavior)
		combat.maximumHitpoints = combat.maximumHitpoints + difference
		combat.currentHitpoints = combat.currentHitpoints + difference
	end)

	stats.stats.onXPGain:register(function(_, skill, xp)
		local actor = self:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			actor = actor.actor
			actor:flash("XPPopup", skill:getName(), xp)
		end
	end)

	self:addPoke('initiateAttack')
	self:addPoke('receiveAttack')
	self:addPoke('resourceHit')
	self:addPoke('hit')
	self:addPoke('miss')
	self:addPoke('die')

	self:getState():addProvider("Skill", PlayerStatsStateProvider(self))
	self:getState():addProvider("Item", PlayerEquipmentStateProvider(self))
	self:getState():addProvider("Item", PlayerInventoryStateProvider(self))
end

function Peep:onReceiveAttack(p)
	local combat = self:getBehavior(CombatStatusBehavior)
	local damage = math.max(math.min(combat.currentHitpoints, p:getDamage()), 0)

	local attack = AttackPoke({
		attackType = p:getAttackType(),
		weaponType = p:getWeaponType(),
		damageType = p:getDamageType(),
		damage = damage,
		aggressor = p:getAggressor()
	})

	local target = self:getBehavior(CombatTargetBehavior)
	if not target then
		local actor = p:getAggressor():getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			local _, target = self:addBehavior(CombatTargetBehavior)
			target.actor = actor.actor

			local mashina = self:getBehavior(MashinaBehavior)
			if mashina then
				if mashina.currentState ~= 'begin-attack' and
				   mashina.currentState ~= 'attack'
				then
					if mashina.states['begin-attack'] then
						mashina.currentState = 'begin-attack'
					elseif mashina.states['attack'] then
						mashina.currentState = 'attack'
					else
						mashina.currentState = false
					end

					self:poke('firstStrike', attack)
				end
			end
		end
	end

	if damage > 0 then
		self:poke('hit', attack)
	else
		self:poke('miss', attack)
	end
end

function Player:onHit(p)
	local combat = self:getBehavior(CombatStatusBehavior)
	combat.currentHitpoints = math.max(combat.currentHitpoints - p:getDamage(), 0)

	if math.floor(combat.currentHitpoints) == 0 then
		self:poke('die', p)
	end
end

function Player:onMiss(p)
	-- Nothing.
end

function Player:onDie(p)
	self:getCommandQueue():clear()

	local movement = self:getBehavior(MovementBehavior)
	movement.velocity = Vector.ZERO
	movement.acceleration = Vector.ZERO
end

return Player
