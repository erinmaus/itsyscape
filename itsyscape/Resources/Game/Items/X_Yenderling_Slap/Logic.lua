--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Yendlering_Slap/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"

local YendleringSlap = Class(MeleeWeapon)

function YendleringSlap:getAttackRange(peep)
	return 2
end

function YendleringSlap:previewDamageRoll(roll)
	local target = roll:getTarget()
	if target and target:hasBehavior(PlayerBehavior) then
		if not target:getState():has("KeyItem", "PreTutorial_LearnedAboutStances") then
			roll:setMinHit(0)
			roll:setMaxHit(0)
		end
	end
end

function YendleringSlap:getBonusForStance(peep)
	return Weapon.BONUS_CRUSH
end

function YendleringSlap:getCooldown()
	return 3
end

return YendleringSlap
