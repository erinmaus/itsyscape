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
local Vector = require "ItsyScape.Common.Math.Vector"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local Book = require "ItsyScape.Graphics.Book"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local DirectionalLightSceneNode = require "ItsyScape.Graphics.DirectionalLightSceneNode"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local Interface = require "ItsyScape.UI.Interface"
local Label = require "ItsyScape.UI.Label"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"

local ReadBook = Class(Interface)

function ReadBook:new(...)
	Interface.new(self, ...)

	local width, height = love.graphics.getScaledMode()
	self:setSize(width, height)
	self:setPosition(0, 0)

	self.camera = ThirdPersonCamera()

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

	self.wasFDown = love.keyboard.isDown("f")
	self.wasBDown = love.keyboard.isDown("b")
end

function ReadBook:update(delta)
	Interface.update(self, delta)

	local isFDown = love.keyboard.isDown("f")
	if not self.wasFDown and isFDown and not self.book:getIsOpeningOrClosing() then
		self.book:flipForward()
	end
	self.wasFDown = isFDown

	local isBDown = love.keyboard.isDown("b")
	if not self.wasBDown and isBDown and not self.book:getIsOpeningOrClosing() then
		self.book:flipBackward()
	end
	self.wasBDown = isBDown

	local gameCamera = self:getView():getGameView():getCamera()
	local width, height = self.bookSceneSnippet:getSize()
	self.camera:copy(gameCamera)
	self.camera:setPosition(Vector.ZERO)
	self.camera:setWidth(width)
	self.camera:setHeight(height)
	self.camera:setDistance(4)

	self.book:update(delta)
	self.book:draw()

	--self.bookSceneSnippet:getRoot():getTransform():setLocalRotation(Quaternion.fromAxisAngle(Vector.UNIT_Y, love.timer.getTime() / 3.14))
end

return ReadBook
