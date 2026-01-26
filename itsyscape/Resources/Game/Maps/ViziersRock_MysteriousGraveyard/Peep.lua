--------------------------------------------------------------------------------
-- Resources/Game/Maps/ViziersRock_MysteriousGraveyard/Peep.lua
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

local ViziersRockMysteriousGraveyard = Class(MapScript)

function ViziersRockMysteriousGraveyard:new(resource, name, ...)
	MapScript.new(self, resource, name or 'ViziersRockMysteriousGraveyard', ...)
end

function ViziersRockMysteriousGraveyard:onLoad(...)
	MapScript.onLoad(self, ...)

	local _, skyMapScript = Utility.Map.spawnMap(self, "Test123_Draft", Vector.ZERO, { isLayer = true })
	local sky = skyMapScript:getBehavior(SkyBehavior)
	sky.daySkyColor = Color.fromHexString("373e48")
	sky.dayAmbientColor = Color.fromHexString("b7bec8")
	sky.sunColor = Color.fromHexString("b380ff")
	sky.moonColor = Color.fromHexString("afdde9")
end

function ViziersRockMysteriousGraveyard:onPlayerEnter(player)
	player:pokeCamera("unlockPosition")
end

function ViziersRockMysteriousGraveyard:onPlayerLeave(player)
	player:pokeCamera("lockPosition")
end

return ViziersRockMysteriousGraveyard
