--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/DemoNewPlayer.lua
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
local ActorView = require "ItsyScape.Graphics.ActorView"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local DefaultCameraController = require "ItsyScape.Graphics.DefaultCameraController"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local NullActor = require "ItsyScape.Game.Null.Actor"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
local Interface = require "ItsyScape.UI.Interface"
local RichTextLabel = require "ItsyScape.UI.RichTextLabel"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"

local DemoNewPlayer = Class(Interface)

DemoNewPlayer.BUTTON_WIDTH = 264
DemoNewPlayer.BUTTON_HEIGHT = 456
DemoNewPlayer.PADDING = 8

DemoNewPlayer.MAX_ANIMATION_TIME = 12
DemoNewPlayer.MIN_ANIMATION_TIME = 4

DemoNewPlayer.BUTTON_STYLE = {
	hover = "Resources/Game/UI/Buttons/Dialog-Hover.png",
	pressed = "Resources/Game/UI/Buttons/Dialog-Pressed.png",
	inactive = "Resources/Game/UI/Buttons/Dialog-Default.png"
}

function DemoNewPlayer:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local width, height = itsyrealm.graphics.getScaledMode()
	self:setSize(width, height)

	self.layout = GamepadGridLayout()
	self.layout:setSize(width, DemoNewPlayer.BUTTON_HEIGHT)
	self.layout:setUniformSize(true, self.BUTTON_WIDTH, self.BUTTON_HEIGHT)
	self.layout:setPadding(self.PADDING, 0)
	self:addChild(self.layout)

	self.currentFocusIndex = 1

	self.classes = {}
end

function DemoNewPlayer:newPlayer(index)
	self:sendPoke("newPlayer", nil, { index = index })
end

function DemoNewPlayer:_onSelectPlayer(index, _, buttonIndex)
	if buttonIndex == 1 then
		self:newPlayer(index)
	end
end

function DemoNewPlayer:_onFocusPlayer(index)
	self.currentFocusIndex = index

	local class = self.classes[index]
	class.actor:setAppearance({
		animations = {
			attack = { priority = 10, animation = class.info.animations.attack }
		}
	})

	class.pendingAnimationTime = self.MAX_ANIMATION_TIME
end

function DemoNewPlayer:addClass(playerStorage, otherStorage, info)
	local index = #self.classes + 1

	local actor = NullActor()
	actor:spawn(index)

	local actorView = ActorView(actor, "Player")
	actorView:attach(self:getView():getGameView())

	actor:fromStorage(playerStorage)
	actor:fromStorage(otherStorage)
	actor:setAppearance({
		animations = {
			idle = { priority = 0, animation = info.animations.idle }
		}
	})

	local button = Button()
	button:setStyle(self.BUTTON_STYLE, ButtonStyle)
	button.onClick:register(self._onSelectPlayer, self, index)
	button.onFocus:register(self._onFocusPlayer, self, index)

	local sceneSnippet = SceneSnippet()
	sceneSnippet:setSize(self.BUTTON_WIDTH - self.PADDING * 2, self.BUTTON_WIDTH - self.PADDING * 2)
	sceneSnippet:setPosition(self.PADDING, self.PADDING)
	button:addChild(sceneSnippet)

	local sceneWidth, sceneHeight = sceneSnippet:getSize()
	local camera = ThirdPersonCamera()
	camera:setUp(Vector.UNIT_Y)
	camera:setDistance(7)
	camera:setVerticalRotation(DefaultCameraController.CAMERA_VERTICAL_ROTATION)
	camera:setHorizontalRotation(DefaultCameraController.CAMERA_HORIZONTAL_ROTATION)
	camera:setPosition(Vector.UNIT_Y)
	camera:setWidth(sceneWidth)
	camera:setHeight(sceneHeight)
	sceneSnippet:setCamera(camera)

	local parentNode = SceneNode()
	parentNode:setParent(sceneSnippet:getRoot())

	local ambientLightSceneNode = AmbientLightSceneNode()
	ambientLightSceneNode:setAmbience(1)
	ambientLightSceneNode:setParent(parentNode)

	sceneSnippet:setChildNode(actorView:getSceneNode())
	sceneSnippet:setParentNode(parentNode)

	local label = RichTextLabel()
	label:setText(info.label)

	label:setSize(
		self.BUTTON_WIDTH - self.PADDING * 4,
		self.BUTTON_HEIGHT - sceneHeight - self.PADDING * 3)

	local labelWidth, labelHeight = label:getSize()
	label:setPosition(
		self.PADDING * 2,
		self.BUTTON_HEIGHT - labelHeight - self.PADDING)
	button:addChild(label)

	self.layout:addChild(button)
	table.insert(self.classes, {
		actor = actor,
		actorView = actorView,
		playerStorage = playerStorage,
		otherStorage = otherStorage,
		info = info,
		button = button,
		camera = camera,
		sceneSnippet = sceneSnippet,
		pendingAnimationTime = love.math.random(self.MIN_ANIMATION_TIME, self.MAX_ANIMATION_TIME)
	})

	local width, height = self:getSize()
	self.layout:setPosition(
		width / 2 - (self.layout:getNumChildren() * (self.PADDING + self.BUTTON_WIDTH) + self.PADDING) / 2,
		height / 2 - self.BUTTON_HEIGHT / 2)

	self:focusChild(self.layout)
end

function DemoNewPlayer:updateClass(class, delta)
	local isFocused = self.classes[self.currentFocusIndex] == class

	class.pendingAnimationTime = class.pendingAnimationTime - delta
	if class.pendingAnimationTime < 0 then
		if isFocused then
			class.actor:setAppearance({
				animations = {
					attack = { priority = 10, animation = class.info.animations.attack }
				}
			})
		end

		class.pendingAnimationTime = class.pendingAnimationTime + love.math.random(self.MIN_ANIMATION_TIME, self.MAX_ANIMATION_TIME)
	end

	class.actorView:update(delta)
end

function DemoNewPlayer:update(delta)
	Interface.update(self, self.delta)

	for _, class in ipairs(self.classes) do
		self:updateClass(class, delta)
	end
end

return DemoNewPlayer
