--------------------------------------------------------------------------------
-- Resources/Game/Maps/Trailer_Antilogika/Peep.lua
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

local Trailer = Class(Map)

function Trailer:new(resource, name, ...)
	Map.new(self, resource, name or 'Trailer_Antilogika', ...)
end

function Trailer:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Trailer_Antilogika', 'Fungal', {
		gravity = { 0, -1, 0 },
		wind = { -1, 0, 0 },
		colors = {
			{ 0.43, 0.54, 0.56, 1.0 },
			{ 0.63, 0.74, 0.76, 1.0 }
		},
		minHeight = 12,
		maxHeight = 20,
		heaviness = 0.25
	})
end

function Trailer:onPlayerEnter(player)
	self:prepareDebugCutscene(player:getActor():getPeep())
end

function Trailer:prepareDebugCutscene(player)
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

function Trailer:onPlayCutscene(player)
	Utility.UI.closeAll(player)

	local cutscene = Utility.Map.playCutscene(self, "Trailer_Antilogika_Debug", "StandardCutscene")
	cutscene:listen('done', self.onFinishCutscene, self, player)
end

function Trailer:onFinishCutscene(player)
	Utility.UI.openGroup(
		player,
		Utility.UI.Groups.WORLD)
end

return Trailer
