--------------------------------------------------------------------------------
-- Resources/Game/Powers/Hexagram/Power.lua
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
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"

local Hexagram = Class(CombatPower)

function Hexagram:new(...)
	CombatPower.new(self, ...)

	local gameDB = self:getGame():getGameDB()
	self.effectResource = gameDB:getResource("Power_Hexagram", "Effect")
end

function Hexagram:activate(activator, target)
	CombatPower.activate(self, activator, target)
	Utility.Peep.applyEffect(target, self.effectResource, true, activator)

	local stage = activator:getDirector():getGameInstance():getStage()
	if target:hasBehavior(PlayerBehavior) then
		stage:fireProjectile("Power_HexagramVsPlayer", activator, target)
	else
		stage:fireProjectile("Power_Hexagram", activator, target)
	end
end

return Hexagram
