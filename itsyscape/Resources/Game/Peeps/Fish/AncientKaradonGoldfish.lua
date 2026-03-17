--------------------------------------------------------------------------------
-- Resources/Peeps/Fish/AncientKaradonGoldfish.lua
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
local BaseFish = require "Resources.Game.Peeps.Fish.BaseFish"

local AncientKaradonGoldfish = Class(BaseFish)

function AncientKaradonGoldfish:ready(director, game)
	Utility.Peep.Creep.applySkin(
		self,
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"Fish/AncientKaradonGoldfish.lua")

	BaseFish.ready(self, director, game)
end

return AncientKaradonGoldfish
