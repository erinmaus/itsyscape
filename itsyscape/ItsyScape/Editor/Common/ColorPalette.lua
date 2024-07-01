--------------------------------------------------------------------------------
-- ItsyScape/Editor/Common/ColorPalette.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local TextInput = require "ItsyScape.UI.TextInput"
local Widget = require "ItsyScape.UI.Widget"
local CharacterCustomization = require "ItsyScape.UI.Interfaces.CharacterCustomizationV2"

local ColorPalette = Class(Widget)
ColorPalette.NUM_ROWS = 6
ColorPalette.ROW_HEIGHT = 48
ColorPalette.PADDING = 8

ColorPalette.WIDTH  = 320
ColorPalette.HEIGHT = ColorPalette.NUM_ROWS * ColorPalette.ROW_HEIGHT + (ColorPalette.NUM_ROWS + 1) * ColorPalette.PADDING

function ColorPalette:new(application)
	Widget.new(self)

	self.application = application

	self:setSize(self.WIDTH, self.HEIGHT)

	self.onUpdate = Callback()
	self.onSubmit = Callback()
	self.onCancel = Callback()

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	local layout = GridLayout()
	layout:setWrapContents(true)
	layout:setSize(self.WIDTH, 0)
	layout:setPadding(self.PADDING, self.PADDING)
	layout:setUniformSize(true, self.WIDTH - self.PADDING * 2, self.ROW_HEIGHT)
	self:addChild(layout)

	self.palette = GridLayout()
	self.palette:setEdgePadding(false)
	self.palette:setUniformSize(true, 32, self.ROW_HEIGHT)
	layout:addChild(self.palette)

	self.hueSlider = CharacterCustomization.HueSlider()
	self.hueSlider.onUpdateValue:register(self.updateHue, self)
	layout:addChild(self.hueSlider)

	self.saturationSlider = CharacterCustomization.SaturationSlider()
	self.saturationSlider.onUpdateValue:register(self.updateSaturation, self)
	layout:addChild(self.saturationSlider)

	self.lightnessSlider = CharacterCustomization.LightnessSlider()
	self.lightnessSlider.onUpdateValue:register(self.updateLightness, self)
	layout:addChild(self.lightnessSlider)

	self.colorTextInput = TextInput()
	self.colorTextInput:setText(Color():toHexString())
	self.colorTextInput.onSubmit:register(function()
		self.colorTextInput:blur()
	end)
	self.colorTextInput.onFocus:register(function()
		self.colorTextInput:setCursor(0, #self.colorTextInput:getText())
	end)
	self.colorTextInput.onBlur:register(function()
		local h, s, l = (Color.fromHexString(self.colorTextInput:getText()) or self.currentColor):toHSL()
		self:updateColor(h * 255, s * 255, l * 255)

		self.colorTextInput:setText(self.currentColor:toHexString())
	end)
	layout:addChild(self.colorTextInput)

	local buttons = GridLayout()
	buttons:setEdgePadding(false)
	buttons:setPadding(self.PADDING, self.PADDING)
	buttons:setUniformSize(true, self.WIDTH / 2 - self.PADDING * 3, self.ROW_HEIGHT)
	layout:addChild(buttons)

	local cancelButton = Button()
	cancelButton.onClick:register(function()
		self:onCancel(self.initialColor or Color())
		self:close()
	end)
	cancelButton:setText("Cancel")
	buttons:addChild(cancelButton)

	local okButton = Button()
	okButton.onClick:register(function()
		self:onSubmit(self.currentColor)
		self:close()
	end)
	okButton:setText("Apply")
	buttons:addChild(okButton)
end

function ColorPalette:getOverflow()
	return true
end

function ColorPalette:updateColor(hue, saturation, lightness)
	self.hueSlider:updateColor(hue, saturation, lightness)
	self.saturationSlider:updateColor(hue, saturation, lightness)
	self.lightnessSlider:updateColor(hue, saturation, lightness)

	self.currentHue = hue / 255
	self.currentSaturation = saturation / 255
	self.currentLightness = lightness / 255

	self.currentColor = Color.fromHSL(self.currentHue, self.currentSaturation, self.currentLightness)
	self:onUpdate(self.currentColor)

	self.colorTextInput:setText(self.currentColor:toHexString())
end

function ColorPalette:updateHue(_, value)
	self:updateColor(value, self.saturationSlider:getValue(), self.lightnessSlider:getValue())
end

function ColorPalette:updateSaturation(_, value)
	self:updateColor(self.hueSlider:getValue(), value, self.lightnessSlider:getValue())
end

function ColorPalette:updateLightness(_, value)
	self:updateColor(self.hueSlider:getValue(), self.saturationSlider:getValue(), value)
end

function ColorPalette:populatePalette(palette)
	self.palette:clearChildren()

	local colors = {}
	for _, color in ipairs(palette) do
		local key = color:toHexString()
		if not colors[key] then
			colors[key] = true

			local inactive = color
			local h, s, l = inactive:toHSL()
			local pressed = Color.fromHSL(h, s, l - 0.2)
			local hover = Color.fromHSL(h, s, l + 0.2)

			local style = {
				inactive = inactive,
				pressed = pressed,
				hover = hover
			}

			local h, s, l = inactive:toHSL()

			local button = Button()
			button:setStyle(ButtonStyle(style, self.application:getUIView():getResources()))
			button.onClick:register(self.updateColor, self, h * 255, s * 255, l * 255)

			self.palette:addChild(button)
		end
	end
end

function ColorPalette:open(currentColor, palette, x, y)
	self.initialColor = currentColor or Color()
	local h, s, l = self.initialColor:toHSL()
	self:updateColor(h * 255, s * 255, l * 255)
	self:populatePalette(palette)

	local windowWidth, windowHeight = love.graphics.getScaledMode()
	x = x or (windowWidth / 2 - self.WIDTH / 2)
	y = y or (windowHeight / 2 - self.HEIGHT / 2)

	self:setPosition(x, y)

	local root = parent or self.application:getUIView():getRoot()
	root:addChild(self)
end

function ColorPalette:close()
	local p = self:getParent()
	if p then
		p:removeChild(self)
	end
end

return ColorPalette
