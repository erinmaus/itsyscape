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
local Curve = require "ItsyScape.Game.Curve"
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Spell = require "ItsyScape.Game.Spell"
local CombatSpell = require "ItsyScape.Game.CombatSpell"
local InterfaceSpell = require "ItsyScape.Game.InterfaceSpell"
local Utility = require "ItsyScape.Game.Utility"
local ActiveSpellBehavior = require "ItsyScape.Peep.Behaviors.ActiveSpellBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
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

		local activeSpellID
		do
			local activeSpell = self:getPeep():getBehavior(ActiveSpellBehavior)
			if activeSpell and activeSpell.spell then
				activeSpellID = activeSpell.spell:getID()
			end
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
			local items = {}
			local z = 0
			if action then
				for requirement in brochure:getRequirements(action) do
					local resource = brochure:getConstraintResource(requirement)
					local resourceType = brochure:getResourceTypeFromResource(resource)
					if resourceType.name == "Skill" and resource.name == "Magic" then
						z = requirement.count
					end
				end

				for input in brochure:getInputs(action) do
					local resource = brochure:getConstraintResource(input)
					local resourceType = brochure:getResourceTypeFromResource(resource)

					if resourceType.name == "Item" then
						local item = {
							count = input.count,
							name = Utility.getName(resource, gameDB)
						}

						table.insert(items, item)
					end
				end
			end

			zValues[resource.name] = z
			table.insert(result.spells, {
				enabled = spell:canCast(self:getPeep()):good(),
				active = activeSpellID == spell:getID(),
				id = resource.name,
				name = Utility.getName(resource, gameDB),
				description = Utility.getDescription(resource, gameDB),
				level = Curve.XP_CURVE:getLevel(z),
				items = items
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
	local peep = self:getPeep()
	if spell:isCompatibleType(CombatSpell) then
		local s, b = peep:addBehavior(ActiveSpellBehavior)
		if s then
			b.spell = self.spells[e.spell]
		end

		local equippedItem = Utility.Peep.getEquippedItem(self:getPeep(), Equipment.PLAYER_SLOT_RIGHT_HAND)
		if equippedItem then
			local logic = self:getDirector():getItemManager():getLogic(equippedItem:getID())
			if logic:isCompatibleType(Weapon) then
				if logic:getStyle() == Weapon.STYLE_MAGIC then
					local s, b = peep:addBehavior(StanceBehavior)
					if s then
						b.useSpell = true
					end
				end
			end
		end
	elseif spell:isCompatibleType(InterfaceSpell) then
		local result = spell:canCast(peep)
		if result:good() then
			spell:cast(peep)
		else
			local action = Utility.getAction(self:getDirector():getGameInstance(), spell:getAction())
			action.instance:fail(peep:getState(), peep)
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
