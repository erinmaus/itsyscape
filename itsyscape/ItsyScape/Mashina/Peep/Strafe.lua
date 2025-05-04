--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/Strafe.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local AttackCommand = require "ItsyScape.Game.AttackCommand"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

local Strafe = B.Node("Strafe")
Strafe.TARGET = B.Reference()
Strafe.DISTANCE = B.Reference()
Strafe.ROTATIONS = B.Reference()
Strafe.CALLBACK = B.Reference()

function Strafe:update(mashina, state, executor)
	local distance = state[self.DISTANCE]
	if not distance then
		return B.Status.Failure
	end

	if not self.isPending then
		self.isPending = true

		local callback = state[self.CALLBACK]
		local success = Utility.Combat.strafe(
			mashina,
			state[self.TARGET],
			distance,
			state[self.ROTATIONS],
			function(peep, target, s)
				self.isDone = true
				self.isSuccess = s
				if callback then
					callback(mashina, state, executor, peep, target, s)
				end
			end)

		if not success then
			self.isDone = true
			self.isSuccess = false
		end
	end

	if self.isDone then
		if self.isSuccess then
			return B.Status.Success
		end

		return B.Status.Failure
	end

	return B.Status.Working
end

function Strafe:deactivated()
	self.isPending = nil
	self.isDone = nil
	self.isSuccess = nil
end

return Strafe
