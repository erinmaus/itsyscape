--------------------------------------------------------------------------------
-- ItsyScape/Game/Dialog/Orlando/Common.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"

local Common = {}

function Common.orlando_has_lit_coconut_fire(dialog)
	local peep = dialog:getSpeaker("_TARGET")
	if not peep then
		return false
	end

	local coconutFires = peep:getDirector():probe(
		peep:getLayerName(),
		Probe.passage("Passage_FishingArea"),
		Probe.resource("Prop", "CoconutFire"))

	return #coconutFires >= 1
end

return Common
