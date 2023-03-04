--------------------------------------------------------------------------------
-- Resources/Game/Maps/Rumbridge_Castle_Basement_YeastBeastLair/Peep.lua
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

local Lair = Class(Map)

function Lair:new(resource, name, ...)
	Map.new(self, resource, name or 'Rumbridge_Castle_Basement_YeastBeastLair', ...)
end

function Lair:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)
end

function Lair:initMites()
	local map = self:getDirector():getMap(self:getLayer())
	if not map then
		return
	end

	self.yeastMites = {}
	for i = 1, 20 do
		local position = map:getTileCenter(math.random(1, map:getWidth()), math.random(1, map:getHeight()))
		local yeastMite = Utility.spawnActorAtPosition(self, "YeastMite", position:get())

		table.insert(self.yeastMites, yeastMite)
	end
end

function Lair:onAttack(player)
	for i = 1, #self.yeastMites do
		Utility.Peep.attack(self.yeastMites[i]:getPeep(), player, math.huge)
	end
end

function Lair:onPlayerEnter(player)
	self:prepareDebugCutscene(player:getActor():getPeep())
end

function Lair:prepareDebugCutscene(player)
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

function Lair:onPlayCutscene(player)
	Utility.UI.closeAll(player)

	self:initMites()

	local cutscene = Utility.Map.playCutscene(self, "Rumbridge_Castle_Basement_YeastBeastLair_Debug", "StandardCutscene")
	cutscene:listen('done', self.onFinishCutscene, self, player)
end

function Lair:onFinishCutscene(player)
	Utility.UI.openGroup(
		player,
		Utility.UI.Groups.WORLD)

	for i = 1, #self.yeastMites do
		Utility.Peep.poof(self.yeastMites[i]:getPeep())
	end
end

return Lair
