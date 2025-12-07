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
local Vector = require "ItsyScape.Common.Math.Vector"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Button = require "ItsyScape.UI.Button"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local Theme = require "ItsyScape.UI.Interfaces.Theme"

local Plinth = Class(Interface)

function Plinth:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self:setData(GamepadSink, GamepadSink({
		isBlockingCamera = false
	}))

	self:setIsSelfClickThrough(true)

	self.panel = Panel()
	self.panel:setStyle({
		radius = 0,
		color = { 0, 0, 0, 0.4 },
	}, PanelStyle)
	self.panel:setIsSelfClickThrough(true)
	self:addChild(self.panel)

	self.sceneSnippet = SceneSnippet()
	self.sceneSnippet:setParentNode(SceneNode())
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

	self:setZDepth(-1000)

	self:performLayout()
end

function Plinth:performLayout()
	Interface.performLayout(self)

	local w, h = itsyrealm.graphics.getScaledMode()
	self:setSize(w, h)
	self:setPosition(0, 0)

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

function Plinth:close()
	self:sendPoke("close", nil)
end

function Plinth:controlUp(control)
	if control:is("back") then
		self:close()
	end
end

function Plinth:update(...)
	Interface.update(self, ...)

	local state = self:getState()

	local gameView = self:getView():getGameView()
	local object = gameView:getPropByID(state.propID) or gameView:getActorByID(state.actorID)

	if object then
		local zoom = state.zoom
		local offset = Vector(unpack(state.offset))
		Theme.setSceneSnippet(self.sceneSnippet, self.camera, gameView, object, offset, zoom)
	end
end

return Plinth
