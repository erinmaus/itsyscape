--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Helm.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local LightBeamSceneNode = require "ItsyScape.Graphics.LightBeamSceneNode"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Widget = require "ItsyScape.UI.Widget"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"

local Helm = Class(Interface)

function Helm:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(w, h)
	self:setPosition(0, 0)

	self.snippet = SceneSnippet()
	self.snippet:setSize(w, h / 2)
	self.snippet:setPosition(0, h / 2)
	self.snippet:setParentNode(SceneNode())
	self.snippet:setRoot(self.snippet:getParentNode())
	self.snippet:setDPIScale(1)
	self:addChild(self.snippet)

	self.camera = ThirdPersonCamera()
	self.camera:setUp(Vector(0, -1, 0))
	self.snippet:setCamera(self.camera)

	self:setZDepth(-1000)

	self.currentMouseX, self.currentMouseY = itsyrealm.mouse.getPosition()

	self:tick()
end

function Helm:getIsFocusable()
	return true
end

function Helm:mousePress(x, y, ...)
	Interface.mousePress(self, x, y, ...)

	self:sendPoke("cancel", nil)
end

function Helm:tick()
	Interface.tick(self)

	self.previousMouseX, self.previousMouseY = self.currentMouseX, self.currentMouseY
	self.currentMouseX, self.currentMouseY = itsyrealm.mouse.getPosition()

	self.currentMouseX = math.floor(self.currentMouseX)
	self.currentMouseY = math.floor(self.currentMouseY)

	local width, height = self:getSize()

	local deltaX = 1 - self.currentMouseX / width
	local deltaY = self.currentMouseY / height

	if self.currentMouseX ~= self.previousMouseX or self.currentMouseY ~= self.previousMouseY then
		self:sendPoke("spin", nil, { x = deltaX, y = deltaY })
	end
end

function Helm:update(...)
	Interface.update(self, ...)

	local state = self:getState()
	local helmPropID = state.helmPropID
	if helmPropID then
		local gameView = self:getView():getGameView()
		local prop = gameView:getPropByID(helmPropID)
		local propView = gameView:getProp(prop)

		self.snippet:setChildNode(propView:getRoot())

		local w, h = self.snippet:getSize()
		self.camera:setWidth(w)
		self.camera:setHeight(h)
		self.camera:setDistance(2)
		self.camera:setPosition(propView:getRoot():getTransform():getLocalTranslation() + Vector(0, 1.75, 0))
	end
end

return Helm
