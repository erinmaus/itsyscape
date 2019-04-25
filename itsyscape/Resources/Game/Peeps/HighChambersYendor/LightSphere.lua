--------------------------------------------------------------------------------
-- Resources/Peeps/HighChambersYendor/LightSphere.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Ray = require "ItsyScape.Common.Math.Ray"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local LightRaySourceBehavior = require "ItsyScape.Peep.Behaviors.LightRaySourceBehavior"
local BasicLightRayCaster = require "Resources.Game.Peeps.Props.BasicLightRayCaster"

local LightSphere = Class(BasicLightRayCaster)

function LightSphere:new(...)
	BasicLightRayCaster.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1.5, 1.5, 1.5)
end

function LightSphere:onFinalize(...)
	BasicLightRayCaster.onFinalize(self, ...)

	local light = self:getBehavior(LightRaySourceBehavior)
	light.rays = {
		Ray(Vector.ZERO, Vector.UNIT_Y),
		Ray(Vector.ZERO, Vector.UNIT_Z)
	}
end

return LightSphere
