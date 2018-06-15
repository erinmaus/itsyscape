--------------------------------------------------------------------------------
-- ItsyScape/Peep/Poke.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Poke = require "ItsyScape.Peep.Poke"

-- A poke is an event that a Peep either sends or receives.
local AttackPoke = Class(Poke)

-- Creates an attack poke. 't' can have the following fields:
--
-- * attackType: a string representing an attack type (e.g., 'stab'). Defaults
--               to 'none'.
-- * weaponType: a string representing the weapon type (e.g., 'scimitar').
--               Defaults to 'none'.
-- * damage: the total damage dealt by the attack. Defaults to 0. Values are
--           clamped to 0. A value of 0 means the attack missed.
function AttackPoke:new(t)
	t = t or {}

	self.attackType = t.attackType or 'none'
	self.weaponType = t.weaponType or 'none'
	self.damage = math.max(t.damage or 0, 0)
end

function AttackPoke:getAttackType()
	return self.attackType
end

function AttackPoke:getWeaponType()
	return self.weaponType
end

function AttackPoke:getDamage()
	return self.damage
end

return AttackPoke
