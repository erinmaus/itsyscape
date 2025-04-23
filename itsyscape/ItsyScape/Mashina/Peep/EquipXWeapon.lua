--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/EquipXWeapon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"

local EquipXWeapon = B.Node("EquipXWeapon")
EquipXWeapon.PEEP = B.Reference()
EquipXWeapon.X_WEAPON = B.Reference()

function EquipXWeapon:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina

	Utility.Peep.equipXWeapon(peep, state[self.X_WEAPON])

	return B.Status.Success
end

return EquipXWeapon
