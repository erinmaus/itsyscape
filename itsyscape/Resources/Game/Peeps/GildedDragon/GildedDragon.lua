--------------------------------------------------------------------------------
-- Resources/Peeps/GildedDragon/GildedDragon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"

local GildedDragon = Class(Creep)

function GildedDragon:ready(director, game)
	Creep.ready(self, director, game)

	Utility.Peep.Creep.setBody(self, "Dragon")

	Utility.Peep.Creep.addAnimation(self, "animation-idle", "Dragon_Idle_Fossil")
	Utility.Peep.Creep.addAnimation(self, "animation-walk", "Dragon_Idle_Fossil")
	Utility.Peep.Creep.addAnimation(self, "animation-die", "Dragon_Idle_Fossil")

	Utility.Peep.Creep.applySkin(
		self,
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"GildedDragon/GildedDragon.lua")
end

function GildedDragon:update(director, game)
	Creep.update(self, director, game)

	if Utility.Peep.face3D(self) then
		local rotation = self:getBehavior(RotationBehavior)
		if rotation.rotation then
			rotation.rotation = rotation.rotation * Quaternion.fromAxisAngle(Vector.UNIT_Y, -math.pi / 3)
		end
	end
end

return GildedDragon
