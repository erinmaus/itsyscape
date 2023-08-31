--------------------------------------------------------------------------------
-- ItsyScape/Editor/Map/TileSetPalette.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local DraggablePanel = require "ItsyScape.UI.DraggablePanel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Label = require "ItsyScape.UI.Label"
local TextInput = require "ItsyScape.UI.TextInput"
local Texture = require "ItsyScape.UI.Texture"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local MapMeshMask = require "ItsyScape.World.MapMeshMask"

TileSetPalette = Class(Widget)
TileSetPalette.TILE_WIDTH = 64
TileSetPalette.TILE_HEIGHT = 64
TileSetPalette.PADDING = 8

function TileSetPalette:new(application)
	Widget.new(self)

	self.application = application

	local windowWidth, windowHeight = love.window.getMode()
	local tileWidth = TileSetPalette.TILE_WIDTH + TileSetPalette.PADDING * 2
	local width = math.max(math.floor(windowWidth / 3 / tileWidth) * tileWidth, tileWidth)
	width = width - TileSetPalette.PADDING * 2
	self:setSize(width, windowHeight)
	self:setPosition(windowWidth - width, 0)

	local panel = DraggablePanel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.gridLayout = GridLayout()
	self.gridLayout:setPadding(8, 8)
	self.gridLayout:setUniformSize(
		true,
		TileSetPalette.TILE_WIDTH,
		TileSetPalette.TILE_HEIGHT)
	self.gridLayout:setSize(self:getSize())
	self:addChild(self.gridLayout)

	self.buttons = {}
	self.currentButton = false

	self.currentTile = false
end

function TileSetPalette:refresh(tileSet, tileSetTexture, masks)
	for i = 1, #self.buttons do
		self.gridLayout:removeChild(self.buttons[i])
	end

	self.buttons = {}
	for index in tileSet:iterateTiles() do
		local button = Button()
		local texture = Texture()

		local l = tileSet:getTileProperty(index, 'textureLeft', nil)
		local r = tileSet:getTileProperty(index, 'textureRight', nil)
		local t = tileSet:getTileProperty(index, 'textureTop', nil)
		local b = tileSet:getTileProperty(index, 'textureBottom', nil)

		local red = tileSet:getTileProperty(index, 'colorRed', 255) / 255
		local green = tileSet:getTileProperty(index, 'colorGreen', 255) / 255
		local blue = tileSet:getTileProperty(index, 'colorBlue', 255) / 255

		texture:setTexture(tileSetTexture, l, r, t, b)
		texture:setKeepAspect(true)
		texture:setSize(
			TileSetPalette.TILE_WIDTH - TileSetPalette.PADDING * 2,
			TileSetPalette.TILE_HEIGHT - TileSetPalette.PADDING * 2)
		texture:setPosition(TileSetPalette.PADDING, TileSetPalette.PADDING)
		texture:setColor(Color(red, green, blue, 1))
		button:addChild(texture)

		button.onClick:register(self.setTile, self, index)

		button:setData('tile-index', index)
		button:setData('tile-texture', texture)
		button:setToolTip(ToolTip.Text(tileSet:getTileProperty(index, 'name', '(unnamed)')))
		table.insert(self.buttons, button)
	end

	local m = {}
	do
		if type(masks) ~= 'table' then
			masks = { masks }
		end

		for key, mask in pairs(m) do
			if mask == true then
				mask = MapMeshMask()
			else
				mask = require(string.format("ItsyScape.World.%sMapMesh", mask))()
			end

			if mask then
				table.insert(m, { texture = mask:getTexture(), key = key })
			end
		end
	end

	for i = 1, #m do
		for j = 1, MapMeshMask.MAX_TYPE_COMBINATIONS do
			local button = Button()
			local texture = Texture()

			local red = tileSet:getTileProperty(index, 'colorRed', 255) / 255
			local green = tileSet:getTileProperty(index, 'colorGreen', 255) / 255
			local blue = tileSet:getTileProperty(index, 'colorBlue', 255) / 255

			texture:setTexture(m[i]:getTexture():getResource(), 0, 1, 0, 1, j)
			texture:setKeepAspect(true)
			texture:setSize(
				TileSetPalette.TILE_WIDTH - TileSetPalette.PADDING * 2,
				TileSetPalette.TILE_HEIGHT - TileSetPalette.PADDING * 2)
			texture:setPosition(TileSetPalette.PADDING, TileSetPalette.PADDING)
			texture:setColor(Color(1, 0, 1, 1))
			button:addChild(texture)

			button.onClick:register(self.setTile, self, -1, m.key, j)

			button:setData('tile-index', 1000 + i * MapMeshMask.MAX_TYPE_COMBINATIONS + j)
			button:setData('mask-key', m.key)
			button:setData('mask-type', j)
			button:setToolTip(ToolTip.Text(m.key), ToolTip.Text(MapMeshMask.TYPE_NAMES[j] or "(unknown)"))
			table.insert(self.buttons, button)
		end
	end

	table.sort(self.buttons, function(a, b)
		return a:getData('tile-index') < b:getData('tile-index')
	end)

	for i = 1, #self.buttons do
		self.gridLayout:addChild(self.buttons[i])
	end
end

function TileSetPalette:setTile(value, key, type)
	if self.currentTile == value then
		value = false
	end

	if key and type then
		self.currentTile = nil
	else
		self.currentTile = value
	end

	self.currentMaskKey = key
	self.currentMaskType = type

	for i = 1, #self.buttons do
		local button = self.buttons[i]
		if button:getData('tile-index') == value or (button:getData("mask-key") == key and button:getData("mask-type") == type) then
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
		else
			button:setStyle(nil)
		end
	end
end

function TileSetPalette:getCurrentTile()
	if not self.currentTile then
		return nil
	else
		return self.currentTile, self.currentMaskKey, self.currentMaskType
	end
end

function TileSetPalette:open(x, y, parent)
	local currentX, currentY = self:getPosition()
	self:setPosition(x or currentX, y or currentY)

	local root = parent or self.application:getUIView():getRoot()
	root:addChild(self)
end

function TileSetPalette:close()
	local p = self:getParent()
	if p then
		p:removeChild(self)
	end
end

function TileSetPalette:update(...)
	Widget.update(self, ...)

	local rotation = self.application:getCamera():getVerticalRotation()
	for i = 1, #self.buttons do
		local texture = self.buttons[i]:getData('tile-texture')
		if texture then
			texture:setRotation(-rotation + math.pi / 2)
		end
	end
end

return TileSetPalette
