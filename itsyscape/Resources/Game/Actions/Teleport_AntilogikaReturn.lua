--------------------------------------------------------------------------------
-- Resources/Game/Actions/Teleport_Antilogika.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Action = require "ItsyScape.Peep.Action"
local AntilogikaBossBehavior = require "ItsyScape.Peep.Behaviors.AntilogikaBossBehavior"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local OpenInterfaceCommand = require "ItsyScape.UI.OpenInterfaceCommand"

local Teleport = Class(Action)
Teleport.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function Teleport:perform(state, player, target)
	if not self:canPerform(state) then
		return false
	end

	if not self:canTeleport(player) then
		return false
	end

	local i, j, k = Utility.Peep.getTileAnchor(target)
	local walk = Utility.Peep.getWalk(player, i, j, k, 1.5, { asCloseAsPossible = false })
	if walk then
		self:transfer(state, player)
		local face = CallbackCommand(Utility.Peep.face, player, target)
		local teleport = CallbackCommand(self.teleport, self, player)
		local perform = CallbackCommand(Action.perform, self, state, player)
		local command = CompositeCommand(true, walk, face, teleport, perform)

		return player:getCommandQueue():interrupt(command)
	end

	return false
end

function Teleport:canTeleport(player)
	local director = player:getDirector()
	local hits = director:probe(player:getLayerName(), function(peep)
		return peep:hasBehavior(AntilogikaBossBehavior) and Utility.Peep.canAttack(peep)
	end)

	return #hits == 0
end

function Teleport:teleport(player)
	local anchor, map = "Anchor_StartGame", "IsabelleIsland_Tower_Floor5"
	do
		local mapScript = Utility.Peep.getMapScript(player)
		local isAntilogikaMap = Class.isCompatibleType(mapScript, require "Resources.Game.Maps.Antilogika.Peep")
		if isAntilogikaMap then
			local instanceManager = mapScript:getInstanceManager()
			if not instanceManager then
				Log.warn("Antilogika map doesn't have instance manager.")
			else
				local dimensionBuilder = instanceManager:getDimensionBuilder()
				local playerConfig = dimensionBuilder:getPlayerConfig()

				local a, m = playerConfig:getReturn()
				anchor = a or anchor
				map = (m and m.name) or map
			end
		end
	end

	local stage = player:getDirector():getGameInstance():getStage()
	stage:movePeep(player, map, anchor)
end

function Teleport:getFailureReason(state, peep, prop, channel)
	local reason = Action.getFailureReason(self, state, peep)

	local s, r = prop:canOpen()
	if not s then
		local gameDB = self:getGameDB()
		r = gameDB:getResource("Message_AntilogikaPortalSealed", "KeyItem")
		if r then
			table.insert(reason.requirements, {
				type = "KeyItem",
				resource = r.name,
				name = Utility.getName(r, gameDB) or ("*" .. r.name),
				description = Utility.getDescription(r, gameDB) or ("*" .. r.name),
				count = 1
			})
		end
	end

	return reason
end

return Teleport
