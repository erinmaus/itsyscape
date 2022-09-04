--------------------------------------------------------------------------------
-- Resources/Game/Maps/Rumbridge_Castle_CaveFloor1/Peep.lua
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

local RumbridgeCave = Class(Map)

function RumbridgeCave:new(resource, name, ...)
	Map.new(self, resource, name or 'Rumbridge_Castle_CaveFloor1', ...)
end

function RumbridgeCave:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Rumbridge_Castle_CaveFloor1_Ash', 'Fungal', {
		gravity = { 0, -0.5, 0 },
		wind = { -1, -1, 0 },
		colors = {
			{ 0.1, 0.1, 0.1, 1.0 },
			{ 1.0, 0.1, 0.1, 1.0 }
		},
		minHeight = 20,
		maxHeight = 25,
		heaviness = 0.25
	})
end

function RumbridgeCave:onPlayerEnter(player)
	self:prepareDebugCutscene(player:getActor():getPeep())
end

function RumbridgeCave:prepareDebugCutscene(player)
	local function actionCallback(action)
		if action == "pressed" then
			self:pushPoke('playCutscene', player)
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

function RumbridgeCave:onPlayCutscene(player)
	Utility.UI.closeAll(player)

	local cutscene = Utility.Map.playCutscene(self, "Rumbridge_Castle_CaveFloor1_Debug", "StandardCutscene")
	cutscene:listen('done', self.onFinishCutscene, self, player)
end

function RumbridgeCave:onFinishCutscene(player)
	Utility.UI.openGroup(
		player,
		Utility.UI.Groups.WORLD)
end

return RumbridgeCave
