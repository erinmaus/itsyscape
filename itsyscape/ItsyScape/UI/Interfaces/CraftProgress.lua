--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/CraftProgress.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local CloseButton = require "ItsyScape.UI.CloseButton"
local Interface = require "ItsyScape.UI.Interface"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local Theme = require "ItsyScape.UI.Interfaces.Theme"
local StatBar = require "ItsyScape.UI.Interfaces.Components.StatBar"

local CraftProgress = Class(Interface)

CraftProgress.CONTENT_WIDTH  = Theme.calculateTiledSizeWithPadding(Theme.CONTENT_WIDTH, Theme.DEFAULT_OUTER_PADDING, 2)
CraftProgress.CONTENT_HEIGHT = Theme.calculateTiledSizeWithPadding(
	Theme.calculateSizeWithPadding(
		Theme.DEFAULT_OUTER_PADDING,
		Theme.DEFAULT_ITEM_SIZE_WITH_PADDING,
		Theme.DEFAULT_ICON_SIZE), Theme.DEFAULT_OUTER_PADDING, 1)

CraftProgress.WINDOW_WIDTH  = CraftProgress.CONTENT_WIDTH
CraftProgress.WINDOW_HEIGHT = Theme.calculateSize(Theme.TITLE_HEIGHT, CraftProgress.CONTENT_HEIGHT)

function CraftProgress:new(...)
	Interface.new(self, ...)

	self:setSize(self.WINDOW_WIDTH, self.WINDOW_HEIGHT)

	self.titlePanel = Theme.newTitlePanel(self, self.WINDOW_WIDTH)
	self.titleLabel = Theme.newTitleLabel(self.titlePanel)
	self.titleLabel:setZDepth(100)

	self.contentPanel = Theme.newContentPanel(self, self.CONTENT_WIDTH, self.CONTENT_HEIGHT)

	Theme.newCloseButton(self.titlePanel)

	self.camera = ThirdPersonCamera()

	self.sceneSnippet = SceneSnippet()
	self.sceneSnippet:setSize(
		Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, Theme.TITLE_HEIGHT),
		Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, Theme.TITLE_HEIGHT))
	self.sceneSnippet:setPosition(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	self.sceneSnippet:setCamera(self.camera)
	self.titlePanel:addChild(self.sceneSnippet)

	local parentNode = SceneNode()
	local ambientLight = AmbientLightSceneNode()
	ambientLight:setAmbience(1)
	ambientLight:setParent(parentNode)

	self.sceneSnippet:setParentNode(parentNode)
	self.sceneSnippet:setRoot(parentNode)

	self.itemPanel = Theme.newItemParent(self.contentPanel, Panel)
	self.itemPanel:setPosition(
		Theme.DEFAULT_OUTER_PADDING,
		Theme.DEFAULT_OUTER_PADDING)

	self.item = Theme.addItemIconChild(self.itemPanel)

	self.itemNameLabel = Label()
	self.itemNameLabel:setStyle(Theme.CONTENT_TITLE_LABEL_STYLE, LabelStyle)
	self.itemNameLabel:setPosition(
		Theme.calculateSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_ITEM_SIZE_WITH_PADDING),
		Theme.DEFAULT_OUTER_PADDING)
	self.contentPanel:addChild(self.itemNameLabel)

	self.itemDescriptionLabel = Label()
	self.itemDescriptionLabel:setStyle(Theme.CONTENT_LABEL_STYLE, LabelStyle)
	self.itemDescriptionLabel:setPosition(
		Theme.calculateSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_ITEM_SIZE_WITH_PADDING),
		Theme.calculateSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.CONTENT_TITLE_LABEL_STYLE.fontSize))
	self.contentPanel:addChild(self.itemDescriptionLabel)

	self.progressBar = StatBar()
	self.progressBar:setNamedColors("ui.resource.progress", "ui.resource.remainder")
	self.progressBar:setSize(
		Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, self.WINDOW_WIDTH),
		Theme.DEFAULT_ICON_SIZE)
	self.progressBar:setPosition(
		Theme.DEFAULT_OUTER_PADDING,
		Theme.calculateSize(Theme.calculateSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_ITEM_SIZE_WITH_PADDING), Theme.DEFAULT_INNER_PADDING))
	self.contentPanel:addChild(self.progressBar)

	self.progressBarLabel = Label()
	self.progressBarLabel:setStyle(Theme.PROGRESS_BAR_LABEL_STYLE, LabelStyle)
	self.progressBar:addChild(self.progressBarLabel)

	self:performLayout()
end

function CraftProgress:performLayout()
	Interface.performLayout(self)

	local width, height = itsyrealm.graphics.getScaledMode()
	local selfWidth, selfHeight = self:getSize()
	self:setPosition((width - selfWidth) / 2, height / 4 - selfHeight / 2)
end

function CraftProgress:tick()
	Interface.tick(self)

	local state = self:getState()
	local current = state.progress and state.progress.current or 0
	local total = state.progress and state.progress.total or 1

	self.progressBar:updateProgress(current, total)
	self.progressBarLabel:setText(string.format("%d/%d", current, total))

	if state.resource then
		self.item:setItemID(state.resource.id)
		self.item:setItemCount(state.resource.count)
		self.itemNameLabel:setText(state.resource.name)
		self.itemDescriptionLabel:setText(state.resource.description)
	end

	self.titleLabel:setText(state.action and state.action.verb or "Crafting")
end

function CraftProgress:updateTitleScene()
	local gameView = self:getView():getGameView()

	local state = self:getState()

	local targetType
	local targetID
	if not state.target or state.target.type == "none" then
		targetType = "actor"
		targetID = gameView:getGame():getPlayer():getActor():getID()
	else
		targetType = state.target.type
		targetID = state.target.id
	end

	local target
	if targetType == "actor" then
		target = gameView:getActorByID(targetID)
	elseif targetType == "prop" then
		target = gameView:getPropByID(targetID)
	end

	if not target then
		target = gameView:getGame():getPlayer():getActor()
	end

	Theme.setSceneSnippet(self.sceneSnippet, self.camera, gameView, target)
end

function CraftProgress:update(delta)
	Interface.update(self, delta)

	self:updateTitleScene()
end

return CraftProgress
