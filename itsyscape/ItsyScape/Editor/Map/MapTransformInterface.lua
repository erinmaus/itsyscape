--------------------------------------------------------------------------------
-- ItsyScape/Editor/Map/MapTransformInterface.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Utility = require "ItsyScape.Game.Utility"
local Button = require "ItsyScape.UI.Button"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local TextInput = require "ItsyScape.UI.TextInput"
local Widget = require "ItsyScape.UI.Widget"

local MapTransformInterface = Class(Widget)
MapTransformInterface.PROPERTIES = {
	"Pos X",
	"Pos Y",
	"Pos Z",
	"Rot X",
	"Rot Y",
	"Rot Z",
	"Scale X",
	"Scale Y",
	"Scale Z",
}

MapTransformInterface.ROW_HEIGHT = 32

MapTransformInterface.WIDTH  = 320
MapTransformInterface.HEIGHT = (#MapTransformInterface.PROPERTIES + 1) * (MapTransformInterface.ROW_HEIGHT + 16)

function MapTransformInterface:new(application)
	Widget.new(self)

	self.application = application
	self.onSubmit = Callback()

	local width, height = love.window.getMode()
	self:setPosition(
		width / 2 - MapTransformInterface.WIDTH / 2,
		height / 2 - MapTransformInterface.HEIGHT / 2)
	self:setSize(MapTransformInterface.WIDTH, MapTransformInterface.HEIGHT)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	local titleLabel = Label()
	titleLabel:setText("Create map...")
	titleLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
		fontSize = 32,
		color = { 1, 1, 1, 1 },
		textShadow = true
	}, application:getUIView():getResources()))
	titleLabel:setPosition(16, -32)
	self:addChild(titleLabel)

	local inputsGridLayout = GridLayout()
	inputsGridLayout:setPadding(16, 16)
	inputsGridLayout:setUniformSize(true, MapTransformInterface.WIDTH / 2 - 16 * 2, 32)
	inputsGridLayout:setSize(MapTransformInterface.WIDTH, 0)
	inputsGridLayout:setWrapContents(true)

	local properties = {}
	for _, property in ipairs(MapTransformInterface.PROPERTIES) do
		local label = Label()
		label:setText(property .. ":")
		inputsGridLayout:addChild(label)

		local input = TextInput()
		if property:match("Scale") then
			input:setText("1")
		else
			input:setText("0")
		end
		inputsGridLayout:addChild(input)

		self.properties[property] = input
	end

	self:addChild(inputsGridLayout)

	local buttonsGridLayout = GridLayout()
	buttonsGridLayout:setPadding(16, 0)
	buttonsGridLayout:setUniformSize(true, MapTransformInterface.WIDTH / 2 - 16 * 2, 32)
	buttonsGridLayout:setSize(MapTransformInterface.WIDTH, MapTransformInterface.ROW_HEIGHT)
	buttonsGridLayout:setPosition(0, MapTransformInterface.HEIGHT - MapTransformInterface.ROW_HEIGHT - 16)
	self:addChild(buttonsGridLayout)

	self.okButton = Button()
	self.okButton.onClick:register(function()
		self:moveMap()
		self:close()
	end)
	self.okButton:setText("OK")
	buttonsGridLayout:addChild(self.okButton)

	self.cancelButton = Button()
	self.cancelButton.onClick:register(function()
		self:close()
	end)
	self.cancelButton:setText("Cancel")
	buttonsGridLayout:addChild(self.cancelButton)
end

function MapTransformInterface:getOverflow()
	return true
end

function MapTransformInterface:moveMap()
	local position = Vector(
		tonumber(self.properties["Pos X"]:getText()) or 0,
		tonumber(self.properties["Pos Y"]:getText()) or 0,
		tonumber(self.properties["Pos Z"]:getText()) or 0)
	local rotation = Quaternion.fromAxisAngle(Vector.UNIT_X, math.rad(self.properties["Rot X"]:getText()) or 0) *
	                 Quaternion.fromAxisAngle(Vector.UNIT_Y, math.rad(self.properties["Rot Y"]:getText()) or 0) *
	                 Quaternion.fromAxisAngle(Vector.UNIT_Z, math.rad(self.properties["Rot Z"]:getText()) or 0)
	local scale = Vector(
		tonumber(self.properties["Scale X"]:getText()) or 0,
		tonumber(self.properties["Scale Y"]:getText()) or 0,
		tonumber(self.properties["Scale Z"]:getText()) or 0)

	if self.application.mapScriptPeep then
		self.application.mapScriptPeep:addBehavior(require "ItsyScape.Peep.Behaviors.PositionBehavior")
		self.application.mapScriptPeep:addBehavior(require "ItsyScape.Peep.Behaviors.RotationBehavior")
		self.application.mapScriptPeep:addBehavior(require "ItsyScape.Peep.Behaviors.ScaleBehavior")

		Utility.Peep.setPosition(self.application.mapScriptPeep, position)
		Utility.Peep.setRotation(self.application.mapScriptPeep, rotation)
		Utility.Peep.setScale(self.application.mapScriptPeep, scale)
	end
end

function MapTransformInterface:close()
	local p = self:getParent()
	if p then
		p:removeChild(self)
	end
end

return MapTransformInterface
