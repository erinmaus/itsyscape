--------------------------------------------------------------------------------
-- ItsyScape/Editor/EditorApplication.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local EditorApplication = require "ItsyScape.Editor.EditorApplication"
local NewMapInterface = require "ItsyScape.Editor.Map.NewMapInterface"
local LandscapeToolPanel = require "ItsyScape.Editor.Map.LandscapeToolPanel"
local TerrainToolPanel = require "ItsyScape.Editor.Map.TerrainToolPanel"
local TileSetPalette = require "ItsyScape.Editor.Map.TileSetPalette"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local MapGridMeshSceneNode = require "ItsyScape.Graphics.MapGridMeshSceneNode"
local FlattenMapMotion = require "ItsyScape.World.FlattenMapMotion"
local HillMapMotion = require "ItsyScape.World.HillMapMotion"
local MapMotion = require "ItsyScape.World.MapMotion"
local TileSet = require "ItsyScape.World.TileSet"

local MapEditorApplication = Class(EditorApplication)
MapEditorApplication.TOOL_NONE = 0
MapEditorApplication.TOOL_TERRAIN = 1
MapEditorApplication.TOOL_PAINT = 2

function MapEditorApplication:new()
	EditorApplication.new(self)

	self.motion = false
	self.landscapeToolPanel = LandscapeToolPanel(self)
	self.terrainToolPanel = TerrainToolPanel(self)
	self.tileSetPalette = TileSetPalette(self)

	self.windows = {
		self.landscapeToolPanel,
		self.terrainToolPanel,
		self.tileSetPalette
	}

	self.currentTool = MapEditorApplication.TOOL_NONE

	self.mapGridSceneNode = MapGridMeshSceneNode()
	self.mapGridSceneNode:getTransform():translate(Vector.UNIT_Y, 1 / 10)
	self.mapGridSceneNode:setParent(self:getGameView():getScene())
	self.mapGridSceneNode:setLineWidth(2)
	self.currentToolNode = false
	self.isDragging = false

	self:getGame():getStage().onMapModified:register(self.updateGrid, self)
	self:getGame():getStage().onLoadMap:register(self.updateTileSet, self)

	self.previousI = 0
	self.currentI = 0
	self.previousJ = 0
	self.currentJ = 0
end

function MapEditorApplication:setTool(tool)
	if tool == self.currentTool then
		return
	end

	for i = 1, #self.windows do
		self.windows[i]:close()
	end

	if tool == MapEditorApplication.TOOL_TERRAIN then
		self.currentTool = MapEditorApplication.TOOL_TERRAIN
		self.terrainToolPanel:open()
		self.terrainToolPanel:setToolSize(0)
	elseif tool == MapEditorApplication.TOOL_PAINT then
		self.currentTool = MapEditorApplication.TOOL_PAINT
		self.tileSetPalette:open()
		self.landscapeToolPanel:open()
		self.landscapeToolPanel:setToolSize(0)
	end
end

function MapEditorApplication:initialize()
	EditorApplication.initialize(self)

	local newMapInterface = NewMapInterface(self)
	self:getUIView():getRoot():addChild(newMapInterface)
	newMapInterface.onSubmit:register(function()
		self:setTool(MapEditorApplication.TOOL_PAINT)
	end)
end

function MapEditorApplication:updateGrid(stage, map, layer)
	if layer == 1 then
		self.mapGridSceneNode:fromMap(map, false)
	end
end

function MapEditorApplication:updateTileSet(stage, map, layer, tileSetID)
	local tileSetFilename = string.format(
		"Resources/Game/TileSets/%s/Layout.lua",
		tileSetID or "GrassyPlain")
	self.tileSet, self.tileSetTexture = TileSet.loadFromFile(tileSetFilename, true)

	self.tileSetPalette:refresh(self.tileSet, self.tileSetTexture)
end

function MapEditorApplication:paint()
	local i, j, width, height
	do
		local motion
		do
			local x, y = love.mouse.getPosition()
			motion = MapMotion(self:getGame():getStage():getMap(1))
			motion:onMousePressed(self:makeMotionEvent(x, y, 1))
		end

		local tile
		tile, i, j = motion:getTile()

		i = i - self.landscapeToolPanel:getToolSize()
		j = j - self.landscapeToolPanel:getToolSize()
		local s = self.landscapeToolPanel:getToolSize() * 2 + 1
		width, height = s, s
	end

	local map = self:getGame():getStage():getMap(1)
	local mode = self.landscapeToolPanel:getMode()

	if map then
		for t = 1, height do
			for s = 1, width do
				local u = i + s - 1
				local v = j + t - 1

				if u >= 1 and u <= map:getWidth() and
				   v >= 1 and v <= map:getHeight()
				then
					local tile = map:getTile(u, v)
					if mode == LandscapeToolPanel.MODE_FLAT then
						tile.flat = self.tileSetPalette:getCurrentTile() or tile.flat
					elseif mode == LandscapeToolPanel.MODE_EDGE then
						tile.edge = self.tileSetPalette:getCurrentTile() or tile.edge
					elseif mode == LandscapeToolPanel.MODE_DECAL then
						tile.decals[1] = self.tileSetPalette:getCurrentTile()
					end
				end
			end
		end
	end

	self:getGame():getStage():updateMap(1)
