--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/ArtisanInfoContentTab.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Config = require "ItsyScape.Game.Config"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local Theme = require "ItsyScape.UI.Interfaces.Theme"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"

local ArtisanInfoContentTab = Class(GamepadContentTab)

function ArtisanInfoContentTab:new(interface)
	GamepadContentTab.new(self, interface)

	self.layout = GridLayout()
	self.layout:setSize(self:getSize())
	self.layout:setPadding(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	self:addChild(self.layout)

	self.stationSnippet = SceneSnippet()
	self.stationSnippet:setSize(
		Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, GamepadContentTab.WIDTH),
		Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, GamepadContentTab.WIDTH))
	self.layout:addChild(self.stationSnippet)

	local parentNode = SceneNode()
	local ambientLight = AmbientLightSceneNode()
	ambientLight:setAmbience(1)
	ambientLight:setParent(parentNode)

	self.stationSnippet:setParentNode(parentNode)
	self.stationSnippet:setRoot(parentNode)

	self.camera = ThirdPersonCamera()
	self.stationSnippet:setCamera(self.camera)

	self.titleLabel = Label()
	self.titleLabel:setStyle(Theme.BUTTON_LABEL_STYLE, LabelStyle)
	self.titleLabel:setSize(
		Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, GamepadContentTab.WIDTH),
		Theme.DEFAULT_ICON_SIZE)
	self.layout:addChild(self.titleLabel)

	local constraintsGroup = Panel()
	constraintsGroup:setStyle(Theme.GROUP_PANEL_STYLE, PanelStyle)
	constraintsGroup:setSize(
		self.WIDTH,
		Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, GamepadContentTab.HEIGHT, Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, GamepadContentTab.WIDTH), Theme.DEFAULT_ICON_SIZE))
	self.layout:addChild(constraintsGroup)

	local constraintsGroupWidth, constraintsGroupHeight = constraintsGroup:getSize()

	self.constraintsPanel = ScrollablePanel(GridLayout)
	self.constraintsPanel:getInnerPanel():setWrapContents(true)
	self.constraintsPanel:getInnerPanel():setPadding(0, 0)
	self.constraintsPanel:setSize(
		Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, constraintsGroupWidth),
		Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, constraintsGroupHeight))
	self.constraintsPanel:setPosition(
		Theme.DEFAULT_OUTER_PADDING,
		Theme.DEFAULT_OUTER_PADDING)
	constraintsGroup:addChild(self.constraintsPanel)

	local constraintsConfig = {
		headerFontSize = 16,
		constraintFontSize = 16,
		artisanPropertiesAsTraits = true,
		padding = 0
	}

	self.traitsPanel = ConstraintsPanel(self:getUIView(), constraintsConfig)
	self.traitsPanel:setText("Traits")
	self.traitsPanel:setData("skillAsLevel", true)
	self.constraintsPanel:addChild(self.traitsPanel)
end

function ArtisanInfoContentTab:gamepadScroll(x, y)
	GamepadContentTab.gamepadScroll(self, x, y)
	self.constraintsPanel:mouseScroll(x, y)
end

function ArtisanInfoContentTab:_updateArtisanSnippet()
	local state = self:getState()

	local object
	if state.target and state.target.type == "actor" then
		object = self:getGameView():getActorByID(state.target.id)
	elseif state.target and state.target.type == "prop" then
		object = self:getGameView():getPropByID(state.target.id)
	end

	if not object then
		object = self:getGameView():getGame():getPlayer():getActor()
	end

	Theme.setSceneSnippet(self.stationSnippet, self.camera, self:getGameView(), object)
	self.titleLabel:setText(object:getName())
end

function ArtisanInfoContentTab:refresh(state)
	GamepadContentTab.refresh(self, state)

	self:_updateArtisanSnippet()

	self.traitsPanel:setConstraints(state.traits)

	local elementWidth = self.constraintsPanel:getSize()
	Theme.layoutScrollablePanelWithGridLayout(
		self.constraintsPanel,
		elementWidth,
		0)

	self.constraintsPanel:getInnerPanel():setScroll(0, 0)
end

function ArtisanInfoContentTab:update(...)
	GamepadContentTab.update(self, ...)

	self:_updateArtisanSnippet()
end

return ArtisanInfoContentTab
