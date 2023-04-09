--------------------------------------------------------------------------------
-- Resources/Game/Props/Crate_Default1/View.lua
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

local Crate = Class(SimpleStaticView)

function Crate:new(...)
	SimpleStaticView.new(self, ...)
end

function Crate:tick()
	local root = self:getRoot()
	local position = self:getProp():getPosition()
	local value = love.math.noise(position.x / 2, position.y / 2, position.z / 2)
	local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi * value * 2)

	self.decoration:getTransform():setLocalRotation(rotation)

	SimpleStaticView.tick(self)
end

function Crate:getTextureFilename()
	return "Resources/Game/Props/Crate_Default1/Texture.png"
end

function Crate:getModelFilename()
	return "Resources/Game/Props/Crate_Default1/Model.lstatic", "Crate"
end

return Crate
