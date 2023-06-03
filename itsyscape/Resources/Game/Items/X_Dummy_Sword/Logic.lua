--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Dummy_Sword/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"
local Utility = require "ItsyScape.Game.Utility"

local XDummySword = Class(MeleeWeapon)

function XDummySword:getCooldown(peep)
	return Utility.Peep.Dummy.getAttackCooldown(peep) or 2.4
end

function XDummySword:getAttackRange(peep)
	return Utility.Peep.Dummy.getAttackRange(peep) or 1
end

function XDummySword:getProjectile(peep)
	return Utility.Peep.Dummy.getProjectile(peep)
end

return XDummySword
