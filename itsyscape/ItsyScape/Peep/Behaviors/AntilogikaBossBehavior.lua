--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/AntilogikaBossBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

local AntilogikaBoss = Behavior("AntilogikaBoss")

function AntilogikaBoss:new()
	Behavior.Type.new(self)
end

return AntilogikaBoss
