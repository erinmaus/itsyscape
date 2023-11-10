--------------------------------------------------------------------------------
-- Resources/Game/Maps/Rumbridge_Castle_Floor1/Peep.lua
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
local Map = require "ItsyScape.Peep.Peeps.Map"
local Probe = require "ItsyScape.Peep.Probe"
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"

local Castle = Class(Map)

function Castle:new(resource, name, ...)
	Map.new(self, resource, name or 'Rumbridge_Castle_Floor1', ...)

	self:addBehavior(MapOffsetBehavior)
end

function Castle:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	Utility.Map.spawnMap(self, "Rumbridge_Castle", Vector.ZERO, { isLayer = true })

	local offset = self:getBehavior(MapOffsetBehavior)
	offset.offset = Vector(0, 8.1, 0)

	self:initGuards()
end

function Castle:initGuards()
	local isCutscene = self:getArguments() and self:getArguments()["super_supper_saboteur"] ~= nil
	if isCutscene then
		return
	end

	local guard1 = self:getDirector():probe(self:getLayerName(), Probe.namedMapObject("Guard1"))[1]
	local guard2 = self:getDirector():probe(self:getLayerName(), Probe.namedMapObject("Guard1"))[1]

	if guard1 then
		Utility.Peep.setMashinaState(guard1, "idle")
	end

	if guard2 then
		Utility.Peep.setMashinaState(guard1, "idle")
	end
end

function Castle:incrementSuperSupperSaboteurDialogTick()
	local tick = self.currentDialogTick or 1
	self.currentDialogTick = tick + 1

	return tick
end

function Castle:onPlayerEnter(player)
	self:initSuperSupperSaboteurInstance(player)
end

function Castle:initSuperSupperSaboteurInstance(player)
	local playerPeep = player:getActor():getPeep()

	local isEarlAlive = not (
		playerPeep:getState():has("KeyItem", "SuperSupperSaboteur_LitKursedCandle") and
		playerPeep:getState():has("KeyItem", "SuperSupperSaboteur_Complete")
	)

	if isEarlAlive then
		local earlActor = Utility.spawnMapObjectAtAnchor(self, "EarlReddick", "Anchor_EarlReddick", 0)
		local earlPeep = earlActor and earlActor:getPeep()
		if not earlPeep then
			Log.warn("Couldn't spawn Earl Reddick for player '%s'.", playerPeep:getName())
		else
			Log.info("Spawned Earl Reddick for player '%s'.", playerPeep:getName())
			local _, instance = earlPeep:addBehavior(InstancedBehavior)
			instance.playerID = player:getID()
		end
	else
		Log.info("Earl Reddick is dead for player '%s'.", playerPeep:getName())
	end

	local isInQuest = Utility.Quest.isNextStep("SuperSupperSaboteur", "SuperSupperSaboteur_BlamedSomeoneElse", playerPeep)
	local SEARCH_FLAGS = { ['item-inventory' ] = true }
	local hasContracts = playerPeep:getState():has("Item", "SuperSupperSaboteur_DemonContract", 1, SEARCH_FLAGS) and
	                     playerPeep:getState():has("Item", "SuperSupperSaboteur_HellhoundContract", 1, SEARCH_FLAGS)
	local isCutscene = self:getArguments() and self:getArguments()["super_supper_saboteur"] ~= nil

	if isInQuest and hasContracts then
		if not isCutscene then
			local stage = self:getDirector():getGameInstance():getStage()
			stage:movePeep(playerPeep, "Rumbridge_Castle_Floor1?super_supper_saboteur=1", "Anchor_FromStairs")
			return
		end

		local position = Utility.Peep.getPosition(playerPeep)
		local demon = Utility.spawnActorAtPosition(self, "SuperSupperSaboteur_DemonicAssassin", position:get())
		local hellhound = Utility.spawnActorAtPosition(self, "SuperSupperSaboteur_Hellhound", position:get())

		if not demon then
			Log.warn("Couldn't spawn demon for player '%s' in Super Supper Saboteur cutscene.", playerPeep:getName())
			return
		end

		if not hellhound then
			Log.warn("Couldn't spawn hellhound for player '%s' in Super Supper Saboteur cutscene.", playerPeep:getName())
			return
		end

		local _finalize = function()
			if not demon:getPeep():getDirector() or not hellhound:getPeep():getDirector() then
				return
			end

			self:playSuperSupperSaboteurCutscene(player)
		end

		hellhound:getPeep():listen('finalize', _finalize)
	end
end

function Castle:playSuperSupperSaboteurCutscene(player)
	local chandelier = self:getDirector():probe(self:getLayerName(), Probe.namedMapObject("Chandelier"))[1]
	if chandelier then
		Utility.Peep.poof(chandelier)
	end

	local TAKE_FLAGS = { ['item-inventory' ] = true }

	local playerPeep = player:getActor():getPeep()
	Utility.UI.closeAll(playerPeep)

	local cutscene = Utility.Map.playCutscene(self, "Rumbridge_Castle_Floor1_AssassinationAttempt", "StandardCutscene", playerPeep)
	cutscene:listen('done', function()
		Utility.UI.openGroup(playerPeep, Utility.UI.Groups.WORLD)

		--playerPeep:getState():take("Item", "SuperSupperSaboteur_DemonContract", 1, TAKE_FLAGS)
		--playerPeep:getState():take("Item", "SuperSupperSaboteur_HellhoundContract", 1, TAKE_FLAGS)

		local stage = playerPeep:getDirector():getGameInstance():getStage()
		stage:movePeep(playerPeep, "Rumbridge_Castle_Floor1", Utility.Peep.getPosition(playerPeep))
	end)
end

return Castle
