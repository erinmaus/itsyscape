--------------------------------------------------------------------------------
-- ItsyScape/Game/ActionCommand/Map.lua
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
local Component = require "ItsyScape.Game.ActionCommands.Component"

local Map = Class(Component)
Map.TYPE = "map"

function Map:new()
	Component.new(self)

	self.mapScript = false
	self.offset = Vector()
	self.distance = 20
	self.verticalRotation = -math.pi / 2 + math.pi / 8
	self.horizontalRotation = -math.pi / 8
end

function Map:setMap(value)
	self.mapScript = value or false
end

function Map:getMap()
	return self.mapScript
end

function Map:setOffset(value)
	self.offset:from((value or Vector.ZERO):get())
end

function Map:getOffset()
	return self.offset
end

function Map:setDistance(value)
	self.distance = value
end

function Map:getDistance()
	return self.distance
end

function Map:setVerticalRotation(value)
	self.verticalRotation = value or 0
end

function Map:getVerticalRotation()
	return self.verticalRotation
end

function Map:setHorizontalRotation(value)
	self.horizontalRotation = value or 0
end

function Map:getHorizontalRotation()
	return self.horizontalRotation
end

function Map:serialize(t)
	Component.serialize(self, t)

	t.mapLayer = false
	t.offsetX = self.offset.x
	t.offsetY = self.offset.y
	t.offsetZ = self.offset.z
	t.distance = self.distance
	t.verticalRotation = self.verticalRotation
	t.horizontalRotation = self.horizontalRotation

	if not (self.mapScript and self.mapScript:getIsReady()) then
		return
	end

	t.mapLayer = Utility.Peep.getLayer(self.mapScript)
end

return Map
