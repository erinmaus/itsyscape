--------------------------------------------------------------------------------
-- Resources/Game/Actions/Travel.lua
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
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local Action = require "ItsyScape.Peep.Action"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local TeleportalBehavior = require "ItsyScape.Peep.Behaviors.TeleportalBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"

local Travel = Class(Action)
Travel.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Travel.FLAGS ={
	['item-inventory'] = true,
	['item-equipment'] = true
}

function Travel:perform(state, player, target)
	if target and
	   self:canPerform(state, Travel.FLAGS) and
	   self:canTransfer(state, Travel.FLAGS)
	then
		local i, j, k = Utility.Peep.getTileAnchor(target)
		local walk = Utility.Peep.getWalk(player, i, j, k, 2.5, { asCloseAsPossible = true })

		if walk then
			local travel = CallbackCommand(self.travel, self, state, player, target)
			local perform = CallbackCommand(Action.perform, self, state, player)
			local command = CompositeCommand(true, walk, wait, travel, perform)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		else
			return self:failWithMessage(player, "ActionFail_Walk")
		end
	end

	return false
end

function Travel:teleport(state, peep, target)
	local p = target:getBehavior(TeleportalBehavior)

	local director = self:getGame():getDirector()
	local map = director:getMap(p.layer)
	if not map then
		return
	end

	local position = map:getTileCenter(p.i, p.j)

	Utility.Peep.setPosition(peep, position)
	Utility.Peep.setLayer(peep, p.layer)

	target:poke("teleport", peep)
end

function Travel:travel(state, peep, target)
	if target:hasBehavior(TeleportalBehavior) then
		self:teleport(state, peep, target)
		return
	end

	local gameDB = self:getGameDB()
	local record = gameDB:getRecord("TravelDestination", { Action = self:getAction() })

	local isLocal = false
	if not record then
		record = gameDB:getRecord("LocalTravelDestination", { Action = self:getAction() })
		isLocal = record and true
	end

	if not record then
		return
	end

	local map = record:get("Map")

	if not map then
		return
	end

	local destination = record:get("Anchor")
	if not destination then
		return
	end

	if not self:canTransfer(state, peep, Travel.FLAGS) then
		return
	end
	
	self:transfer(state, peep, Travel.FLAGS)

	if isLocal then
		local mapScriptResource = Utility.Peep.getMapResource(peep)
		if not mapScriptResource or mapScriptResource.id.value ~= map.id.value then
			return
		end

		local position = Vector(Utility.Map.getAnchorPosition(self:getGame(), map, record:get("Anchor")))
		Utility.Peep.setPosition(peep, position)
		Utility.orientateToAnchor(peep, mapScriptResource, record:get("Anchor"))
	else
		local arguments = record:get("Arguments")
		if arguments and arguments ~= "" then
			arguments = "?" .. arguments
		else
			arguments = ""
		end

		local isSameStage = false
		do
			local instance = Utility.Peep.getInstance(peep)
			local mapScript = instance:getMapScriptByLayer(Utility.Peep.getLayer(peep))
			if mapScript:getFilename() == map.name and arguments == "" then
				isSameStage = true
			end
		end

		if isSameStage then
			local anchorPosition = Vector(Utility.Map.getAnchorPosition(
				self:getGame(),
				map,
				destination))
			Utility.Peep.setPosition(peep, anchorPosition)
		else
			local instance = Utility.Peep.getInstance(peep)
			local raid = instance:getRaid()
			local isInGroup = raid ~= nil and gameDB:getRecord("RaidGroup", {
				Map = map,
				Raid = raid:getResource()
			})

			if raid and isInGroup then
				local existingInstance = raid:getInstances(map.name)[1]
				if existingInstance then
					Utility.move(peep, existingInstance, destination)
				else
					Utility.move(peep, "@" .. map.name .. arguments, destination, raid)
				end
			else
				if record:get("IsInstance") == 0 then
					Utility.move(peep, map.name .. arguments, destination)
				else
					Utility.move(peep, "@" .. map.name .. arguments, destination)
				end
			end
		end
	end
end

return Travel
