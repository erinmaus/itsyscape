--------------------------------------------------------------------------------
-- ItsyScape/Peep/Peeps/Creep.lua
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
local AttackCommand = require "ItsyScape.Game.AttackCommand"
local PlayerStatsStateProvider = require "ItsyScape.Game.PlayerStatsStateProvider"
local Stats = require "ItsyScape.Game.Stats"
local Peep = require "ItsyScape.Peep.Peep"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local CreepBehavior = require "ItsyScape.Peep.Behaviors.CreepBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local LootDropperBehavior = require "ItsyScape.Peep.Behaviors.LootDropperBehavior"
local MapObjectBehavior = require "ItsyScape.Peep.Behaviors.MapObjectBehavior"
local MappResourceBehavior = require "ItsyScape.Peep.Behaviors.MappResourceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local Creep = Class(Peep)

function Creep:new(resource, ...)
	Peep.new(self, ...)

	self:addBehavior(ActorReferenceBehavior)
	self:addBehavior(CombatStatusBehavior)
	self:addBehavior(CreepBehavior)
	self:addBehavior(EquipmentBehavior)
	self:addBehavior(LootDropperBehavior)
	self:addBehavior(MovementBehavior)
	self:addBehavior(PositionBehavior)
	self:addBehavior(SizeBehavior)
	self:addBehavior(StanceBehavior)
	self:addBehavior(StatsBehavior)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 12
	movement.maxAcceleration = 8
	movement.decay = 0.7
	movement.velocityMultiplier = 1
	movement.accelerationMultiplier = 1
	movement.stoppingForce = 4

	self.resource = resource or false
	self.mapObject = false

	if self.resource then
		local s, b = self:addBehavior(MappResourceBehavior)
		if s then
			b.resource = self.resource
		end
	end
end

function Creep:getGameDBResource()
	return self.resource
end

function Creep:setMapObject(value)
	self.mapObject = value or false

	if self.mapObject then
		local s, b = self:addBehavior(MappObjectBehavior)
		if s then
			b.mapObject = self.mapObject
		end
	else
		self:removeBehavior(MapObjectBehavior)
	end
end

function Creep:getMapObject()
	return self.mapObject
end

function Creep:ready(director, game)
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
		if stats then
			stats.stats = Stats(self:getName(), game:getGameDB())
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
							local s, r = love.filesystem.load(tree)
							if not s then
								Log.warn("error loading %s: %s", tree, r)
							else
								m.states[state] = love.filesystem.load(tree)()

								local default = record:get("IsDefault")
								if default and default ~= 0 then
									m.currentState = state
								end
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
	end
end

function Creep:assign(director)
	Peep.assign(self, director)

	self:addPoke('initiateAttack')
	self:addPoke('receiveAttack')
	self:addPoke('resourceHit')
	self:addPoke('hit')
	self:addPoke('miss')
	self:addPoke('die')
	self:addPoke('firstStrike')

	self:getState():addProvider("Skill", PlayerStatsStateProvider(self))
end

function Creep:onReceiveAttack(p)
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
			if self:getCommandQueue():interrupt(AttackCommand()) then
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
	end

	if damage > 0 then
		self:poke('hit', attack)
	else
		self:poke('miss', attack)
	end
end

function Creep:onHit(p)
	local combat = self:getBehavior(CombatStatusBehavior)
	combat.currentHitpoints = math.max(combat.currentHitpoints - p:getDamage(), 0)

	if math.floor(combat.currentHitpoints) == 0 then
		self:poke('die', p)
	end
end

function Creep:onMiss(p)
	-- Nothing.
end

function Creep:onDie(p)
	self:getCommandQueue():clear()

	local movement = self:getBehavior(MovementBehavior)
	movement.velocity = Vector.ZERO
	movement.acceleration = Vector.ZERO
end

return Creep
