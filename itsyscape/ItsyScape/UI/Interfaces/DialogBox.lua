--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/DialogBox.lua
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
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local TextInput = require "ItsyScape.UI.TextInput"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"

local DialogBox = Class(Interface)
DialogBox.PADDING = 16
DialogBox.HEIGHT = 240

function DialogBox:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.window.getMode()
	self:setSize(w, DialogBox.HEIGHT + 32)
	self:setPosition(0, 0)

	local panel = Panel()
	panel:setSize(w, DialogBox.HEIGHT)
	self:addChild(panel)

	self.speakerLabel = Label()
	self.speakerLabel:setText("Unknown")
	self.speakerLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
		fontSize = 32,
		color = { 1, 1, 1, 1 },
		textShadow = true
	}, self:getView():getResources()))
	self.speakerLabel:setPosition(DialogBox.PADDING, DialogBox.HEIGHT)
	self:addChild(self.speakerLabel)

	self.messageLabel = Label()
	self.messageLabel:setText("Lorem ipsum...")
	self.messageLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
		fontSize = 24,
		color = { 1, 1, 1, 1 },
		textShadow = true
	}, self:getView():getResources()))
	self.messageLabel:setPosition(
		DialogBox.PADDING * 2 + DialogBox.HEIGHT, DialogBox.PADDING)
	self.messageLabel:setSize(
		w - DialogBox.PADDING * 2 - DialogBox.HEIGHT,
		DialogBox.HEIGHT - DialogBox.PADDING * 2)
	panel:addChild(self.messageLabel)

	self.inputBox = TextInput()
	self.inputBox:setSize(w - DialogBox.PADDING * 2, 32)
	self.inputBox:setPosition(DialogBox.PADDING, DialogBox.HEIGHT / 2 - 16)

	self.nextButton = Button()
	self.nextButton:setText("Continue >")
	self.nextButton:setSize(128, 32)
	self.nextButton:setPosition(w - 128, DialogBox.HEIGHT)
	self.nextButton.onClick:register(DialogBox.pump, self)

	self.speakerIconBackground = Panel()
	self.speakerIconBackground:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Speaker.9.png"
	}, self:getView():getResources()))
	self.speakerIconBackground:setSize(
		DialogBox.HEIGHT - DialogBox.PADDING * 2,
		DialogBox.HEIGHT - DialogBox.PADDING * 2)
	self.speakerIconBackground:setPosition(
		DialogBox.PADDING,
		DialogBox.PADDING)
	self:addChild(self.speakerIconBackground)

	self.speakerIcon = SceneSnippet()
	self.speakerIcon:setSize(
		DialogBox.HEIGHT - DialogBox.PADDING * 2,
		DialogBox.HEIGHT - DialogBox.PADDING * 2)
	self.speakerIcon:setPosition(
		DialogBox.PADDING,
		DialogBox.PADDING)
	self:addChild(self.speakerIcon)

	self.options = {}

	self.camera = ThirdPersonCamera()
	self.camera:setDistance(2.5)
	self.camera:setUp(Vector(0, -1, 0))
	self.speakerIcon:setCamera(self.camera)
end

function DialogBox:getOverflow()
	return true
end

function DialogBox:pump()
	local state = self:getState()

	if state.input then
		self:sendPoke("submit", nil, { value = self.inputBox:getText() })
	else
		self:sendPoke("next", nil, {})
	end
end

function DialogBox:select(index)
	self:sendPoke("select", nil, { index = index })
end

function DialogBox:next()
	local state = self:getState()

	for i = 1, #self.options do
		self:removeChild(self.options[i])
	end
	self.options = {}

	if state.content then
		self.messageLabel:setText(table.concat(state.content[1], "\n"))
		self:addChild(self.nextButton)
		self:addChild(self.speakerIcon)
		self:addChild(self.speakerIconBackground)
	elseif state.input then
		self.messageLabel:setText(table.concat(state.input, "\n"))

		self:getView():getInputProvider():setFocusedWidget(self.inputBox)
		self.inputBox:setText("")

		self:addChild(self.inputBox)
		self:addChild(self.nextButton)
	elseif state.options then
		self.messageLabel:setText("")
		self:removeChild(self.inputBox)
		local y = DialogBox.PADDING
		local w, h = self:getSize()
		for i = 1, #state.options do
			local option = Button()
			option:setText(table.concat(state.options[i], " "))
			option:setSize(w - DialogBox.PADDING * 2, 32)
			option:setPosition(DialogBox.PADDING, y)
			option.onClick:register(DialogBox.select, self, i)
			self:addChild(option)

			y = y + DialogBox.PADDING + 32

			table.insert(self.options, option)
		end

		self:removeChild(self.nextButton)
	end

	if not state.content then
		self:removeChild(self.speakerIcon)
		self:removeChild(self.speakerIconBackground)
	elseif not state.input then
		self.removeChild(self.inputBox)
	end

	if state.options then
		self.speakerLabel:setText("Select an option")
	elseif state.input then
		self.speakerLabel:setText("Enter a value")
	else
		self.speakerLabel:setText(state.speaker)
	end

	self.actorView = nil
	if state.actor then
		local game = self:getView():getGame()
		local gameView = self:getView():getGameView()
		for actor in game:getStage():iterateActors() do
			if actor:getID() == state.actor then
				local actorView = gameView:getActor(actor)
				if actorView then
					self.speakerIcon:setRoot(actorView:getSceneNode())
					self.actor = actor
				end
			end
		end
	end
end

function DialogBox:update(...)
	Interface.update(self, ...)

	local gameCamera = self:getView():getGameView():getRenderer():getCamera()
	self.camera:setHorizontalRotation(gameCamera:getHorizontalRotation())
	self.camera:setVerticalRotation(gameCamera:getVerticalRotation())

	local root = self.speakerIcon:getRoot()
	local transform = root:getTransform():getGlobalDeltaTransform(0)

	local offset
	if self.actor then
		local min, max = self.actor:getBounds()
		offset = (max.y - min.y) - 0.75
	else
		offset = 0
	end

	local x, y, z = transform:transformPoint(0, offset, 0)

	local w, h = self.speakerIcon:getSize()
	self.camera:setWidth(w)
	self.camera:setHeight(h)
	self.camera:setPosition(Vector(x, y, z))
end

return DialogBox
