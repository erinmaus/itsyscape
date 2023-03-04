--------------------------------------------------------------------------------
-- Resources/Game/Items/X_ChocoroachVomit/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local MagicWeapon = require "ItsyScape.Game.MagicWeapon"

local ChocoroachVomit = Class(MagicWeapon)

function ChocoroachVomit:getAttackRange(peep)
	return 2
end

function ChocoroachVomit:getProjectile()
	return 'ChocoroachVomit'
end

function ChocoroachVomit:getCooldown()
	return 1.8
end

return ChocoroachVomit
