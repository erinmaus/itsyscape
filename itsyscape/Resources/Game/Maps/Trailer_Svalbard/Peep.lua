--------------------------------------------------------------------------------
-- Resources/Game/Maps/Trailer_Svalbard/Peep.lua
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

local Svalbard = Class(Map)

function Svalbard:new(resource, name, ...)
	Map.new(self, resource, name or 'Trailer_Svalbard', ...)
end

function Svalbard:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Trailer_Svalbard_Base', 'Fungal', {
		gravity = { 0, -10, 0 },
		wind = { -6, 0, 0 },
		colors = {
			{ 1, 1, 1, 1 }
		},
		minHeight = 20,
		maxHeight = 25,
		heaviness = 0.25
	})

	self:prepareDebugCutscene()
end

function Svalbard:prepareDebugCutscene()
	local function actionCallback(action)
		if action == "pressed" then
			self:pushPoke('playCutscene')
		end
	end

	local function openCallback()
		return not self:wasPoofed()
	end

	Utility.UI.openInterface(
		Utility.Peep.getPlayer(self),
		"KeyboardAction",
		false,
		"DEBUG_TRIGGER_1", actionCallback, openCallback)
end

function Svalbard:onPlayCutscene()
	Utility.UI.closeAll(Utility.Peep.getPlayer(self))

	local cutscene = Utility.Map.playCutscene(self, "Trailer_Svalbard_Debug", "StandardCutscene")
	cutscene:listen('done', self.onFinishCutscene, self)
end

function Svalbard:onFinishCutscene()
	Utility.UI.openGroup(
		Utility.Peep.getPlayer(self),
		Utility.UI.Groups.WORLD)
end

return Svalbard
