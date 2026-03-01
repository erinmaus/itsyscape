--------------------------------------------------------------------------------
-- Resources/Game/ActionCommands/MineHumanityEdgeAzatite.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Mine1 = require "Resources.Game.ActionCommands.Mine1"

MineHumanityEdgeAzatite = Class(Mine1)
MineHumanityEdgeAzatite.MAP = "Skilling_MiningHumanityEdgeAzatite"

function MineHumanityEdgeAzatite:updateMapCamera()
	Mine1.updateMapCamera(self)

	self:getMapWidget():setDistance(20)
end

return MineHumanityEdgeAzatite
