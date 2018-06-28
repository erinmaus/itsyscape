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
local Button = require "ItsyScape.UI.Button"
local DraggablePanel = require "ItsyScape.UI.DraggablePanel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Label = require "ItsyScape.UI.Label"
local TextInput = require "ItsyScape.UI.TextInput"
local Texture = require "ItsyScape.UI.Texture"
local Widget = require "ItsyScape.UI.Widget"

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
end

function TileSetPalette:refresh(tileSet, tileSetTexture)
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

		texture:setTexture(tileSetTexture, l, r, t, b)
		texture:setKeepAspect(true)
		texture:setSize(
			TileSetPalette.TILE_WIDTH - TileSetPalette.PADDING * 2,
			TileSetPalette.TILE_HEIGHT - TileSetPalette.PADDING * 2)
		texture:setPosition(TileSetPalette.PADDING, TileSetPalette.PADDING)
		button:addChild(texture)

		button:setData('tile-index', index)
		table.insert(self.buttons, button)
	end

	table.sort(self.buttons, function(a, b)
		return a:getData('tile-index') < b:getData('tile-index')
	end)

	for i = 1, #self.buttons do
		self.gridLayout:addChild(self.buttons[i])
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

return TileSetPalette
