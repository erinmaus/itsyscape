--------------------------------------------------------------------------------
-- ItsyScape/Editor/Map/PropPalette.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Mapp = require "ItsyScape.GameDB.Mapp"
local LocalProp = require "ItsyScape.Game.LocalModel.Prop"
local Vector = require "ItsyScape.Common.Math.Vector"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local StaticMesh = require "ItsyScape.Graphics.StaticMesh"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Peep = require "ItsyScape.Peep.Peep"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local DraggablePanel = require "ItsyScape.UI.DraggablePanel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local TextInput = require "ItsyScape.UI.TextInput"
local Widget = require "ItsyScape.UI.Widget"

PropPalette = Class(Widget)
PropPalette.TILE_WIDTH = 96
PropPalette.TILE_HEIGHT = 96
PropPalette.PADDING = 8

function PropPalette:new(application)
	Widget.new(self)

	self.application = application
	self.staticMesh = StaticMesh("Resources/Game/TileSets/RumbridgeCastle/Layout.lstatic")
	self.texture = TextureResource()
	do
		self.texture:loadFromFile("Resources/Game/TileSets/RumbridgeCastle/Texture.png")
	end
	self.camera = ThirdPersonCamera()
	self.camera:setDistance(8)
	self.camera:setUp(Vector(0, -1, 0))

	local windowWidth, windowHeight = love.window.getMode()
	local tileWidth = PropPalette.TILE_WIDTH + PropPalette.PADDING * 2
	local width = math.max(tileWidth * 2, tileWidth)
	width = width + PropPalette.PADDING + ScrollablePanel.DEFAULT_SCROLL_SIZE
	self:setSize(width, windowHeight)
	self:setPosition(windowWidth - width, 0)

	local panel = DraggablePanel()
	panel:setSize(width, windowHeight)
	self:addChild(panel)

	local search = TextInput()
	search.onValueChanged:register(function(_, value)
		self:updateButtons(value)
	end)
	search:setSize(width - PropPalette.PADDING * 2, 32)
	search:setPosition(PropPalette.PADDING, PropPalette.PADDING)
	self:addChild(search)

	self.scrollablePanel = ScrollablePanel(GridLayout)
	self.scrollablePanel:setPosition(PropPalette.PADDING / 2, PropPalette.PADDING / 2 + 32)
	self.scrollablePanel:setSize(width - PropPalette.PADDING, windowHeight - PropPalette.PADDING * 2 - 32)
	self.scrollablePanel:getInnerPanel():setUniformSize(true, PropPalette.TILE_WIDTH, PropPalette.TILE_HEIGHT)
	self:addChild(self.scrollablePanel)

	self.scrollablePanel:setSize(width, windowHeight)

	self.currentProp = false
	self.currentPropButton = false

	self.props = {}
	do
		local gameDB = self.application:getGame():getGameDB()
		local brochure = gameDB:getBrochure()

		local resourceType = Mapp.ResourceType()
		if brochure:tryGetResourceType("Prop", resourceType) then
			for prop in brochure:findResourcesByType(resourceType) do
				local propViewName = string.format(
					"Resources.Game.Props.%s.View",
					prop.name)
				local s, r = pcall(require, propViewName)
				if not s then
					r = require "Resources.Game.Props.Null.View"
				end
				local PropViewType = r
				local p = LocalProp(self.application:getGame(), Peep)
				local propView = PropViewType(p, self.application:getGameView())
				propView:load()
				table.insert(self.props, {
					resource = prop,
					prop = p,
					view = propView
				})
			end
		end
	end

	self.buttons = {}
	self:updateButtons("")
end

function PropPalette:updateButtons(filter)
	do
		local f = ".*"
		for c = 1, #filter do
			local character = filter:sub(c, c)
			if character:match("[%w_]") then
				f = f .. character .. ".*"
			end
		end

		filter = f:lower()
	end

	for i = 1, #self.buttons do
		self.scrollablePanel:removeChild(self.buttons[i])
	end

	self.buttons = {}

	for i = 1, #self.props do
		local p = self.props[i]
		if p.resource.name:lower():match(filter) then
			local button = Button()
			local sceneSnippet = SceneSnippet()

			button:setData('prop-name', p.resource.name)

			button.onClick:register(self.select, self, p)

			p.view:getRoot():setParent(sceneSnippet:getRoot())

			local light = AmbientLightSceneNode()
			light:setAmbience(1)
			light:setIsGlobal(true)
			light:setParent(sceneSnippet:getRoot())

			sceneSnippet:setSize(
				PropPalette.TILE_WIDTH - PropPalette.PADDING * 2,
				PropPalette.TILE_WIDTH - PropPalette.PADDING * 2)
			sceneSnippet:setPosition(
				PropPalette.PADDING,
				PropPalette.PADDING)
			sceneSnippet:setCamera(self.camera)

			button:addChild(sceneSnippet)
			button:setToolTip(p.resource.name)

			table.insert(self.buttons, button)
		end
	end

	table.sort(self.buttons, function(a, b)
		return a:getData('prop-name') < b:getData('prop-name')
	end)

	for i = 1, #self.buttons do
		self.scrollablePanel:addChild(self.buttons[i])
	end

	self.scrollablePanel:setScrollSize(width, math.floor(#self.buttons / 2 + 0.5) * PropPalette.TILE_HEIGHT + PropPalette.PADDING * 2)
end

function PropPalette:open(x, y, parent)
	local currentX, currentY = self:getPosition()
	self:setPosition(x or currentX, y or currentY)

	local root = parent or self.application:getUIView():getRoot()
	root:addChild(self)
end

function PropPalette:close()
	local p = self:getParent()
	if p then
		p:removeChild(self)
	end
end

function PropPalette:select(p, button)
	if self.currentProp == p then
		button:setStyle(nil)
		self.currentProp = false
	else
		if self.currentPropButton then
			self.currentPropButton:setStyle(false)
		end

		button:setStyle(ButtonStyle({
			pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
			inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
			hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png",
			color = { 1, 1, 1, 1 },
			font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
			fontSize = 24,
			textShadow = true,
			padding = 4
		}, self.application:getUIView():getResources()))
		self.currentProp = p
		self.currentPropButton = button
	end
end

function PropPalette:getCurrentProp()
	if self.currentProp then
		return self.currentProp.resource
	end

	return false
end

function PropPalette:update(...)
	Widget.update(self, ...)

	local gameCamera = self.application:getCamera()
	self.camera:setHorizontalRotation(gameCamera:getHorizontalRotation())
	self.camera:setVerticalRotation(gameCamera:getVerticalRotation())
	self.camera:setWidth(
		PropPalette.TILE_WIDTH - PropPalette.PADDING * 2)
	self.camera:setHeight(
		PropPalette.TILE_WIDTH - PropPalette.PADDING * 2)
end

return PropPalette
