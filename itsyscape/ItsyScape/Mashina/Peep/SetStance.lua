--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/SetStance.lua
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
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

local SetStance = B.Node("SetStance")
SetStance.STANCE = B.Reference()
SetStance.USE_SPELL = B.Reference()

local ALLOWED_STANCES = {
	[Weapon.STANCE_NONE] = true,
	[Weapon.STANCE_AGGRESSIVE] = true,
	[Weapon.STANCE_CONTROLLED] = true,
	[Weapon.STANCE_DEFENSIVE] = true
}

function SetStance:update(mashina, state, executor)
	local desiredStance = state[self.STANCE]
	local useSpell = state[self.USE_SPELL]

	if not ALLOWED_STANCES[desiredStance] then
		return B.Status.Failure
	end

	local _, stance = mashina:addBehavior(StanceBehavior)

	stance.stance = desiredStance
	if useSpell ~= nil then
		stance.useSpell = not not useSpell
	end

	return B.Status.Success
end

return SetStance
