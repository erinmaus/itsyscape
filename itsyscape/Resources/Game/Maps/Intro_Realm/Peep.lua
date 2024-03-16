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
	{
		loadMaps = {
			"EmptyRuins_Downtown"
		},

		unloadMaps = {
			"EmptyRuins_Downtown",
			"EmptyRuins_Downtown_Floor1",
			"EmptyRuins_Downtown_Floor2",
			"EmptyRuins_SistineOfTheSimulacrum_Outside"
		}
	},
	{
		loadMaps = {
			"Rumbridge_Town_Center",
			"ViziersRock_Town_Center",
			"EmptyRuins_DragonValley_Ginsville"
		},

		unloadMaps = {
			"Rumbridge_Town_Center",
			"ViziersRock_Town_Center",
			"EmptyRuins_DragonValley_Ginsville"
		}
	},
	{
		loadMaps = {
			"Rumbridge_Castle_Floor1"
		},

		unloadMaps = {
			"Rumbridge_Castle_Floor1",
			"Rumbridge_Castle"
		}
	}
}

function Intro:new(resource, name, ...)
	Map.new(self, resource, name or 'Intro_Realm', ...)
	self:silence('playerEnter', Map.showPlayerMapInfo)
end

function Intro:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)
end

function Intro:onPlayerEnter(player)
	self.currentCutsceneIndex = 0
	self:poke("initCutscene", "EmptyRuins_Downtown", "prepareCutscene")
end

function Intro:onInitCutscene(mapScriptFilename, poke)
	local oldMaps = Intro.MAPS[self.currentCutsceneIndex]
	if oldMaps then
		local stage = self:getDirector():getGameInstance():getStage()

		local instance = Utility.Peep.getInstance(self)
		for _, mapName in ipairs(oldMaps.unloadMaps) do
			local mapScript = instance:getMapScriptByMapFilename(mapName)
			if mapScript then
				stage:unloadLayer(mapScript:getLayer())
			end
		end
	end
	self.currentCutsceneIndex = self.currentCutsceneIndex + 1

	local playerPeep = Utility.Peep.getPlayer(self)
	if playerPeep then
		local isCutsceneTransitionOpen = Utility.UI.isOpen(playerPeep, "CutsceneTransition")
		if not isCutsceneTransitionOpen then
			Utility.UI.openInterface(playerPeep, "CutsceneTransition", false)
		end
	end

	local newMaps = Intro.MAPS[self.currentCutsceneIndex]
	if newMaps then
		local mapScript
		for _, mapResource in ipairs(newMaps.loadMaps) do
			mapScript = Utility.spawnMapAtAnchor(self, mapResource, "Anchor_SpawnMap_Center", { cutscene = true })
		end

		mapScript:listen("load", function()
			self:pushPoke("disableMaps", mapScriptFilename, poke)
		end)
	end
end

function Intro:onDisableMaps(mapScriptFilename, poke)
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
		self:pushPoke("disableMaps", mapScriptFilename, poke)
	else
		Log.info("push Intro.onPlayCutscene", mapScriptFilename, poke)
		self:pushPoke("playCutscene", mapScriptFilename, poke)
	end
end

function Intro:onPlayCutscene(mapScriptFilename, poke)
	local mapScript = Utility.Peep.getInstance(self):getMapScriptByMapFilename(mapScriptFilename)
	local playerPeep = Utility.Peep.getPlayer(self)

	if mapScript and playerPeep then
		Log.info("has map script and player peep")
		Utility.UI.closeAll(playerPeep, nil, { "CutsceneTransition", "DramaticText" })
		local isCutsceneTransitionOpen, cutsceneTransitionIndex = Utility.UI.isOpen(playerPeep, "CutsceneTransition")
		if isCutsceneTransitionOpen then
			local cutsceneTransition = Utility.UI.getOpenInterface(playerPeep, "CutsceneTransition", cutsceneTransitionIndex)
			if cutsceneTransition then
				cutsceneTransition:move()
			end
		end

		mapScript:pushPoke(poke, playerPeep)
	else
		Log.info("does not have map script (%s) and/or player peep (%s)", Log.boolean(mapScript), Log.boolean(playerPeep))
	end
end

function Intro:onPlayIntroCutscene(playerPeep)
	Utility.Map.playCutscene(self, "Intro_Realm", "StandardCutscene", playerPeep)
end

return Intro
