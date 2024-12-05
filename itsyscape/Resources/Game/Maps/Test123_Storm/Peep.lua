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

	sky.hasFog = true
	sky.fogFollowTarget = true

	sky.sunPropType = false
	sky.moonPropType = false

	local skyColor = Color.fromHexString("111111", 0.3)
	local worldColor = Color.fromHexString("2d2d55", 1)

	local lightColor = Color.fromHexString("255938")
	sky.sunColor = lightColor
	sky.moonColor = lightColor

	sky.dawnSkyColor = worldColor
	sky.daySkyColor = worldColor
	sky.duskSkyColor = worldColor
	sky.nightSkyColor = worldColor
	sky.previousSkyColor = worldColor
	sky.currentSkyColor = worldColor

	sky.dawnAmbientColor = worldColor
	sky.dayAmbientColor = worldColor
	sky.duskAmbientColor = worldColor
	sky.nightAmbientColor = worldColor
	sky.currentAmbientColor = worldColor

	sky.skyDawnAmbientColor = skyColor
	sky.skyDayAmbientColor = skyColor
	sky.skyDuskAmbientColor = skyColor
	sky.skyNightAmbientColor = skyColor
	sky.currentSkyAmbientColor = skyColor

	sky.cloudPropType = false
end

return TestMap
