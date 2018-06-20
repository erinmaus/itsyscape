--------------------------------------------------------------------------------
-- ItsyScape/UI/PlayerSpellsController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Spell = require "ItsyScape.Game.Spell"
local CombatSpell = require "ItsyScape.Game.CombatSpell"
local Utility = require "ItsyScape.Game.Utility"
local ActiveSpellBehavior = require "ItsyScape.Peep.Behaviors.ActiveSpellBehavior"
local Controller = require "ItsyScape.UI.Controller"

local PlayerSpellsController = Class(Controller)

function PlayerSpellsController:new(peep, director)
	Controller.new(self, peep, director)

	self.spells = {}
	self.state = self:getSpellState()

	self.initialized = false
end

function PlayerSpellsController:poke(actionID, actionIndex, e)
	if actionID == "cast" then
		self:cast(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function PlayerSpellsController:getSpellState()
	local result = { spells = {} }
	do
		local gameDB = self:getDirector():getGameDB()
		local brochure = gameDB:getBrochure()
		local resourceType = Mapp.ResourceType()
		brochure:tryGetResourceType("Spell", resourceType)

		local activeSpell = self:getPeep():getBehavior(ActiveSpellBehavior)
		if activeSpell then
			activeSpell = activeSpell.spell
		end

		local zValues = {}
		for resource in brochure:findResourcesByType(resourceType) do
			local spell = self.spells[resource.name]
			if not spell then
				local TypeName = string.format("Resources.Game.Spells.%s.Spell", resource.name)
				local Type = require(TypeName)
				spell = Type(resource.name, self:getGame())
				self.spells[resource.name] = spell
			end

			local action = spell:getAction()
			local z = 0
			if action then
				for requirement in brochure:getRequirements(action) do
					local resource = brochure:getConstraintResource(requirement)
					local resourceType = brochure:getResourceTypeFromResource(resource)
					if resourceType.name == "Skill" and resource.name == "Magic" then
						z = requirement.count
					end
				end
			end

			zValues[resource.name] = z
			table.insert(result.spells, {
				enabled = spell:canCast(self:getPeep()):good(),
				active = activeSpell == spell,
				id = resource.name
			})
		end

		table.sort(result.spells, function(a, b) return zValues[a.id] < zValues[b.id] end)
	end

	return result
end

function PlayerSpellsController:pull()
	return self.state
end

function PlayerSpellsController:cast(e)
	assert(self.spells[e.spell] ~= nil, "spell not loaded")

	local spell = self.spells[e.spell]
	if spell:isCompatibleType(CombatSpell) then
		local peep = self:getPeep()
		local s, b = peep:addBehavior(ActiveSpellBehavior)
		if s then
			b.spell = self.spells[e.spell]
		end
	else
		Log.warn("cannot cast spell '%s': not yet implemented", e.spell)
	end
end

function PlayerSpellsController:update(delta)
	Controller.update(delta)

	self.state = self:getSpellState()
	if not self.initialized then
		self.initialized = true

		self:getDirector():getGameInstance():getUI():sendPoke(
			self,
			"setNumSpells",
			nil,
			{ #self.state.spells })
	end
end

return PlayerSpellsController
