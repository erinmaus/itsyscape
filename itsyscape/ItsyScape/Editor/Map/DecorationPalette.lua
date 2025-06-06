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
local LayerTextureResource = require "ItsyScape.Graphics.LayerTextureResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local DraggablePanel = require "ItsyScape.UI.DraggablePanel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local TextInput = require "ItsyScape.UI.TextInput"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"

DecorationPalette = Class(Widget)
DecorationPalette.TILE_WIDTH = 96
DecorationPalette.TILE_HEIGHT = 96
DecorationPalette.PADDING = 8
DecorationPalette.INPUT_HEIGHT = 48

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

	self.searchInput = TextInput()
	self.searchInput.onValueChanged:register(function(_, value)
		self:search(value)
	end)
	self.searchInput.onSubmit:register(function()
		self.searchInput:blur()
	end)
	self.searchInput:setSize(width - DecorationPalette.PADDING * 2, DecorationPalette.INPUT_HEIGHT)
	self.searchInput:setPosition(DecorationPalette.PADDING, DecorationPalette.PADDING)
	self:addChild(self.searchInput)

	self.buttonsPanel = ScrollablePanel(GridLayout)
	self.buttonsPanel:setPosition(DecorationPalette.PADDING / 2, DecorationPalette.PADDING / 2 + DecorationPalette.PADDING + DecorationPalette.INPUT_HEIGHT)
	self.buttonsPanel:setSize(width - DecorationPalette.PADDING, windowHeight - DecorationPalette.PADDING - DecorationPalette.INPUT_HEIGHT - DecorationPalette.PADDING * 2)
	self:addChild(self.buttonsPanel)

	self.currentGroup = false
	self.currentGroupButton = false
end

function DecorationPalette:search(term)
	local terms = {}
	for match in string.gmatch(term:lower(), "([^%s]+)") do
		table.insert(terms, match)
	end

	do
		local gridLayout = self.buttonsPanel:getInnerPanel()

		local oldButtons = {}
		for _, button in gridLayout:iterate() do
			table.insert(oldButtons, button)
		end

		for i = 1, #oldButtons do
			gridLayout:removeChild(oldButtons[i])
		end
	end

	for _, button in ipairs(self.buttons) do
		local group = button:getData('tile-group')

		local isMatch
		if group and #terms >= 1 then
			isMatch = true
			for _, term in ipairs(terms) do
				if not group:lower():find(term, 1, true) then
					isMatch = false
					break
				end
			end
		else
			isMatch = true
		end

		if isMatch then
			self.buttonsPanel:addChild(button)
		end
	end

	self.buttonsPanel:setScrollSize(self.buttonsPanel:getInnerPanel():getSize())
	self.buttonsPanel:setScroll(0, 0)
end

function DecorationPalette:loadDecorations()
	self.searchInput:setText("")

	self.staticMesh = StaticMesh(string.format("Resources/Game/TileSets/%s/Layout.lstatic", self.application.currentDecorationTileSet))

	local textureFilename = string.format(
		"Resources/Game/TileSets/%s/Texture.png",
		self.application.currentDecorationTileSet)
	local layerTextureFilename = string.format(
		"Resources/Game/TileSets/%s/Texture.lua",
		self.application.currentDecorationTileSet)

	if love.filesystem.getInfo(layerTextureFilename) then
		self.texture = LayerTextureResource()
		self.texture:loadFromFile(layerTextureFilename)
	else
		self.texture = TextureResource()
		self.texture:loadFromFile(textureFilename)
	end

	local oldButtons = self.buttons or {}
	self.buttons = {}

	for group in self.staticMesh:iterate() do
		local button = Button()
		local sceneSnippet = SceneSnippet()
		button:setData('tile-group', group)

		button.onClick:register(self.select, self, group)

		local decoration = Decoration({ { id = group } })
		local sceneNode = DecorationSceneNode()
		sceneNode:fromDecoration(decoration, self.staticMesh)
		sceneNode:getMaterial():setTextures(self.texture)
		sceneNode:getMaterial():setIsCullDisabled(true)
		sceneNode:getTransform():setLocalTranslation(Vector(-0.5, 0, -0.5))
		sceneNode:setParent(sceneSnippet:getRoot())

		local shader = ShaderResource()
		if Class.isCompatibleType(self.texture, LayerTextureResource) then
			shader:loadFromFile("Resources/Shaders/MultiTextureDecoration")
		else
			shader:loadFromFile("Resources/Shaders/Decoration")
		end
		sceneNode:getMaterial():setShader(shader)

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

		table.insert(self.buttons, button)
	end

	table.sort(self.buttons, function(a, b)
		return a:getData('tile-group') < b:getData('tile-group')
	end)

	local setColorButton = Button()
	setColorButton:setText("Set Color")
	setColorButton.onClick:register(self.setColor, self)

	table.insert(self.buttons, setColorButton)

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

	for i = 1, #oldButtons do
		gridLayout:removeChild(oldButtons[i])
	end

	for i = 1, #self.buttons do
		gridLayout:addChild(self.buttons[i])
	end

	self.buttonsPanel:setSize(width, windowHeight)
	self.buttonsPanel:setScrollSize(gridLayout:getSize())
	self.buttonsPanel:setScroll(0, 0)
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

function DecorationPalette:_select(group, button, texture)
	if self.currentGroup == group and self.currenTexture == texture then
		button:setStyle(nil)
		self.currentGroup = false
		self.currentTexture = nil
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
		self.currentTexture = texture
	end
end

function DecorationPalette:select(group, button, mouseButton)
	if mouseButton == 1 then
		self:_select(group, button, 1)
	elseif mouseButton == 2 and Class.isCompatibleType(self.texture, LayerTextureResource) then
		local actions = {}
		for i = 1, self.texture:getLayerCount() do
			table.insert(actions, {
				id = i,
				verb = "Select-Texture",
				object = tostring(i),
				callback = function()
					self:_select(group, button, i)
				end
			})
		end

		self.application:getUIView():probe(actions)
	end
end

function DecorationPalette:setColor()
	local prompt = PromptWindow(self.application)
	prompt.onSubmit:register(function(_, color)
		self.application.currentDecorationColor = Color.fromHexString(color) or self.application.currentDecorationColor
	end)
	prompt:open("Enter six-digit color hex code.", "Color")
end

function DecorationPalette:getCurrentGroup()
	return self.currentGroup
end

function DecorationPalette:getCurrentTexture()
	return self.currentTexture
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
