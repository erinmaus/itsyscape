--------------------------------------------------------------------------------
-- Resources/Game/Props/Shop_Butcher_HangingBeef/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local Beef = Class(SimpleStaticView)
Beef.INITIAL_TIME_RANGE = 10
Beef.SPEED_DENOMINATOR = 1

function Beef:getTextureFilename()
	return "Resources/Game/Props/Shop_Butcher_HangingBeef/Texture.png"
end

function Beef:getModelFilename()
	return "Resources/Game/Props/Shop_Butcher_HangingBeef/Model.lstatic", "Cow"
end

function Beef:tick()
	SimpleStaticView.tick(self)

	local modelNode = self:getModelNode()
	
	local position = self:getProp():getPosition()
	local time = self.time or math.random() * Beef.INITIAL_TIME_RANGE
	local noise = love.math.noise(position.x / 33, position.y / 33, position.z / 33)
	local angleZ = (noise * time * math.pi) / Beef.SPEED_DENOMINATOR
	angleZ = math.sin(angleZ) * math.pi * (1 / 16)
	local rotationZ = Quaternion.fromAxisAngle(Vector.UNIT_Z, angleZ)
	modelNode:getTransform():setLocalRotation(rotationZ)

	self.time = self.time or time
end

function Beef:update(delta)
	SimpleStaticView.update(self, delta)

	if self.time then
		self.time = self.time + delta
	end
end

return Beef
