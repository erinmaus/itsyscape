--------------------------------------------------------------------------------
-- Resources/Game/Props/Hay_Default/View.lua
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

local Hay = Class(SimpleStaticView)

function Hay:new(...)
	SimpleStaticView.new(self, ...)
end

function Hay:tick()
	local root = self:getRoot()
	local position = self:getProp():getPosition()
	local value = love.math.noise(position.x / 2, position.y / 2, position.z / 2)
	local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi * value * 2)

	self.decoration:getTransform():setLocalRotation(rotation)

	SimpleStaticView.tick(self)
end

function Hay:getTextureFilename()
	return "Resources/Game/Props/Hay_Default/Texture.png"
end

function Hay:getModelFilename()
	return "Resources/Game/Props/Hay_Default/Model.lstatic", "HayBale"
end

return Hay
