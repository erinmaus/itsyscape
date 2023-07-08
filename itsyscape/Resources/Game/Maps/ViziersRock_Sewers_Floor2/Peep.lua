--------------------------------------------------------------------------------
-- Resources/Game/Maps/ViziersRock_Sewers_Floor2/Peep.lua
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
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"
local Common = require "Resources.Game.Peeps.ViziersRock.SewersCommon"

local Sewers = Class(Map)

function Sewers:new(resource, name, ...)
	Map.new(self, resource, name or 'ViziersRock_Sewers_Floor2', ...)
end

function Sewers:onLoad(...)
	Map.onLoad(self, ...)

	if not Common.hasValveBeenOpenedOrClosed(self, Common.MARK_CIRCLE) then
		Common.closeValve(self, Common.MARK_CIRCLE)
	end

	if not Common.hasValveBeenOpenedOrClosed(self, Common.MARK_STAR) then
		Common.closeValve(self, Common.MARK_STAR)
	end
end

function Sewers:update(...)
	Map.update(self, ...)

	Common.updateValve(self, "Valve_SquareTriangle", Common.MARK_SQUARE, Common.MARK_TRIANGLE)
	Common.updateValve(self, "Valve_Star", Common.MARK_STAR, Common.MARK_NONE)
	Common.updateValve(self, "Valve_Circle", Common.MARK_CIRCLE, Common.MARK_NONE)

	Common.updateDoor(self, "Door_Circle1", Common.MARK_CIRCLE)
	Common.updateDoor(self, "Door_Circle2", Common.MARK_CIRCLE)
	Common.updateDoor(self, "Door_Star1", Common.MARK_STAR)
	Common.updateDoor(self, "Door_Star2", Common.MARK_STAR)
	Common.updateDoor(self, "Door_Square1", Common.MARK_SQUARE)
end

return Sewers
