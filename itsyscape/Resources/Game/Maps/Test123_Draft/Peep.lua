--------------------------------------------------------------------------------
-- Resources/Game/Maps/Test123_Draft/Peep.lua
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
local Map = require "ItsyScape.Peep.Peeps.Map"
local SkyBehavior = require "ItsyScape.Peep.Behaviors.SkyBehavior"

local TestMap = Class(Map)

function TestMap:onLoad(...)
	Map.onLoad(self, ...)

	self:addBehavior(SkyBehavior)
end

return TestMap
