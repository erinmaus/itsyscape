--------------------------------------------------------------------------------
-- ItsyScape/UI/PlayerStanceController.lua
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
local Weapon = require "ItsyScape.Game.Weapon"
local Controller = require "ItsyScape.UI.Controller"
local ActiveSpellBehavior = require "ItsyScape.Peep.Behaviors.ActiveSpellBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

local PlayerStanceController = Class(Controller)

function PlayerStanceController:new(peep, director)
	Controller.new(self, peep, director)
end

function PlayerStanceController:poke(actionID, actionIndex, e)
	if actionID == "setStance" then
		self:setStance(e)
	elseif actionID == "toggleSpell" then
		self:toggleSpell(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function PlayerStanceController:pull()
	local result = {}

	local equippedItem = Utility.Peep.getEquippedItem(self:getPeep(), Equipment.PLAYER_SLOT_RIGHT_HAND)
	if equippedItem then
		local logic = self:getDirector():getItemManager():getLogic(equippedItem:getID())
		if logic:isCompatibleType(Weapon) then
			result.style = logic:getStyle()
		else
			result.style = Weapon.STYLE_MELEE
		end
	else
		result.style = Weapon.STYLE_MELEE
	end

	local stance = self:getPeep():getBehavior(StanceBehavior)
	local spell = self:getPeep():getBehavior(ActiveSpellBehavior)
	if stance then
		result.stance = stance.stance

		if spell and spell.spell and result.style == Weapon.STYLE_MAGIC then
			result.useSpell = stance.useSpell
		else
			result.useSpell = false
		end
	else
		result.stance = false
		result.useSpell = false
	end

	return result
end

function PlayerStanceController:setStance(e)
	assert(type(e.stance) == "number", "stance must be number")

	if e.stance == Weapon.STANCE_AGGRESSIVE or
	   e.stance == Weapon.STANCE_CONTROLLED or
	   e.stance == Weapon.STANCE_DEFENSIVE
	then
		local stance = self:getPeep():getBehavior(StanceBehavior)
		if stance then
			stance.stance = e.stance
		end
	else
		error("expected STANCE_AGGRESSIVE, STANCE_CONTROLLED, or STANCE_DEFENSIVE")
	end
end

function PlayerStanceController:toggleSpell(e)
	local state = self:pull()

	local stance = self:getPeep():getBehavior(StanceBehavior)
	if stance then
		if state.style == Weapon.STYLE_MAGIC then
			stance.useSpell = not stance.useSpell
		else
			stance.useSpell = false
		end
	end
end

return PlayerStanceController
