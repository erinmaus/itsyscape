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
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Color = require "ItsyScape.Graphics.Color"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Keybinds = require "ItsyScape.UI.Keybinds"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
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
DialogBox.HEIGHT = 272
DialogBox.OPTION_HEIGHT = 48

DialogBox.OPTION_BUTTON_STYLE = {
	inactive = "Resources/Game/UI/Buttons/Button-Default.png",
	pressed = "Resources/Game/UI/Buttons/Button-Pressed.png",
	hover = "Resources/Game/UI/Buttons/Button-Hover.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 32,
	textX = 0.5,
	textY = 0.5,
	padding = 4
}

function DialogBox.concatMessage(message)
	local m = {}
	for i = 1, #message do
		local content = message[i]
		for k = 1, #content do
			for j = 1, #content[k] do
				table.insert(m, content[k][j])
			end

			table.insert(m, { 1, 1, 1, 1 })
			table.insert(m, " ")
		end
	end

	return m
end

function DialogBox:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self:setZDepth(10000)

	self:setData(GamepadSink, GamepadSink({ isBlocking = true }))

	local w, h = love.graphics.getScaledMode()
	self:setSize(DialogBox.WIDTH, DialogBox.HEIGHT)
	self:setPosition(w / 2 - DialogBox.WIDTH / 2, h - DialogBox.HEIGHT - DialogBox.PADDING)

	self.panel = Panel()
	self.panel:setStyle({
	image = "Resources/Game/UI/Buttons/Dialog-Default.png"
	}, PanelStyle)
	self.panel:setSize(DialogBox.WIDTH, DialogBox.HEIGHT)
	self:addChild(self.panel)

	self.dialogButton = Button()
	self.dialogButton:setStyle({
		hover = "Resources/Game/UI/Buttons/Dialog-Default.png",
		pressed = "Resources/Game/UI/Buttons/Dialog-Pressed.png",
		inactive = "Resources/Game/UI/Buttons/Dialog-Default.png"
	}, ButtonStyle)
	self.dialogButton:setSize(DialogBox.WIDTH, DialogBox.HEIGHT)
	self.dialogButton.onClick:register(DialogBox._onClickDialogButton, self)

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
	self.messageLabel:setIsClickThrough(true)
	self.dialogButton:addChild(self.messageLabel)

	self.clickToContinue = Label()
	self.clickToContinue:setText("Click to continue")
	self.clickToContinue:setStyle({
		align = 'center',
		textShadow = true,
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
		fontSize = _MOBILE and 28 or 24
	}, LabelStyle)
	self.clickToContinue:setPosition(
		self.messageLabel:getPosition(),
		DialogBox.HEIGHT - 24 - DialogBox.PADDING * 2)
	self.clickToContinue:setIsClickThrough(true)

	self.pressToContinue = GamepadToolTip()
	self.pressToContinue:setHasBackground(false)
	self.pressToContinue:setText("Continue")
	self.pressToContinue:setPosition(
		DialogBox.WIDTH / 2 - GamepadToolTip.MAX_WIDTH / 2,
		DialogBox.HEIGHT - GamepadToolTip.BUTTON_SIZE - DialogBox.PADDING)
	self.pressToContinue:setIsClickThrough(true)

	self.inputBox = TextInput()
	self.inputBox:setSize(DialogBox.WIDTH - DialogBox.PADDING * 2, 32)
	self.inputBox:setPosition(DialogBox.PADDING, DialogBox.HEIGHT / 2 - 16)

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
	self.dialogButton:addChild(self.speakerIconBackground)

	self.speakerIcon = SceneSnippet()
	self.speakerIcon:setSize(
		DialogBox.HEIGHT - DialogBox.PADDING * 2,
		DialogBox.HEIGHT - DialogBox.PADDING * 2)
	self.speakerIcon:setPosition(
		DialogBox.PADDING,
		DialogBox.PADDING)
	self.speakerIcon:setParentNode(SceneNode())
	self.speakerIcon:setRoot(self.speakerIcon:getParentNode())
	self.dialogButton:addChild(self.speakerIcon)

	self.options = {}

	self.camera = ThirdPersonCamera()
	self.camera:setDistance(2.5)
	self.camera:setUp(Vector(0, -1, 0))
	self.speakerIcon:setCamera(self.camera)

	self.keybind = Keybinds['PLAYER_1_CONTINUE']
	self.isKeybindDown = self.keybind:isDown()

	self:next()
end

