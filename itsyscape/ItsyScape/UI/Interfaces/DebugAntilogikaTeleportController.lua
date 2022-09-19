--------------------------------------------------------------------------------
-- ItsyScape/UI/DebugAntilogikaTeleportController.lua
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

local DebugAntilogikaTeleportController = Class(Controller)

DebugAntilogikaTeleportController.MAX_SIZE     = 8
DebugAntilogikaTeleportController.MIN_SIZE     = 1
DebugAntilogikaTeleportController.DEFAULT_SIZE = 4

function DebugAntilogikaTeleportController:new(peep, director)
	Controller.new(self, peep, director)
end

function DebugAntilogikaTeleportController:poke(actionID, actionIndex, e)
	if actionID == "teleport" then
		self:teleport(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function DebugAntilogikaTeleportController:teleport(e)
	local seed = Antilogika.Seed(e.x, e.y, e.z, e.w, tonumber(e.time) or 0)

	local size = tonumber(e.size) or DebugAntilogikaTeleportController.DEFAULT_SIZE
	size = math.max(math.min(size, DebugAntilogikaTeleportController.MAX_SIZE), DebugAntilogikaTeleportController.MIN_SIZE)

	local dimensionBuilder = Antilogika.DimensionBuilder(seed, size)
	local instanceManager = Antilogika.InstanceManager(self:getGame(), dimensionBuilder)
	local instance = instanceManager:instantiate(size + 1, size + 1)
	self:getGame():getStage():movePeep(self:getPeep(), instance, Vector(16, 10, 16))

	self:getGame():getUI():closeInstance(self)
end

return DebugAntilogikaTeleportController