end

function MapEditorApplication:makeMotionEvent(x, y, button)
	return {
		x = x or 0,
		y = y or 0,
		button = button or 1,
		ray = self:shoot(x, y),
		forward = self:getCamera():getForward(),
		left = self:getCamera():getLeft(),
		zoom = self:getCamera():getDistance(),
		eye = self:getCamera():getEye()
	}
end

function MapEditorApplication:makeMotion(x, y, button)
	local map = self:getGame():getStage():getMap(1)
	local size = self.terrainToolPanel:getToolSize()
	if size == TerrainToolPanel.SIZE_HILL then
		self.motion = HillMapMotion(map)
	elseif size == TerrainToolPanel.SIZE_SINGLE then
		self.motion = MapMotion(map)
	else
		self.motion = FlattenMapMotion(size, map)
	end
end

function MapEditorApplication:mousePress(x, y, button)
	if not EditorApplication.mousePress(self, x, y, button) then
		if button == 1 then
			if self.currentTool == MapEditorApplication.TOOL_TERRAIN then
				self:makeMotion(x, y, button)
				self.motion:onMousePressed(self:makeMotionEvent(x, y, button))
			elseif self.currentTool == MapEditorApplication.TOOL_PAINT then
				self:paint()
				self.isDragging = true
			end
		end
	end
end

function MapEditorApplication:mouseMove(x, y, dx, dy)
	if not EditorApplication.mouseMove(self, x, y, dx, dy) then
		if self.motion then
			local r = self.motion:onMouseMoved(self:makeMotionEvent(x, y))

			if r then
				self:getGame():getStage():updateMap(1)
			end
		end

		do
			local motion = MapMotion(self:getGame():getStage():getMap(1))
			motion:onMousePressed(self:makeMotionEvent(x, y, 1))
			local _, i, j = motion:getTile()
			self.previousI = self.currentI
			self.previousJ = self.currentJ
			self.currentI = i
			self.currentJ = j
		end

		if self.currentTool == MapEditorApplication.TOOL_TERRAIN then
			if not self.currentToolNode then
				self.currentToolNode = MapGridMeshSceneNode()
				self.currentToolNode:getTransform():translate(Vector.UNIT_Y, 1 / 10)
				self.currentToolNode:setParent(self:getGameView():getScene())
				self.currentToolNode:setLineWidth(4)
			end

			local motion = MapMotion(self:getGame():getStage():getMap(1))
			motion:onMousePressed(self:makeMotionEvent(x, y, 1))

			local _, i, j = motion:getTile()
			self.currentToolNode:fromMap(
				self:getGame():getStage():getMap(1),
				motion,
				i, i, j, j)
		elseif self.currentTool == MapEditorApplication.TOOL_PAINT then
			if not self.currentToolNode then
				self.currentToolNode = MapGridMeshSceneNode()
				self.currentToolNode:getTransform():translate(Vector.UNIT_Y, 1 / 10)
				self.currentToolNode:setParent(self:getGameView():getScene())
				self.currentToolNode:setLineWidth(4)
			end

			local motion
			if not self.motion then
				motion = MapMotion(self:getGame():getStage():getMap(1))
				motion:onMousePressed(self:makeMotionEvent(x, y, 1))
			else
				motion = self.motion
			end

			local _, i, j = motion:getTile()

			self.currentToolNode:fromMap(
				self:getGame():getStage():getMap(1),
				false,
				i - self.landscapeToolPanel:getToolSize(),
				i + self.landscapeToolPanel:getToolSize(),
				j - self.landscapeToolPanel:getToolSize(),
				j + self.landscapeToolPanel:getToolSize())

			if self.isDragging and
			   (self.previousI ~= self.currentI or self.currentJ ~= self.previousJ)
			then
				self:paint()
			end
		elseif self.currentToolNode then
			self.currentToolNode:setParent(nil)
			self.currentToolNode = false
		end
	end
end

function MapEditorApplication:mouseRelease(x, y, button)
	if not EditorApplication.mouseRelease(self, x, y, button) then
		if button == 1 and self.motion then
			self.motion:onMouseReleased(self:makeMotionEvent(x, y, button))
			self.motion = false
		end

		self.isDragging = false
	end
end

function MapEditorApplication:keyDown(key, scan, isRepeat, ...)
	if not EditorApplication.keyDown(self, key, scan, isRepeat, ...) then
		if not isRepeat then
			if key == 'f1' then
				self:setTool(MapEditorApplication.TOOL_TERRAIN)
			elseif key == 'f2' then
				self:setTool(MapEditorApplication.TOOL_PAINT)
			end
		end
	end
end

return MapEditorApplication
