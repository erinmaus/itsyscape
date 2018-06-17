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
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

local PlayerStanceController = Class(Controller)

function PlayerStanceController:new(peep, director)
	Controller.new(self, peep, director)
end

function PlayerStanceController:poke(actionID, actionIndex, e)
	if actionID == "setStance" then
		self:setStance(e)
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
			--print 'is weapon'
			result.style = logic:getStyle()
		else
			--print 'not weapon'
			result.style = Weapon.STYLE_MELEE
		end
	else
		--print 'no equippedItem'
		result.style = Weapon.STYLE_MELEE
	end

	local stance = self:getPeep():getBehavior(StanceBehavior)
	if stance then
		result.stance = stance.stance
		result.useSpell = stance.useSpell
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

return PlayerStanceController
