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
GoredDragon.EQUIPMENT_SLOT_BONES      = "bones"
GoredDragon.EQUIPMENT_SLOT_FLAME_SACK = "flame-sack"

function GoredDragon:new(...)
	BaseDragon.new(self, ...)

	Utility.Peep.makeArtisanStation(self)
end

function GoredDragon:ready(director, game)
	BaseDragon.ready(self, director, game)

	Utility.Peep.Creep.applySkin(
		self,
		self.EQUIPMENT_SLOT_BONES,
		Equipment.SKIN_PRIORITY_BASE,
		"GoredDragon/Bones.lua")

	Utility.Peep.Creep.applySkin(
		self,
		self.EQUIPMENT_SLOT_FLAME_SACK,
		Equipment.SKIN_PRIORITY_BASE,
		"GoredDragon/FlameSack.lua")

	Utility.Peep.equipXWeapon(self, "Dragon_ChargedDragonfyre")
end

return GoredDragon
