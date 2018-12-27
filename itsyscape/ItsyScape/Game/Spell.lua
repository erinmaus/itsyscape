--------------------------------------------------------------------------------
-- ItsyScape/Game/Spell.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ActionResult = require "ItsyScape.Game.ActionResult"

local Spell = Class()

function Spell:new(id, game)
	self.id = id
	self.game = game

	self.resource = game:getGameDB():getResource(id, "Spell") or false
	if self.resource then
		self.action = false
		local brochure = game:getGameDB():getBrochure()
		for action in brochure:findActionsByResource(self.resource) do
			local actionType = brochure:getActionDefinitionFromAction(action)
			if actionType.name == "Cast" then
				self.action = action
				break
			end
		end
	end
end

function Spell:getID()
	return self.id
end

function Spell:getResource()
	return self.resource
end

function Spell:getAction()
	return self.action
end

function Spell:getGame()
	return self.game
end

function Spell:consume(peep)
	if not self.resource or not self.action then
		return false
	end

	local flags = { ['item-inventory'] = true, ['item-equipment'] = true }
	local state = peep:getState()

	local gameDB = self.game:getGameDB()
	local brochure = gameDB:getBrochure()
	for input in brochure:getInputs(self.action) do
		local resource = brochure:getConstraintResource(input)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		state:take(resourceType.name, resource.name, input.count, flags)
	end

	return true
end

function Spell:transfer(peep)
	if not self.resource or not self.action then
		return false
	end

	local flags = {}
	local state = peep:getState()

	local gameDB = self.game:getGameDB()
	local brochure = gameDB:getBrochure()
	for output in brochure:getOutputs(self.action) do
		local resource = brochure:getConstraintResource(output)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		state:give(resourceType.name, resource.name, output.count, flags)
	end

	return true
end

function Spell:canCast(peep)
	local result = ActionResult(self.game:getGameDB())

	if not self.resource or not self.action then
		result:fail()
		return result
	end

	local success = false

	local inputFlags = { ['item-inventory'] = true, ['item-equipment'] = true }
	local requirementFlags = { ['item-equipment'] = true }
	local state = peep:getState()
	local gameDB = self.game:getGameDB()
	local brochure = gameDB:getBrochure()

	for input in brochure:getInputs(self.action) do
		local resource = brochure:getConstraintResource(input)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		if not state:has(resourceType.name, resource.name, input.count, inputFlags) then
			-- TODO: Custom callback
			result:addMissing(resource, input.count)
		end
	end

	for requirement in brochure:getRequirements(self.action) do
		local resource = brochure:getConstraintResource(requirement)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		if not state:has(resourceType.name, resource.name, requirement.count, requirementFlags) then
			-- TODO: Custom callback
			result:addMissing(resource, requirement.count)
		end
	end

	return result
end

function Spell:cast(...)
	-- Nothing.
end

return Spell
