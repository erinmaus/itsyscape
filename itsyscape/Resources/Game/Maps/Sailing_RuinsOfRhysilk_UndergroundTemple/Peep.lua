--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_RuinsOfRhysilk_UndergroundTemple/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

local Ruins = Class(Map)

function Ruins:new(resource, name, ...)
	Map.new(self, resource, name or 'RuinsOfRhysilk_UndergroundTemple', ...)
end

function Ruins:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Sailing_RuinsOfRhysilk_UndergroundTemple_Fungus', 'Fungal', {
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

return Ruins
