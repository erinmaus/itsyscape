--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/PlayerBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies the position of a Peep.
local PlayerBehavior = Behavior("Player")

-- Constructs a PlayerBehavior.
function PlayerBehavior:new(x, y, z)
	Behavior.Type.new(self)
end

return PlayerBehavior
