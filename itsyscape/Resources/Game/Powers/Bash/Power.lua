--------------------------------------------------------------------------------
-- Resources/Game/Powers/Bash/Power.lua
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
local Effect = require "ItsyScape.Peep.Effect"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"

local Bash = Class(CombatPower)

function Bash:activate(activator, target)
	CombatPower.activate(self, activator, target)

	local level = activator:getState():count(
		"Skill",
		"Defense",
		{ ['skill-as-level'] = true })

	local additionalCooldown = math.min(((level - 10) / 50), 1) * 10 + 10
	local _, cooldown = target:addBehavior(AttackCooldownBehavior)
	cooldown.cooldown = cooldown.cooldown + additionalCooldown
	cooldown.ticks = activator:getDirector():getGameInstance():getCurrentTick()
end

return Bash
