--------------------------------------------------------------------------------
-- Resources/Game/Actions/OpenInventoryCraftWindow.lua
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

local OpenInventoryCraftWindow = Class(Action)
OpenInventoryCraftWindow.SCOPES = { ['inventory'] = true }

function OpenInventoryCraftWindow:perform(state, player, item)
	local game = self:getGame()
	local gameDB = game:getGameDB()
	local target = gameDB:getRecords("DelegatedActionTarget", { Action = self:getAction() })[1]
	if target then
		local key = target:get("CategoryKey")
		if key == "" then
			key = nil
		end

		local value = target:get("CategoryValue")
		if value == "" then
			value = nil
		end

		local open = OpenInterfaceCommand("CraftWindow", true, prop, key, value, target:get("ActionType"))
		local perform = CallbackCommand(Action.perform, self, state, player)

		local queue = player:getCommandQueue()
		return queue:interrupt(open) and queue:push(perform)
	end
end

return OpenInventoryCraftWindow
