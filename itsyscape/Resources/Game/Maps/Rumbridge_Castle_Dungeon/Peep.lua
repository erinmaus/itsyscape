--------------------------------------------------------------------------------
-- Resources/Game/Maps/Rumbridge_Castle_Dungeon/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"
local Probe = require "ItsyScape.Peep.Probe"
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"

local Dungeon = Class(Map)

function Dungeon:new(resource, name, ...)
	Map.new(self, resource, name or 'Rumbridge_Castle_Dungeon', ...)
end

function Dungeon:onPlayerEnter(player)
	self:trySpawnLyra(player)
	self:trySpawnChef(player)
end

function Dungeon:trySpawnChef(player)
	local playerPeep = player:getActor():getPeep()
	local isQuestComplete = playerPeep:getState():has("Quest", "SuperSupperSaboteur")
	local isLyraInJail = playerPeep:getState():has("KeyItem", "SuperSupperSaboteur_BetrayedLyra") or
	                     playerPeep:getState():has("KeyItem", "SuperSupperSaboteur_TurnedInLyra")
    local playerLitKursedCandle = playerPeep:getState():has("KeyItem", "SuperSupperSaboteur_LitKursedCandle")

    if isLyraInJail or not playerLitKursedCandle or not isQuestComplete then
    	Log.info("Chef Allon is not is not in jail for player '%s'.", playerPeep:getName())
    	return
    end

	local gameDB = self:getDirector():getGameDB()
	local chefResource = gameDB:getResource("ChefAllon", "Peep")
	if not chefResource then
		Log.warn(
			"Couldn't get resource in Rumbridge Dungeon (Chef = %s).",
			Log.boolean(chefResource))
		return
	end

	local chefActor = Utility.spawnMapObjectAtAnchor(self, "ChefAllon", "Anchor_SuperSupperSaboteurVictim", 0)
	local _, instance = chefActor:getPeep():addBehavior(InstancedBehavior)
	instance.playerID = player:getID()

	Log.info("Spawned Chef Allon in jail for player '%s'.", playerPeep:getName())
end

function Dungeon:trySpawnLyra(player)
	local playerPeep = player:getActor():getPeep()
	local isLyraInJail = playerPeep:getState():has("KeyItem", "SuperSupperSaboteur_BetrayedLyra") or
	                     playerPeep:getState():has("KeyItem", "SuperSupperSaboteur_TurnedInLyra")

    if not isLyraInJail then
    	Log.info("Lyra and Oliver are not is not in jail for player '%s'.", playerPeep:getName())
    	return
    end

	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local gameDB = self:getDirector():getGameDB()
	local lyraResource, oliverResource = gameDB:getResource("Lyra", "Peep"), gameDB:getResource("Oliver", "Peep")
	if not lyraResource or not oliverResource then
		Log.warn(
			"Couldn't get resource in Rumbridge Dungeon (Lyra = %s, Oliver = %s).",
			Log.boolean(lyraResource),
			Log.boolean(oliverResource))
		return
	end

	local lyraActor = Utility.spawnMapObjectAtAnchor(self, "Lyra", "Anchor_SuperSupperSaboteurVictim", 0)
	local _, instance = lyraActor:getPeep():addBehavior(InstancedBehavior)
	instance.playerID = player:getID()

	local oliverActor = Utility.spawnMapObjectAtAnchor(self, "Oliver", "Anchor_SuperSupperSaboteurVictim", 1.5)
	local _, instance = oliverActor:getPeep():addBehavior(InstancedBehavior)
	instance.playerID = player:getID()

	Log.info("Spawned Lyra and Oliver in jail for player '%s'.", playerPeep:getName())
end

return Dungeon
