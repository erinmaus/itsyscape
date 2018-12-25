--------------------------------------------------------------------------------
-- Resources/Game/Actions/Cook.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local Make = require "Resources.Game.Actions.Make"

local Cook = Class(Make)
Cook.DURATION = 0.4
Cook.SCOPES = { ['craft'] = true }
Cook.FLAGS = { ['item-inventory'] = true }

function Cook:perform(state, player, target)
	if target:wasPoofed() then
		local queue = player:getCommandQueue()
		queue:clear()

		Log.info("Prop '%s' was poofed, cannot cook on air.", target:getName())

		return false
	end

	if self:canPerform(state) and self:canTransfer(state) then
		local gameDB = self:getGameDB()
		local failure = gameDB:getRecord("CookingFailedAction", {
			Action = self:getAction()
		})

		local cook
		if failure then
			cook = CallbackCommand(self.cook, self, state, player, failure, target)
		else
			cook = CallbackCommand(self.succeed, self, state, player)
		end

		local wait = WaitCommand(self.DURATION)

		local perform = CallbackCommand(Action.perform, self, state, player)

		local queue = player:getCommandQueue()
		return queue:push(CompositeCommand(nil, wait, cook, perform))
	end
end

function Cook:cook(state, player, failure, target)
	local tier
	do
		local rangeTier = Utility.Peep.getTier(target)
		local cookingTier = state:count("Skill", "Cooking", { ['skill-as-level'] = true })

		tier = math.max(rangeTier, cookingTier)
	end

	local chance
	do
		local start, stop = failure:get("Start"), failure:get("Stop")
		local width = stop - start
		local difference = tier - start
		if difference >= width then
			chance = 0.01
		else
			chance = math.max(math.min(2 ^ -(difference + 1), 1.0), 0.01)
		end

		Log.info("Chance of burning food: %d%%.", chance * 100)
	end

	local r = math.random()
	if r <= chance then
		self:fail(state, player, failure:get("Output"))
	else
		self:succeed(state, player)
	end
end

function Cook:fail(state, player, action)
	local a = Utility.getAction(self:getGame(), action)
	if a then
		a.instance:transfer(state, player)
	end
end

function Cook:succeed(state, player)
	if not self:transfer(state, player) then
		player:getCommandQueue():clear()
	end
end

return Cook
