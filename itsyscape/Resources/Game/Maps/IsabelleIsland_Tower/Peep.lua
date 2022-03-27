--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_Tower/Peep.lua
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

local Tower = Class(Map)

function Tower:new(resource, name, ...)
	Map.new(self, resource, name or 'Tower', ...)
end

function Tower:onLoad(...)
	Map.onLoad(self, ...)

	self:prepareDebugCutscene()
end

function Tower:prepareDebugCutscene()
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

function Tower:onPlayCutscene()
	Utility.UI.closeAll(Utility.Peep.getPlayer(self))

	local cutscene = Utility.Map.playCutscene(self, "IsabelleIsland_Tower_Debug", "StandardCutscene")
	cutscene:listen('done', self.onFinishCutscene, self)
end

function Tower:onFinishCutscene()
	Utility.UI.openGroup(
		Utility.Peep.getPlayer(self),
		Utility.UI.Groups.WORLD)
end

function Tower:onWriteLine(line)
	local _, _, ui = Utility.UI.openInterface(
		Utility.Peep.getPlayer(self),
		"DramaticText",
		false,
		{ line })
end

return Tower
