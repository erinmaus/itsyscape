--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/WasHealed.lua
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

local WasHealed = B.Node("WasHealed")
WasHealed.TARGET = B.Reference()
WasHealed.DAMAGE_HEALED = B.Reference()
WasHealed.ZEALOUS = B.Reference()
WasHealed.HEAL_POKE = B.Reference()
WasHealed.HEALED = B.Local()
WasHealed.INTERNAL_HEAL_POKE = B.Local()

function WasHealed:update(mashina, state, executor)
	local healed = state[self.HEALED]

	if healed == true then
		local poke = state[self.INTERNAL_HEAL_POKE]
		state[self.HEAL_POKE] = poke
		state[self.HEALED] = nil
		state[self.INTERNAL_HEAL_POKE] = nil
		state[self.DAMAGE_HEALED] = poke.hitPoints
		state[self.ZEALOUS] = poke.zealous or false

		return B.Status.Success
	else
		return B.Status.Working
	end
end

function WasHealed:healed(state, _, p)
	if p.hitPoints >= 1 then
		state[self.HEALED] = true
	end

	state[self.INTERNAL_HEAL_POKE] = p
end

function WasHealed:activated(mashina, state, executor)
	local tookDamage = state[self.TOOK_DAMAGE]
	local missed = state[self.MISSED]

	local callback = self.callback or function(self, ...)
		self:healed(...)
	end

	self.callback = callback
	self.target = state[self.TARGET] or mashina

	self.target:listen('heal', callback, self, state)
end

function WasHealed:deactivated(mashina, state, executor)
	state[self.HEALED] = nil
	state[self.INTERNAL_HEAL_POKE] = nil

	self.target:silence('heal', self.callback)
	self.callback = nil
end

function WasHealed:removed()
	if self.target then
		self.target:silence('heal', self.callback)
		self.callback = nil
		self.target = nil
	end
end

return WasHealed
