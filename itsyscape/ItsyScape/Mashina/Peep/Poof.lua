--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/Poof.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"

local Poof = B.Node("Poof")
Poof.PEEP = B.Reference()

function Poof:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina

	if peep:hasBehavior(PlayerBehavior) then
		Log.warn("Peep '%s' tried poofing player '%s'! Not allowed!", mashina:getName(), peep:getName())
		return B.Status.Failure
	end

	if peep:hasBehavior(FollowerBehavior) and mashina ~= peep then
		Log.warn("Peep '%s' tried poofing a follower '%s'! Not allowed!", mashina:getName(), peep:getName())
		return B.Status.Failure
	end

	Utility.Peep.poof(peep)
	return B.Status.Success
end

return Poof
