--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Dog/Yenderhound.lua
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
local Dog = require "Resources.Game.Peeps.Dog.Dog"

local Yenderhound = Class(Dog)

function Yenderhound:ready(director, game)
	Dog.ready(self, director, game)

	Utility.Peep.Creep.applySkin(
		self,
		Equipment.PLAYER_SLOT_SELF,
		Equipment.SKIN_PRIORITY_BASE,
		"Yenderhound/Yenderhound.lua")
end

return Yenderhound
