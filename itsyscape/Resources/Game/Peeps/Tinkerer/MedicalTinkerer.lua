--------------------------------------------------------------------------------
-- Resources/Peeps/Tinkerer/MedicalTinkerer.lua
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
local Probe = require "ItsyScape.Peep.Probe"
local BaseTinkerer = require "Resources.Game.Peeps.Tinkerer.BaseTinkerer"

local Tinkerer = Class(BaseTinkerer)

function Tinkerer:ready(director, game)
	BaseTinkerer.ready(self, director, game)

	Utility.Peep.Creep.addAnimation(self, "animation-attack", "Tinkerer_Attack_Saw")
	Utility.Peep.Creep.addAnimation(self, "animation-idle", "Tinkerer_Idle_Saw")
	Utility.Peep.Creep.addAnimation(self, "animation-fly", "Tinkerer_Fly")

	Utility.Peep.Creep.applySkin(
		self,
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"Tinkerer/MedicalTinkerer.lua")

	Utility.Peep.Creep.applySkin(
		self,
		Equipment.PLAYER_SLOT_TWO_HANDED,
		Equipment.SKIN_PRIORITY_EQUIPMENT,
		"Tinkerer/MedicalSaw.lua")

	Utility.Peep.equipXWeapon(self, "Tinkerer_Attack_MedicalSaw")
end

return Tinkerer
