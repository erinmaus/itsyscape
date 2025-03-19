--------------------------------------------------------------------------------
-- ItsyScape/UI/GamepadRibbonController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Curve = require "ItsyScape.Game.Curve"
local Equipment = require "ItsyScape.Game.Equipment"
local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local GamepadRibbonController = Class(Controller)

GamepadRibbonController.TABS = {
	"inventory",
	"equipment",
	"skills",
	"settings"
}

GamepadRibbonController.SKILL_GUIDE_ACTION_ICON_RESOURCE_TYPES = {
	prop = true,
	sailingcrew = true,
	peep = true,
	spell = true,
	effect = true,
	power = true,
	sailingItem = true
}

function GamepadRibbonController:new(peep, director)
	Controller.new(self, peep, director)

	self.currentTab = false
	self.currentSkill = false

	self.actionsByID = {}
	self.actionsBySkill = {}

	self._sortSkillGuideFunc = function(a, b)
		a = self.actionsByID[a.id].instance:getAction()
		b = self.actionsByID[b.id].instance:getAction()

		local aReqXP, bReqXP = self:findActionXPRequirement(a), self:findActionXPRequirement(b)
		local aOutXP, bOutXP = self:findActionOutputXP(a), self:findActionOutputXP(b)
		local aResource, bResource = self:findActionResource(a), self:findActionResource(b)

		if aReqXP < bReqXP then
			return true
		elseif aReqXP == bReqXP then
			if aOutXP < bOutXP then
				return true
			elseif aOutXP == bOutXP then
				if aResource and bResource then
					return aResource.name < bResource.name
				else
					return a.id < b.id
				end
			end
		end

		return false
	end

	self.currentInventoryProbeIndex = false
	self.currentInventoryProbeItem = false
	self.currentEquipmentProbeIndex = false
	self.currentEquipmentProbeItem = false

	self.isOpen = false
end

function GamepadRibbonController:getProbedInventoryItem()
	return self.currentInventoryProbeItem, self.currentInventoryProbeIndex
end

function GamepadRibbonController:getProbedEquipmentItem()
	return self.currentEquipmentProbeItem, self.currentEquipmentProbeIndex
end

function GamepadRibbonController:getIsOpen()
	return self.isOpen
end

function GamepadRibbonController:pull()
	return {
		inventory = { items = self:pullInventory(), count = self:getInventorySpace() },
		equipment = { items = self:pullEquipment(), count = Equipment.PLAYER_SLOTS_MAX },
		skills = self:pullSkills(),
		stats = self:pullEquipmentStats()
	}
end

function GamepadRibbonController:getCurrentTab()
	return self.currentTab
end

function GamepadRibbonController:openTab(e)
	assert(type(e.tab) == "string", "tab must be string")
	assert(self.TABS[e.tab], "tab not permitted")

	self.currentTab = e.tab
end

function GamepadRibbonController:openRibbon()
	self.isOpen = true
end

function GamepadRibbonController:closeRibbon()
	self.isOpen = false
end

