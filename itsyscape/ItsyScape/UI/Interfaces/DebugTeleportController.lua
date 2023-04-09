--------------------------------------------------------------------------------
-- ItsyScape/UI/DebugTeleportController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local DebugTeleportController = Class(Controller)

function DebugTeleportController:new(peep, director)
	Controller.new(self, peep, director)
end

function DebugTeleportController:poke(actionID, actionIndex, e)
	if actionID == "teleport" then
		self:teleport(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function DebugTeleportController:teleport(e)
	assert(type(e.map) == "string", "map must be string")
	assert(type(e.anchor) == "string", "anchor must be string")

	local peep = self:getPeep()
	local instance = Utility.Peep.getInstance(peep)
	local mapScript = instance:getMapScriptByLayer(Utility.Peep.getLayer(peep))
	if mapScript and mapScript:getFilename() == e.map then
		local anchorPosition = Vector(Utility.Map.getAnchorPosition(
			self:getGame(),
			Utility.Peep.getResource(mapScript),
			e.anchor))
		Utility.Peep.setPosition(peep, anchorPosition)
	else
		self:getGame():getStage():movePeep(
			peep,
			e.map,
			e.anchor)
	end
end

function DebugTeleportController:pull()
	local mapScript = Utility.Peep.getMapScript(self:getPeep())
	local state = {
		currentMap = mapScript and mapScript:getFilename()
	}

	return state
end

return DebugTeleportController
