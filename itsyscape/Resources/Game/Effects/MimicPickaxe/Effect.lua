--------------------------------------------------------------------------------
-- Resources/Game/Effects/MimicPickaxe/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local Effect = require "ItsyScape.Peep.Effect"

local MimicPickaxe = Class(Effect)

function MimicPickaxe:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function MimicPickaxe:mine(peep, action)
	local gameDB = peep:getDirector():getGameDB()
	local brochure = gameDB:getBrochure()

	for resource in brochure:findResourcesByAction(action:getAction()) do
		local resourceType = brochure:getResourceTypeFromResource(resource)

		local isProp = resourceType.name == "Prop"
		local gatherablePropMeta = isProp and gameDB:getRecord("GatherableProp", {
			Resource = resource
		})

		if gatherablePropMeta then
			local maxNumRolls = math.max(math.ceil(gatherablePropMeta:get("Health") / 20), 1)
			peep:getCommandQueue():push(CallbackCommand(self.collect, self, peep, maxNumRolls))
			return
		end
	end
end

function MimicPickaxe:collect(peep, maxNumRolls)
	local gameDB = peep:getDirector():getGameDB()

	local secondaryResourceActions = {}
	do
		local pickaxeResource = gameDB:getResource("MimicPickaxe", "Item")
		if not pickaxeResource then
			return
		end

		local actions = Utility.getActions(peep:getDirector():getGameInstance(), pickaxeResource, "make-action")
		for _, action in ipairs(actions) do
			table.insert(secondaryResourceActions, action.instance)
		end
	end

	local loot = {}
	local numRolls = love.math.random(1, maxNumRolls)
	for i = 1, numRolls do
		local action = secondaryResourceActions[love.math.random(#secondaryResourceActions)]
		loot[action] = (loot[action] or 0) + 1
	end

	for action, count in pairs(loot) do
		action:perform(peep:getState(), peep, count)
	end
end

function MimicPickaxe:checkAction(peep, e)
	local action = e.action
	if action and action:is("Mine") then
		self:mine(peep, e.action)
	end
end

function MimicPickaxe:enchant(peep)
	Effect.enchant(self, peep)

	self._actionPerformed = function(peep, e)
		self:checkAction(peep, e)
	end

	peep:listen("actionPerformed", self._actionPerformed)
end

function MimicPickaxe:sizzle()
	local peep = self:getPeep()
	peep:silence("actionPerformed", self._actionPerformed)

	Effect.sizzle(self)
end

return MimicPickaxe
