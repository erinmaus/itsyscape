--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicBomb.lua
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
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Probe = require "ItsyScape.Peep.Probe"
local PassableProp = require "ItsyScape.Peep.Peeps.PassableProp"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"

local BasicBomb = Class(PassableProp)
BasicBomb.TICK = 1
BasicBomb.RADIUS = 6

function BasicBomb:new(...)
	PassableProp.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 1, 1)

	self:addBehavior(PropResourceHealthBehavior)

	self:addPoke('prime')
	self:addPoke('boom')
end

function BasicBomb:ready(director, game)
	PassableProp.ready(self, director, game)

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
				h.currentProgress = 0
			end
		end
	end

	self:poke('prime')
end

function BasicBomb:onSpawnedByPeep(p)
	self.peep = p.peep
end

function BasicBomb:onPrime()
	self.isPrimed = true
	self.tick = BasicBomb.TICK

	self.damage = self:calculatePrimedDamage()
end

function BasicBomb:calculatePrimedDamage()
	if not self.isPrimed then
		return 0
	end

	local weapon = Utility.Peep.getEquippedItem(self.peep, Equipment.PLAYER_SLOT_RIGHT_HAND) or
	               Utility.Peep.getEquippedItem(self.peep, Equipment.PLAYER_SLOT_TWO_HANDED)
	if not weapon then
		return 0
	end

	local level = self.peep:getState():count(
		"Skill",
		"Dexterity",
		{ ['skill-as-level'] = true })

	local logic = self:getDirector():getItemManager():getLogic(weapon:getID())
	local damageRoll = logic:rollDamage(self.peep, Weapon.PURPOSE_KILL)
	local maxHit = damageRoll:getMaxHit() + 1
	local multiplier = math.min(math.max(level - 5, 0) / 50 * 2, 2) + 1

	return math.floor(maxHit * multiplier)
end

function BasicBomb:onBoom()
	self.isPrimed = false

	local director = self:getDirector()
	local position = Utility.Peep.getAbsolutePosition(self)
	local hits = director:probe(self:getLayerName(), Probe.attackable(), function(peep)
		local difference = (Utility.Peep.getAbsolutePosition(peep) - position):getLength()
		return difference < BasicBomb.RADIUS
	end)

	for i = 1, #hits do
		local distance = (Utility.Peep.getAbsolutePosition(hits[i]) - position):getLength()
		local relativeDistance = 1 - (distance / BasicBomb.RADIUS)

		local attack = AttackPoke({
			damage = math.ceil(self.damage * relativeDistance),
			aggressor = self.peep
		})

		hits[i]:poke('receiveAttack', attack)

		Log.info('Sploded on %s.', hits[i]:getName())
	end

	Log.info("BOOM!")
end

function BasicBomb:getPropState()
	local result = {}

	local health = self:getBehavior(PropResourceHealthBehavior)
	local progress = math.floor(health.currentProgress / health.maxProgress * 100)
	result.resource = {
		progress = progress,
		ready = progress == 100
	}

	return result
end

function BasicBomb:update(director, game)
	PassableProp.update(self, director, game)

	if self.isPrimed then
		self.tick = self.tick - game:getDelta()
		if self.tick <= 0 then
			Log.info("TICK!")

			local health = self:getBehavior(PropResourceHealthBehavior)
			if health then
				health.currentProgress = health.currentProgress + 1

				if health.currentProgress > health.maxProgress then
					director:getGameInstance():getStage():removeProp(self)
				elseif health.currentProgress == health.maxProgress then
					self:poke('boom')
				end
			end

			self.tick = BasicBomb.TICK
		end
	end
end

return BasicBomb
