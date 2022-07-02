--------------------------------------------------------------------------------
-- ItsyScape/UI/SailorEquipmentController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Controller = require "ItsyScape.UI.Controller"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local SailorEquipmentController = Class(Controller)
SailorEquipmentController.SLOTS = {
	Equipment.PLAYER_SLOT_RIGHT_HAND,
	Equipment.PLAYER_SLOT_LEFT_HAND,
	Equipment.PLAYER_SLOT_HEAD,
	Equipment.PLAYER_SLOT_NECK,
	Equipment.PLAYER_SLOT_BODY,
	Equipment.PLAYER_SLOT_LEGS,
	Equipment.PLAYER_SLOT_FEET,
	Equipment.PLAYER_SLOT_HANDS,
	Equipment.PLAYER_SLOT_BACK,
	Equipment.PLAYER_SLOT_FINGER,
	Equipment.PLAYER_SLOT_POCKET,
	Equipment.PLAYER_SLOT_QUIVER,
}

function SailorEquipmentController:new(peep, director, target)
	Controller.new(self, peep, director)

	Utility.UI.broadcast(
		self:getDirector():getGameInstance():getUI(),
		self:getPeep(),
		"Ribbon",
		"hide",
		nil,
		{})

	self.target = target
	self:updateState()

	peep:listen('actionPerformed', self.interrupt, self)
	peep:listen('walk', self.interrupt, self)
	peep:listen('receiveAttack', self.interrupt, self)
end

function SailorEquipmentController:poke(actionID, actionIndex, e)
	if actionID == "equip" then
		self:equip(e)
	elseif actionID == "dequip" then
		self:dequip(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function SailorEquipmentController:interrupt(peep, e)
	local action = (e or {}).action
	if not action or (not action:is("Equip") and not action:is("Dequip")) then
		self:getGame():getUI():closeInstance(self)
	end
end


function SailorEquipmentController:updateState()
	local result = { inventory = {}, equipment = {}, stats = {} }

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	if inventory then
		local broker = inventory.inventory:getBroker()
		if broker then
			for key in broker:keys(inventory.inventory) do
				for item in broker:iterateItemsByKey(inventory.inventory, key) do
					local resultItem = self:pullItem(item)
					resultItem.disabled = true
					self:pullActions(item, resultItem, 'inventory')

					for i = 1, #resultItem.actions do
						local action = resultItem.actions[i].instance
						if action:is("Equip") then
							resultItem.disabled = not action:canPerform(self.target:getState())
						end
					end

					result.inventory[key] = resultItem
					break
				end
			end
		end

		result.inventory.n = inventory.inventory:getMaxInventorySpace()
	end

	local equipment = self.target:getBehavior(EquipmentBehavior)
	if equipment and equipment.equipment then
		local broker = equipment.equipment:getBroker()
		for key in broker:keys(equipment.equipment) do
			for item in broker:iterateItemsByKey(equipment.equipment, key) do
				local resultItem = self:pullItem(item)
				self:pullActions(item, resultItem, 'equipment')

				if key == Equipment.PLAYER_SLOT_TWO_HANDED then
					key = Equipment.PLAYER_SLOT_RIGHT_HAND
				end
				
				result.equipment[key] = resultItem
				break
			end
		end

		for name, value in equipment.equipment:getStats() do
			result.stats[name] = value
		end

		result.equipment.n = #SailorEquipmentController.SLOTS
		result.equipment.slots = SailorEquipmentController.SLOTS
	end

	local actor = self.target:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		result.actor = actor.actor:getID()
		result.name = self.target:getName()
		result.level = self.target:getState():count("Skill", "Sailing", {
			['skill-as-level'] = true,
			['skill-unboosted'] = true
		})
	end

	self.state = result
end

function SailorEquipmentController:pull()
	return self.state
end

function SailorEquipmentController:pullItem(item)
	local result = {}
	result.id = item:getID()
	result.count = item:getCount()
	result.noted = item:isNoted()

	return result
end

function SailorEquipmentController:pullActions(item, serializedItem, scope)
	-- Noted items don't have actions.
	if item:isNoted() then
		serializedItem.actions = {}
		return
	end

	local gameDB = self:getDirector():getGameDB()
	local itemResource = gameDB:getResource(item:getID(), "Item")
	if itemResource then
		serializedItem.actions = Utility.getActions(
			self:getDirector():getGameInstance(),
			itemResource,
			scope,
			true)
	else
		serializedItem.actions = {}
	end
end

function SailorEquipmentController:close()
	Utility.UI.broadcast(
		self:getDirector():getGameInstance():getUI(),
		self:getPeep(),
		"Ribbon",
		"show",
		nil,
		{})

	self:getPeep():silence('actionPerformed', self.interrupt)
	self:getPeep():silence('walk', self.interrupt)
	self:getPeep():silence('receiveAttack', self.interrupt)
end

function SailorEquipmentController:equip(e)
	assert(type(e.index) == 'number', "index is not number")

	local item
	do
		local inventory = self:getPeep():getBehavior(InventoryBehavior)
		if inventory and inventory.inventory then
			local broker = inventory.inventory:getBroker()

			for i in broker:iterateItemsByKey(inventory.inventory, e.index) do
				item = i
				break
			end
		end
	end

	if not item then
		Log.error("no item at index %d", e.index)
		return false
	end

	local itemResource = self:getGame():getGameDB():getResource(item:getID(), "Item")
	if itemResource then
		local actions = Utility.getActions(
			self:getDirector():getGameInstance(),
			itemResource,
			scope)

		for i = 1, #actions do
			if actions[i].instance:is("Equip") then
				Utility.performAction(
					self:getGame(),
					itemResource,
					actions[i].instance:getAction().id.value,
					'inventory',
					self.target:getState(), self:getPeep(), item, self.target)
				break
			end
		end
	end
end

function SailorEquipmentController:dequip(e)
	assert(type(e.index) == 'number', "index is not number")

	local item
	do
		local equipment = self.target:getBehavior(EquipmentBehavior)
		if equipment and equipment.equipment then
			local broker = equipment.equipment:getBroker()

			for i in broker:iterateItemsByKey(equipment.equipment, e.index) do
				item = i
				break
			end
		end
	end

	if not item then
		Log.error("no item at index %d", e.index)
		return false
	end

	local itemResource = self:getGame():getGameDB():getResource(item:getID(), "Item")
	if itemResource then
		local actions = Utility.getActions(
			self:getDirector():getGameInstance(),
			itemResource,
			scope)

		for i = 1, #actions do
			if actions[i].instance:is("Dequip") then
				Utility.performAction(
					self:getGame(),
					itemResource,
					actions[i].instance:getAction().id.value,
					'equipment',
					self.target:getState(), self.target, item, self:getPeep())
				break
			end
		end
	end
end

function SailorEquipmentController:update(delta)
	Controller.update(delta)

	self:updateState()
end

return SailorEquipmentController
