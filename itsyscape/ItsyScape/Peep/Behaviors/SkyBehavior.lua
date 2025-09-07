--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/SkyBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"
local Color = require "ItsyScape.Graphics.Color"

local SkyBehavior = Behavior("Sky")

function SkyBehavior:new()
	Behavior.Type.new(self)

	self.hasSky = true

	self.sunNormal = Vector()
	self.sunDistance = 35
	self.sunPosition = Vector()
	self.sunPropType = "Sun_Default"
	self.sunColor = Color(1, 0.4, 0.0, 1.0)
	self.sunAlpha = 1.0

	self.currentOffsetSeconds = false
	self.startOffsetSeconds = 0
	self.stopOffsetSeconds = 0
	self.offsetTimeDelta = 0

	self.moonNormal = Vector()
	self.moonDistance = 35
	self.moonPosition = Vector()
	self.moonPropType = "Moon_Default"
	self.moonColor = Color.fromHexString("5fd3bc")
	self.moonRotation = Quaternion.fromAxisAngle(Vector.UNIT_Z, -math.pi / 4)
	self.moonAlpha = 1.0

	self.dawnSkyColor = Color.fromHexString("ff80b2")
	self.daySkyColor = Color.fromHexString("87cdde")
	self.duskSkyColor = Color.fromHexString("ff9955")
	self.nightSkyColor = Color.fromHexString("111128")
	self.previousSkyColor = self.daySkyColor
	self.currentSkyColor = self.daySkyColor

	self.dawnAmbientColor = Color.fromHexString("ff80b2", 0.5) * Color(0.5)
	self.dayAmbientColor = Color.fromHexString("ffffff", 0.7) * Color(0.5)
	self.duskAmbientColor = Color.fromHexString("ff9955", 0.5)
	self.nightAmbientColor = Color.fromHexString("111128", 0.6)
	self.currentAmbientColor = self.dayAmbientColor

	self.skyDawnAmbientColor = Color.fromHexString("ff80b2", 0.5) * Color(0.5)
	self.skyDayAmbientColor = Color.fromHexString("ffffff", 0.7) * Color(0.5)
	self.skyDuskAmbientColor = Color.fromHexString("ff9955", 0.5)
	self.skyNightAmbientColor = Color.fromHexString("111128", 0.6)
	self.currentSkyAmbientColor = self.skyDayAmbientColor

	self.hasFog = false
	self.fogNearDistance = 40
	self.fogFarDistance = 100
	self.fogFollowTarget = false

	self.windDirection = Vector(1, 0, 0):getNormal()
	self.windSpeed = 0.25

	self.cloudiness = 0.1
	self.cloudPropType = "Cloud_Default"

	-- Clouds spawn around the mid point to the end point of the troposhere
	self.troposphereEnd = 30

	-- No clue what goes here?
	self.stratosphereEnd = 50

	-- Between the stratosphere and here is where comets, space debris spawn.
	-- After the mesosphere ends, space starts.
	self.mesosphereEnd = 60
end

return SkyBehavior
