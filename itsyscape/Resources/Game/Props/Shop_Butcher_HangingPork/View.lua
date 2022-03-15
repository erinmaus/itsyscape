--------------------------------------------------------------------------------
-- Resources/Game/Props/Shop_Butcher_HangingPork/View.lua
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

local Pork = Class(SimpleStaticView)
Pork.INITIAL_TIME_RANGE = 10
Pork.SPEED_DENOMINATOR = 1

function Pork:getTextureFilename()
	return "Resources/Game/Props/Shop_Butcher_HangingPork/Texture.png"
end

function Pork:getModelFilename()
	return "Resources/Game/Props/Shop_Butcher_HangingPork/Model.lstatic", "Pig"
end

function Pork:tick()
	SimpleStaticView.tick(self)

	local modelNode = self:getModelNode()
	
	local position = self:getProp():getPosition()
	local time = self.time or math.random() * Pork.INITIAL_TIME_RANGE
	local noise = love.math.noise(position.x / 33, position.y / 33, position.z / 33)
	local angleZ = (noise * time * math.pi) / Pork.SPEED_DENOMINATOR
	angleZ = math.sin(angleZ) * math.pi * (1 / 16)
	local rotationZ = Quaternion.fromAxisAngle(Vector.UNIT_Z, angleZ)
	modelNode:getTransform():setLocalRotation(rotationZ)

	self.time = self.time or time
end

function Pork:update(delta)
	SimpleStaticView.update(self, delta)

	if self.time then
		self.time = self.time + delta
	end
end

return Pork
