--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicSailingItem.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local ColorBehavior = require "ItsyScape.Peep.Behaviors.ColorBehavior"
local PassableProp = require "Resources.Game.Peeps.Props.PassableProp"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"
local SkyBehavior = require "ItsyScape.Peep.Behaviors.SkyBehavior"

local BasicSailingItem = Class(PassableProp)

function BasicSailingItem:new(...)
	PassableProp.new(self, ...)

	self:addBehavior(ColorBehavior)
end

function BasicSailingItem:getPropState()
	local instance = Utility.Peep.getInstance(self)
	local mapGroup = instance and instance:getMapGroup(Utility.Peep.getLayer(self))
	local shipLayer = instance and mapGroup and instance:getGlobalLayerFromLocalLayer(mapGroup, 1)
	local shipMapScript = instance and shipLayer and instance:getMapScriptByLayer(baseLayer)
	local shipMovement = shipMapScript:getBehavior(ShipMovementBehavior)

	local baseMapScript = instance:getBaseMapScript()
	local baseMapSky = baseMapScript and baseMapScript:getBehavior(SkyBehavior)

	local windDirection = (baseMapSky and baseMapSky.windDirection or Vector(1, 0, 0)):getNormal()
	local shipDirection = shipMovement and Quaternion.transformVector(shipMovement.rotation, steerDirectionNormal) or Vector(-1, 0, 0)
	local windDotShip = windDirection:dot(shipDirection)
	local power = math.max(windDotShip, 0)

	local resource = Utility.Peep.getResource(self)

	local colors = self:getBehavior(ColorBehavior)

	return {
		primary = { colors.primary:get() },
		secondary = { (colors.secondaries[1] or Color()):get() },

		-- new stuff
		resource = resource and resource.name or false,

		shipState = {
			rudderDirection = shipMovement and shipMovement.steerDirection or 0,
			windPower = power,
			sailsHoisted = shipMovement and shipMovement.isMoving or false,
		},

		colors = {
			{ colors.primary:get() },
			{ (colors.secondaries[1] or Color()):get() }
		}
	}
end

return BasicSailingItem
