--------------------------------------------------------------------------------
-- Resources/Peeps/Yendorian/ScoutYendorian.lua
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
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local BaseYendorian = require "Resources.Game.Peeps.Yendorian.BaseYendorian"

local ScoutYendorian = Class(BaseYendorian)

function ScoutYendorian:ready(director, game)
	BaseYendorian.ready(self, director, game)

	Utility.Peep.Creep.setBody(self, "Yendorian")

	Utility.Peep.Creep.applySkin(
		self,
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"Yendorian/Yendorian_Scout.lua")

	Utility.Peep.Creep.applySkin(
		self,
		Equipment.PLAYER_SLOT_TWO_HANDED,
		Equipment.SKIN_PRIORITY_EQUIPMENT,
		"Yendorian/Weapon_Flare.lua")

	Utility.Peep.Creep.addAnimation(
		self,
		"animation-attack",
		"Yendorian_Attack_Flare")

	Utility.Peep.equipXWeapon(self, "YendorianFlare")
end

function ScoutYendorian:update(director, game)
	BaseYendorian.update(self, director, game)

	if Utility.Peep.face3D(self) then
		local rotation = self:getBehavior(RotationBehavior)
		if rotation.rotation then
			rotation.rotation = rotation.rotation * Quaternion.fromAxisAngle(Vector.UNIT_Y, -math.pi / 3)
		end
	end
end

return ScoutYendorian
