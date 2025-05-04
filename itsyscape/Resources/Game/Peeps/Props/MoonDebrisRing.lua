--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Props/MoonDebrisRing.lua
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
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local SkyBehavior = require "ItsyScape.Peep.Behaviors.SkyBehavior"
local TimedSkyProp = require "Resources.Game.Peeps.Props.TimedSkyProp"

local MoonDebrisRing = Class(TimedSkyProp)

function MoonDebrisRing:getPropState()
	local mapScript = Utility.Peep.getMapScript(self)
	local sky = mapScript and mapScript:getBehavior(SkyBehavior)

	local state = TimedSkyProp.getPropState(self)
	state.currentSkyColor = sky and { sky.currentSkyColor.r, sky.currentSkyColor.g, sky.currentSkyColor.b, sky.currentSkyColor.a }
	state.previousSkyColor = sky and { sky.previousSkyColor.r, sky.previousSkyColor.g, sky.previousSkyColor.b, sky.previousSkyColor.a }

	return state
end

return MoonDebrisRing
