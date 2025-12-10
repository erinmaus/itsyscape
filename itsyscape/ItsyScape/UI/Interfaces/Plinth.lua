--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Plinth.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Config = require "ItsyScape.Game.Config"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local Color = require "ItsyScape.Graphics.Color"
local DirectionalLightSceneNode = require "ItsyScape.Graphics.DirectionalLightSceneNode"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Button = require "ItsyScape.UI.Button"
local InputScheme = require "ItsyScape.UI.InputScheme"
local Interface = require "ItsyScape.UI.Interface"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local Widget = require "ItsyScape.UI.Widget"
local Theme = require "ItsyScape.UI.Interfaces.Theme"

local Plinth = Class(Interface)

Plinth.RADIANS_PER_SECOND = math.pi

Plinth.EXHIBIT_BACKGROUND_PANEL = {
	radius = 0,
	color = { 0, 0, 0, 0.4 }
}

Plinth.TEXT_BACKGROUND_PANEL = {
	radius = Theme.DEFAULT_OUTER_PADDING,
	color = { 0, 0, 0, 0.5 }
}

Plinth.TITLE_LABEL = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 48,
	spaceLines = true,
	textShadow = true
}

Plinth.DESCRIPTION_LABEL = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 32,
	spaceLines = true,
	textShadow = true
}

Plinth.TITLE_HEIGHT = 48

function Plinth:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.currentRotation = Quaternion.IDENTITY

	self:setData(GamepadSink, GamepadSink({
		isBlockingCamera = false
	}))

	self:setIsSelfClickThrough(true)

	self.panel = Panel()
	self.panel:setStyle(self.EXHIBIT_BACKGROUND_PANEL, PanelStyle)
	self.panel:setIsSelfClickThrough(true)
	self:addChild(self.panel)

	self.sceneSnippet = SceneSnippet()

	local parentNode = SceneNode()

	local ambientLight = AmbientLightSceneNode()
	ambientLight:setAmbience(0.25)
	ambientLight:setParent(parentNode)

	local directionalLight = DirectionalLightSceneNode()
	directionalLight:setColor(Color(0.5, 0.5, 0.5, 1))
	directionalLight:setDirection(Vector(1, 2, 1))
	directionalLight:setParent(parentNode)

	self.sceneSnippet:setParentNode(parentNode)
	self.sceneSnippet:setRoot(self.sceneSnippet:getParentNode())
	self.sceneSnippet:setDPIScale(1)
	self.sceneSnippet:setIsSelfClickThrough(true)
	self:addChild(self.sceneSnippet)

	self.closeButton = Button()
	self.closeButton:setText("Close Exhibit")
	self.closeButton:setSize(256, Theme.DEFAULT_BUTTON_SIZE)
	self.closeButton.onClick:register(self._onCloseButtonClicked, self)
	self:addChild(self.closeButton)

	self.camera = ThirdPersonCamera()
	self.camera:setUp(Vector(0, -1, 0))
	self.sceneSnippet:setCamera(self.camera)

	self.textContainer = Panel()
	self.textContainer:setStyle(self.TEXT_BACKGROUND_PANEL, PanelStyle)
	self.textContainer:setIsSelfClickThrough(true)
	self.textContainer:setAreChildrenClickThrough(true)
	self:addChild(self.textContainer)

	self.titleContainer = Widget()
	self.textContainer:addChild(self.titleContainer)

	self.titleLabel = Label()
	self.titleLabel:setStyle(self.TITLE_LABEL, LabelStyle)
	self.titleContainer:addChild(self.titleLabel)

	self.descriptionContainer = Widget()
	self.textContainer:addChild(self.descriptionContainer)

	self.descriptionLabel = Label()
	self.descriptionLabel:setStyle(self.DESCRIPTION_LABEL, LabelStyle)
	self.descriptionContainer:addChild(self.descriptionLabel)

	self:setZDepth(-500)
	self:performLayout()
end

function Plinth:attach()
	self:focusChild(self.closeButton)
end

