--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/GamepadCirclePanelZap.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Utility = require "ItsyScape.Game.Utility"
local Particles = require "ItsyScape.UI.Particles"
local Widget = require "ItsyScape.UI.Widget"

local GamepadCirclePanelZap = Class(Widget)
GamepadCirclePanelZap.DURATION = 0.5

function GamepadCirclePanelZap.zap(widget)
	local absoluteX, absoluteY = widget:getAbsoluteCenter()

	local parent = widget:getRootParent()
	if parent then
		local zap = GamepadCirclePanelZap()
		local parentX, parentY = parent:getPosition()
		zap:setPosition(
			absoluteX - parentX,
			absoluteY - parentY)
		parent:addChild(zap)
	end
end

function GamepadCirclePanelZap:new()
	Widget.new(self)

	self.duration = 0

	self._particles = Particles()
	self._particles:updateParticleSystemProperties({
		EmissionArea = { "ellipse", 64, 64, math.rad(360), true },
		ParticleLifetime = { 0.25, 0.5 },
		Sizes = { 0.25, 1, 0.25 },
		Speed = { 64, 96 },
		Rotation = { math.rad(0), math.rad(360) },
		SizeVariation = { 0.25 },
		Colors = {
			{ 1, 1, 1, 0 },
			{ 1, 1, 1, 1 },
			{ 1, 1, 1, 1 },
			{ 1, 1, 1, 1 },
			{ 1, 1, 1, 0 },
		},
		Quads = {
			love.graphics.newQuad(0, 0, 64, 64, 128, 128),
			love.graphics.newQuad(64, 0, 64, 64, 128, 128),
			love.graphics.newQuad(0, 64, 64, 64, 128, 128),
			love.graphics.newQuad(64, 64, 64, 64, 128, 128),
		},
		Offset = {
			32, 32
		}
	})
	self._particles:emit(10, 20)
	self._particles:setTexture("Resources/Game/UI/Particles/Combat/Zap.png")
	self._particles:setTintColor(Color.fromHexString("ffcc00"))
	self:addChild(self._particles)

	self:setIsSelfClickThrough(true)
end

function GamepadCirclePanelZap:getOverflow()
	return true
end

function GamepadCirclePanelZap:update(delta)
	Widget.update(self, delta)

	self.duration = self.duration + delta
	if self.duration > self.DURATION then
		local parent = self:getParent()
		if parent then
			parent:removeChild(self)
		end
	end
end

return GamepadCirclePanelZap
