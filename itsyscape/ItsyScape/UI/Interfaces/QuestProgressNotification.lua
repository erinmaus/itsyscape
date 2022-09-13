--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/QuestProgressNotification.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Drawable = require "ItsyScape.UI.Drawable"
local Icon = require "ItsyScape.UI.Icon"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local RichTextLabel = require "ItsyScape.UI.RichTextLabel"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local Widget = require "ItsyScape.UI.Widget"

local QuestProgressNotification = Class(Interface)
QuestProgressNotification.WIDTH = 384
QuestProgressNotification.HEIGHT = 320
QuestProgressNotification.PADDING = 8
QuestProgressNotification.ICON_SIZE = 48
QuestProgressNotification.BUTTON_SIZE = 48
QuestProgressNotification.HINT_WIDTH = 240
QuestProgressNotification.HINT_HEIGHT = 128

QuestProgressNotification.LocationHint = Class(Drawable)

function QuestProgressNotification.LocationHint:new(hint, interface)
	Drawable.new(self)

	self.hint = hint
	self.interface = interface

	self:setSize(
		QuestProgressNotification.HINT_WIDTH,
		QuestProgressNotification.HINT_HEIGHT)

	local label = Label()
	label:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 14,
		textShadow = true,
		width = QuestProgressNotification.HINT_WIDTH,
		color = { 1, 1, 0, 1 },
		align = 'center'
	}, interface:getView():getResources()))
	label:setText(hint.description)
	label:setIsClickThrough(true)
	self:addChild(label)

	self:setIsClickThrough(true)
	self:setZDepth(-1)
end

function QuestProgressNotification.LocationHint:getWorldPosition(worldTransform, position)
	local gameView = self.interface:getView():getGameView()

	local camera = gameView:getRenderer():getCamera()
	local projectionTransform, viewTransform = camera:getTransforms()

	local completeTransform = love.math.newTransform()
	completeTransform:apply(projectionTransform)
	completeTransform:apply(viewTransform)
	completeTransform:apply(worldTransform)

	result = Vector(completeTransform:transformPoint(position:get()))
	result = (result + Vector(1)) * Vector(0.5) * Vector(camera:getWidth(), camera:getHeight(), 1)

	return result
end

function QuestProgressNotification.LocationHint:getActorPosition(actorID)
	local gameView = self.interface:getView():getGameView()
	local actorView = gameView:getActor(gameView:getActorByID(actorID))

	if not actorView then
		return Vector.ZERO
	end

	local actorPosition
	do
		local worldTransform = actorView:getSceneNode():getTransform():getGlobalDeltaTransform(_APP:getFrameDelta())
		actorPosition = self:getWorldPosition(worldTransform, Vector.ZERO)
	end

	return actorPosition
end

function QuestProgressNotification.LocationHint:getPropPosition(propID)
	local gameView = self.interface:getView():getGameView()
	local propView = gameView:getProp(gameView:getPropByID(propID))

	if not propView then
		return Vector.ZERO
	end

	local propPosition
	do
		local worldTransform = propView:getRoot():getTransform():getGlobalDeltaTransform(_APP:getFrameDelta())
		propPosition = self:getWorldPosition(worldTransform, Vector.ZERO)
	end

	return propPosition
end

function QuestProgressNotification.LocationHint:getMapPosition(layer, vector)
	local mapSceneNode = self.interface:getView():getGameView():getMapSceneNode(layer)
	if mapSceneNode then
		local worldTransform = mapSceneNode:getTransform():getGlobalDeltaTransform(_APP:getFrameDelta())
		return self:getWorldPosition(worldTransform, vector)
	end

	return Vector.ZERO
end

function QuestProgressNotification.LocationHint:update()
	Drawable.update(self, delta)

	local w, h = self:getSize()
	local windowWidth, windowHeight = love.graphics.getScaledMode()

	local screenPosition
	do
		if self.hint.prop then
			screenPosition = self:getPropPosition(self.hint.prop)
		elseif self.hint.actor then
			screenPosition = self:getActorPosition(self.hint.actor)
		elseif self.hint.layer then
			screenPosition = self:getMapPosition(self.hint.layer, Vector(self.hint.x, self.hint.y, self.hint.z))
		else
			screenPosition = Vector.ZERO
		end
	end

	local x, y = self:getParent():getPosition()

	self:setPosition(
		math.min(math.max(screenPosition.x, 0), windowWidth) - w / 2 - x,
		math.min(math.max(screenPosition.y, 0), windowHeight) - h / 2 - y)
