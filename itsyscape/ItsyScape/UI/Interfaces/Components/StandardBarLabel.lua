--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/StandardBarLabel.lua
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
local Utility = require "ItsyScape.Game.Utility"
local Variables = require "ItsyScape.Game.Variables"
local Drawable = require "ItsyScape.UI.Drawable"
local Widget = require "ItsyScape.UI.Widget"
local Particles = require "ItsyScape.UI.Particles"

StandardBarLabel = Class(Drawable)

local CONFIG = Variables.load("Resources/Game/Variables/Config.json")
local COLOR_PATH = Variables.Path("colors", Variables.PathParameter("color"))

function StandardBarLabel:new()
	Drawable.new(self)

	self.padding = 4
	self.align = false
end

function StandardBarLabel:setPadding(value)
	self.padding = value or self.padding
end

function StandardBarLabel:getPadding()
	return self.padding
end

function StandardBarLabel:setAlign(value)
	self.align = value or false
end

function StandardBarLabel:getAlign()
	return self.align
end

function StandardBarLabel:loadDynamic(resources)
	local _, height = (self:getParent() or self):getSize()
	local newFontSize = math.max(height - self.padding * 2, 8)
	if self.fontSize ~= newFontSize then
		self.fontSize = newFontSize
		self.font = resources:load(
			love.graphics.newFont,
			"Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
			self.fontSize)
	end
end

function StandardBarLabel:draw(resources, state)
	self:loadDynamic(resources)

	local width, height = (self:getParent() or self):getSize()

	love.graphics.push("all")

	local textColor = Color.fromHexString(CONFIG:get(COLOR_PATH, "color", "ui.combat.bar.text"))
	local textShadowColor = Color.fromHexString(CONFIG:get(COLOR_PATH, "color", "ui.combat.bar.textShadow"))

	local fontHeight = self.font:getHeight()
	local textY = height / 2 - fontHeight / 2

	love.graphics.setFont(self.font)

	if self.align then
		love.graphics.setColor(textShadowColor:get())
		itsyrealm.graphics.printf(self:getText(), 2, textY + 2, width, self.align)

		love.graphics.setColor(textColor:get())
		itsyrealm.graphics.printf(self:getText(), 0, textY, width, self.align)
	else
		love.graphics.setColor(textShadowColor:get())
		itsyrealm.graphics.print(self:getText(), self.padding + 2, textY + 2)

		love.graphics.setColor(textColor:get())
		itsyrealm.graphics.print(self:getText(), self.padding, textY)
	end

	love.graphics.pop()
end

return StandardBarLabel
