--------------------------------------------------------------------------------
-- Resources/Game/Items/X_TheEmptyKing_FullyRealized_Zweihander/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local MagicWeapon = require "ItsyScape.Game.MagicWeapon"

local Staff = Class(MagicWeapon)

function Staff:getAttackRange()
	return 16
end

function Staff:getCooldown(peep)
	return 1.8
end

function Staff:perform(peep, target)
	MagicWeapon.perform(self, peep, target)

	local stage = peep:getDirector():getGameInstance():getStage()
	stage:fireProjectile("TheEmptyKing_FullyRealized_Staff", peep, target)

	return true
end

return Staff
