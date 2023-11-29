--------------------------------------------------------------------------------
-- Resources/Game/Items/RustyNeedle/Logic.lua
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
local Zweihander = require "Resources.Game.Items.Common.Zweihander"
local TetanusEffect = require "Resources.Game.Effects.Tetanus.Effect"

local RustyNeedle = Class(Zweihander)

function RustyNeedle:getBonusForStance(peep)
	return Weapon.BONUS_STAB
end

function RustyNeedle:onAttackHit(peep, target)
	Zweihander.onAttackHit(self, peep, target)

	local effect = target:getEffect(TetanusEffect)
	if not effect then
		Utility.Peep.applyEffect(target, "Tetanus", true, peep)
	else
		effect:boost()
	end
end

return RustyNeedle
