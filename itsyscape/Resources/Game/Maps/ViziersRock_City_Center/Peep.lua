--------------------------------------------------------------------------------
-- Resources/Game/Maps/ViziersRock_City_Center/Peep.lua
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
local MapScript = require "ItsyScape.Peep.Peeps.Map"
local SkyBehavior = require "ItsyScape.Peep.Behaviors.SkyBehavior"

local ViziersRockCityCenter = Class(MapScript)

function ViziersRockCityCenter:new(resource, name, ...)
	MapScript.new(self, resource, name or 'ViziersRockCityCenter', ...)
end

function ViziersRockCityCenter:onLoad(...)
	MapScript.onLoad(self, ...)

	local _, skyMapScript = Utility.Map.spawnMap(self, "Test123_Draft", Vector.ZERO, { isLayer = true })
	local sky = skyMapScript:getBehavior(SkyBehavior)
	sky.daySkyColor = Color.fromHexString("373e48")
	sky.dayAmbientColor = Color.fromHexString("b7bec8")
	sky.sunColor = Color.fromHexString("b380ff")
	sky.moonColor = Color.fromHexString("afdde9")
end

return ViziersRockCityCenter
