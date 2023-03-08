--------------------------------------------------------------------------------
-- Resources/Game/Maps/Test123/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"

local TestMap = Class(Map)

function TestMap:onPlayerEnter(player)
	player = player:getActor():getPeep()

	local function actionCallback(action)
		if action == "pressed" then
			Utility.Map.playCutscene(self, "Test123_Skilling", "StandardCutscene", player)
		end
	end

	local function openCallback()
		return not self:wasPoofed()
	end

	Utility.UI.openInterface(
		player,
		"KeyboardAction",
		false,
		"DEBUG_TRIGGER_1", actionCallback, openCallback)
end

return TestMap
