--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/DebugAntilogikaTeleport.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Button = require "ItsyScape.UI.Button"
local Interface = require "ItsyScape.UI.Interface"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local TextInput = require "ItsyScape.UI.TextInput"

local DebugAntilogikaTeleport = Class(Interface)

DebugAntilogikaTeleport.WIDTH  = 480
DebugAntilogikaTeleport.HEIGHT = 480

DebugAntilogikaTeleport.PADDING = 8

DebugAntilogikaTeleport.ROW_HEIGHT = 48

DebugAntilogikaTeleport.COORDINATES = {
	"X",
	"Y",
	"Z",
	"W",
	"Time",
	"Size"
}

function DebugAntilogikaTeleport:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(DebugAntilogikaTeleport.WIDTH, DebugAntilogikaTeleport.HEIGHT)
	self:setPosition(
		(w - DebugAntilogikaTeleport.WIDTH) / 2,
		(h - DebugAntilogikaTeleport.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	local layout = GridLayout()
	layout:setSize(DebugAntilogikaTeleport.WIDTH, 0)
	layout:setUniformSize(
		true,
		DebugAntilogikaTeleport.WIDTH / 2 - DebugAntilogikaTeleport.PADDING * 3,
		DebugAntilogikaTeleport.ROW_HEIGHT)
	layout:setPadding(DebugAntilogikaTeleport.PADDING, DebugAntilogikaTeleport.PADDING)
	layout:setWrapContents(true)
	self:addChild(layout)

	self.coordinates = {
		x = "0",
		y = "0",
		z = "0",
		w = "0",
		time = "0",
		size = "4"
	}

	for i = 1, #DebugAntilogikaTeleport.COORDINATES do
		local coordinate = DebugAntilogikaTeleport.COORDINATES[i]
		local label = Label()
		label:setText(coordinate)
		label:setStyle(LabelStyle({
			color = { 1, 1, 1, 1 },
			textShadow = true,
			font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
			fontSize = 20,
			spaceLines = true
		}, ui:getResources()))
		layout:addChild(label)

		local textInput = TextInput()
		textInput:setText(self.coordinates[coordinate:lower()])
		textInput.onValueChanged:register(self.onCoordinateInputChanged, self, coordinate)
		layout:addChild(textInput)
	end

	local confirmButton = Button()
	confirmButton:setText("Teleport!")
	confirmButton.onClick:register(self.onConfirmButtonClicked, self)
	layout:addChild(confirmButton)

	local cancelButton = Button()
	cancelButton:setText("Cancel")
	cancelButton.onClick:register(self.onCancelButtonClicked, self)
	layout:addChild(cancelButton)
end

function DebugAntilogikaTeleport:onCoordinateInputChanged(coordinate, textInput)
	coordinate = coordinate:lower()

	if coordinate ~= "time" and coordinate ~= "size" then
		textInput:setText(textInput:getText():sub(1, 3):upper())
	end

	self.coordinates[coordinate:lower()] = textInput:getText()
end

function DebugAntilogikaTeleport:onConfirmButtonClicked()
	self:sendPoke("teleport", nil, self.coordinates)
end

function DebugAntilogikaTeleport:onCancelButtonClicked()
	self:sendPoke("close", nil, {})
end

return DebugAntilogikaTeleport
