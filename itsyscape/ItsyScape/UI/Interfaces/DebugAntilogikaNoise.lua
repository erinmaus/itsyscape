--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/DebugAntilogikaNoise.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Button = require "ItsyScape.UI.Button"
local Drawable = require "ItsyScape.UI.Drawable"
local Interface = require "ItsyScape.UI.Interface"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local TextInput = require "ItsyScape.UI.TextInput"
local NoiseBuilder = require "ItsyScape.Game.Skills.Antilogika.NoiseBuilder"

local DebugAntilogikaNoise = Class(Interface)

DebugAntilogikaNoise.Noise = Class(Drawable)
function DebugAntilogikaNoise.Noise:new(params)
	Drawable.new(self)

	self:setSize(1, 1)

	self.params = params
	self:refresh()
end

function DebugAntilogikaNoise.Noise:refresh()
	local noise = NoiseBuilder.TERRAIN(self.params)
	noise = noise({ offset = Vector(self.params.x, self.params.y, self.params.z) })

	local w, h = self:getSize()
	self.texture = love.graphics.newImage(noise:sampleTestImage(w, h))
end

function DebugAntilogikaNoise.Noise:draw()
	itsyrealm.graphics.draw(self.texture)
end

DebugAntilogikaNoise.WIDTH  = 480
DebugAntilogikaNoise.HEIGHT = 640

DebugAntilogikaNoise.NOISE_SIZE = 256

DebugAntilogikaNoise.PADDING = 8

DebugAntilogikaNoise.ROW_HEIGHT = 48

DebugAntilogikaNoise.PARAMS = {
	"Persistence",
	"Scale",
	"Octaves",
	"Amplitude",
	"Lacunarity",
	"X",
	"Y",
	"Z"
}

function DebugAntilogikaNoise:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(DebugAntilogikaNoise.WIDTH, DebugAntilogikaNoise.HEIGHT)
	self:setPosition(
		(w - DebugAntilogikaNoise.WIDTH) / 2,
		(h - DebugAntilogikaNoise.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	local layout = GridLayout()
	layout:setSize(DebugAntilogikaNoise.WIDTH, 0)
	layout:setUniformSize(
		true,
		DebugAntilogikaNoise.WIDTH / 2 - DebugAntilogikaNoise.PADDING * 3,
		DebugAntilogikaNoise.ROW_HEIGHT)
	layout:setPadding(DebugAntilogikaNoise.PADDING, DebugAntilogikaNoise.PADDING)
	layout:setWrapContents(true)
	self:addChild(layout)

	self.params = {
		persistence = NoiseBuilder.TERRAIN:getPersistence(),
		scale = NoiseBuilder.TERRAIN:getScale(),
		octaves = NoiseBuilder.TERRAIN:getOctaves(),
		amplitude = NoiseBuilder.TERRAIN:getAmplitude(),
		lacunarity = NoiseBuilder.TERRAIN:getLacunarity(),
		x = NoiseBuilder.TERRAIN:getOffset().x,
		y = NoiseBuilder.TERRAIN:getOffset().y,
		z = NoiseBuilder.TERRAIN:getOffset().z
	}

	for i = 1, #DebugAntilogikaNoise.PARAMS do
		local param = DebugAntilogikaNoise.PARAMS[i]
		local label = Label()
		label:setText(param)
		label:setStyle(LabelStyle({
			color = { 1, 1, 1, 1 },
			textShadow = true,
			font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
			fontSize = 20,
			spaceLines = true
		}, ui:getResources()))
		layout:addChild(label)

		local textInput = TextInput()
		textInput:setText(tostring(self.params[param:lower()]))
		textInput.onValueChanged:register(self.onParameterInputChanged, self, param)
		layout:addChild(textInput)
	end

	local confirmButton = Button()
	confirmButton:setText("Update!")
	confirmButton.onClick:register(self.onConfirmButtonClicked, self)
	layout:addChild(confirmButton)

	local noisePanel = Panel()
	noisePanel:setSize(
		DebugAntilogikaNoise.NOISE_SIZE + DebugAntilogikaNoise.PADDING * 2,
		DebugAntilogikaNoise.NOISE_SIZE + DebugAntilogikaNoise.PADDING * 2)
	noisePanel:setPosition(DebugAntilogikaNoise.WIDTH + DebugAntilogikaNoise.PADDING, 0)
	self:addChild(noisePanel)

	self.noise = DebugAntilogikaNoise.Noise(self.params)
	self.noise:setSize(DebugAntilogikaNoise.NOISE_SIZE, DebugAntilogikaNoise.NOISE_SIZE)
	self.noise:setPosition(DebugAntilogikaNoise.PADDING, DebugAntilogikaNoise.PADDING)
	noisePanel:addChild(self.noise)

	self.closeButton = Button()
	self.closeButton:setSize(48, 48)
	self.closeButton:setPosition(DebugAntilogikaNoise.WIDTH - 48, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(self.onCancelButtonClicked, self)
	self:addChild(self.closeButton)
end

function DebugAntilogikaNoise:onParameterInputChanged(param, textInput)
	param = param:lower()
	self.params[param] = tonumber(textInput:getText())
end

function DebugAntilogikaNoise:onConfirmButtonClicked()
	self.noise:refresh()
end

function DebugAntilogikaNoise:onCancelButtonClicked()
	self:sendPoke("close", nil, {})
end

return DebugAntilogikaNoise
