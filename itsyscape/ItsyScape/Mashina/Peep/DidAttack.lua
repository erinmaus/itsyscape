--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/DidAttack.lua
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

local DidAttack = B.Node("DidAttack")
DidAttack.TOOK_DAMAGE = B.Reference()
DidAttack.MISSED = B.Reference()
DidAttack.ATTACK_POKE = B.Reference()
DidAttack.DAMAGE = B.Reference()
DidAttack.INTERNAL_ATTACK_POKE = B.Local()
DidAttack.ATTACKED = B.Local()
DidAttack.CALLBACK = B.Local()

function DidAttack:update(mashina, state, executor)
	local attacked = state[self.ATTACKED]

	if attacked == true then
		local attackPoke = state[self.INTERNAL_ATTACK_POKE]
		state[self.ATTACK_POKE] = attackPoke
		state[self.DAMAGE] = attackPoke:getDamage()
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

function DidAttack:hit(peep, tookDamage, missed, state, _, p)
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

function DidAttack:activated(mashina, state, executor)
	local tookDamage = state[self.TOOK_DAMAGE]
	local missed = state[self.MISSED]

	local callback = self.callback or function(self, ...)
		self:hit(...)
	end

	self.callback = callback
	self.mashina = mashina

	mashina:listen('initiateAttack', callback, self, mashina, tookDamage, missed, state)
end

function DidAttack:deactivated(mashina, state, executor)
	state[self.ATTACKED] = nil
	state[self.INTERNAL_ATTACK_POKE] = nil

	mashina:silence('initiateAttack', self.callback)
	self.callback = nil
end

function DidAttack:removed()
	if self.mashina then
		self.mashina:silence('initiateAttack', self.callback)
		self.callback = nil
		self.mashina = nil
	end
end

return DidAttack
