--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/IsCombatStyle.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"

local IsCombatStyle = B.Node("IsCombatStyle")
IsCombatStyle.TARGET = B.Reference()
IsCombatStyle.STYLE = B.Reference()

function IsCombatStyle:update(mashina, state, executor)
	local peep = state[self.TARGET] or mashina
	local weapon = Utility.Peep.getEquippedWeapon(peep, true)

	local style
	if weapon then
		style = weapon:getStyle()
	else
		style = Weapon.STYLE_MELEE
	end

	local otherStyle = state[self.STYLE] or Weapon.STYLE_NONE

	if otherStyle == style then
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return IsCombatStyle