function DialogBox:getOverflow()
	return true
end

function DialogBox:_onClickDialogButton(_, buttonIndex)
	if buttonIndex == 1 then
		self:pump()
	end
end

function DialogBox:pump()
	local state = self:getState()

	if state.input then
		self:sendPoke("submit", nil, { value = self.inputBox:getText() })
	else
		self:sendPoke("next", nil, {})
	end
end

function DialogBox:_onClickOptionButton(index, _, buttonIndex)
	if buttonIndex == 1 then
		self:select(index)
	end
end

function DialogBox:select(index)
	self:sendPoke("select", nil, { index = index })
end

function DialogBox:next(state)
	state = state or self:getState()

	self:removeChild(self.gridLayout)
	self.gridLayout = nil

	if state.content then
		self.messageLabel:setText(DialogBox.concatMessage(state.content))

		self:addChild(self.dialogButton)

		local inputProvider = self:getInputProvider()
		if inputProvider and inputProvider:getCurrentJoystick() then
			self:removeChild(self.clickToContinue)
			self:addChild(self.pressToContinue)

			self.pressToContinue:update(0)
			local x = self.messageLabel:getPosition()
			local labelWidth, labelHeight = self.messageLabel:getSize()
			local toolTipWidth, toolTipHeight = self.pressToContinue:getSize()
			self.pressToContinue:setPosition(
				x + labelWidth / 2 - toolTipWidth / 2,
				self.HEIGHT - toolTipHeight - self.PADDING)
		else
			self:removeChild(self.pressToContinue)
			self:addChild(self.clickToContinue)
		end

		self:focusChild(self.dialogButton)
	elseif state.input then
		self.messageLabel:setText(DialogBox.concatMessage(state.content))

		self:getView():getInputProvider():setFocusedWidget(self.inputBox)
		self.inputBox:setText("")

		self:addChild(self.inputBox)
		self:addChild(self.nextButton)
	elseif state.options then
		self.messageLabel:setText("")
		self:removeChild(self.dialogButton)
		self:removeChild(self.inputBox)
		self:removeChild(self.clickToContinue)
		self:removeChild(self.pressToContinue)

		local w, h = self:getSize()
		local gridLayout = GamepadGridLayout()
		gridLayout:setSize(w - self.PADDING * 2, 0)
		gridLayout:setPosition(self.PADDING, 0)
		gridLayout:setPadding(0, self.PADDING)
		gridLayout:setUniformSize(true, w - self.PADDING * 2, self.OPTION_HEIGHT)
		gridLayout:setWrapContents(true)

		for i = 1, #state.options do
			local option = Button()
			option:setStyle(DialogBox.OPTION_BUTTON_STYLE, ButtonStyle)
			option:setText(DialogBox.concatMessage({ state.options[i] }))
			option.onClick:register(DialogBox._onClickOptionButton, self, i)
			gridLayout:addChild(option)
		end

		self:addChild(gridLayout)
		self:focusChild(gridLayout, "select")

		self.gridLayout = gridLayout
	end

	if not state.content then
		self:removeChild(self.speakerIcon)
		self:removeChild(self.speakerIconBackground)
	elseif not state.input then
		self:removeChild(self.inputBox)
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
					self.speakerIcon:setChildNode(actorView:getSceneNode())
					self.actor = actor
					self.prop = nil
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
					self.speakerIcon:setChildNode(propView:getRoot())
					self.prop = prop
					self.actor = nil
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

	local root = self.speakerIcon:getChildNode()
	local transform = root and root:getTransform():getLocalTransform() or love.math.newTransform()

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
		local rotation = Quaternion.IDENTITY
		if node == self.actor then
			local direction, r = node:getDirection()
			if r then
				rotation = (-r) * Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi / 4)
			elseif direction.x < 0 then
				rotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi)
			end
		elseif node == self.prop then
			rotation = (-node:getRotation()) * Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi / 4)
		end
		self.speakerIcon:getParentNode():getTransform():setLocalRotation(rotation:getNormal())

		local otherTransform = self.speakerIcon:getParentNode():getTransform():getGlobalTransform()
		otherTransform:apply(transform)

		transform = otherTransform

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

	local isKeybindDown = self.keybind:isDown()
	if not self.isKeybindDown and isKeybindDown then
		if self:getState().content and not self:getView():getInputProvider():getFocusedWidget() then
			self:pump()
		end
	end
	self.isKeybindDown = isKeybindDown
end

return DialogBox
