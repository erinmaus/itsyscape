--------------------------------------------------------------------------------
-- ItsyScape/UI/DebugAntilogikaNoiseController.lua
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

local DebugAntilogikaNoiseController = Class(Controller)

function DebugAntilogikaNoiseController:new(peep, director)
	Controller.new(self, peep, director)
end

function DebugAntilogikaNoiseController:poke(actionID, actionIndex, e)
	if actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

return DebugAntilogikaNoiseController
