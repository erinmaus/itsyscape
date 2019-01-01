--------------------------------------------------------------------------------
-- Resources/Game/Peeps/HighChambersYendor/Common.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Equipment = require "ItsyScape.Game.Equipment"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local Utility = require "ItsyScape.Game.Utility"

local Common = {}
function Common.targetPlayer(target)
	return function(peep)
		return peep:hasBehavior(PlayerBehavior)
	end
end

return Common
