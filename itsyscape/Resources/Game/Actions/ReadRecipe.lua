--------------------------------------------------------------------------------
-- Resources/Game/Actions/ReadRecipe.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local OpenInterfaceCommand = require "ItsyScape.UI.OpenInterfaceCommand"
local Action = require "ItsyScape.Peep.Action"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"

local ReadRecipe = Class(Action)
ReadRecipe.SCOPES = { ['inventory'] = true }
ReadRecipe.FLAGS = { ['item-inventory'] = true }

function ReadRecipe:perform(state, player, item)
	if not self:canPerform(state) then
		return false
	end

	local gameDB = self:getGameDB()
	local resource = gameDB:getResource(item:getID(), "Item")
	if not resource then
		return false
	end

	local open = OpenInterfaceCommand("RecipeCard", true, resource, self:getAction())
	local perform = CallbackCommand(Action.perform, self, state, player)

	local queue = player:getCommandQueue()
	return queue:interrupt(open) and queue:push(perform)
end

return ReadRecipe
