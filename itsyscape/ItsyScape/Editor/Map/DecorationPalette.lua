--------------------------------------------------------------------------------
-- ItsyScape/Editor/Map/DecorationPalette.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Vector = require "ItsyScape.Common.Math.Vector"
local PromptWindow = require "ItsyScape.Editor.Common.PromptWindow"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local StaticMesh = require "ItsyScape.Graphics.StaticMesh"
local Color = require "ItsyScape.Graphics.Color"
local Decoration = require "ItsyScape.Graphics.Decoration"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local DraggablePanel = require "ItsyScape.UI.DraggablePanel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"

DecorationPalette = Class(Widget)
DecorationPalette.TILE_WIDTH = 96
DecorationPalette.TILE_HEIGHT = 96
DecorationPalette.PADDING = 8

function DecorationPalette:new(application)
	Widget.new(self)

	self.application = application
	self.camera = ThirdPersonCamera()
	self.camera:setDistance(12)
	self.camera:setUp(Vector(0, -1, 0))

	local windowWidth, windowHeight = love.window.getMode()
	local tileWidth = DecorationPalette.TILE_WIDTH + DecorationPalette.PADDING * 2
	local width = math.max(tileWidth * 2, tileWidth)
	width = width + DecorationPalette.PADDING + ScrollablePanel.DEFAULT_SCROLL_SIZE
	self:setSize(width, windowHeight)
	self:setPosition(windowWidth - width, 0)

	local panel = DraggablePanel()
	panel:setSize(width, windowHeight)
	self:addChild(panel)

	self.buttonsPanel = ScrollablePanel(GridLayout)
	self.buttonsPanel:setPosition(DecorationPalette.PADDING / 2, DecorationPalette.PADDING / 2)
	self.buttonsPanel:setSize(width - DecorationPalette.PADDING, windowHeight - DecorationPalette.PADDING)
	self:addChild(self.buttonsPanel)

	self.currentGroup = false
	self.currentGroupButton = false
end

function DecorationPalette:loadDecorations()
	self.staticMesh = StaticMesh(string.format("Resources/Game/TileSets/%s/Layout.lstatic", self.application.currentDecorationTileSet))
	self.texture = TextureResource()
	do
		self.texture:loadFromFile(string.format("Resources/Game/TileSets/%s/Texture.png", self.application.currentDecorationTileSet))
	end

	local buttons = {}

	for group in self.staticMesh:iterate() do
		local button = Button()
		local sceneSnippet = SceneSnippet()
		button:setData('tile-group', group)

		button.onClick:register(self.select, self, group)

		local decoration = Decoration({ { id = group } })
		local sceneNode = DecorationSceneNode()
		sceneNode:fromDecoration(decoration, self.staticMesh)
		sceneNode:getMaterial():setTextures(self.texture)
		sceneNode:getTransform():setLocalTranslation(Vector(-0.5, 0, -0.5))
		sceneNode:setParent(sceneSnippet:getRoot())

		local light = AmbientLightSceneNode()
		light:setAmbience(1)
		light:setIsGlobal(true)
		light:setParent(sceneSnippet:getRoot())

		sceneSnippet:setSize(
			DecorationPalette.TILE_WIDTH - DecorationPalette.PADDING * 2,
			DecorationPalette.TILE_WIDTH - DecorationPalette.PADDING * 2)
		sceneSnippet:setPosition(
			DecorationPalette.PADDING,
			DecorationPalette.PADDING)
		sceneSnippet:setCamera(self.camera)
		sceneSnippet:setToolTip(ToolTip.Text(group))

		button:addChild(sceneSnippet)

		table.insert(buttons, button)
	end

	table.sort(buttons, function(a, b)
		return a:getData('tile-group') < b:getData('tile-group')
	end)

	local setColorButton = Button()
	setColorButton:setText("Set Color")
	setColorButton.onClick:register(self.setColor, self)

	table.insert(buttons, setColorButton)

	local gridLayout = self.buttonsPanel:getInnerPanel()
	gridLayout:setPosition(
		DecorationPalette.PADDING / 2,
		DecorationPalette.PADDING / 2)
	gridLayout:setPadding(
		DecorationPalette.PADDING,
		DecorationPalette.PADDING)
	gridLayout:setUniformSize(
		true,
		DecorationPalette.TILE_WIDTH,
		DecorationPalette.TILE_HEIGHT)
	gridLayout:setWrapContents(true)


	local oldButtons = {}
	for _, button in gridLayout:iterate() do
		table.insert(oldButtons, button)
	end

	for i = 1, #oldButtons do
		gridLayout:removeChild(oldButtons[i])
	end

	for i = 1, #buttons do
		gridLayout:addChild(buttons[i])
	end

	self.buttonsPanel:setSize(width, windowHeight)
	self.buttonsPanel:setScrollSize(gridLayout:getSize())
end

function DecorationPalette:open(x, y, parent)
	local currentX, currentY = self:getPosition()
	self:setPosition(x or currentX, y or currentY)

	local root = parent or self.application:getUIView():getRoot()
	root:addChild(self)

	self:loadDecorations()
end

function DecorationPalette:close()
	local p = self:getParent()
	if p then
		p:removeChild(self)
	end
end

function DecorationPalette:select(group, button)
	if self.currentGroup == group then
		button:setStyle(nil)
		self.currentGroup = false
	else
		if self.currentGroupButton then
			self.currentGroupButton:setStyle(false)
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
		self.currentGroup = group
		self.currentGroupButton = button
	end
end

function DecorationPalette:setColor()
	local prompt = PromptWindow(self.application)
	prompt.onSubmit:register(function(_, color)
		local red, green, blue = color:match("(%x%x)(%x%x)(%x%x)")

		if red and green and blue then
			red = tonumber(red, 16) / 255
			green = tonumber(green, 16) / 255
			blue = tonumber(blue, 16) / 255

			self.application.currentDecorationColor = Color(red, green, blue, 1)
		end
	end)
	prompt:open("Enter six-digit color hex code.", "Color")
end

function DecorationPalette:getCurrentGroup()
	return self.currentGroup
end

function DecorationPalette:update(...)
	Widget.update(self, ...)

	local gameCamera = self.application:getCamera()
	self.camera:setHorizontalRotation(gameCamera:getHorizontalRotation())
	self.camera:setVerticalRotation(gameCamera:getVerticalRotation())
	self.camera:setWidth(
		DecorationPalette.TILE_WIDTH - DecorationPalette.PADDING * 2)
	self.camera:setHeight(
		DecorationPalette.TILE_WIDTH - DecorationPalette.PADDING * 2)
end

return DecorationPalette
