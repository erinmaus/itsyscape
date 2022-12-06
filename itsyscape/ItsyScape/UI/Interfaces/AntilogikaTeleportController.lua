--------------------------------------------------------------------------------
-- ItsyScape/UI/AntilogikaTeleportController.lua
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
local Antilogika = require "ItsyScape.Game.Skills.Antilogika"
local Controller = require "ItsyScape.UI.Controller"

local AntilogikaTeleportController = Class(Controller)
AntilogikaTeleportController.SIZE = 1

function AntilogikaTeleportController:new(peep, director, portal)
	Controller.new(self, peep, director)

	self.portal = portal
end

function AntilogikaTeleportController:poke(actionID, actionIndex, e)
	if actionID == "teleport" then
		self:teleport(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function AntilogikaTeleportController:getReturn()
	local mapObject = Utility.Peep.getMapObject(self.portal)
	local destination = self:getDirector():getGameDB():getRecord("AntilogikaTeleportDestination", {
		Portal = mapObject
	})

	if destination then
		return destination:get("ReturnAnchor"), destination:get("ReturnMap")
	end

	return nil, nil
end

function AntilogikaTeleportController:teleport(e)
	local seed = Antilogika.Seed(e.x, e.y, e.z, e.w, 0)
	local playerConfig = Antilogika.PlayerConfig(Utility.Peep.getPlayerModel(self:getPeep()))
	playerConfig:setReturn(self:getReturn())

	local size = AntilogikaTeleportController.SIZE

	local dimensionBuilder = Antilogika.DimensionBuilder(seed, size, nil, playerConfig)
	local instanceManager = Antilogika.InstanceManager(self:getGame(), dimensionBuilder)
	local instance = instanceManager:instantiate(size + 1, size + 1)
	self:getGame():getStage():movePeep(self:getPeep(), instance, Vector(24, 10, 24))

	self:getGame():getUI():closeInstance(self)
end

return AntilogikaTeleportController