function Plinth:performLayout()
	Interface.performLayout(self)

	local w, h = itsyrealm.graphics.getScaledMode()
	self:setSize(w, h)
	self:setPosition(0, 0)

	self.textContainer:setPosition(w / 2 - w / 4 - Theme.DEFAULT_OUTER_PADDING, h / 2 - self.TITLE_HEIGHT - Theme.DEFAULT_OUTER_PADDING)
	self.textContainer:setSize(
		w / 2 + Theme.DEFAULT_OUTER_PADDING * 2,
		h / 2 + self.TITLE_HEIGHT - Theme.DEFAULT_BUTTON_SIZE - Theme.DEFAULT_OUTER_PADDING)

	self.titleContainer:setPosition(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	self.titleContainer:setSize(w / 2, self.TITLE_HEIGHT)

	self.descriptionContainer:setPosition(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING + self.TITLE_HEIGHT)
	self.descriptionContainer:setSize(w / 2, h / 2 - Theme.DEFAULT_BUTTON_SIZE - Theme.DEFAULT_OUTER_PADDING)

	self.panel:setSize(w, h)

	self.sceneSnippet:setSize(w, h)
	self.sceneSnippet:setPosition(0, 0)

	local buttonWidth, buttonHeight = self.closeButton:getSize()
	self.closeButton:setPosition(
		(w - buttonWidth) / 2,
		h - buttonHeight - Theme.DEFAULT_OUTER_PADDING)
end

function Plinth:restoreFocus()
	Interface.restoreFocus(self)

	self:focusChild(self.closeButton)
end

function Plinth:_onCloseButtonClicked(_, index)
	if index == 1 then
		self:close()
	end
end

function Plinth:mouseMove(x, y)
	local uiView = self:getView()
	if uiView:getCurrentInputScheme() ~= InputScheme.INPUT_SCHEME_MOUSE_KEYBOARD then
		return
	end

	local width, height = self:getSize()
	local halfWidth, halfHeight = width / 2, height / 2

	local xAngle = (x - halfWidth) / halfWidth * math.pi
	local xRotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, xAngle)

	local yAngle = (y - halfHeight) / halfHeight * math.pi
	local yRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, yAngle)

	local rotation = (xRotation * yRotation):getNormal()

	self.currentRotation = rotation
end

function Plinth:close()
	self:sendPoke("close", nil)
end

function Plinth:controlUp(control)
	if control:is("back") then
		self:close()
	end
end

function Plinth:updateGamepadRotation(delta)
	local uiView = self:getView()
	if uiView:getCurrentInputScheme() ~= InputScheme.INPUT_SCHEME_GAMEPAD then
		return
	end

	local inputProvider = uiView:getInputProvider()
	local currentJoystick = inputProvider:getCurrentJoystick()

	local xAxisLabel = Config.get("Input", "KEYBIND", "type", "ui", "name", "xAxis") or "leftx"
	local yAxisLabel = Config.get("Input", "KEYBIND", "type", "ui", "name", "yAxis") or "lefty"
	local axisSensitivity = Config.get("Input", "KEYBIND", "type", "ui", "name", "axisSensitivity") or 0.5

	local x = currentJoystick:getGamepadAxis(xAxisLabel)
	if math.abs(x) < axisSensitivity then
		x = 0
	end

	local y = currentJoystick:getGamepadAxis(yAxisLabel)
	if math.abs(y) < axisSensitivity then
		y = 0
	end

	local xAngle = x * self.RADIANS_PER_SECOND * delta
	local yAngle = y * self.RADIANS_PER_SECOND * delta

	local xRotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, xAngle)
	local yRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, yAngle)

	self.currentRotation = (self.currentRotation * (xRotation * yRotation)):getNormal()
end

function Plinth:tick()
	Interface.tick(self)

	local state = self:getState()

	self.titleLabel:setText(state.name)
	self.descriptionLabel:setText(state.description)
end

function Plinth:update(delta)
	Interface.update(self, delta)

	self:updateGamepadRotation(delta)

	local state = self:getState()

	local gameView = self:getView():getGameView()
	local object = gameView:getPropByID(state.propID) or gameView:getActorByID(state.actorID)

	if object then
		local zoom = state.zoom
		local offset = Vector(unpack(state.offset))

		Theme.setSceneSnippet(self.sceneSnippet, self.camera, gameView, object, offset, zoom)
		self.camera:setRotation(self.camera:getRotation() * self.currentRotation)
	end
end

return Plinth
