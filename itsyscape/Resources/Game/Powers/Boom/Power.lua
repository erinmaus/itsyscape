--------------------------------------------------------------------------------
-- Resources/Game/Powers/Boom/Power.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CombatPower = require "ItsyScape.Game.CombatPower"
local Utility = require "ItsyScape.Game.Utility"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local Boom = Class(CombatPower)

function Boom:new(...)
	CombatPower.new(self, ...)

	local gameDB = self:getGame():getGameDB()
	self.effectResource = gameDB:getResource("Power_Boom", "Effect")

	self:setXWeaponID("Power_Boom")
end

function Boom:activate(activator, target)
	CombatPower.activate(self, activator, target)

	local position = target:getBehavior(PositionBehavior)
	if position then
		position = position.position
		Utility.spawnPropAtPosition(
			activator,
			"Power_Bomb_Default",
			position.x,
			position.y,
			position.z,
			0.25)
	end
end

return Boom
