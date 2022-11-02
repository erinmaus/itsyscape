--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/AntilogikaTeleport.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local TextInput = require "ItsyScape.UI.TextInput"
local TextInputStyle = require "ItsyScape.UI.TextInputStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"

local AntilogikaTeleport = Class(Interface)

AntilogikaTeleport.WIDTH  = 640
AntilogikaTeleport.HEIGHT = 320

AntilogikaTeleport.PADDING = 4

AntilogikaTeleport.ROW_WIDTH  = 48 * 3
AntilogikaTeleport.ROW_HEIGHT = 48

AntilogikaTeleport.COORDINATES = {
	"x",
	"y",
	"z",
	"w"
}

AntilogikaTeleport.MAX_COORDINATE_LENGTH = 3

AntilogikaTeleport.COORDINATE_INPUT_STYLE = {
	inactive = Color(0, 0, 0, 0),
	hover = Color(0.0, 0.4, 0.0),
	active = Color(0.0, 0.3, 0.0),
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 22,
	color = Color(1, 1, 1, 1),
	textShadow = true,
	padding = 2
}

AntilogikaTeleport.BUTTON_STYLE = {
	pressed = "Resources/Renderers/Widget/Button/Antilogika-Pressed.9.png",
	inactive = "Resources/Renderers/Widget/Button/Antilogika-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/Antilogika-Hover.9.png",
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 24,
	textShadow = true,
	padding = 4
}

function AntilogikaTeleport:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(AntilogikaTeleport.WIDTH, AntilogikaTeleport.HEIGHT)
	self:setPosition(
		(w - AntilogikaTeleport.WIDTH) / 2,
		(h - AntilogikaTeleport.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(self:getSize())
	panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Antilogika.9.png"
	}, self:getView():getResources()))
	self:addChild(panel)

	local layout = GridLayout()
	layout:setSize(AntilogikaTeleport.WIDTH, 0)
	layout:setUniformSize(
		true,
		AntilogikaTeleport.ROW_WIDTH,
		AntilogikaTeleport.ROW_HEIGHT)
	layout:setPadding(AntilogikaTeleport.PADDING)
	layout:setWrapContents(true)
	self:addChild(layout)

	self.coordinates = {
		x = self:getRandomCoordinate(),
		y = self:getRandomCoordinate(),
		z = self:getRandomCoordinate(),
		w = self:getRandomCoordinate()
	}

	for i = 1, #AntilogikaTeleport.COORDINATES do
		local coordinate = AntilogikaTeleport.COORDINATES[i]

		local textInput = TextInput()
		textInput:setStyle(TextInputStyle(AntilogikaTeleport.COORDINATE_INPUT_STYLE, self:getView():getResources()))
		textInput:setText(self.coordinates[coordinate])
		textInput.onValueChanged:register(self.onCoordinateInputChanged, self, coordinate)
		textInput.onFocus:register(self.onCoordinateInputFocused, self)
		layout:addChild(textInput)
	end

	self.closeButton = Button()
	self.closeButton:setText("X")
	self.closeButton:setStyle(ButtonStyle(AntilogikaTeleport.BUTTON_STYLE, self:getView():getResources()))
	self.closeButton:setPosition(
		AntilogikaTeleport.WIDTH - AntilogikaTeleport.ROW_HEIGHT,
		0)
	self.closeButton:setSize(AntilogikaTeleport.ROW_HEIGHT, AntilogikaTeleport.ROW_HEIGHT)
	self.closeButton.onClick:register(self.onCloseButtonClicked, self)
	self:addChild(self.closeButton)

	self.warpButton = Button()
	self.warpButton:setText("Warp!")
	self.warpButton:setStyle(ButtonStyle(AntilogikaTeleport.BUTTON_STYLE, self:getView():getResources()))
	self.warpButton:setPosition(
		AntilogikaTeleport.WIDTH - AntilogikaTeleport.ROW_WIDTH - AntilogikaTeleport.PADDING,
		AntilogikaTeleport.HEIGHT - AntilogikaTeleport.ROW_HEIGHT - AntilogikaTeleport.PADDING)
	self.warpButton:setSize(AntilogikaTeleport.ROW_WIDTH, AntilogikaTeleport.ROW_HEIGHT)
	self.warpButton.onClick:register(self.onWarpButtonClicked, self)
	self:addChild(self.warpButton)
end

function AntilogikaTeleport:getRandomCoordinate()
	local result = ""

	for i = 1, AntilogikaTeleport.MAX_COORDINATE_LENGTH do
		local chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		local index = math.random(#chars)
		result = result .. chars:sub(index, index)
	end

	return result
end

function AntilogikaTeleport:onCoordinateInputClicked(textInput)
	textInput:setCursor(0, #textInput:getText() + 1)
end

function AntilogikaTeleport:onCoordinateInputChanged(coordinate, textInput)
	textInput:setText(textInput:getText():sub(1, 3):upper())
	self.coordinate[coordinate] = textInput:getText()
end

function AntilogikaTeleport:onCloseButtonClicked()
	self:sendPoke("close", nil, {})
end

function AntilogikaTeleport:onWarpButtonClicked()
	self:sendPoke("teleport", nil, self.coordinates)
end

return AntilogikaTeleport
