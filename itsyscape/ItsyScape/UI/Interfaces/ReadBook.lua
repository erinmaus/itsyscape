--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/ReadBook.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local Book = require "ItsyScape.Graphics.Book"
local Color = require "ItsyScape.Graphics.Color"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local DirectionalLightSceneNode = require "ItsyScape.Graphics.DirectionalLightSceneNode"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local Interface = require "ItsyScape.UI.Interface"
local Label = require "ItsyScape.UI.Label"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"

local ReadBook = Class(Interface)

function ReadBook:new(...)
	Interface.new(self, ...)

	local width, height = love.graphics.getScaledMode()
	self:setSize(width, height)
	self:setPosition(0, 0)

	self.camera = ThirdPersonCamera()

	local panel = Panel()
	panel:setStyle(PanelStyle({ color = { Color.fromHexString("#ffffff"):get() } }))
	panel:setSize(width, height)
	panel:setIsClickThrough(true)
	self:addChild(panel)
	

	self.bookSceneSnippet = SceneSnippet()
	self.bookSceneSnippet:setPosition(0, 0)
	self.bookSceneSnippet:setSize(width, height)
	self.bookSceneSnippet:setCamera(self.camera)
	self:addChild(self.bookSceneSnippet)

	local state = self:getState()
	local resource = self:getView():getGame():getGameDB():getResource(state.resource, "Book")
	self.book = Book(state.book, resource, self:getView():getGameView())
	self.book:load()

	local parentSceneNode = SceneNode()
	parentSceneNode:getTransform():setLocalRotation(Quaternion.X_90)
	parentSceneNode:setParent(self.bookSceneSnippet:getRoot())

	local ambientLight = AmbientLightSceneNode()
	ambientLight:setAmbience(0.7)
	ambientLight:setParent(parentSceneNode)

	local directionalLight = DirectionalLightSceneNode()
	directionalLight:setDirection(Vector(1, 2, 1):getNormal())
	directionalLight:setParent(parentSceneNode)

	self.bookSceneSnippet:setParentNode(parentSceneNode)
	self.bookSceneSnippet:setChildNode(self.book:getSceneNode())

	self:setIsClickThrough(true)
	self.bookSceneSnippet:setIsClickThrough()

	local label = Label()
	label:setText("Book Is Open")
	self:addChild(label)

	self.currentBookState = "spine"
	self.ready = false

	self.wasFDown = love.keyboard.isDown("f")
	self.wasBDown = love.keyboard.isDown("b")
end

function ReadBook:update(delta)
	Interface.update(self, delta)

	local isFDown = love.keyboard.isDown("f")
	if not self.wasFDown and isFDown and not self.book:getIsOpeningOrClosing() then
		if (self.book:getIsFlipping() and self.book:getWillFlipForwardCloseBook()) then
			print(">>> waiting... try again!")
		elseif self.ready then
			print("> FORWARD!")
			self.book:flipForward()
		else
			self.ready = true
			print("> READY!")
		end
	end
	self.wasFDown = isFDown

	local isBDown = love.keyboard.isDown("b")
	if not self.wasBDown and isBDown and not self.book:getIsOpeningOrClosing() then
		if (self.book:getIsFlipping() and self.book:getWillFlipBackwardCloseBook()) then
			print(">>> waiting... try again!")
		elseif self.book:getCurrentState() == Book.STATE_FRONT_COVER then
			self.currentBookState = "spine"
			self.ready = false
		else
			print("> BACKWARD!")
			self.book:flipBackward()
		end
	end
	self.wasBDown = isBDown

	self.book:update(delta)
	self.book:draw()

	local currentState = self.ready and self.book:getCurrentState() or self.currentBookState
	if currentState ~= self.currentBookState then
		self.previousBookState = self.currentBookState or currentState
		self.currentBookState = currentState
		self.currentCameraTime = 0
		print(">>> reset", "prev", previousState, "curr", currentState)
	end
	local previousState = self.previousBookState or currentState

	local rotation
	do
		self.currentCameraTime = (self.currentCameraTime or 0) + delta
		local mu = math.clamp(self.currentCameraTime / 0.25)

		local currentRotation
		if currentState == "spine" then
			currentRotation = math.pi / 2
		elseif currentState == Book.STATE_FRONT_COVER then
			currentRotation = 0
		elseif currentState == Book.STATE_BACK_COVER then
			currentRotation = -math.pi
		else
			currentRotation = -math.pi / 2
		end

		local previousRotation
		if currentState == "spine" then
			previousRotation = math.pi / 2
		elseif previousState == Book.STATE_FRONT_COVER then
			previousRotation = 0
		elseif previousState == Book.STATE_BACK_COVER then
			previousRotation = -math.pi
		else
			previousRotation = -math.pi / 2
		end

		rotation = math.lerpAngle(previousRotation, currentRotation, Tween.sineEaseOut(mu))
		if mu >= 1 then
			self.previousBookState = currentState
		end
	end


	local gameCamera = self:getView():getGameView():getCamera()
	local width, height = self.bookSceneSnippet:getSize()
	self.camera:copy(gameCamera)
	self.camera:setVerticalRotation(rotation)
	self.camera:setHorizontalRotation(math.pi / 4)
	self.camera:setPosition(Vector.ZERO)
	self.camera:setWidth(width)
	self.camera:setHeight(height)
	self.camera:setDistance(3)
	--self.bookSceneSnippet:getRoot():getTransform():setLocalRotation(Quaternion.fromAxisAngle(Vector.UNIT_Y, love.timer.getTime() / 3.14))
end

return ReadBook
