--------------------------------------------------------------------------------
-- ItsyScape/UI/SkillGuideController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Controller = require "ItsyScape.UI.Controller"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local SkillGuideController = Class(Controller)

SkillGuideController.SKILL_GUIDE_ACTION_ICON_RESOURCE_TYPES = {
	item = true,
	prop = true,
	sailingcrew = true,
	peep = true,
	spell = true,
	effect = true,
	power = true,
	sailingItem = true
}

function SkillGuideController:new(peep, director, skill)
	Controller.new(self, peep, director)

	local game = director:getGameInstance()
	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()

	self.state = { actions = {} }
	self.actionsByID = {}
	self.skill = skill or false

	if self.skill then
		self.state.skill = self:pullSkill()

		local actionTypes = gameDB:getRecords("SkillAction", {
			Skill = gameDB:getResource(self.skill, "Skill")
		})

		local actionDefinition = Mapp.ActionDefinition()
		for i = 1, #actionTypes do
			if brochure:tryGetActionDefinition(actionTypes[i]:get("ActionType"), actionDefinition) then
				for action in brochure:findActionsByDefinition(actionDefinition) do
					local a, ActionType = Utility.getAction(game, action)
					if a then
						local action = a.instance:getAction()
						if not gameDB:getRecord("HiddenFromSkillGuide", { Action = action }) then
							table.insert(self.state.actions, self:pullSkillGuideAction(a.instance))
							self.actionsByID[a.id] = a
						end
					end
				end
			end
		end

		self:sort()
	end
end

function SkillGuideController:pullSkill()
	local skills = self:getPeep():getBehavior(StatsBehavior)
	skills = skills and skills.stats

	if not skills then
		return result
	end

	local skill = skills:getSkill(self.skill)

	local gameDB = self:getDirector():getGameDB()
	local s = gameDB:getResource(skill:getName(), "Skill")

	return {
		id = skill:getName(),
		name = Utility.getName(s, gameDB),
		description = Utility.getDescription(s, gameDB),
		xp = skill:getXP(),
		workingLevel = skill:getWorkingLevel(),
		baseLevel = skill:getBaseLevel(),
		xpNextLevel = math.max(Curve.XP_CURVE:compute(skill:getBaseLevel() + 1) - skill:getXP(), 0),
		xpPastCurrentLevel = skill:getXP() - Curve.XP_CURVE:compute(skill:getBaseLevel()),
		nextLevelXP = Curve.XP_CURVE:compute(skill:getBaseLevel() + 1) - Curve.XP_CURVE:compute(skill:getBaseLevel())
	}
end

function SkillGuideController:findActionXPRequirement(action)
	local gameDB = self:getDirector():getGameDB()
	local brochure = gameDB:getBrochure()
	for requirement in brochure:getRequirements(action) do
		local resource = brochure:getConstraintResource(requirement)
		local resourceType = brochure:getResourceTypeFromResource(resource)
		if resourceType.name:lower() == 'skill' and
		   resource.name:lower() == self.skill:lower()
		then
			return requirement.count
		end
	end

	return false
end

function SkillGuideController:findActionOutputXP(action)
	local gameDB = self:getDirector():getGameDB()
	local brochure = gameDB:getBrochure()
	for output in brochure:getOutputs(action) do
		local resource = brochure:getConstraintResource(output)
		local resourceType = brochure:getResourceTypeFromResource(resource)
		if resourceType.name:lower() == 'skill' and
		   resource.name:lower() == self.skill:lower()
		then
			return output.count
		end
	end

	return 0
end

function SkillGuideController:findActionResource(action)
	local gameDB = self:getDirector():getGameDB()
	local brochure = gameDB:getBrochure()
	for resource in brochure:findResourcesByAction(action) do
		return resource
	end

	return nil
end

function SkillGuideController:pullSkillGuideAction(action)
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
		action = { id = { value = action:getID() } },
		id = action:getID(),
		verb = action:getVerb() or action:getName(),
		item = item and item.name or false,
		quantity = quantity,
		resourceType = actionType,
		resourceID = actionResource.name,
		name = Utility.getName(actionResource, gameDB),
		description = Utility.getDescription(actionResource, gameDB)
	}
end

function SkillGuideController:sort()
	local index = 1
	while index <= #self.state.actions do
		local action = self.actionsByID[self.state.actions[index].id]
		if not self:findActionXPRequirement(action.instance:getAction()) then
			table.remove(self.state.actions, index)
			self.actionsByID[action.instance:getAction().id] = nil
		else
			index = index + 1
		end
	end

	table.sort(self.state.actions, function(a, b)
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
	end)
end

function SkillGuideController:poke(actionID, actionIndex, e)
	if actionID == "selectSkillAction" then
		self:selectSkillAction(e)
	elseif actionID == "steal" then
		self:steal(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function SkillGuideController:pull()
	local hasAmuletOfYendor = self:getPeep():getState():has("Item", "AmuletOfYendor", 1, {
		["item-inventory"] = true,
		["item-equipment"] = true,
		["item-bank"] = true,
	})

	return {
		hasAmuletOfYendor = hasAmuletOfYendor,
		skill = self.state.skill,
		actions = self.state.actions
	}
end

function SkillGuideController:selectSkillAction(e)
	assert(type(e.id) == "number", "action ID must be number")
	assert(self.actionsByID[e.id] ~= nil, "action with ID not found")

	local director = self:getDirector()
	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()

	local action = self.actionsByID[e.id].instance
	local result = Utility.getActionConstraints(self:getDirector():getGameInstance(), action:getAction())

	self:send("populateSkillGuideAction", self:pullSkillGuideAction(action), result)
end

function SkillGuideController:steal(e)
	assert((_DEBUG ~= nil and _DEBUG) or not self:getPeep():getState():has("Item", "AmuletOfYendor", 1, {
		["item-inventory"] = true,
		["item-equipment"] = true,
		["item-bank"] = true,
	}), "debug mode must be enabled to steal items")
	local count = e.count or 1

	local gameDB = self:getGame():getGameDB()
	local brochure = gameDB:getBrochure()

	local action = self.actionsByID[e.id]
	if not action then
		return
	end

	local state = self:getPeep():getState()

	for resource in brochure:findResourcesByAction(action.instance:getAction()) do
		local resourceType = brochure:getResourceTypeFromResource(resource)
		if resourceType.name == "Item" then
			state:give("Item", resource.name, count, { ['item-inventory'] = true, ['item-drop-excess'] = true })
		end
	end

	for requirement in brochure:getRequirements(action.instance:getAction()) do
		local requirementResource = brochure:getConstraintResource(requirement)
		local requirementType = brochure:getResourceTypeFromResource(requirementResource)

		if requirementType.name == "Item" then
			state:give("Item", requirementResource.name, (requirement.count or 1) * count, { ['item-inventory'] = true, ['item-drop-excess'] = true })
		end
	end

	for input in brochure:getInputs(action.instance:getAction()) do
		local inputResource = brochure:getConstraintResource(input)
		local inputType = brochure:getResourceTypeFromResource(inputResource)

		if inputType.name == "Item" then
			state:give("Item", inputResource.name, (input.count or 1) * count, { ['item-inventory'] = true, ['item-drop-excess'] = true })
		end
	end

	for output in brochure:getOutputs(action.instance:getAction()) do
		local outputResource = brochure:getConstraintResource(output)
		local outputType = brochure:getResourceTypeFromResource(outputResource)

		if outputType.name == "Item" then
			state:give("Item", outputResource.name, (output.count or 1) * count, { ['item-inventory'] = true, ['item-drop-excess'] = true })
		end
	end
end

return SkillGuideController
