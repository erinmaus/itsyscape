--------------------------------------------------------------------------------
-- ItsyScape/World/GatherResourceCommand.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Command = require "ItsyScape.Peep.Command"
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"

local GatherResourceCommand = Class(Command)
GatherResourceCommand.FINISH_DELAY = 0.5

function GatherResourceCommand:new(prop, tool, callback, t)
	Command.new(self)

	t = t or {}
	self.prop = prop
	self.tool = tool
	self.skill = t.skill or false
	self.action = t.action or false
	self.skin = t.skin or false
	self.time = 0
	self.isFinished = false
	self.callback = callback
	self._onResourceObtained = function(...)
		self:onResourceObtained(...)
	end
end

function GatherResourceCommand:getIsFinished()
	return self.isFinished and self.time > self.cooldown
end

function GatherResourceCommand:onResourceObtained(peep, e)
	self.isFinished = true
	self.time = 0
	self.cooldown = GatherResourceCommand.FINISH_DELAY

	if self.callback then
		self.callback()
	end
end

function GatherResourceCommand:onBegin(peep)
	local itemManager = peep:getDirector():getItemManager()
	local logic = itemManager:getLogic(self.tool:getID())
	if logic:isCompatibleType(Weapon) then
		self.cooldown = logic:getCooldown(peep)
	else
		Log.warn("Unsupported logic for Item '%s'.", self.tool:getID())
		self.cooldown = math.huge
	end

	self.prop:listen('resourceObtained', self._onResourceObtained, self, peep)

	peep:poke('resourceHit', {
		tool = self.tool,
		damage = 0,
		skill = self.skill,
		prop = self.prop
	})

	self:showTool(peep)
end

function GatherResourceCommand:showTool(peep)
	if self.skin then
		local currentWeapon = Utility.Peep.getEquippedWeapon(peep)
		if currentWeapon then
			local gameDB = peep:getDirector():getGameDB()
			local itemResource = gameDB:getResource(currentWeapon:getID(), "Item")

			if itemResource then
				local equipmentRecord = gameDB:getRecord("Equipment", { Resource = itemResource })
				if equipmentRecord then
					self.slot = equipmentRecord:get("EquipSlot")
				else
					Log.error("No equipment record for tool '%s'.", bestTool:getID())
				end
			else
				Log.error("No item resource for '%s'.", currentWeapon:getID())
			end
		else
			self.slot = Equipment.PLAYER_SLOT_RIGHT_HAND
		end

		if self.slot then
			local actor = peep:getBehavior(ActorReferenceBehavior)
			if actor and actor.actor then
				actor = actor.actor

				actor:setSkin(
					self.slot,
					Equipment.SKIN_PRIORITY_EQUIPMENT_OVERRIDE,
					self.skin)
			end
		end
	end
end

function GatherResourceCommand:hideTool(peep)
	if self.slot then
		local actor = peep:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			actor = actor.actor

			actor:unsetSkin(
				self.slot,
				Equipment.SKIN_PRIORITY_EQUIPMENT_OVERRIDE,
				self.skin)
		end
	end
end

function GatherResourceCommand:onEnd(peep)
	self.prop:silence('resourceObtained', self._onResourceObtained)
	self:hideTool(peep)
end

function GatherResourceCommand:onInterrupt(peep)
	self.prop:silence('resourceObtained', self._onResourceObtained)
	self:hideTool(peep)
end

function GatherResourceCommand:update(delta, peep)
	if self.time > self.cooldown then
		self:attack(peep)
		self.time = 0
	else
		self.time = self.time + delta
	end
end

function GatherResourceCommand:attack(peep)
	local itemManager = peep:getDirector():getItemManager()
	local logic = itemManager:getLogic(self.tool:getID())
	if logic:isCompatibleType(Weapon) then
		self.cooldown = logic:getCooldown(peep)

		if self.action then
			if not self.action:consume(peep:getState()) then
				Log.info("Couldn't continue to gather resource.")

				self.action:fail(peep:getState(), peep)
				self.isFinished = true

				return
			end
		end

		local damage = logic:rollDamage(peep, Weapon.PURPOSE_TOOL, self.prop):roll()
		self.prop:poke('resourceHit', {
			tool = self.tool,
			damage = damage,
			peep = peep
		})

		peep:poke('resourceHit', {
			tool = self.tool,
			damage = damage,
			skill = self.skill,
			prop = self.prop
		})
	end
end

return GatherResourceCommand
