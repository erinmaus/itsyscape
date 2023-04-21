--------------------------------------------------------------------------------
-- ItsyScape/UI/PlayerPrayersController.lua
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
local Utility = require "ItsyScape.Game.Utility"
local ActiveSpellBehavior = require "ItsyScape.Peep.Behaviors.ActiveSpellBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local Controller = require "ItsyScape.UI.Controller"

local PlayerPrayersController = Class(Controller)

function PlayerPrayersController:new(peep, director)
	Controller.new(self, peep, director)

	self.prayers = {}
	self.state = self:getPrayerState()

	self.initialized = false
end

function PlayerPrayersController:poke(actionID, actionIndex, e)
	if actionID == "toggle" then
		self:toggle(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function PlayerPrayersController:getPrayerState()
	local result = { prayers = {} }
	do
		local game = self:getDirector():getGameInstance()
		local gameDB = self:getDirector():getGameDB()
		local brochure = gameDB:getBrochure()
		local resourceType = Mapp.ResourceType()
		brochure:tryGetResourceType("Effect", resourceType)

		local zValues = {}
		local index = 1
		for resource in brochure:findResourcesByType(resourceType) do
			local action
			do
				local actions = Utility.getActions(game, resource, 'prayer')
				if #actions >= 1 then
					action = actions[1].instance

					if not self.prayers[resource.name] then
						self.prayers[resource.name] = action
					end
				end
			end

			if action then
				local z = 0
				if action then
					for requirement in brochure:getRequirements(action:getAction()) do
						local resource = brochure:getConstraintResource(requirement)
						local resourceType = brochure:getResourceTypeFromResource(resource)
						if resourceType.name == "Skill" and resource.name == "Faith" then
							z = requirement.count
						end
					end
				end

				zValues[resource.name] = { z = Curve.XP_CURVE:getLevel(z), i = index }
				table.insert(result.prayers, {
					id = resource.name,
					name = Utility.getName(resource, gameDB),
					description = Utility.getDescription(resource, gameDB),
					level = Curve.XP_CURVE:getLevel(z),
					isActive = self:getPeep():getEffect(Utility.Peep.getEffectType(resource, gameDB)) ~= nil
				})

				index = index + 1
			end
		end

		table.sort(result.prayers, function(a, b)
			if math.floor(zValues[a.id].z) < math.floor(zValues[b.id].z) then
				return true
			elseif math.floor(zValues[a.id].z) == math.floor(zValues[b.id].z) then
				return zValues[a.id].i < zValues[b.id].i
			else
				return false
			end
		end)
	end

	return result
end

function PlayerPrayersController:pull()
	return self.state
end

function PlayerPrayersController:toggle(e)
	assert(self.prayers[e.prayer] ~= nil, "prayer not loaded")

	local prayer = self.prayers[e.prayer]
	prayer:perform(self:getPeep():getState(), self:getPeep())
end

function PlayerPrayersController:update(delta)
	Controller.update(delta)

	self.state = self:getPrayerState()
	if not self.initialized then
		self.initialized = true

		self:getDirector():getGameInstance():getUI():sendPoke(
			self,
			"setNumPrayers",
			nil,
			{ #self.state.prayers })
	end
end

return PlayerPrayersController
