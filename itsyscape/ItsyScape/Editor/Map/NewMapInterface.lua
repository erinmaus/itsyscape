--------------------------------------------------------------------------------
-- ItsyScape/Editor/Map/NewMapInterface.lua
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
local OriginBehavior = require "ItsyScape.Peep.Behaviors.OriginBehavior"
local Button = require "ItsyScape.UI.Button"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local TextInput = require "ItsyScape.UI.TextInput"
local Widget = require "ItsyScape.UI.Widget"

local NewMapInterface = Class(Widget)
NewMapInterface.WIDTH = 320
NewMapInterface.HEIGHT = 368
function NewMapInterface:new(application, create)
	Widget.new(self)

	self.application = application
	self.create = create == nil and true or not not create

	self.onSubmit = Callback()

	local width, height = love.window.getMode()
	self:setPosition(
		width / 2 - NewMapInterface.WIDTH / 2,
		height / 2 - NewMapInterface.HEIGHT / 2)
	self:setSize(NewMapInterface.WIDTH, NewMapInterface.HEIGHT)

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
	inputsGridLayout:setUniformSize(true, NewMapInterface.WIDTH / 2 - 16 * 2, 32)
	inputsGridLayout:setSize(NewMapInterface.WIDTH, NewMapInterface.HEIGHT * (2 / 3))

	self:addChild(inputsGridLayout)

	local widthLabel = Label()
	widthLabel:setText("Width:")
	inputsGridLayout:addChild(widthLabel)

	self.widthInput = TextInput()
	self.widthInput:setText("32")
	inputsGridLayout:addChild(self.widthInput)

	local heightLabel = Label()
	heightLabel:setText("Height:")
	inputsGridLayout:addChild(heightLabel)

	self.heightInput = TextInput()
	self.heightInput:setText("32")
	inputsGridLayout:addChild(self.heightInput)

	local paddingLabel = Label()
	paddingLabel:setText("Padding:")
	inputsGridLayout:addChild(paddingLabel)

	self.paddingInput = TextInput()
	self.paddingInput:setText("16")
	inputsGridLayout:addChild(self.paddingInput)

	local elevationLabel = Label()
	elevationLabel:setText("Elevation:")
	inputsGridLayout:addChild(elevationLabel)

	self.elevationInput = TextInput()
	self.elevationInput:setText("1")
	inputsGridLayout:addChild(self.elevationInput)

	local tileSetLabel = Label()
	tileSetLabel:setText("Tile Set:")
	inputsGridLayout:addChild(tileSetLabel)

	self.tileSetIDInput = TextInput()
	self.tileSetIDInput:setText("Draft")
	inputsGridLayout:addChild(self.tileSetIDInput)

	local buttonsGridLayout = GridLayout()
	buttonsGridLayout:setPadding(16, 0)
	buttonsGridLayout:setUniformSize(true, NewMapInterface.WIDTH / 2 - 16 * 2, 32)
	buttonsGridLayout:setSize(NewMapInterface.WIDTH, NewMapInterface.HEIGHT * (1 / 3))
	buttonsGridLayout:setPosition(0, NewMapInterface.HEIGHT * (2 / 3))
	self:addChild(buttonsGridLayout)

	self.okButton = Button()
	self.okButton.onClick:register(function()
		self:createMap()
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

function NewMapInterface:getOverflow()
	return true
end

function NewMapInterface:createMap()
	local gameView = self.application:getGameView()
	local stage = self.application:getGame():getStage()
	local width = tonumber(self.widthInput:getText()) or 32
	local height = tonumber(self.heightInput:getText()) or 32
	local padding = tonumber(self.paddingInput:getText()) or 16
	local halfPadding = padding / 2
	local elevation = tonumber(self.elevationInput:getText()) or 1

	local layer
	if self.create  then
		layer = 1
	else
		local layers = {}
		for i = 1, #self.application.mapScriptLayers do
			table.insert(layers, self.application.mapScriptLayers[i])
		end
		table.sort(layers)

		for i = 1, #layers - 1 do
			local nextLayer = layers[i + 1]
			local currentLayer = layers[i]
			if nextLayer > currentLayer + 1 then
				layer = currentLayer + 1
				break
			end 
		end

		layer = (layers[#layers] or 0) + 1
	end

	if width and height then
		stage:newMap(width + padding * 2, height + padding * 2, self.tileSetIDInput:getText(), true, layer)
		local map = stage:getMap(layer)
		if map then
			for j = 1, map:getHeight() do
				for i = 1, map:getWidth() do
					local tile = map:getTile(i, j)
					if j <= padding or j > height + padding or
					   i <= padding or i > width + padding
					then
						tile.flat = 3
					else
						tile.edge = 2
					end

					if j <= halfPadding or j > height + padding + halfPadding or
					   i <= halfPadding or i > width + padding + halfPadding
					then
						tile:setFlag("impassable")
					end

					tile.topLeft = elevation
					tile.topRight = elevation
					tile.bottomLeft = elevation
					tile.bottomRight = elevation
				end
			end

			table.insert(self.application.mapScriptLayers, layer)

			stage:updateMap(layer)

			local center = Vector(
				map:getWidth() * map:getCellSize() / 2,
				elevation + 5,
				map:getHeight() * map:getCellSize() / 2)
			self.application:getCamera():setPosition(center)

			stage:onMapMoved(layer, Vector.ZERO, Quaternion.IDENTITY, Vector.ONE, Vector(map:getWidth() * map:getCellSize() / 2, 0, map:getHeight() * map:getCellSize() / 2), false)

			do
				local MapPeep = require "ItsyScape.Peep.Peeps.Map"

				local peep = self.application:getGame():getDirector():addPeep("::orphan", MapPeep, resource)
				peep:poke("load", "Unsaved", {}, layer)
				self.application:getGame():getStage():getPeepInstance():addMapScript(layer, peep, filename)

				peep:addBehavior(require "ItsyScape.Peep.Behaviors.PositionBehavior")
				peep:addBehavior(require "ItsyScape.Peep.Behaviors.ScaleBehavior")
				peep:addBehavior(require "ItsyScape.Peep.Behaviors.RotationBehavior")

				local _, origin = peep:addBehavior(OriginBehavior)
				origin.origin = Vector(map:getWidth() * map:getCellSize() / 2, 0, map:getHeight() * map:getCellSize() / 2)

				self.application.mapScriptPeeps[layer] = peep
			end

			self.onSubmit(self)
			self:close()
		end
	end
end

function NewMapInterface:close()
	local p = self:getParent()
	if p then
		p:removeChild(self)
	end
end

return NewMapInterface
