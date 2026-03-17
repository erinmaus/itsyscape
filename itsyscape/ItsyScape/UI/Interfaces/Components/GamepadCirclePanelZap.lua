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
local Config = require "ItsyScape.Game.Config"
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

	local fromColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.gamepadZap.from"))
	local fr, fg, fb = fromColor:get()
	local toColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.gamepadZap.to"))
	local tr, tg, tb = toColor:get()

	self._particles = Particles()
	self._particles:updateParticleSystemProperties({
		EmissionArea = { "ellipse", 64, 64, math.rad(360), true },
		ParticleLifetime = { 0.4, 0.6 },
		Sizes = { 0.25, 1.25, 0.25 },
		Speed = { 96, 128 },
		Rotation = { math.rad(0), math.rad(360) },
		LinearAcceleration = { 0, -32, 0, -32 },
		SizeVariation = { 0.5 },
		Colors = {
			{ fr, fg, fb, 0 },
			{ fr, fg, fb, 1 },
			{ tr, tg, tb, 1 },
			{ tr, tg, tb, 0 }
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
	self._particles:emit(20, 35)
	self._particles:setTexture("Resources/Game/UI/Particles/Combat/Zap.png")
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
