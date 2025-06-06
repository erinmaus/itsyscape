--------------------------------------------------------------------------------
-- Resources/Game/Maps/Trailer_Insanitorium2/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Map = require "ItsyScape.Peep.Peeps.Map"

local Trailer = Class(Map)

function Trailer:new(resource, name, ...)
	Map.new(self, resource, name or 'Trailer_Insanitorium2', ...)
end

function Trailer:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Trailer_Insanitorium2_Bubbles', 'Fungal', {
		gravity = { 0, -1, 0 },
		wind = { 0, 0, 0 },
		colors = {
			{ Color.fromHexString("00f3ff"):get() },
			{ Color.fromHexString("00f3ff"):get() },
			{ Color.fromHexString("00c1c6"):get() }
		},
		minHeight = 2,
		maxHeight = 8,
		ceiling = 20,
		heaviness = 0.5
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

	local cutscene = Utility.Map.playCutscene(self, "Trailer_Insanitorium2_Debug", "StandardCutscene")
	cutscene:listen('done', self.onFinishCutscene, self, player)
end

function Trailer:onFinishCutscene(player)
	Utility.UI.openGroup(
		player,
		Utility.UI.Groups.WORLD)
end

return Trailer
