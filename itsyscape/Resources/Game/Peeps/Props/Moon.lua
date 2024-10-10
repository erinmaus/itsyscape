--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Props/Moon.lua
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

local Moon = Class(Prop)

function Moon:new(...)
	Prop.new(self, ...)
end

function Moon:spawnOrPoofTile()
	-- Nothing.
end

function Moon:getPropState()
	local mapScript = Utility.Peep.getMapScript(self)
	local sky = mapScript and mapScript:getBehavior(SkyBehavior)

	return {
		color = sky and { sky.moonColor.r, sky.moonColor.g, sky.moonColor.b, sky.moonColor.a * sky.moonAlpha },
		skyColor = sky and { sky.currentSkyColor.r, sky.currentSkyColor.g, sky.currentSkyColor.b, sky.currentSkyColor.a },
		normal = sky and { sky.moonNormal:get() }
	}
end

return Moon
