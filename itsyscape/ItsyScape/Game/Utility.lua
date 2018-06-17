--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Color = require "ItsyScape.Graphics.Color"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"

-- Contains utility methods for a variety of purposes.
--
-- These methods can be used on both the client and server. They should not load
-- any resources.
local Utility = {}

function Utility.performAction(game, resource, id, scope, ...)
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()
	local foundAction = false
	for action in brochure:findActionsByResource(resource) do
		if action.id.value == id then
			local definition = brochure:getActionDefinitionFromAction(action)
			local typeName = string.format("Resources.Game.Actions.%s", definition.name)
			local s, r = pcall(require, typeName)
			if not s then
				Log.error("failed to load action %s: %s", typeName, r)
			else
				local ActionType = r
				if ActionType.SCOPES and ActionType.SCOPES[scope] then
					local a = ActionType(game, action)
					a:perform(...)

					foundAction = true
				else
					Log.error(
						"action %s cannot be performed from inventory (on item %s @ %d)",
						typeName,
						item:getID(),
						e.index)
				end
			end
		end
	end

	return foundAction
end

function Utility.getActions(game, resource, scope)
	local actions = {}
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()
	for action in brochure:findActionsByResource(resource) do
		local definition = brochure:getActionDefinitionFromAction(action)
		local typeName = string.format("Resources.Game.Actions.%s", definition.name)
		local s, r = pcall(require, typeName)
		if not s then
			Log.error("failed to load action %s: %s", typeName, r)
		else
			local ActionType = r
			if ActionType.SCOPES and ActionType.SCOPES[scope] then
				local a = ActionType(game, action)
				local t = {
					id = action.id.value,
					type = definition.name,
					verb = a:getVerb() or a:getName()
				}

				table.insert(actions, t)
			end
		end
	end

	return actions
end

-- Contains utility methods to deal with items.
Utility.Item = {}

-- Gets the shorthand count and color for 'count' using 'lang'.
--
-- 'lang' defaults to "en-US".
--
-- Values
--  * Under 100,000 remain as-is.
--  * Up to a million are divided by 100,000 and suffixed with a 'k' specifier.
--  * Up to a billion are divided by the same and suffixed with an 'm' specifier.
--  * Up to a trillion are divided by the same and suffixed with an 'b' specifier.
--  * Up to a quadrillion are divided by the same and suffixed with an 'q' specifier.
--
-- Values are floored. Thus 100,999 becomes '100k' (or whatever it may be in
-- 'lang').
function Utility.Item.getItemCountShorthand(count, lang)
	lang = lang or "en-US"
	-- 'lang' is NYI.

	local HUNDRED_THOUSAND = 100000
	local MILLION          = 1000000
	local BILLION          = 1000000000
	local TRILLION         = 1000000000000
	local QUADRILLION      = 1000000000000000

	local text, color
	if count >= QUADRILLION then
		text = string.format("%dq", count / QUADRILLION)
		color = { 1, 0, 1, 1 }
	elseif count >= TRILLION then
		text = string.format("%dt", count / TRILLION)
		color = { 0, 1, 1, 1 }
	elseif count >= BILLION then
		text = string.format("%db", count / BILLION)
		color = { 1, 0.5, 0, 1 }
	elseif count >= MILLION then
		text = string.format("%dm", count / MILLION)
		color = { 0, 1, 0.5, 1 }
	elseif count >= HUNDRED_THOUSAND then
		text = string.format("%dk", count / HUNDRED_THOUSAND * 100)
		color = { 1, 1, 1, 1 }
	else
		text = string.format("%d", count)
		color = { 1, 1, 0, 1 }
	end

	return text, color
end

function Utility.Item.getName(id, gameDB, lang)
	lang = lang or "en-US"

	local itemResource = gameDB:getResource(id, "Item")
	local nameRecord = gameDB:getRecords("ResourceName", { Resource = itemResource, Language = "en-US" }, 1)[1]
	if nameRecord then
		return nameRecord:get("Value")
	else
		return false
	end
end

Utility.Peep = {}
function Utility.Peep.getEquippedItem(peep, slot)
	local equipment = peep:getBehavior(EquipmentBehavior)
	if equipment and equipment.equipment then
		equipment = equipment.equipment
		return equipment:getEquipped(slot)
	end
end

return Utility
