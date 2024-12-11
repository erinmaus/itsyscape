--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Cannon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local LightBeamSceneNode = require "ItsyScape.Graphics.LightBeamSceneNode"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Widget = require "ItsyScape.UI.Widget"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"

local Cannon = Class(Interface)

function Cannon:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.onClose:register(function()
		if self.currentSceneNode then
			self.currentSceneNode:setParent()
		end
	end)

	local w, h = love.graphics.getScaledMode()
	self:setSize(w, h)
	self:setPosition(0, 0)

	self:setZDepth(-1000)

	self.currentMouseX, self.currentMouseY = itsyrealm.mouse.getPosition()

	self:tick()
end

function Cannon:getIsFocusable()
	return true
end

function Cannon:mousePress(x, y, ...)
	Interface.mousePress(self, x, y, ...)

	self:sendPoke("fire", nil, { resource = "ItsyCannonball" })
end

function Cannon:tick()
	Interface.tick(self)

	self.previousMouseX, self.previousMouseY = self.currentMouseX, self.currentMouseY
	self.currentMouseX, self.currentMouseY = itsyrealm.mouse.getPosition()

	self.currentMouseX = math.floor(self.currentMouseX)
	self.currentMouseY = math.floor(self.currentMouseY)

	local width, height = self:getSize()

	if self.currentMouseX ~= self.previousMouseX or self.currentMouseY ~= self.previousMouseY then
		self:sendPoke("tilt", nil, { y = self.currentMouseX / width, x = self.currentMouseY / height })
	end
end

function Cannon:updatePath(path)
	local gameView = self:getView():getGameView()

	if self.currentSceneNode then
		self.currentSceneNode:setParent()
	end

	self.currentSceneNode = LightBeamSceneNode()
	self.currentSceneNode:setBeamSize(0.5)
	self.currentSceneNode:getMaterial():setColor(Color.fromHexString("ffcc00"))
	self.currentSceneNode:getMaterial():setIsFullLit(true)

	self.currentSceneNode:buildSeamless(path)
	self.currentSceneNode:setParent(gameView:getScene())
end

return Cannon
