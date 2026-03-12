--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Arachnid/WarfMite.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local Mite = require "Resources.Game.Peeps.Arachnid.Mite"

local WarfMite = Class(Mite)

function WarfMite:ready(director, game)
	Mite.ready(self, director, game)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 4

	Utility.Peep.Creep.applySkin(
		self,
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"WarfMite/WarfMite.lua")
end

return WarfMite
