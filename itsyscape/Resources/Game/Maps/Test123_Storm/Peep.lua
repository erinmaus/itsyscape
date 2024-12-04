--------------------------------------------------------------------------------
-- Resources/Game/Maps/Test123_Storm/Peep.lua
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

local TestMap = Class(Map)

function TestMap:new(...)
	Map.new(self, ...)

	local _, sky = self:addBehavior(SkyBehavior)

	sky.sunPropType = false
	sky.moonPropType = false

	local color = Color.fromHexString("ffffff", 0.4)

	sky.dawnSkyColor = color
	sky.daySkyColor = color
	sky.duskSkyColor = color
	sky.nightSkyColor = color
	sky.previousSkyColor = color
	sky.currentSkyColor = color

	sky.dawnAmbientColor = color
	sky.dayAmbientColor = color
	sky.duskAmbientColor = color
	sky.nightAmbientColor = color
	sky.currentAmbientColor = color

	sky.cloudPropType = false
end

return TestMap
