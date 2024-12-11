--------------------------------------------------------------------------------
-- ItsyScape/UI/CannonController.lua
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

local CannonController = Class(Controller)

function CannonController:new(peep, cannon)
	Controller.new(self, peep, director)

	self.cannon = cannon
end

function CannonController:pull()
	return {}
end

function CannonController:update(delta)
	Controller.update(self, delta)
end

return CannonController
