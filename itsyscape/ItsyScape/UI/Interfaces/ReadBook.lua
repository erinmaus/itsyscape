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
	panel:setIsSelfClickThrough(true)
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

	self:setIsSelfClickThrough(true)
	self.bookSceneSnippet:setIsSelfClickThrough()

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
			-- Nothing.
		else
			if self.ready then
				self.book:flipForward()
			else
				self.ready = true
			end
		end
	end
	self.wasFDown = isFDown

	local isBDown = love.keyboard.isDown("b")
	if not self.wasBDown and isBDown and not self.book:getIsOpeningOrClosing() then
		if (self.book:getIsFlipping() and self.book:getWillFlipBackwardCloseBook()) then
			-- Nothing.
		else
			if self.book:getCurrentState() == Book.STATE_FRONT_COVER then
				self.currentBookState = "spine"
				self.previousBookState = Book.STATE_FRONT_COVER
				self.currentCameraTime = 0
				self.ready = false
			else
				self.book:flipBackward()
			end
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
	end
	local previousState = self.previousBookState or currentState

	local verticalRotation, horizontalRotation
	do
		self.currentCameraTime = (self.currentCameraTime or 0) + delta
		local mu = math.clamp(self.currentCameraTime / 0.25)

		local currentVerticalRotation, currentHorizontalRotation
		if currentState == "spine" then
			currentVerticalRotation = math.pi / 2
			currentHorizontalRotation = 0
		elseif currentState == Book.STATE_FRONT_COVER then
			currentVerticalRotation = 0
			currentHorizontalRotation = math.pi / 8
		elseif currentState == Book.STATE_BACK_COVER then
			currentVerticalRotation = -math.pi
			currentHorizontalRotation = math.pi / 8
		else
			currentVerticalRotation = -math.pi / 2
			currentHorizontalRotation = math.pi / 7
		end

		local previousVerticalRotation, previousHorizontalRotation
		if previousState == "spine" then
			previousVerticalRotation = math.pi / 2
			previousHorizontalRotation = 0
		elseif previousState == Book.STATE_FRONT_COVER then
			previousVerticalRotation = 0
			previousHorizontalRotation = math.pi / 8
		elseif previousState == Book.STATE_BACK_COVER then
			previousVerticalRotation = -math.pi
			previousHorizontalRotation = math.pi / 8
		else
			previousVerticalRotation = -math.pi / 2
			previousHorizontalRotation = math.pi / 7
		end

		verticalRotation = math.lerpAngle(previousVerticalRotation, currentVerticalRotation, Tween.sineEaseOut(mu))
		horizontalRotation = math.lerpAngle(previousHorizontalRotation, currentHorizontalRotation, Tween.sineEaseOut(mu))

		if mu >= 1 then
			self.previousBookState = currentState
		end
	end


	local gameCamera = self:getView():getGameView():getCamera()
	local width, height = self.bookSceneSnippet:getSize()
	self.camera:copy(gameCamera)
	self.camera:setVerticalRotation(verticalRotation)
	self.camera:setHorizontalRotation(horizontalRotation)
	self.camera:setPosition(Vector.ZERO)
	self.camera:setWidth(width)
	self.camera:setHeight(height)
	self.camera:setDistance(3)
	--self.bookSceneSnippet:getRoot():getTransform():setLocalRotation(Quaternion.fromAxisAngle(Vector.UNIT_Y, love.timer.getTime() / 3.14))
end

return ReadBook
