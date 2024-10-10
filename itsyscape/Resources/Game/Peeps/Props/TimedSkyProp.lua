--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Props/TimedSkyProp.lua
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
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local SkyBehavior = require "ItsyScape.Peep.Behaviors.SkyBehavior"

local TimedSkyProp = Class(Prop)

function TimedSkyProp:new(...)
	Prop.new(self, ...)
end

function TimedSkyProp:spawnOrPoofTile()
	-- Nothing.
end

function TimedSkyProp:getPropState()
	local mapScript = Utility.Peep.getMapScript(self)
	local sky = mapScript and mapScript:getBehavior(SkyBehavior)

	return {
		offset = sky and sky.currentOffsetSeconds or 0
	}
end

return TimedSkyProp
