--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/WasAttacked.lua
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

local WasAttacked = B.Node("WasAttacked")
WasAttacked.TOOK_DAMAGE = B.Reference()
WasAttacked.MISSED = B.Reference()
WasAttacked.ATTACK_POKE = B.Reference()
WasAttacked.INTERNAL_ATTACK_POKE = B.Local()
WasAttacked.ATTACKED = B.Local()
WasAttacked.CALLBACK = B.Local()

function WasAttacked:update(mashina, state, executor)
	local attacked = state[self.ATTACKED]

	if attacked == true then
		state[self.ATTACK_POKE] = state[self.INTERNAL_ATTACK_POKE]
		state[self.ATTACKED] = nil
		state[self.INTERNAL_ATTACK_POKE] = nil
		return B.Status.Success
	elseif attacked == false then
		state[self.ATTACK_POKE] = state[self.INTERNAL_ATTACK_POKE]
		state[self.ATTACKED] = nil
		state[self.INTERNAL_ATTACK_POKE] = nil
		return B.Status.Failure
	else
		return B.Status.Working
	end
end

function WasAttacked:hit(peep, tookDamage, missed, state, _, p)
	if (missed == true or missed == nil) and p:getDamage() == 0 then
		state[self.ATTACKED] = true
	end

	if (tookDamage == true or tookDamage == nil) and p:getDamage() > 0 then
		state[self.ATTACKED] = true
	end

	if state[self.ATTACKED] == nil then
		state[self.ATTACKED] = false
	end

	state[self.INTERNAL_ATTACK_POKE] = p
end

function WasAttacked:activated(mashina, state, executor)
	local tookDamage = state[self.TOOK_DAMAGE]
	local missed = state[self.MISSED]

	local callback = self.callback or function(self, ...)
		self:hit(...)
	end

	self.callback = callback
	self.mashina = mashina

	mashina:listen('receiveAttack', callback, self, mashina, tookDamage, missed, state)
end

function WasAttacked:deactivated(mashina, state, executor)
	state[self.ATTACKED] = nil
	state[self.INTERNAL_ATTACK_POKE] = nil

	mashina:silence('receiveAttack', self.callback)
	self.callback = nil
end

function WasAttacked:removed()
	if self.mashina then
		self.mashina:silence('receiveAttack', self.callback)
		self.callback = nil
		self.mashina = nil
	end
end

return WasAttacked