end

function QuestProgressNotification:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.hints = {}

	self:updatePosition()
	self:setSize(QuestProgressNotification.WIDTH, QuestProgressNotification.HEIGHT)

	local panel = Panel()
	panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Group.9.png"
	}, self:getView():getResources()))
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.closeButton = Button()
	self.closeButton:setSize(QuestProgressNotification.BUTTON_SIZE, QuestProgressNotification.BUTTON_SIZE)
	self.closeButton:setPosition(QuestProgressNotification.WIDTH - QuestProgressNotification.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	local icon = Icon()
	icon:setPosition(
		QuestProgressNotification.WIDTH / 2 - QuestProgressNotification.ICON_SIZE / 2,
		QuestProgressNotification.PADDING)
	icon:setSize(
		QuestProgressNotification.ICON_SIZE,
		QuestProgressNotification.ICON_SIZE)
	icon:setIcon("Resources/Game/UI/Icons/Things/Compass.png")
	self:addChild(icon)

	self.title = Label()
	self.title:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 22,
		textShadow = true,
		width = QuestProgressNotification.WIDTH,
		align = 'center'
	}, self:getView():getResources()))
	self.title:setPosition(
		0,
		QuestProgressNotification.ICON_SIZE + QuestProgressNotification.PADDING * 2)
	self:addChild(self.title)

	self.infoPanel = ScrollablePanel(GridLayout)
	self.infoPanel:setSize(
		QuestProgressNotification.WIDTH - QuestProgressNotification.PADDING * 2,
		QuestProgressNotification.HEIGHT - QuestProgressNotification.PADDING * 3 - QuestProgressNotification.ICON_SIZE - 24)
	self.infoPanel:getInnerPanel():setWrapContents(true)
	self.infoPanel:getInnerPanel():setPadding(0, 0)
	self.infoPanel:setPosition(
		QuestProgressNotification.PADDING,
		QuestProgressNotification.PADDING * 3 + QuestProgressNotification.ICON_SIZE + 24)
	self:addChild(self.infoPanel)

	self.guideLabel = RichTextLabel()
	self.guideLabel:setSize(
		QuestProgressNotification.WIDTH - QuestProgressNotification.PADDING * 2 - ScrollablePanel.DEFAULT_SCROLL_SIZE,
		0)
	self.guideLabel:setWrapContents(true)
	self.guideLabel:setWrapParentContents(true)
	self.infoPanel:addChild(self.guideLabel)

	self:setZDepth(-1)

	self:updateQuest()
	self:updateHints()
end

function QuestProgressNotification:getOverflow()
	return true
end

function QuestProgressNotification:updatePosition()
	local w, h = love.graphics.getScaledMode()
	local x, y = w - QuestProgressNotification.WIDTH - QuestProgressNotification.PADDING, QuestProgressNotification.PADDING
	do
		for _, interface in self:getView():getInterfaces("DialogBox") do
			local interfaceWidth, interfaceHeight = interface:getSize()
			local interfaceX, interfaceY = interface:getPosition()
			x = interfaceX + (interfaceWidth - QuestProgressNotification.WIDTH) / 2
			y = interfaceY - QuestProgressNotification.HEIGHT - QuestProgressNotification.PADDING
			break
		end
	end

	self:setPosition(x, y)
end

function QuestProgressNotification:updateQuest()
	local state = self:getState()

	self.title:setText(state.questName or "")

	local label = state.steps and {
		state.steps[#state.steps - 1] or "",
		state.steps[#state.steps] or "",
	}

	self.guideLabel:setText(label or "")
end

function QuestProgressNotification:updateHints()
	for i = 1, #self.hints do
		self:removeChild(self.hints[i])
	end
	table.clear(self.hints)

	local state = self:getState()
	local hints = state.hints or {}
	for i = 1, #hints do
		local hint = QuestProgressNotification.LocationHint(state.hints[i], self)
		self:addChild(hint)
		table.insert(self.hints, hint)
	end
end

function QuestProgressNotification:update(delta)
	Interface.update(self, delta)

	self:updatePosition()
end

return QuestProgressNotification
