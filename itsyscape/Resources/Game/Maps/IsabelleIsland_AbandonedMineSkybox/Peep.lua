--------------------------------------------------------------------------------
-- Resources/Game/Maps/AbandonedMineSkybox/Peep.lua
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
local SkyBehavior = require "ItsyScape.Peep.Behaviors.SkyBehavior"

local AbandonedMineSkybox = Class(Map)

function AbandonedMineSkybox:new(...)
	Map.new(self, ...)

	local _, sky = self:addBehavior(SkyBehavior)
	sky.hasSky = false

	sky.dawnSkyColor = Color(0)
	sky.daySkyColor = Color(0)
	sky.duskSkyColor = Color(0)
	sky.nightSkyColor = Color(0)
	sky.previousSkyColor = sky.daySkyColor
	sky.currentSkyColor = sky.daySkyColor

	sky.dawnAmbientColor = Color(0)
	sky.dayAmbientColor = Color(0)
	sky.duskAmbientColor = Color(0)
	sky.nightAmbientColor = Color(0)
	sky.currentAmbientColor = sky.dayAmbientColor
end

return AbandonedMineSkybox
