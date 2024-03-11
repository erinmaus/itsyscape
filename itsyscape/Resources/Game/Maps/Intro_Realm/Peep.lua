--------------------------------------------------------------------------------
-- Resources/Game/Maps/Intro_Realm/Peep.lua
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
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local Map = require "ItsyScape.Peep.Peeps.Map"

local Intro = Class(Map)
Intro.MAPS = {
	"Rumbridge_Town_Center",
	"ViziersRock_Town_Center",
	"EmptyRuins_DragonValley_Ginsville",
	"EmptyRuins_Downtown",
	"Rumbridge_Castle_Floor1"
}

function Intro:new(resource, name, ...)
	Map.new(self, resource, name or 'Intro_Realm', ...)
	self:silence('playerEnter', Map.showPlayerMapInfo)
end

function Intro:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	self:initCutscene()
end

function Intro:initCutscene()
	local mapScript
	for _, mapResource in ipairs(Intro.MAPS) do
		mapScript = Utility.spawnMapAtAnchor(self, mapResource, "Anchor_SpawnMap_Center", { cutscene = true })
	end

	mapScript:listen("load", function()
		self:pushPoke("disableMaps")
	end)
end

function Intro:onPlayerEnter(player)
end

function Intro:onDisableMaps()
	local instance = Utility.Peep.getInstance(self)

	local continue = false
	for _, layer in instance:iterateLayers() do
		local mapScript = instance:getMapScriptByLayer(layer)
		local isDisabled = not mapScript or mapScript:hasBehavior(DisabledBehavior)

		if layer ~= self:getLayer() and not isDisabled then
			mapScript:addBehavior(DisabledBehavior)
			continue = true
		end
	end

	if continue then
		self:pushPoke("disableMaps")
	else
		self:pushPoke("playStartCutscene", Utility.Peep.getPlayer(self))
	end
end

function Intro:onPlayStartCutscene(playerPeep)
	if playerPeep then
		Utility.UI.closeAll(playerPeep, nil, { "CutsceneTransition", "DramaticText" })

		local mapScript = Utility.Peep.getInstance(self):getMapScriptByMapFilename("EmptyRuins_Downtown")
		mapScript:pushPoke("prepareCutscene", playerPeep)
	end
end

function Intro:onPlayCutscene(playerPeep)
	Utility.Map.playCutscene(self, "Intro_Realm", "StandardCutscene")
end

return Intro
