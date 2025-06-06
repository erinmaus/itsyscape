--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_Tower_Floor4/Peep.lua
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
local Map = require "ItsyScape.Peep.Peeps.Map"
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"

local Tower = Class(Map)

function Tower:new(resource, name, ...)
	Map.new(self, resource, name or 'IsabelleIsland_Tower_Floor4', ...)

	self:addBehavior(MapOffsetBehavior)
end

function Tower:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	Utility.Map.spawnMap(self, "IsabelleIsland_Tower_Floor3", Vector.ZERO, { isLayer = true })

	local offset = self:getBehavior(MapOffsetBehavior)
	offset.offset = Vector(0, 12.3, 0)

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
		"DEBUG_TRIGGER_2", actionCallback, openCallback)
end

function Tower:onPlayCutscene()
	Utility.UI.closeAll(Utility.Peep.getPlayer(self))

	local cutscene = Utility.Map.playCutscene(self, "IsabelleIsland_Tower_Floor4_Debug", "StandardCutscene")
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
