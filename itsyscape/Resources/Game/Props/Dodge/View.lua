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
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Decoration = require "ItsyScape.Graphics.Decoration"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticGreeble = require "Resources.Game.Props.Common.Greeble.StaticGreeble"

local Dodge = Class(PropView)

Dodge.LIGHTNESS_SHIFT  = 0.2
Dodge.SATURATION_SHIFT = 0.1

Dodge.ALPHA = 0.1

Dodge.SHIFT_SPEED = math.pi / 2

function Dodge:new(...)
	PropView.new(self, ...)

	self.innerGreeble = self:addGreeble(StaticGreeble, {
		MESH = "Resources/Game/Props/Dodge/Model.lstatic",
		GROUP = "dodge.inner",
		MATERIAL = {
			shader = "Resources/Shaders/SoftSolid",
			texture = false,

			properties = {
				isTranslucent = true,
				isFullLit = true,
				color = "ffffff",
				alpha = 0,
				outlineThreshold = -1,
			},

			uniforms = {
				scape_Specular = { "float", 1 }
			}
		}
	})

	self.innerColor = Color(1, 1, 1, 0)
	self.shiftedInnerColor = Color()

	self.outerGreeble = self:addGreeble(StaticGreeble, {
		MESH = "Resources/Game/Props/Dodge/Model.lstatic",
		GROUP = "dodge.outer",
		MATERIAL = {
			shader = "Resources/Shaders/SoftSolid",
			texture = false,

			properties = {
				isTranslucent = true,
				isFullLit = true,
				color = "ffffff",
				alpha = 0,
				outlineThreshold = -1,
			},

			uniforms = {
				scape_Specular = { "float", 1 }
			}
		}
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
		self.outerColor:from(unpack(State.outerColor))
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
	self.outerColor.a = self.ALPHA * alpha
	self.innerColor:shiftHSL(0, saturationShift, lightnessShift, self.shiftedOuterColor)
	self.innerColor.a = self.ALPHA * alpha

	local innerMaterial = self.innerGreeble:getDecorationNode():getMaterial()
	innerMaterial:setColor(self.shiftedInnerColor)

	local outerMaterial = self.outerGreeble:getDecorationNode():getMaterial()
	outerMaterial:setColor(self.shiftedOuterColor)
end

return Cannonball
