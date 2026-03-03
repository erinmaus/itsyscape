--------------------------------------------------------------------------------
-- Resources/Game/Maps/OldGinsville_Test/Peep.lua
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

local Ginsville = Class(MapScript)

function Ginsville:new(resource, name, ...)
	MapScript.new(self, resource, name or 'OldGinsville_Test', ...)
end

function Ginsville:onLoad(filename, args, layer)
	MapScript.onLoad(self, filename, args, layer)

	local _, skyMapScript = Utility.Map.spawnMap(self, "Test123_Draft", Vector.ZERO, { isLayer = true })
	local sky = skyMapScript:getBehavior(SkyBehavior)
	sky.daySkyColor = Color.fromHexString("5a3761")
	sky.dayAmbientColor = Color.fromHexString("eab51f", 0.6)
	sky.dawnSkyColor = Color.fromHexString("4f5699")
	sky.dawnAmbientColor = Color.fromHexString("eab51f", 0.6)
	sky.duskSkyColor = Color.fromHexString("5a3761")
	sky.duskAmbientColor = Color.fromHexString("eab51f", 0.6)
	sky.nightSkyColor = Color.fromHexString("2d334e")
	sky.nightAmbientColor = Color.fromHexString("eab51f", 0.5)
	sky.hasFog = true
	sky.fogNearDistance = 15
	sky.fogFarDistance = 125

	sky.sunPropType = "Sun_Default"
end

function Ginsville:onPlayerEnter(player)
	player:pokeCamera("unlockPosition")
end

function Ginsville:onPlayerLeave(player)
	player:pokeCamera("unlockPosition")
end

return Ginsville
