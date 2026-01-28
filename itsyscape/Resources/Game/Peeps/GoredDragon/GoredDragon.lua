--------------------------------------------------------------------------------
-- Resources/Peeps/GoredDragon/GoredDragon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local BaseDragon = require "Resources.Game.Peeps.Dragon.BaseDragon"

local GoredDragon = Class(BaseDragon)
GoredDragon.EQUIPMENT_SLOT_BONES = "bones"

function GoredDragon:ready(director, game)
	BaseDragon.ready(self, director, game)

	Utility.Peep.Creep.applySkin(
		self,
		self.EQUIPMENT_SLOT_BONES,
		Equipment.SKIN_PRIORITY_BASE,
		"GoredDragon/Bones.lua")

	Utility.Peep.equipXWeapon(self, "Dragon_ChargedDragonfyre")
end

return GoredDragon
