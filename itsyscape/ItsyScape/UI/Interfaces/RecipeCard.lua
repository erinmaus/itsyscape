--------------------------------------------------------------------------------
-- ItsyScape/UI/RecipeCard.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local Button = require "ItsyScape.UI.Button"
local Interface = require "ItsyScape.UI.Interface"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local Texture = require "ItsyScape.UI.Texture"
local ToolTip = require "ItsyScape.UI.ToolTip"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"

local RecipeCard = Class(Interface)
RecipeCard.WIDTH = 480
RecipeCard.HEIGHT = 480
RecipeCard.PADDING = 48
RecipeCard.BUTTON_SIZE    = 48
RecipeCard.BUTTON_PADDING = 8

function RecipeCard:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(RecipeCard.WIDTH, RecipeCard.HEIGHT)
	self:setPosition(
		(w - RecipeCard.WIDTH) / 2,
		(h - RecipeCard.HEIGHT) / 2)

	local state = self:getState()

	local window = Texture()
	window:setSize(RecipeCard.WIDTH, RecipeCard.HEIGHT)
	ui:getGameView():getResourceManager():queue(
		TextureResource,
		"Resources/Renderers/Widget/Textures/RecipeCard.png",
		function(texture)
			window:setTexture(texture)
		end)
	self:addChild(window)

	self.closeButton = Button()
	self.closeButton:setSize(RecipeCard.BUTTON_SIZE, RecipeCard.BUTTON_SIZE)
	self.closeButton:setPosition(
		RecipeCard.WIDTH - RecipeCard.BUTTON_SIZE - RecipeCard.BUTTON_PADDING,
		RecipeCard.BUTTON_PADDING)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	self.constraintsPanel = ScrollablePanel(GridLayout)
	self.constraintsPanel:setSize(
		RecipeCard.WIDTH - RecipeCard.PADDING * 2,
		RecipeCard.HEIGHT - RecipeCard.PADDING * 2 - RecipeCard.BUTTON_PADDING)
	self.constraintsPanel:setPosition(
		RecipeCard.PADDING,
		RecipeCard.PADDING + RecipeCard.BUTTON_PADDING)
	self.constraintsPanel:getInnerPanel():setSize(
		RecipeCard.WIDTH - RecipeCard.PADDING * 2 - ScrollablePanel.DEFAULT_SCROLL_SIZE,
		RecipeCard.HEIGHT - RecipeCard.PADDING * 2)
	self.constraintsPanel:getInnerPanel():setWrapContents(true)

	local state = self:getState()

	self.requirementsConstraints = ConstraintsPanel(ui, {
		headerFontSize = 22,
		headerColor = { 0, 0, 0, 1 },
		headerShadow = false,
		constraintFontSize = 18,
		constraintColor = { 0, 0, 0, 1 },
		constraintShadow = false
	})
	self.requirementsConstraints:setData("skillAsLevel", true)
	self.requirementsConstraints:setSize(
		RecipeCard.WIDTH - ScrollablePanel.DEFAULT_SCROLL_SIZE - RecipeCard.PADDING * 2,
		0)
	self.requirementsConstraints:setText(state.recipeName)
	self.requirementsConstraints:setConstraints(state.recipe)
	self.constraintsPanel:addChild(self.requirementsConstraints)

	self.constraintsPanel:setScrollSize(self.constraintsPanel:getInnerPanel():getSize())
	self:addChild(self.constraintsPanel)
end

return RecipeCard
