--------------------------------------------------------------------------------
-- Resources/Game/Items/X_AncientKaradon_Magic/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MagicWeapon = require "ItsyScape.Game.MagicWeapon"
local Utility = require "ItsyScape.Game.Utility"

local MagicAttack = Class(MagicWeapon)

function MagicAttack:getCooldown(peep)
	return 3
end

function MagicAttack:getAttackRange(peep)
	return 16
end

function MagicAttack:getProjectile(peep)
	return "WaterBlast"
end

return MagicAttack
