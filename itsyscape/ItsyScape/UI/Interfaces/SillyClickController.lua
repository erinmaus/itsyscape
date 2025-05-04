--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/SillyClickController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"

local SillyClickController = Class(Controller)

function SillyClickController:new(...)
	Controller.new(self, ...)

	Utility.Peep.disable(self:getPeep())
end

function SillyClickController:close()
	Utility.Peep.enable(self:getPeep())
end

function SillyClickController:poke(actionID, actionIndex, e)
	if actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

return SillyClickController
