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

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'OldGinsville_Test_Ash', 'Fungal', {
		gravity = { 0, -0.5, 0 },
		wind = { 1, -2, -1 },
		colors = {
			{ 0.1, 0.1, 0.1, 1.0 },
			{ 0.1, 0.1, 0.1, 1.0 },
			{ 0.1, 0.1, 0.1, 1.0 },
			{ 1.0, 0.4, 0.0, 1.0 },
			{ 1.0, 0.5, 0.0, 1.0 },
			{ 0.9, 0.4, 0.0, 0.0 },
		},
		minHeight = 20,
		maxHeight = 25,
		heaviness = 0.5,
		init = true
	})

	local _, skyMapScript = Utility.Map.spawnMap(self, "Test123_Draft", Vector.ZERO, { isLayer = true })
	local sky = skyMapScript:getBehavior(SkyBehavior)
	sky.daySkyColor = Color.fromHexString("1a1722")
	sky.dayAmbientColor = Color.fromHexString("1b1824", 0.6)
	sky.dawnSkyColor = Color.fromHexString("1a1722")
	sky.dawnAmbientColor = Color.fromHexString("1b1824", 0.6)
	sky.duskSkyColor = Color.fromHexString("1a1722")
	sky.duskAmbientColor = Color.fromHexString("1b1824", 0.6)
	sky.nightSkyColor = Color.fromHexString("1a1722")
	sky.nightAmbientColor = Color.fromHexString("1b1824", 0.6)
	sky.sunColor = Color.fromHexString("1b1824")
	sky.moonColor = Color.fromHexString("5b2626")

	sky.sunPropType = "Sun_Default"
end

function Ginsville:onPlayerEnter(player)
	player:pokeCamera("unlockPosition")
end

function Ginsville:onPlayerLeave(player)
	player:pokeCamera("unlockPosition")
end

return Ginsville
