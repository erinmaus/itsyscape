--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_FarOcean_Cutscene/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Cutscene = require "ItsyScape.Game.Cutscene"
local Map = require "ItsyScape.Peep.Peeps.Map"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local FarOcean = Class(Map)

function FarOcean:new(resource, name, ...)
	Map.new(self, resource, name or 'IsabelleIsland_FarOcean_Cutscene', ...)
end

function FarOcean:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local s = Utility.spawnMapAtAnchor(self, "Ship_IsabelleIsland_Pirate", "Anchor_Ship_Spawn")
	s:listen('ready', function()
		self.cutscene = Cutscene(
			self:getDirector():getGameDB():getResource("IsabelleIsland_FarOcean_Sink", "Cutscene"),
			Utility.Peep.getPlayer(self),
			self:getDirector(),
			self:getLayerName())
	end)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'IsabelleIsland_FarOcean_Cutscene_Bubbles', 'Fungal', {
		gravity = { 0, 3, 0 },
		wind = { 3, 0, 0 },
		colors = {
			{ 0.3, 0.3, 0.6, 0.5 }
		},
		minHeight = -10,
		maxHeight = 0,
		ceiling = 20,
		heaviness = 0.5
	})
end

function FarOcean:update(...)
	Map.update(self, ...)
	if self.cutscene then
		self.cutscene:update()
	end
end

return FarOcean