function GamepadRibbonController:poke(actionID, actionIndex, e)
	if actionID == "openTab" then
		self:openTab(e)
	elseif actionID == "open" then
		self:openRibbon(e)
	elseif actionID == "close" then
		self:closeRibbon(e)
	elseif actionID == "selectSkill" then
		self:selectSkillGuide(e)
	elseif actionID == "selectSkillAction" then
		self:selectSkillAction(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	elseif actionID == "swapInventoryItems" then
		self:swapInventoryItems(e)
	elseif actionID == "dropInventoryItem" then
		self:dropInventoryItem(e)
	elseif actionID == "pokeInventoryItem" then
		self:pokeInventoryItem(e)
	elseif actionID == "pokeEquipmentItem" then
		self:pokeEquipmentItem(e)
	elseif actionID == "probeInventoryItem" then
		self:probeInventoryItem(e)
	elseif actionID == "probeEquipmentItem" then
		self:probeEquipmentItem(e)
	elseif actionID == "spawn" then
		self:spawn(e)
	elseif actionID == "steal" then
		self:steal(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function GamepadRibbonController:selectSkillGuide(e)
	assert(type(e.skill) == "string", "skill is not number")

	local skillResource = gameDB:getResource(e.skill, "Skill")
	if not skillResource then
		Log.warn("Unknown skill: '%s'", e.skill)
		return
	end

	self:populateSkillGuide(skillResource)
	self:send("populateSkillGuide", self.actionsBySkill[e.skill])
end

function GamepadRibbonController:selectSkillAction(e)
	assert(type(e.id) == "number", "action ID must be number")
	assert(self.actionsByID[e.id] ~= nil, "action with ID not found")

	local director = self:getDirector()
	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()

	local action = self.actionsByID[e.id].instance:getAction()
	local result = Utility.getActionConstraints(self:getDirector():getGameInstance(), action)

	self:send("populateSkillGuideAction", result)
end

function GamepadRibbonController:pullSkillGuideAction(action)
	local director = self:getDirector()
	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()

	local item, quantity
	for output in brochure:getOutputs(action:getAction()) do
		local outputResource = brochure:getConstraintResource(output)
		local outputType = brochure:getResourceTypeFromResource(outputResource)
		if outputType.name:lower() == "item" then
			item = outputResource
			quantity = output.count
			break
		end
	end

	if not item then
		for input in brochure:getInputs(action:getAction()) do
			local inputResource = brochure:getConstraintResource(input)
			local inputType = brochure:getResourceTypeFromResource(inputResource)
			if inputType.name:lower() == "item" then
				item = inputResource
				quantity = input.count
				break
			end
		end
	end

	if not item then
		for resource in brochure:findResourcesByAction(action:getAction()) do
			local resourceType = brochure:getResourceTypeFromResource(resource)
			if resourceType.name:lower() == "item" then
				item = resource
				quantity = 1
				break
			end
		end
	end

	local actionType, actionResource
	for resource in brochure:findResourcesByAction(action:getAction()) do
		local resourceType = brochure:getResourceTypeFromResource(resource)

		if self.SKILL_GUIDE_ACTION_ICON_RESOURCE_TYPES[resourceType.name:lower()] then
			actionType = resourceType.name:lower()
			actionResource = resource
			break
		end
	end

	if not actionType then
		return nil
	end

	return {
		id = a.id,
		verb = action:getVerb() or action:getName(),
		item = item and item.name or false,
		quantity = quantity,
		resourceType = actionType,
		resourceID = actionResource.name,
		name = Utility.getName(actionResource, gameDB),
		description = Utility.getDescription(actionResource, gameDB)
	}
end

function GamepadRibbonController:populateSkillGuide(skill)
	if self.actionsBySkill[skill.name] then
		return
	end
	self.actionsBySkill[skill.name] = {}

	local actionTypes = gameDB:getRecords("SkillAction", {
		Skill = skillResource
	})

	local actionDefinition = Mapp.ActionDefinition()
	for _, actionType in ipairs(actionTypes) do
		if brochure:tryGetActionDefinition(actionType:get("ActionType"), actionDefinition) then
			for action in brochure:findActionsByDefinition(actionDefinition) do
				local a, ActionType = Utility.getAction(game, action)
				if a then
					local action = a.instance:getAction()
					if not gameDB:getRecord("HiddenFromSkillGuide", { Action = action }) then
						local result = self:pullSkillGuideAction(a.instance)
						if result then
							table.insert(self.actionsBySkill[skill.name], result)
							self.actionsByID[a.id] = a
						end
					end
				end
			end
		end
	end

	self:sortSkillGuide(skill)
end

function GamepadRibbonController:findActionXPRequirement(skillName, action)
	local gameDB = self:getDirector():getGameDB()
	local brochure = gameDB:getBrochure()
	for requirement in brochure:getRequirements(action) do
		local resource = brochure:getConstraintResource(requirement)
		local resourceType = brochure:getResourceTypeFromResource(resource)
		if resourceType.name:lower() == "skill" and
		   resource.name:lower() == skillName
		then
			return requirement.count
		end
	end

	return false
end

function GamepadRibbonController:findActionOutputXP(skillName, action)
	local gameDB = self:getDirector():getGameDB()
	local brochure = gameDB:getBrochure()
	for output in brochure:getOutputs(action) do
		local resource = brochure:getConstraintResource(output)
		local resourceType = brochure:getResourceTypeFromResource(resource)
		if resourceType.name:lower() == "skill" and
		   resource.name:lower() == skillName
		then
			return output.count
		end
	end

	return 0
end

function GamepadRibbonController:findActionResource(action)
	local gameDB = self:getDirector():getGameDB()
	local brochure = gameDB:getBrochure()
	for resource in brochure:findResourcesByAction(action) do
		return resource
	end

	return nil
end

function GamepadRibbonController:sortSkillGuide(skill)
	local actions = self.actionsBySkill[skill.name]

	for i = #actions, 1, -1 do
		local actionState = actions[i]
		local action = self.actionsByID[actionState.id]

		if not self:findActionXPRequirement(action.instance:getAction()) then
			self.actionsByID[action.instance:getAction().id] = nil
			table.remove(actions, index)
		end
	end

	table.sort(actions, self._sortSkillGuideFunc)
end

function GamepadRibbonController:swapInventoryItems(e)
	assert(type(e.a) == "number", "a is not number")
	assert(type(e.b) == "number", "b is not number")

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	inventory = inventory and inventory.inventory

	if not inventory then
		return
	end

	local broker = inventory:getBroker()
	if not broker then
		return
	end

	local item1
	for item in broker:iterateItemsByKey(inventory, e.a) do
		item1 = item
		break
	end

	local item2
	for item in broker:iterateItemsByKey(inventory, e.b) do
		item2 = item
		break
	end

	if item1 then
		broker:setItemKey(item1, e.b)
		broker:setItemZ(item1, e.b)
	end

	if item2 then
		broker:setItemKey(item2, e.a)
		broker:setItemZ(item2, e.a)
	end
end

function GamepadRibbonController:dropInventoryItem(e)
	assert(type(e.index) == "number", "index is not number")

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	inventory = inventory and inventory.inventory

	if not inventory then
		return
	end

	local broker = inventory:getBroker()
	if not broker then
		return
	end

	local item
	for i in broker:iterateItemsByKey(inventory, e.index) do
		item = i
		break
	end

	if item then
		local game = self.director:getGameInstance()
		game:getStage():dropItem(item, item:getCount())
	end
end

function GamepadRibbonController:pokeInventoryItem(e)
	assert(type(e.index) == "number", "index is not number")
	assert(type(e.id) == "number", "id is not number")

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	inventory = inventory and inventory.inventory

	if not inventory then
		return
	end

	local broker = inventory:getBroker()
	if not broker then
		return
	end

	local item
	for i in broker:iterateItemsByKey(inventory, e.index) do
		item = i
		break
	end

	if not item then
		Log.error("No item at index %d", e.index)
		return
	end

	local itemResource = self:getGame():getGameDB():getResource(item:getID(), "Item")
	if itemResource then
		Utility.performAction(
			self:getGame(),
			itemResource,
			e.id,
			"inventory",
			self:getPeep():getState(), self:getPeep(), item)
	end
end

function GamepadRibbonController:pokeEquipmentItem(e)
	assert(type(e.index) == "number", "index is not number")
	assert(type(e.id) == "number", "id is not number")

	local equipment = self:getPeep():getBehavior(EquipmentBehavior)
	equipment = equipment and equipment.equipment

	if not equipment then
		return items
	end

	local broker = equipment:getBroker()
	if not broker then
		return items
	end

	local item
	for i in broker:iterateItemsByKey(equipment, e.index) do
		item = i
		break
	end

	if not item and e.index == Equipment.PLAYER_SLOT_RIGHT_HAND then
		for i in broker:iterateItemsByKey(equipment, Equipment.PLAYER_SLOT_TWO_HANDED) do
			item = i
			break
		end
	end

	if not item then
		Log.error("No equipment in slot %d.", e.index)
		return
	end

	local itemResource = self:getGame():getGameDB():getResource(item:getID(), "Item")
	if itemResource then
		local success = Utility.performAction(
			self:getGame(),
			itemResource,
			e.id,
			"equipment",
			self:getPeep():getState(), self:getPeep(), item)

		if not success then
			Log.error(
				"Action #%d not successful on item '%s' at slot %d.",
				e.id,
				item:getID(),
				e.index)
		end
	end
end

function GamepadRibbonController:probeInventoryItem(e)
	if not e.index then
		self.currentInventoryProbeIndex = false
		self.currentInventoryProbeItem = false
		return
	end

	assert(type(e.index) == 'number', "index is not number")

	local item
	do
		local inventory = self:getPeep():getBehavior(InventoryBehavior)
		inventory = inventory and inventory.inventory

		if inventory then
			local broker = inventory:getBroker()

			if broker then
				for i in broker:iterateItemsByKey(inventory, e.index) do
					item = i
					break
				end
			end
		end
	end

	self.currentInventoryProbeIndex = e.index
	self.currentInventoryProbeItem = item
end

function GamepadRibbonController:probeEquipmentItem(e)
	if not e.index then
		self.currentEquipmentProbeIndex = false
		self.currentEquipmentProbeItem = false
		return
	end

	assert(type(e.index) == 'number', "index is not number")

	local index, item
	do
		local equipment = self:getPeep():getBehavior(EquipmentBehavior)
		equipment = equipment and equipment.equipment

		if equipment then
			local broker = equipment:getBroker()

			if broker then
				for i in broker:iterateItemsByKey(equipment, e.index) do
					index = e.index
					item = i
					break
				end

				if not item and e.index == Equipment.PLAYER_SLOT_RIGHT_HAND then
					for i in broker:iterateItemsByKey(equipment, Equipment.PLAYER_SLOT_TWO_HANDED) do
						index = Equipment.PLAYER_SLOT_TWO_HANDED
						item = i
						break
					end
				end
			end
		end
	end

	self.currentEquipmentProbeIndex = index
	self.currentEquipmentProbeItem = item
end

function GamepadRibbonController:pullItem(item, scope)
	local result = {}
	result.id = item:getID()
	result.count = item:getCount()
	result.noted = item:isNoted()
	result.name = Utility.Item.getInstanceName(item)
	result.description = Utility.Item.getInstanceDescription(item)
	result.stats = Utility.Item.getInstanceStats(item, self:getPeep())
	result.slot = Utility.Item.getSlot(item)
	self:pullActions(item, result, scope)

	return result
end

function GamepadRibbonController:pullActions(item, result, scope)
	if item:isNoted() then
		result.actions = {}
		return
	end

	local gameDB = self:getDirector():getGameDB()
	local itemResource = gameDB:getResource(item:getID(), "Item")
	if itemResource then
		result.actions = Utility.getActions(
			self:getDirector():getGameInstance(),
			itemResource,
			scope,
			true)
	else
		result.actions = {}
	end
end

function GamepadRibbonController:pullInventory()
	local items = {}

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	inventory = inventory and inventory.inventory

	if not inventory then
		return items
	end

	local broker = inventory:getBroker()
	if not broker then
		return items
	end

	for key in broker:keys(inventory) do
		for item in broker:iterateItemsByKey(inventory, key) do
			items[key] = self:pullItem(item, "inventory")
			break
		end
	end

	return items
end

function GamepadRibbonController:getInventorySpace()
	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	inventory = inventory and inventory.inventory

	if not inventory then
		return 0
	end

	local broker = inventory:getBroker()
	if not broker then
		return 0
	end

	return inventory:getMaxInventorySpace()
end

function GamepadRibbonController:pullEquipment()
	local items = {}

	local equipment = self:getPeep():getBehavior(EquipmentBehavior)
	equipment = equipment and equipment.equipment

	if not equipment then
		return items
	end

	local broker = equipment:getBroker()
	if not broker then
		return items
	end

	for key in broker:keys(equipment) do
		for item in broker:iterateItemsByKey(equipment, key) do
			if key == Equipment.PLAYER_SLOT_TWO_HANDED then
				key = Equipment.PLAYER_SLOT_RIGHT_HAND
			end

			items[key] = self:pullItem(item, "equipment")
			break
		end
	end

	return items
end

function GamepadRibbonController:pullSkills()
	local result = { skills = {}, totalLevel = 0, combatLevel = Utility.Combat.getCombatLevel(self:getPeep()) }

	local skills = self:getPeep():getBehavior(StatsBehavior)
	skills = skills and skills.skills

	if not skills then
		return result
	end

	for skill in skills:iterate() do
		local s = gameDB:getResource(skill:getName(), "Skill")

		result.totalLevel = result.totalLevel + skill:getBaseLevel()

		table.insert(result.skills, {
			name = Utility.getName(s, gameDB),
			description = Utility.getDescription(s, gameDB),
			xp = skill:getXP(),
			workingLevel = skill:getWorkingLevel(),
			baseLevel = skill:getBaseLevel(),
			xpNextLevel = math.max(Curve.XP_CURVE:compute(skill:getBaseLevel() + 1) - skill:getXP(), 0)
		})
	end
end

function GamepadRibbonController:pullEquipmentStats()
	local bonuses = Utility.Peep.getEquipmentBonuses(self:getPeep())

	local result = {}
	for i = 1, #EquipmentInventoryProvider.STATS do
		table.insert(result, {
			name = EquipmentInventoryProvider.STATS[i],
			value = bonuses[EquipmentInventoryProvider.STATS[i]]
		})
	end

	return result
end

function GamepadRibbonController:spawn(e)
	assert(_DEBUG ~= nil and _DEBUG, "debug mode must be enabled spawn item")

	local state = self:getPeep():getState()
	local success = state:give("Item", e.itemID, e.count or 1, { ['item-inventory'] = true, ['item-drop-excess'] = true })

	if success then
		Log.info("Spawned %d '%s' in the inventory of peep '%s' via skill guide debug cheat.", e.count or 1, e.itemID, self:getPeep():getName())
	end
end

function GamepadRibbonController:steal(e)
	assert(_DEBUG ~= nil and _DEBUG, "debug mode must be enabled to steal items")

	local gameDB = self:getGame():getGameDB()
	local brochure = gameDB:getBrochure()

	local action = self.actionsByID[e.id]
	if not action then
		return
	end

	local state = self:getPeep():getState()

	for requirement in brochure:getRequirements(action) do
		local requirementResource = brochure:getConstraintResource(requirement)
		local requirementType = brochure:getResourceTypeFromResource(requirementResource)

		if requirementType.name:lower() == "item" then
			state:give("Item", requirementResource.name, requirement.count or 1, { ['item-inventory'] = true, ['item-drop-excess'] = true })
		end
	end

	for input in brochure:getInputs(action) do
		local inputResource = brochure:getConstraintResource(input)
		local inputType = brochure:getResourceTypeFromResource(inputResource)

		if inputType.name:lower() == "item" then
			state:give("Item", inputResource.name, input.count or 1, { ['item-inventory'] = true, ['item-drop-excess'] = true })
		end
	end

	for output in brochure:getOutputs(action) do
		local outputResource = brochure:getConstraintResource(output)
		local outputType = brochure:getResourceTypeFromResource(outputResource)

		if outputType.name:lower() == "item" then
			state:give("Item", inputResource.name, output.count or 1, { ['item-inventory'] = true, ['item-drop-excess'] = true })
		end
	end
end

return GamepadRibbonController
