--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Props/Cloud.lua
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
local CloudBehavior = require "ItsyScape.Peep.Behaviors.CloudBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local SkyBehavior = require "ItsyScape.Peep.Behaviors.SkyBehavior"

local Cloud = Class(Prop)
Cloud.MIN_NUM_LUMPS = 2
Cloud.MAX_NUM_LUMPS = 6

Cloud.MIN_LUMP_RADIUS = 1
Cloud.MAX_LUMP_RADIUS = 3

Cloud.MIN_LUMP_OFFSET = Vector(4, 1, 4)
Cloud.MAX_LUMP_OFFSET = Vector(8, 2, 8)

Cloud.MIN_SCALE = 2
Cloud.MAX_SCALE = 4

function Cloud:new(...)
	Prop.new(self, ...)

	self:addBehavior(MovementBehavior)
	self:addBehavior(CloudBehavior)
end

function Cloud:ready(...)
	Prop.ready(self, ...)

	local movement = self:getBehavior(MovementBehavior)
	movement.noClip = true
	movement.maxSpeed = math.huge

	self.currentCloudID = 0
	self.cloudState = {}

	local numLumps = love.math.random(self.MIN_NUM_LUMPS, self.MAX_NUM_LUMPS)
	for i = 1, numLumps do
		table.insert(self.cloudState, self:generateLump())
	end
end

function Cloud:generateLump()
	local id = self.currentCloudID + 1
	self.currentCloudID = id

	local position = {
		love.math.random() * (self.MAX_LUMP_OFFSET.x - self.MIN_LUMP_OFFSET.x) + self.MIN_LUMP_OFFSET.x,
		love.math.random() * (self.MAX_LUMP_OFFSET.y - self.MIN_LUMP_OFFSET.y) + self.MIN_LUMP_OFFSET.y,
		love.math.random() * (self.MAX_LUMP_OFFSET.z - self.MIN_LUMP_OFFSET).z + self.MIN_LUMP_OFFSET.z,
	}

	local radius = love.math.random() * (self.MAX_LUMP_RADIUS - self.MIN_LUMP_RADIUS) + self.MIN_LUMP_RADIUS

	local scale = love.math.random() * (self.MAX_SCALE - self.MIN_SCALE) + self.MIN_SCALE
	Utility.Peep.setScale(self, Vector(scale))

	return {
		id = id,
		position = position,
		radius = radius
	}
end

function Cloud:spawnOrPoofTile()
	-- Nothing.
end

function Cloud:getPropState()
	local mapScript = Utility.Peep.getMapScript(self)
	local sky = mapScript and mapScript:getBehavior(SkyBehavior)
	local cloud = self:getBehavior(CloudBehavior)

	return {
		wind = sky and { (sky.windDirection * sky.windSpeed):get() },
		sun = sky and { sky.sunPosition:get() },
		color = { 1, 1, 1, 1 },
		alpha = cloud and cloud.alpha or 0.5,
		clouds = self.cloudState
	}
end

return Cloud
