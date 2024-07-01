--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Props/Sun.lua
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

local Sun = Class(Prop)

function Sun:new(...)
	Prop.new(self, ...)
end

function Sun:spawnOrPoofTile()
	-- Nothing.
end

function Sun:getPropState()
	local mapScript = Utility.Peep.getMapScript(self)
	local sky = mapScript and mapScript:getBehavior(SkyBehavior)

	return {
		color = sky and { sky.sunColor.r, sky.sunColor.g, sky.sunColor.b, sky.sunColor.a * sky.sunAlpha },
		currentSkyColor = sky and { sky.currentSkyColor.r, sky.currentSkyColor.g, sky.currentSkyColor.b, sky.currentSkyColor.a },
		previousSkyColor = sky and { sky.previousSkyColor.r, sky.previousSkyColor.g, sky.previousSkyColor.b, sky.previousSkyColor.a },
		normal = sky and { (sky.sunColor.a <= 0 and sky.sunNormal or sky.sunNormal):get() }
	}
end

return Sun
