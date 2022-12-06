--------------------------------------------------------------------------------
-- ItsyScape/UI/DebugAntilogikaWarpController.lua
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

local DebugAntilogikaWarpController = Class(Controller)
DebugAntilogikaWarpController.CONFIG = "ItsyScape/Game/Skills/Antilogika/DimensionConfig.lua"

function DebugAntilogikaWarpController:new(peep, director)
	Controller.new(self, peep, director)

	self.state = {
		dimensions = {}
	}
end

function DebugAntilogikaWarpController:poke(actionID, actionIndex, e)
	if actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function DebugAntilogikaWarpController:pull()
	local info = love.filesystem.getInfo(DebugAntilogikaWarpController.CONFIG)
	if info and info.modtime ~= self.state.lastUpdateTime then
		local s, r = pcall(loadstring(love.filesystem.read(DebugAntilogikaWarpController.CONFIG)))
		if s then
			self.state.dimensions = r
		else
			Log.warn("Couldn't read '%s': %s.", DebugAntilogikaWarpController.CONFIG, r)
		end

		self.state.lastUpdateTime = info.modtime
	end

	return self.state
end

return DebugAntilogikaWarpController
