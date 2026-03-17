--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_Tower2/Peep.lua
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

local Tower = Class(Map)

function Tower:onLoad(...)
	Map.onLoad(self, ...)

	local _, skyMapScript = Utility.Map.spawnMap(self, "Test123_Draft", Vector.ZERO, { isLayer = true })
	local sky = skyMapScript:getBehavior(SkyBehavior)
	sky.daySkyColor = Color.fromHexString("644296")
	sky.dayAmbientColor = Color.fromHexString("e9c8af")
	sky.sunColor = Color.fromHexString("b380ff")
	sky.moonColor = Color.fromHexString("afdde9")
end

return Tower
