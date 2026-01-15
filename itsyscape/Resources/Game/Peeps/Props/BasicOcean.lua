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
local Probe = require "ItsyScape.Peep.Probe"
local OceanBehavior = require "ItsyScape.Peep.Behaviors.OceanBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"
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

	local shipPeeps = self:getDirector():probe(
		self:getLayerName(),
		Probe.layer(Utility.Peep.getLayer(self)),
		Probe.component(ShipMovementBehavior))

	local ships = {}
	for _, shipPeep in ipairs(shipPeeps) do
		local shipMovement = shipPeep:getBehavior(ShipMovementBehavior)
		local mask = shipMovement and shipMovement.mask
		if mask then
			local position, rotation, scale, origin = Utility.Peep.getDecomposedMapTransform(shipPeep)
			local ship = {
				id = shipPeep:getTally(),
				position = { position:get() },
				rotation = { rotation:get() },
				scale = { scale:get() },
				origin = { origin:get() },
				size = { shipMovement.beam, 0, shipMovement.length },
				direction = { shipMovement.steerDirectionNormal:get() },
				mask = mask
			}

			table.insert(ships, ship)
		end
	end

	return {
		time = ocean.time or 0,
		x = love.timer.getTime(),

		ships = ships,

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
