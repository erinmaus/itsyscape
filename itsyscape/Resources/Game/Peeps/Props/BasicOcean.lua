--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicOcean.lua
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
local OceanBehavior = require "ItsyScape.Peep.Behaviors.OceanBehavior"
local WhirlpoolBehavior = require "ItsyScape.Peep.Behaviors.WhirlpoolBehavior"
local PassableProp = require "Resources.Game.Peeps.Props.PassableProp"

local BasicOcean = Class(PassableProp)

function BasicOcean:new(...)
	PassableProp.new(self, ...)
end

function BasicOcean:getPropState()
	local mapScript = Utility.Peep.getMapScript(self)
	local ocean = mapScript and mapScript:getBehavior(OceanBehavior) or {}
	local whirlpool = mapScript and mapScript:getBehavior(WhirlpoolBehavior) or {}

	return {
		time = ocean.time or 0,

		ocean = {
			hasOcean = ocean ~= nil,
			y = ocean.depth,
			offset = ocean.offset,
			positionTimeScale = ocean.positionTimeScale,
			textureTimeScale = ocean.textureTimeScale and {
				ocean.textureTimeScale.x,
				ocean.textureTimeScale.y
			} or {},
			windSpeedMultiplier = ocean.windSpeedMultiplier or 0.25,
			windPatternMultiplier = { (ocean.windPatternMultiplier or Vector(2, 4, 8)):get() }
		},

		whirlpool = {
			hasWhirlpool = whirlpool ~= nil,
			center = whirlpool.center and { whirlpool.center.x, whirlpool.center.z },
			radius = whirlpool.radius,
			holeRadius = whirlpool.holeRadius,
			rings = whirlpool.rings,
			rotationSpeed = whirlpool.rotationSpeed,
			holeSpeed = whirlpool.holeSpeed,

		}
	}
end

return BasicOcean
