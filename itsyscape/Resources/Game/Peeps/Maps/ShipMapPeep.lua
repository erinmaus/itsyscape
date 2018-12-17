--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Maps/ShipMapPeep.lua
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
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"

local ShipMapPeep = Class(Map)

function ShipMapPeep:new(name, ...)
	Map.new(self, name or 'ShipMapPeep', ...)

	self:addBehavior(PositionBehavior)
	self:addBehavior(RotationBehavior)
	self.time = 0
end

function ShipMapPeep:getPrefix()
	return "Small"
end

function ShipMapPeep:getSuffix()
	return "Default"
end

function ShipMapPeep:onLoad(filename, args)
	local game = self:getDirector():getGameInstance()
	local stage = game:getStage()

	local map = args['map']
	if map then
		Log.info('Ship map: %s.', map)
		local layer, script = stage:loadMapResource(map, {
			ship = filename
		})

		-- TODO: get this from the map
		local WATER_ELEVATION = 2.25

		if script then
			local baseMap = stage:getMap(1)
			local x = (baseMap:getWidth() + 0.5) * baseMap:getCellSize() / 2
			local z = (baseMap:getHeight()+ 0.5) * baseMap:getCellSize() / 2

			local boatFoamPropName = string.format("resource://BoatFoam_%s_%s", self:getPrefix(), self:getSuffix())
			local _, boatFoamProp = stage:placeProp(boatFoamPropName, layer)
			if boatFoamProp then
				local peep = boatFoamProp:getPeep()
				peep:listen('finalize', function()
					local position = peep:getBehavior(PositionBehavior)
					if position then
						position.position = Vector(x, WATER_ELEVATION, z)
					end
				end)
			end

			local boatFoamTrailPropName = string.format("resource://BoatFoamTrail_%s_%s", self:getPrefix(), self:getSuffix())
			local _, boatFoamTrailProp = stage:placeProp(boatFoamTrailPropName, layer)
			if boatFoamTrailProp then
				local peep = boatFoamTrailProp:getPeep()
				peep:listen('finalize', function()
					local position = peep:getBehavior(PositionBehavior)
					if position then
						position.position = Vector(x, WATER_ELEVATION, z)
					end
				end)
			end
		end
	else
		Log.warn("No ship map.")
	end
end

function ShipMapPeep:update(director, game)
	Map.update(self, director, game)

	local delta = game:getDelta()

	self.time = self.time + delta

	local position = self:getBehavior(PositionBehavior)
	if position then
		position.position = Vector(0, math.sin(self.time * math.pi / 2) * 0.5, 0)
	end
end

return ShipMapPeep
