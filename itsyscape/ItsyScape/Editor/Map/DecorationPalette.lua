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
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local StaticMesh = require "ItsyScape.Graphics.StaticMesh"
local Decoration = require "ItsyScape.Graphics.Decoration"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Button = require "ItsyScape.UI.Button"
local DraggablePanel = require "ItsyScape.UI.DraggablePanel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local Widget = require "ItsyScape.UI.Widget"

DecorationPalette = Class(Widget)
DecorationPalette.TILE_WIDTH = 96
DecorationPalette.TILE_HEIGHT = 96
DecorationPalette.PADDING = 8

function DecorationPalette:new(application)
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
	local tileWidth = DecorationPalette.TILE_WIDTH + DecorationPalette.PADDING * 2
	local width = math.max(tileWidth * 2, tileWidth)
	width = width + DecorationPalette.PADDING + ScrollablePanel.DEFAULT_SCROLL_SIZE
	self:setSize(width, windowHeight)
	self:setPosition(windowWidth - width, 0)

	local panel = DraggablePanel()
	panel:setSize(width, windowHeight)
	self:addChild(panel)

	local scrollablePanel = ScrollablePanel(GridLayout)
	scrollablePanel:setPosition(DecorationPalette.PADDING / 2, DecorationPalette.PADDING / 2)
	scrollablePanel:setSize(width - DecorationPalette.PADDING, windowHeight - DecorationPalette.PADDING)
	self:addChild(scrollablePanel)

	local gridLayout = scrollablePanel:getInnerPanel()
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

	local buttons = {}

	for group in self.staticMesh:iterate() do
		local button = Button()
		local sceneSnippet = SceneSnippet()
		button:setData('tile-group', group)

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

		button:addChild(sceneSnippet)

		table.insert(buttons, button)
	end

	table.sort(buttons, function(a, b)
		return a:getData('tile-group') < b:getData('tile-group')
	end)

	for i = 1, #buttons do
		gridLayout:addChild(buttons[i])
	end

	scrollablePanel:setSize(width, windowHeight)
	scrollablePanel:setScrollSize(width, math.floor(#buttons / 2 + 0.5) * DecorationPalette.TILE_HEIGHT + DecorationPalette.PADDING * 2)
end

function DecorationPalette:open(x, y, parent)
	local currentX, currentY = self:getPosition()
	self:setPosition(x or currentX, y or currentY)

	local root = parent or self.application:getUIView():getRoot()
	root:addChild(self)
end

function DecorationPalette:close()
	local p = self:getParent()
	if p then
		p:removeChild(self)
	end
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
