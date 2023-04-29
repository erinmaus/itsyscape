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
local Color = require "ItsyScape.Graphics.Color"
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
DialogBox.WIDTH = 960
DialogBox.HEIGHT = 240

function DialogBox.concatMessage(message)
	local m = {}
	for i = 1, #message do
		local content = message[i]
		for k = 1, #content do
			for j = 1, #content[k] do
				table.insert(m, content[k][j])
			end

			table.insert(m, { 1, 1, 1, 1 })
			table.insert(m, "\n")
		end
	end

	return m
end

function DialogBox:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(DialogBox.WIDTH, DialogBox.HEIGHT)
	self:setPosition(w / 2 - DialogBox.WIDTH / 2, h - DialogBox.HEIGHT)

	local panel = Panel()
	panel:setSize(DialogBox.WIDTH, DialogBox.HEIGHT)
	self:addChild(panel)

	self.speakerLabel = Label()
	self.speakerLabel:setText("Unknown")
	self.speakerLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 32,
		color = { 1, 1, 1, 1 },
		textShadow = true
	}, self:getView():getResources()))
	self.speakerLabel:setPosition(DialogBox.PADDING, -48)
	self:addChild(self.speakerLabel)

	self.messageLabel = Label()
	self.messageLabel:setText("Lorem ipsum...")
	self.messageLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
		fontSize = 32,
		color = { 1, 1, 1, 1 },
		textShadow = true,
		align = 'center',
		spaceLines = true
	}, self:getView():getResources()))
	self.messageLabel:setPosition(
		DialogBox.PADDING * 2 + DialogBox.HEIGHT, DialogBox.PADDING)
	self.messageLabel:setSize(
		DialogBox.WIDTH - DialogBox.PADDING * 3 - DialogBox.HEIGHT,
		DialogBox.HEIGHT - DialogBox.PADDING * 2 - 24)
	panel:addChild(self.messageLabel)

	local clickToContinue = Label()
	clickToContinue:setText("Click to continue")
	clickToContinue:setStyle(LabelStyle({
		align = 'center',
		textShadow = true,
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
		fontSize = 24
	}, self:getView():getResources()))
	clickToContinue:setPosition(
		0,
		DialogBox.HEIGHT - 24 - DialogBox.PADDING * 2)
	self.messageLabel:addChild(clickToContinue)

	self.inputBox = TextInput()
	self.inputBox:setSize(DialogBox.WIDTH - DialogBox.PADDING * 2, 32)
	self.inputBox:setPosition(DialogBox.PADDING, DialogBox.HEIGHT / 2 - 16)

	self.nextButton = Button()
	self.nextButton:setStyle(ButtonStyle({
		hover = Color(0, 0, 0, 0.05),
		pressed = Color(0, 0, 0, 0.1)
	}, self:getView():getResources()))
	self.nextButton:setSize(w, DialogBox.HEIGHT)
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

	self:next()
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

function DialogBox:next(state)
	state = state or self:getState()

	for i = 1, #self.options do
		self:removeChild(self.options[i])
	end
	self.options = {}

	if state.content then
		self.messageLabel:setText(DialogBox.concatMessage(state.content))

		self:addChild(self.messageLabel)
		self:addChild(self.nextButton)
		self:addChild(self.speakerIcon)
		self:addChild(self.speakerIconBackground)
	elseif state.input then
		self.messageLabel:setText(DialogBox.concatMessage(state.content))

		self:getView():getInputProvider():setFocusedWidget(self.inputBox)
		self.inputBox:setText("")

		self:addChild(self.inputBox)
		self:addChild(self.nextButton)
	elseif state.options then
		self:removeChild(self.messageLabel)
		self.messageLabel:setText("")
		self:removeChild(self.inputBox)
		local y = DialogBox.PADDING
		local w, h = self:getSize()
		for i = 1, #state.options do
			local option = Button()
			option:setText(DialogBox.concatMessage({ state.options[i] }))
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

	self.propView = nil
	if state.prop then
		local game = self:getView():getGame()
		local gameView = self:getView():getGameView()
		for prop in game:getStage():iterateProps() do
			if prop:getID() == state.prop then
				local propView = gameView:getProp(prop)
				if propView then
					self.speakerIcon:setRoot(propView:getRoot())
					self.prop = prop
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
	local transform = root:getTransform():getGlobalTransform()

	local offset
	local zoom
	if self.actor or self.prop then
		local node = self.actor or self.prop
		local min, max, z, o = node:getBounds()

		local otherY
		if self.prop then
			otherY = 1
		else
			otherY = 0.75
		end

		offset = Vector.UNIT_Y * (max.y - min.y) - o
		zoom = math.max(max.x - min.x, max.y - min.y, max.z - min.z) * (z or 1)

		-- Flip if facing left.
		if node == self.actor and node:getDirection().x < 0 then
			self.camera:setVerticalRotation(
				self.camera:getVerticalRotation() + math.pi)
		end

		self.camera:setNear(0.01)
		self.camera:setFar(zoom * 2)
	else
		offset = Vector.ZERO
		zoom = 1
	end

	local x, y, z = transform:transformPoint(offset:get())

	local w, h = self.speakerIcon:getSize()
	self.camera:setWidth(w)
	self.camera:setHeight(h)
	self.camera:setPosition(Vector(x, y, z))
	self.camera:setDistance(zoom)
end

return DialogBox
