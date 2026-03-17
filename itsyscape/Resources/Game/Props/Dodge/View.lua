--------------------------------------------------------------------------------
-- Resources/Game/Props/Dodge/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Decoration = require "ItsyScape.Graphics.Decoration"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticGreeble = require "Resources.Game.Props.Common.Greeble.StaticGreeble"

local Dodge = Class(PropView)

Dodge.LIGHTNESS_SHIFT  = 0.05
Dodge.SATURATION_SHIFT = 0.1

Dodge.SHIFT_SPEED = math.pi * 4

Dodge.INNER_ROTATION_SPEED = -math.pi
Dodge.OUTER_ROTATION_SPEED = math.pi

function Dodge:new(...)
	PropView.new(self, ...)

	self.innerGreeble = self:addGreeble(StaticGreeble, {
		MESH = "Resources/Game/Props/Dodge/Model.lstatic",
		GROUP = "dodge.inner",
		MATERIAL = DecorationMaterial({
			shader = "Resources/Shaders/SoftSolid",
			texture = false,

			properties = {
				isTranslucent = true,
				isFullLit = true,
				color = "ffffff",
				alpha = 0,
				outlineThreshold = -1,
				isZWriteDisabled = true,
				zBias = 0.005
			},

			uniforms = {
				scape_Specular = { "float", 1 }
			}
		})
	})

	self.innerColor = Color(1, 1, 1, 0)
	self.shiftedInnerColor = Color()

	self.outerGreeble = self:addGreeble(StaticGreeble, {
		MESH = "Resources/Game/Props/Dodge/Model.lstatic",
		GROUP = "dodge.outer",
		MATERIAL = DecorationMaterial({
			shader = "Resources/Shaders/SoftSolid",
			texture = false,

			properties = {
				isTranslucent = true,
				isFullLit = true,
				color = "ffffff",
				alpha = 0,
				outlineThreshold = -1,
				isZWriteDisabled = true,
				zBias = 0.01
			},

			uniforms = {
				scape_Specular = { "float", 1 }
			}
		})
	})

	self.outerColor = Color(1, 1, 1, 0)
	self.shiftedOuterColor = Color()

	self.previousAlpha = 0
	self.currentAlpha = 0
end

function Dodge:getIsStatic()
	return false
end

function Dodge:tick()
	PropView.tick(self)

	local state = self:getProp():getState()

	if state.innerColor then
		self.innerColor:from(unpack(state.innerColor))
	end

	if state.outerColor then
		self.outerColor:from(unpack(state.outerColor))
	end

	self.previousAlpha = self.currentAlpha or 0
	self.currentAlpha = state.alpha or 1
end

function Dodge:update(delta)
	PropView.update(self, delta)

	local shiftDelta = math.sin(love.timer.getTime() * self.SHIFT_SPEED)
	local saturationShift = shiftDelta * self.SATURATION_SHIFT
	local lightnessShift = shiftDelta * self.LIGHTNESS_SHIFT
	local alpha = math.lerp(self.previousAlpha, self.currentAlpha, _APP:getPreviousFrameDelta())

	self.outerColor:shiftHSL(0, saturationShift, lightnessShift, self.shiftedInnerColor)
	self.innerColor:shiftHSL(0, saturationShift, lightnessShift, self.shiftedOuterColor)

	if self.innerGreeble:getDecorationNode() then
		local node = self.innerGreeble:getDecorationNode()

		local transform = node:getTransform()
		transform:setLocalRotation(Quaternion.fromAxisAngle(Vector.UNIT_Z, love.timer.getTime() * self.INNER_ROTATION_SPEED))

		local material = node:getMaterial()
		material:setColor(self.shiftedInnerColor)
		material:setAlpha(alpha)
	end

	if self.outerGreeble:getDecorationNode() then
		local node = self.outerGreeble:getDecorationNode()

		local transform = node:getTransform()
		transform:setLocalRotation(Quaternion.fromAxisAngle(Vector.UNIT_Z, love.timer.getTime() * self.OUTER_ROTATION_SPEED))

		local material = node:getMaterial()
		material:setColor(self.shiftedOuterColor)
		material:setAlpha(alpha)
	end
end

return Dodge
