--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/IsDodging.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Peep = require "ItsyScape.Peep.Peep"
local CombatDodgeBehavior = require "ItsyScape.Peep.Behaviors.CombatDodgeBehavior"
local DodgeCooldownBehavior = require "ItsyScape.Peep.Behaviors.DodgeCooldownBehavior"

local IsDodging = B.Node("IsDodging")
IsDodging.PEEP = B.Reference()
IsDodging.INCLUDE_COOLDOWN = B.Reference()
IsDodging.INCLUDE_KNOCKBACK = B.Reference()

function IsDodging:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	local includeCooldown = state[self.INCLUDE_COOLDOWN]
	local includeKnockback = state[self.INCLUDE_KNOCKBACK]

	if includeKnockback == nil then
		includeKnockback = true
	end

	if includeCooldown and peep:hasBehavior(DodgeCooldownBehavior) then
		return B.Status.Success
	end

	local dodge = peep:getBehavior(CombatDodgeBehavior)
	if not dodge then
		return B.Status.Failure
	end

	if dodge.dodgeBehavior == Weapon.Weapon.DODGE_BEHAVIOR_KNOCKBACK and not includeKnockback then
		return B.Status.Failure
	end

	return B.Status.Success
end

return IsDodging
