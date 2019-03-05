--------------------------------------------------------------------------------
-- Resources/Game/Powers/Taunt/Power.lua
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
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

local Taunt = Class(CombatPower)
Taunt.TAUNTS = {
	["en-US"] = {
		"You're as graceful as a drunkard!",
		"You're as intelligent as a potato!",
		"You're so fat I could never miss!",
		"Your mother hates you!",
		"The gods disown you!"
	}
}

function Taunt:new(...)
	CombatPower.new(self, ...)

	local gameDB = self:getGame():getGameDB()
	self.effectResource = gameDB:getResource("Power_Taunt", "Effect")
end

function Taunt:activate(activator, target)
	CombatPower.activate(self, activator, target)

	local actor = activator:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor

		local taunt = Taunt.TAUNTS["en-US"][math.random(#Taunt.TAUNTS["en-US"])]
		actor:flash('Message', 1, taunt)
	end

	Utility.Peep.applyEffect(target, self.effectResource, true, activator)
end

return Taunt
