--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Dragon_ChargedDragonfyreHit/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local MagicWeapon = require "ItsyScape.Game.MagicWeapon"

local ChargedDragonfyreHit = Class(MagicWeapon)

function ChargedDragonfyreHit:pokeInitiateAttack(...)
	-- This is a (potential) multi-hit attack that gets initiated by X_Dragon_ChargedDragonfyre.
	-- Let X_Dragon_ChargedDragonfyre fire the initial 'initiateAttack'.
end

function ChargedDragonfyreHit:getAttackRange()
	return 0
end

function ChargedDragonfyreHit:getCooldown()
	return 0
end

return ChargedDragonfyreHit