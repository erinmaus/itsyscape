--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/IsCharacter.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

local IsCharacter = B.Node("IsCharacter")
IsCharacter.PEEP = B.Reference()
IsCharacter.CHARACTER = B.Reference()

function IsCharacter:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	if not peep then
		return B.Status.Failure
	end

	local targetCharacter = state[self.CHARACTER]
	if not targetCharacter then
		return B.Status.Failure
	end

	local character = Utility.Peep.getCharacter(peep)
	if character.name == targetCharacter then
		return B.Status.Success
	end

	return B.Status.Failure
end

return IsCharacter
