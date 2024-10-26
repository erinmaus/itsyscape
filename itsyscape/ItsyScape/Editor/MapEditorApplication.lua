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
local StringBuilder = require "ItsyScape.Common.StringBuilder"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local GameDB = require "ItsyScape.GameDB.GameDB"
local Utility = require "ItsyScape.Game.Utility"
local Prop = require "ItsyScape.Game.Model.Prop"
local EditorApplication = require "ItsyScape.Editor.EditorApplication"
local AlertWindow = require "ItsyScape.Editor.Common.AlertWindow"
local ColorPalette = require "ItsyScape.Editor.Common.ColorPalette"
local ConfirmWindow = require "ItsyScape.Editor.Common.ConfirmWindow"
local PromptWindow = require "ItsyScape.Editor.Common.PromptWindow"
local BrushToolPanel = require "ItsyScape.Editor.Map.BrushToolPanel"
local DecorationList = require "ItsyScape.Editor.Map.DecorationList"
local DecorationPalette = require "ItsyScape.Editor.Map.DecorationPalette"
local Gizmo = require "ItsyScape.Editor.Map.Gizmo"
local LandscapeToolPanel = require "ItsyScape.Editor.Map.LandscapeToolPanel"
local PropPalette = require "ItsyScape.Editor.Map.PropPalette"
local MapTransformInterface = require "ItsyScape.Editor.Map.MapTransformInterface"
local NewMapInterface = require "ItsyScape.Editor.Map.NewMapInterface"
local TerrainToolPanel = require "ItsyScape.Editor.Map.TerrainToolPanel"
local TileSetPalette = require "ItsyScape.Editor.Map.TileSetPalette"
local Decoration = require "ItsyScape.Graphics.Decoration"
local MapGridMeshSceneNode = require "ItsyScape.Graphics.MapGridMeshSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local Color = require "ItsyScape.Graphics.Color"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local Spline = require "ItsyScape.Graphics.Spline"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local FlattenMapMotion = require "ItsyScape.World.FlattenMapMotion"
local HillMapMotion = require "ItsyScape.World.HillMapMotion"
local Map = require "ItsyScape.World.Map"
local MapCurve = require "ItsyScape.World.MapCurve"
local MapMeshMask = require "ItsyScape.World.MapMeshMask"
local MapMotion = require "ItsyScape.World.MapMotion"
local Tile = require "ItsyScape.World.Tile"
local TileSet = require "ItsyScape.World.TileSet"
local OriginBehavior = require "ItsyScape.Peep.Behaviors.OriginBehavior"
local MapPeep = require "ItsyScape.Peep.Peeps.Map"

local MapEditorApplication = Class(EditorApplication)
MapEditorApplication.TOOL_NONE = 0
MapEditorApplication.TOOL_TERRAIN = 1
MapEditorApplication.TOOL_PAINT = 2
MapEditorApplication.TOOL_DECORATE = 3
MapEditorApplication.TOOL_PROP = 4
MapEditorApplication.TOOL_CURVE = 5
MapEditorApplication.TOOL_BRUSH = 6

function MapEditorApplication:new()
	-- ew
	do
		local GameView = require "ItsyScape.Graphics.GameView"
		GameView.MAP_MESH_DIVISIONS = 1024
	end

	_DEBUG = false

	EditorApplication.new(self)

	self.currentDecorationTileSet = "RumbridgeCabin"
	self.currentDecorationColor = Color()

	self.motion = false
	self.decorationList = DecorationList(self)
	self.decorationPalette = DecorationPalette(self)
	self.landscapeToolPanel = LandscapeToolPanel(self)
	self.terrainToolPanel = TerrainToolPanel(self)
	self.tileSetPalette = TileSetPalette(self)
	self.propPalette = PropPalette(self)
	self.brushToolPanel = BrushToolPanel(self)

	self.decorationList.onSelect:register(self.onSelectDecorationGroup, self)

	self.windows = {
		self.decorationList,
		self.decorationPalette,
		self.landscapeToolPanel,
		self.terrainToolPanel,
		self.tileSetPalette,
		self.propPalette,
		self.brushToolPanel
	}

	self.flagIcons = {
		{
			name = "impassable",
			icon = love.graphics.newImage("Resources/Game/UI/Icons/Editor/Impassable.png")
		},
		{
			name = "building",
			icon = love.graphics.newImage("Resources/Game/UI/Icons/Editor/Building.png")
		}
	}

	self.currentTool = MapEditorApplication.TOOL_NONE

	self.mapGridSceneNodes = {}
	self.currentToolNode = false
	self.isDragging = false

	self:getGame():getStage().onMapModified:register(self.updateGrid, self)
	self:getGame():getStage().onLoadMap:register(self.updateTileSet, self)

	self.previousI = 0
	self.currentI = 0
	self.previousJ = 0
	self.currentJ = 0
	self.previousLayer = 1
	self.currentLayer = 1

	self.currentFeatureIndex = false
	self.lastProp = false
	self.filename = false
	self.currentOtherLayer = 1000

	self.mapScriptPeeps = {}
	self.mapScriptLayers = {}

	self.propNames = {}

	self:getGameView():getRenderer():setClearColor(self:getGameView():getRenderer():getClearColor() * 0.7)

	self:getGameView():getResourceManager():setFrameDuration(1)
end

function MapEditorApplication:beginEditCurve(map, curve, layer)
	if curve then
		map = map == nil and self:getGame():getStage():getMap(layer or 1) or map

		self.curve = MapCurve(map, curve)
		self.curveMap = map
		self.curveLayer = layer
	end

	self.isEditingCurve = true

	local point = self.curve:getPositions():get(1)
	self:createTranslationGizmo(point)
end

function MapEditorApplication:endEditCurve()
	self.isEditingCurve = false
end

function MapEditorApplication:createCurveValueGizmo(Type, index)
	if Type == MapCurve.Position then
		self:createTranslationGizmo(self.curve:getPositions():get(index))
	elseif Type == MapCurve.Rotation then
		self:createRotationGizmo(self.curve:getRotations():get(index))
	elseif Type == MapCurve.Normal then
		self:createRotationGizmo(self.curve:getNormals():get(index))
	elseif Type == MapCurve.Scale then
		self:createScaleGizmo(self.curve:getScales():get(index))
	else
		self:unsetGizmo()
	end
end

function MapEditorApplication:createGizmo(target)
	if self.gizmoOperation == Gizmo.OPERATION_TRANSLATION then
		self:createTranslationGizmo(target)
	elseif self.gizmoOperation == Gizmo.OPERATION_ROTATION then
		self:createRotationGizmo(target)
	elseif self.gizmoOperation == Gizmo.OPERATION_SCALE then
		self:createScaleGizmo(target)
	elseif self.gizmoOperation == Gizmo.OPERATION_BOUNDS then
		self:createBoundsGizmo(target)
	else
		self:createTranslationGizmo(target)
	end
end

function MapEditorApplication:createTranslationGizmo(target)
	self.gizmo = Gizmo(
		target,
		Gizmo.TranslationAxisOperation(Vector.UNIT_X),
		Gizmo.TranslationAxisOperation(Vector.UNIT_Y),
		Gizmo.TranslationAxisOperation(Vector.UNIT_Z),
		Gizmo.TranslationAxisOperation(Vector(1, 0, 1)))
	self.gizmoOperation = Gizmo.OPERATION_TRANSLATION
	self.isGizmoGrabbed = false
end

function MapEditorApplication:createRotationGizmo(target)
	self.gizmo = Gizmo(
		target,
		Gizmo.RotationAxisOperation(Vector.UNIT_X),
		Gizmo.RotationAxisOperation(Vector.UNIT_Y),
		Gizmo.RotationAxisOperation(Vector.UNIT_Z))
	self.gizmoOperation = Gizmo.OPERATION_ROTATION
	self.isGizmoGrabbed = false
end

function MapEditorApplication:createScaleGizmo(target)
	self.gizmo = Gizmo(
		target,
		Gizmo.ScaleAxisOperation(Vector.UNIT_X),
		Gizmo.ScaleAxisOperation(Vector.UNIT_Y),
		Gizmo.ScaleAxisOperation(Vector.UNIT_Z),
		Gizmo.ScaleAxisOperation(Vector.ONE))
	self.gizmoOperation = Gizmo.OPERATION_SCALE
	self.isGizmoGrabbed = false
end

function MapEditorApplication:createBoundsGizmo(target)
	self.gizmo = Gizmo(
		target,
		Gizmo.BoundingBoxOperation())
	self.gizmo:setHoverDistance(-math.huge)
	self.gizmoOperation = Gizmo.OPERATION_BOUNDS
	self.isGizmoGrabbed = false
end

function MapEditorApplication:unsetGizmo()
	self.gizmo = false
	self.gizmoOperation = nil
	self.isGizmoGrabbed = false
end

function MapEditorApplication:setTool(tool)
	if tool == self.currentTool then
		return
	end

	for i = 1, #self.windows do
		self.windows[i]:close()
	end

	self:unsetGizmo()
	self:endEditCurve()

	if self.currentPalette then
		self.currentPalette:close()
	end

	self:getGameView():bendMap(1)

	if tool == MapEditorApplication.TOOL_TERRAIN then
		self.currentTool = MapEditorApplication.TOOL_TERRAIN
		self.terrainToolPanel:open()
		self.terrainToolPanel:setToolSize(0)
	elseif tool == MapEditorApplication.TOOL_PAINT then
		self.currentTool = MapEditorApplication.TOOL_PAINT
		self.tileSetPalette:open()
		self.landscapeToolPanel:open(nil, nil, nil, self.tileSetPalette)
		self.landscapeToolPanel:setToolSize(0)
	elseif tool == MapEditorApplication.TOOL_DECORATE then
		self.currentFeatureIndex = false
		self.currentTool = MapEditorApplication.TOOL_DECORATE
		self.decorationList:open()
		self.decorationPalette:open()
	elseif tool == MapEditorApplication.TOOL_PROP then
		self.currentTool = MapEditorApplication.TOOL_PROP
		self.propPalette:open()
	elseif tool == MapEditorApplication.TOOL_CURVE then
		self.currentTool = MapEditorApplication.TOOL_CURVE

		-- mobius strip
		-- self.curveRotations = {
		-- 	{ Quaternion.fromAxisAngle(Vector.UNIT_Z, 0):get() },
		-- 	{ Quaternion.fromAxisAngle(Vector.UNIT_Z, math.pi * 2):get() },
		-- 	{ Quaternion.fromAxisAngle(Vector.UNIT_Z, math.pi):get() },
		-- }

		-- local center = Vector(map:getWidth() * map:getCellSize() / 2, 0, map:getHeight() * map:getCellSize() / 2)
		-- local P = 8
		-- for i = 1, P do
		-- 	local t = (i - 1) / (P - 1)
		-- 	local p = Quaternion.fromAxisAngle(Vector.UNIT_X, t * math.pi * 2):transformVector(Vector(0, 0, 32))
		-- 	table.insert(self.curvePoints, { (p + center):get() })
		-- 	table.insert(self.curveNormals, { (-p):getNormal():get() })
		-- end
	elseif tool == MapEditorApplication.TOOL_BRUSH then
		self.currentTool = MapEditorApplication.TOOL_BRUSH
		self.brushToolPanel:open()
	end

	self:updateCurve()
end

function MapEditorApplication:initialize()
	EditorApplication.initialize(self)

	self:getGame():getStage():newMap(1, 1, "Draft", nil, 1)

	local newMapInterface = NewMapInterface(self)
	self:getUIView():getRoot():addChild(newMapInterface)
	newMapInterface.onSubmit:register(function()
		self:setTool(MapEditorApplication.TOOL_PAINT)
	end)
end

function MapEditorApplication:decorationFeatureToSceneNode(feature)
	local sceneNode = SceneNode()
	local transform = sceneNode:getTransform()
	transform:setLocalTranslation(feature:getPosition())
	transform:setLocalScale(feature:getScale())
	transform:setLocalRotation(feature:getRotation())

	return sceneNode
end

function MapEditorApplication:curveToSceneNode(target)
	local sceneNode = SceneNode()

	if Class.isCompatibleType(target, MapCurve.Position) then
		sceneNode:getTransform():setLocalTranslation(target:getValue())
	elseif Class.isCompatibleType(target, MapCurve.Normal) then
		sceneNode:getTransform():setLocalTranslation(self.curve:getPositions():get(target:getIndex() or 1):getValue())

		local normal = target:getValue()
		local rotation = Quaternion.lookAt(Vector.ZERO, normal, Vector.UNIT_Y)
		sceneNode:getTransform():setLocalRotation(rotation)
	elseif Class.isCompatibleType(target, MapCurve.Rotation) then
		local t = ((target:getIndex() or 1) - 1) / (self.curve:getRotations():length() - 1)
		sceneNode:getTransform():setLocalTranslation(self.curve:evaluatePosition(t) + self.curve:evaluateNormal(t) * 4)
		sceneNode:getTransform():setLocalRotation(target:getValue())
	elseif Class.isCompatibleType(target, MapCurve.Scale) then
		sceneNode:getTransform():setLocalTranslation(self.curve:getPositions():get(target:getIndex() or 1):getValue())
		sceneNode:getTransform():setLocalScale(target:getValue())
	end

	return sceneNode
end

function MapEditorApplication:getLastDecorationFeature()
	local _, decoration = self.decorationList:getCurrentDecoration()
	if decoration and self.currentFeatureIndex then
		return decoration:getFeatureByIndex(self.currentFeatureIndex)
	end

	return nil
end

function MapEditorApplication:updateCurve()
	if self.currentTool == MapEditorApplication.TOOL_CURVE then
		if self.curve and self.curve:getPositions():length() >= 2 then
			self:getGameView():bendMap(self.curveLayer, self.curve:toConfig())
		else
			self:getGameView():bendMap(self.curveLayer)
		end
	elseif self.currentTool == MapEditorApplication.TOOL_DECORATE then
		local group, decoration = self.decorationList:getCurrentDecoration()
		local feature = self:getLastDecorationFeature()
		if feature then
			feature:setCurve(self.curve)

			if decoration and Class.isCompatibleType(decoration, Spline) then
				self:getGame():getStage():decorate(group, decoration)
			end
		end
	end
end

function MapEditorApplication:updateGrid(stage, map, layer)
	local mapGridSceneNode = self.mapGridSceneNodes[layer]
	if not mapGridSceneNode then
		local hasLayer = false

		for _, k in ipairs(self.mapScriptLayers) do
			if k == layer then
				hasLayer = true
				break
			end
		end

		if hasLayer then
			mapGridSceneNode = MapGridMeshSceneNode()
			mapGridSceneNode:getTransform():translate(Vector.UNIT_Y, 1 / 10)
			mapGridSceneNode:setParent(self:getGameView():getMapSceneNode(layer))
			mapGridSceneNode:setLineWidth(2)

			self.mapGridSceneNodes[layer] = mapGridSceneNode
		end
	end

	if mapGridSceneNode then
		mapGridSceneNode:fromMap(map, false)
	end
end

function MapEditorApplication:onSelectDecorationGroup(_, _, decoration)
	self.currentDecorationTileSet = decoration:getTileSetID()
	self.decorationPalette:loadDecorations()
end

function MapEditorApplication:updateTileSet(stage, map, layer, tileSetID, masks)
	local tileSetFilename = string.format(
		"Resources/Game/TileSets/%s/Layout.lua",
		tileSetID or "GrassyPlain")
	self.tileSet, self.tileSetTexture = TileSet.loadFromFile(tileSetFilename, true)

	self.tileSetPalette:refresh(self.tileSet, self.tileSetTexture, masks)
end

function MapEditorApplication:recursivePaint(map, i, j, e)
	if i < 0 or j < 0 or i > map:getWidth() or j > map:getHeight() then
		return
	end

	e = e or {}
	local index = j * map:getWidth() + i
	if not e[index] then
		e[index] = true

		local tile = map:getTile(i, j)
		local mode = self.landscapeToolPanel:getMode()
		if mode == LandscapeToolPanel.MODE_FLAT then
			tile.flat = self.tileSetPalette:getCurrentTile() or tile.flat
		elseif mode == LandscapeToolPanel.MODE_EDGE then
			tile.edge = self.tileSetPalette:getCurrentTile() or tile.edge
		elseif mode == LandscapeToolPanel.MODE_DECAL then
			tile.decals[1] = self.tileSetPalette:getCurrentTile()
		end

		if map:canMove(i, j, -1, 0) then
			self:recursivePaint(map, i - 1, j, e)
		end

		if map:canMove(i, j, 1, 0) then
			self:recursivePaint(map, i + 1, j, e)
		end

		if map:canMove(i, j, 0, -1) then
			self:recursivePaint(map, i, j - 1, e)
		end

		if map:canMove(i, j, 0, 1) then
			self:recursivePaint(map, i, j + 1, e)
		end
	end
end

function MapEditorApplication:_doPaint(i, j)
	local width, height, radius
	do
		local s = self.landscapeToolPanel:getToolSize()
		if self.landscapeToolPanel:getPaintMode() == LandscapeToolPanel.PAINT_MODE_CIRCLE then
			s = s + 1
		end

		if s >= 0 then
			i = i - s
			j = j - s
			s = s * 2 + 1
			width, height = s, s
		end

		radius = math.ceil(s / 2 - 1)
	end

	local map = self:getGame():getStage():getMap(self.currentLayer)
	local mode = self.landscapeToolPanel:getMode()

	if map then
		if width and height then
			for t = 1, height do
				for s = 1, width do
					local u = i + s - 1
					local v = j + t - 1
					local r = math.sqrt(math.ceil((s - (width / 2)) ^ 2 + (t - (height / 2)) ^ 2))

					if u >= 1 and u <= map:getWidth() and
					   v >= 1 and v <= map:getHeight() and
					   (self.landscapeToolPanel:getPaintMode() == LandscapeToolPanel.PAINT_MODE_RECTANGLE or r <= radius + 0.5)
					then
						local tile = map:getTile(u, v)
						if mode == LandscapeToolPanel.MODE_FLAT then
							local flat, maskID, maskType = self.tileSetPalette:getCurrentTile()
							if maskID and maskType then
								if flat then
									if maskType == MapMeshMask.TYPE_UNMASKED then
										tile.mask = {}
									elseif tile.mask[maskType] == flat then
										tile.mask[maskType] = nil
									else
										tile.mask[maskType] = flat
									end
								end

								if next(tile.mask, nil) then
									tile:setData("mask-key", maskID)
								else
									tile:unsetData("mask-key")
								end
							else
								tile.flat = flat or tile.flat
							end
						elseif mode == LandscapeToolPanel.MODE_EDGE then
							tile.edge = self.tileSetPalette:getCurrentTile() or tile.edge
						elseif mode == LandscapeToolPanel.MODE_DECAL then
							if love.keyboard.isDown('lalt') or
							   love.keyboard.isDown('ralt')
							then
								tile.decals[#tile.decals + 1] = self.tileSetPalette:getCurrentTile() or nil
							else
								tile.decals = {
									self.tileSetPalette:getCurrentTile() or nil
								}
							end
						end
					end
				end
			end
		else
			self:recursivePaint(map, i, j)
		end
	end
end

function MapEditorApplication:paint()
	local i1, j1 = self.previousPaintI or self.previousI, self.previousPaintJ or self.previousJ
	local i2, j2 = self.currentPaintI or self.currentI, self.currentPaintJ or self.currentJ

	local dx = math.abs(i2 - i1)
	local dy = -math.abs(j2 - j1)
	local sx = i1 < i2 and 1 or -1
	local sy = j1 < j2 and 1 or -1
	local error = dx + dy

	local x, y = i1, j1

	self:_doPaint(x, y)
	while not (x == i2 and y == j2) do

		local e2 = 2 * error
		if e2 >= dy then
			error = error + dy
			x = x + sx
		end

		if e2 <= dx then
			error = error + dx
			y = y + sy
		end

		self:_doPaint(x, y)
	end

	self:getGame():getStage():updateMap(self.currentLayer)
end

function MapEditorApplication:makeMotionEvent(x, y, button, layer)
	layer = layer or self.motionLayer or self.currentLayer

	local ray = self:shoot(x, y)
	local mapSceneNode = self:getGameView():getMapSceneNode(self.motionLayer)
	if mapSceneNode then
		local transform = mapSceneNode:getTransform():getGlobalTransform()
		
		local origin1 = Vector(transform:inverseTransformPoint(ray.origin:get()))
		local origin2 = Vector(transform:inverseTransformPoint((ray.origin + ray.direction):get()))
		local direction = origin2 - origin1
		ray = Ray(origin1, direction)
	end

	return {
		x = x or 0,
		y = y or 0,
		button = button or 1,
		ray = ray,
		forward = self:getCamera():getForward(),
		left = self:getCamera():getLeft(),
		zoom = self:getCamera():getDistance(),
		eye = self:getCamera():getEye()
	}
end

function MapEditorApplication:makeMotion(x, y, button)
	local map = self:getGame():getStage():getMap(self.motionLayer)
	local size = self.terrainToolPanel:getToolSize()
	if size == TerrainToolPanel.SIZE_HILL then
		self.motion = HillMapMotion(map)
	elseif size == TerrainToolPanel.SIZE_SINGLE then
		self.motion = MapMotion(map)
	else
		self.motion = FlattenMapMotion(size, map)
	end
end

function MapEditorApplication:makeCurrentToolNode()
	if not self.currentToolNode then
		self.currentToolNode = MapGridMeshSceneNode()
		self.currentToolNode:getTransform():translate(Vector.UNIT_Y, 1 / 10)
		self.currentToolNode:setParent(self:getGameView():getScene())
		self.currentToolNode:setLineWidth(4)
	end
end

function MapEditorApplication:mousePress(x, y, button)
	if not EditorApplication.mousePress(self, x, y, button) then
		if button == 1 then
			if self.gizmo then
				local target = self.gizmo:getTarget()

				local sceneNode
				if Class.isCompatibleType(target, Prop) then
					local p = self:getGameView():getProp(target)
					if p then
						local min, max = target:getBounds()
						sceneNode = p:getRoot()
					end
				elseif Class.isCompatibleType(target, Decoration.Feature) then
					sceneNode = self:decorationFeatureToSceneNode(target)
				elseif Class.isCompatibleType(target, MapCurve.Value) then
					sceneNode = self:curveToSceneNode(target)
				elseif Class.isCompatibleType(target, MapPeep) then
					sceneNode = self:getGameView():getMapSceneNode(target:getLayer())
				end

				if sceneNode then
					self.isGizmoGrabbed = self.gizmo:hover(x, y, self:getCamera(), sceneNode)
					if self.isGizmoGrabbed then
						self.gizmoGrabX = x
						self.gizmoGrabY = y
					end
				end
			end

			if self.currentTool == MapEditorApplication.TOOL_TERRAIN then
				self:probe(x, y, false, function(probe)
					local _, _, layer = probe:getTile()

					if layer then
						self.motionLayer = layer
						self:makeMotion(x, y, button)
						self.motion:onMousePressed(self:makeMotionEvent(x, y, button))

						if not self.currentToolNode then
							self:makeCurrentToolNode()
						end

						local _, i, j = self.motion:getTile()
						self.currentToolNode:setParent(self:getGameView():getMapSceneNode(self.motionLayer))
						self.currentToolNode:fromMap(
							self:getGame():getStage():getMap(self.motionLayer),
							motion,
							i, i, j, j)
					end
				end)
			elseif self.currentTool == MapEditorApplication.TOOL_BRUSH then
				self.paintingMotion = self:getBrushMotion()
				self.isPainting = true
			elseif self.currentTool == MapEditorApplication.TOOL_PAINT then
				self:paint()
				self.isDragging = true
			elseif self.currentTool == MapEditorApplication.TOOL_DECORATE and not (self.gizmo and self.gizmo:getIsActive()) then
				local group, decoration = self.decorationList:getCurrentDecoration()
				if group and decoration then
					local hit
					do
						local tileSetFilename = string.format(
							"Resources/Game/TileSets/%s/Layout.lstatic",
							decoration:getTileSetID())
						local staticMesh = self:getGameView():getResourceManager():load(
							StaticMeshResource,
							tileSetFilename)

						do
							local hits = decoration:testRay(self:shoot(x, y), staticMesh:getResource())
							table.sort(hits, function(a, b)
								local i = self:getCamera():getEye() - a[Decoration.RAY_TEST_RESULT_POSITION]
								local j = self:getCamera():getEye() - b[Decoration.RAY_TEST_RESULT_POSITION]

								return i:getLength() < j:getLength()
							end)

							hit = hits[1]
						end
					end

					local feature
					if hit then
						self.currentFeatureIndex = hit[Decoration.RAY_TEST_RESULT_INDEX]
						feature = self:getLastDecorationFeature()
					end

					if not feature and Class.isCompatibleType(decoration, Decoration) then
						local layer = self:getGameView():getDecorationLayer(decoration) or 1

						local tile = self.decorationPalette:getCurrentGroup()
						if tile then
							local motion = MapMotion(self:getGame():getStage():getMap(layer))
							motion:onMousePressed(self:makeMotionEvent(x, y, button, layer))

							local t, i, j = motion:getTile()
							if t then
								local y = t:getInterpolatedHeight(0.5, 0.5)
								local x = (i - 1 + 0.5) * motion:getMap():getCellSize()
								local z = (j - 1 + 0.5) * motion:getMap():getCellSize()

								local lastDecorationFeature = self:getLastDecorationFeature()
								local rotation, scale
								if lastDecorationFeature then
									rotation = lastDecorationFeature:getRotation()
									scale = lastDecorationFeature:getScale()
								end

								feature = decoration:add(
									tile,
									Vector(x, y, z),
									rotation,
									scale,
									self.currentDecorationColor,
									self.decorationPalette:getCurrentTexture())
								self:getGame():getStage():decorate(group, decoration, layer)
								self.currentFeatureIndex = decoration:getNumFeatures()
							end
						end
					end

					if feature then
						if Class.isCompatibleType(feature, Decoration.Feature) then
							self:createBoundsGizmo(feature)
						elseif Class.isCompatibleType(feature, Spline.Feature) then
							self:beginEditCurve(false, feature:getCurve():toConfig())
						end
					end
				end
			elseif self.currentTool == MapEditorApplication.TOOL_PROP and not (self.gizmo and self.gizmo:getIsActive()) then
				if not love.keyboard.isDown("lctrl") and not love.keyboard.isDown("rctrl") then
					self.lastProp = nil

					local hits = {}
					for prop in self:getGame():getStage():iterateProps() do
						local ray = self:shoot(x, y)
						local min, max = prop:getBounds()
						local size = max - min
						size = size:max(Vector.ONE)
						min, max = Vector(-size.x / 2, 0, -size.y / 2) + prop:getPosition(), Vector(size.x / 2, size.y, size.x / 2) + prop:getPosition()

						local s, p = ray:hitBounds(min, max)
						if s then
							table.insert(hits, { position = p, prop = prop })
						end
					end

					local eye = self:getCamera():getEye()
					table.sort(hits, function(a, b)
						return (a.position - eye):getLength() < (b.position - eye):getLength()
					end)

					local hit = hits[1]
					if hit then
						self.lastProp = hit.prop
					end
				else
					self.lastProp = nil
				end

				if not self.lastProp then
					local prop = self.propPalette:getCurrentProp()
					if prop then
						local s, p = self:getGame():getStage():placeProp("resource://" .. prop.name, 1, "::orphan")
						if s then
							local motion = MapMotion(self:getGame():getStage():getMap(self.currentLayer))
							motion:onMousePressed(self:makeMotionEvent(x, y, button, self.currentLayer))

							local t, i, j = motion:getTile()
							if t then
								local y = t:getInterpolatedHeight(0.5, 0.5)
								local x = (i - 1 + 0.5) * motion:getMap():getCellSize()
								local z = (j - 1 + 0.5) * motion:getMap():getCellSize()

								local peep = p:getPeep()
								local position = peep:getBehavior(require "ItsyScape.Peep.Behaviors.PositionBehavior")
								position.position = Vector(x, y, z)

								local index = 1
								local name
								repeat
									name = string.format("%s%d", prop.name, index)
									index = index + 1
								until self.propNames[name] == nil

								self.propNames[name] = p
								self.propNames[p] = name

								self.lastProp = p
							end
						end
					end
				end

				if self.lastProp then
					self:createBoundsGizmo(self.lastProp)
				end
			end

			if self.isEditingCurve and not (self.gizmo and self.gizmo:getIsActive()) then
				local minDistance = math.huge
				local clickedCurveIndex

				local positionCurve = self.curve:getPositions()
				for i = 1, positionCurve:length() do
					local curvePoint = positionCurve:get(i):getValue()
					local screenPoint = self:getCamera():project(curvePoint)
					local distance = (screenPoint - Vector(x, y, 0)):getLength()

					if distance <= minDistance then
						minDistance = distance
						clickedCurveIndex = i
					end
				end

				if clickedCurveIndex and minDistance <= 16 then
					if self.gizmoOperation == Gizmo.OPERATION_TRANSLATION then
						self:createTranslationGizmo(positionCurve:get(clickedCurveIndex))
					elseif self.gizmoOperation == Gizmo.OPERATION_ROTATION then
						self:createRotationGizmo(self.curve:getNormals():get(clickedCurveIndex))
					end
				end

				minDistance = math.huge
				clickedCurveIndex = nil

				local rotationCurve = self.curve:getRotations()
				for i = 1, rotationCurve:length() do
					local t = (i - 1) / (rotationCurve:length() - 1)
					local curvePoint = positionCurve:evaluate(t) + Vector(0, 4, 0)
					local screenPoint = self:getCamera():project(curvePoint)
					local distance = (screenPoint - Vector(x, y, 0)):getLength()

					if distance <= minDistance then
						minDistance = distance
						clickedCurveIndex = i
					end
				end

				if clickedCurveIndex and minDistance <= 8 then
					self:createRotationGizmo(rotationCurve:get(clickedCurveIndex))
				end
			elseif self.currentTool == MapEditorApplication.TOOL_CURVE then
				if not self.isGizmoGrabbed then
					self:probe(x, y, false, function(probe)
						local _, _, layer = probe:getTile()

						local mapScriptPeep = self.mapScriptPeeps[layer]
						if mapScriptPeep then
							self:createBoundsGizmo(mapScriptPeep)
						end
					end)
				end
			end
		elseif button == 2 then
			if self.currentTool == MapEditorApplication.TOOL_CURVE then
				self:probe(x, y, false, function(probe)
					local _, _, layer = probe:getTile()

					if not layer then
						return
					end

					local actions = {
						{
							id = 1,
							verb = "New",
							object = "Map",
							callback = function()
								local newMapInterface = NewMapInterface(self, false)
								self:getUIView():getRoot():addChild(newMapInterface)
							end
						},
						{
							id = 2,
							verb = "Delete",
							object = string.format("Layer %d", layer),
							callback = function()
								local confirm = ConfirmWindow(self)
								confirm.onSubmit:register(function()
									self:unloadLayer(layer)
								end)
								confirm:open("Are you sure you want to delete this layer?")
							end
						},
						{
							id = 3,
							verb = "Load",
							object = "Other Map",
							callback = function()
								local prompt = PromptWindow(self)
								prompt.onSubmit:register(function(_, filename)
									if not self:isResourceNameValid(filename) then
										local alert = AlertWindow(self)
										alert:open(string.format("Map name '%s' invalid.", filename))
									else
										local layer = self:getGame():getStage():newLayer(self:getGame():getStage():getInstanceByLayer(1))
										self:load(filename, true, layer)
									end
								end)
								prompt:open("What is the additional map name?", "Load")
							end
						}
					}

					self:getUIView():probe(actions)
				end)
			end
		end
	end
end

function MapEditorApplication:mouseMove(x, y, dx, dy)
	if not EditorApplication.mouseMove(self, x, y, dx, dy) then
		if self.motion then
			local r = self.motion:onMouseMoved(self:makeMotionEvent(x, y))

			if r then
				self:getGame():getStage():updateMap(self.motionLayer)
			end
		end

		do
			self:probe(x, y, false, function(probe)
				local motion, layer
				if self.motion then
					motion = self.motion
					layer = self.motionLayer
				elseif probe:getTile() then
					local _, _, k = probe:getTile()
					layer = k

					motion = MapMotion(self:getGame():getStage():getMap(layer))
					motion:onMousePressed(self:makeMotionEvent(x, y, 1))
				end

				if motion and layer then
					local _, i, j = motion:getTile()
					self.previousI = self.currentI
					self.previousJ = self.currentJ
					self.previousLayer = self.currentLayer
					self.currentI = i
					self.currentJ = j
					self.currentLayer = layer or 1
				end
			end)
		end

		if self.currentTool == MapEditorApplication.TOOL_TERRAIN then
			self:probe(x, y, false, function(probe)
				if not probe:getTile() then
					return
				end

				local motion, layer
				if self.motion then
					motion = self.motion
					layer = self.motionLayer
				else
					local _, _, k = probe:getTile()
					layer = k

					motion = MapMotion(self:getGame():getStage():getMap(layer))
					motion:onMousePressed(self:makeMotionEvent(x, y, nil, layer))
				end

				local _, i, j = motion:getTile()
				if not self.currentToolNode then
					self:makeCurrentToolNode()
				end

				local size = math.max(self.terrainToolPanel.toolSize - 1, 0)
				self.currentToolNode:setParent(self:getGameView():getMapSceneNode(layer))
				self.currentToolNode:fromMap(
					self:getGame():getStage():getMap(layer),
					motion,
					i - size,
					i + size,
					j - size,
					j + size)

				local isShiftDown = love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift')

				if love.keyboard.isDown('i') and isShiftDown then
					local map = self:getGame():getStage():getMap(layer)
					local tile = map:getTile(self.currentI, self.currentJ)
					tile:setFlag('impassable')
				elseif love.keyboard.isDown('b') and isShiftDown then
					local map = self:getGame():getStage():getMap(layer)
					local tile = map:getTile(self.currentI, self.currentJ)
					tile:setFlag('building')
				end
			end)
		elseif self.currentTool == MapEditorApplication.TOOL_BRUSH then
			local motion = MapMotion(self:getGame():getStage():getMap(self.motionLayer))
			motion:onMousePressed(self:makeMotionEvent(x, y, 1))

			local _, i, j = motion:getTile()
			if not self.currentToolNode then
				self:makeCurrentToolNode()
			end

			local size = math.max(math.floor(self.brushToolPanel:getToolSize() - 1), 0)
			self.currentToolNode:setParent(self:getGameView():getMapSceneNode(self.motionLayer))
			self.currentToolNode:fromMap(
				self:getGame():getStage():getMap(self.motionLayer),
				motion,
				i - size,
				i + size,
				j - size,
				j + size)
		elseif self.currentTool == MapEditorApplication.TOOL_PAINT then
			self:probe(x, y, false, function(probe)
				if not self.currentToolNode then
					self:makeCurrentToolNode()
				end

				if not probe:getTile() then
					return
				end

				local i, j = probe:getTile()
				local size = math.max(self.landscapeToolPanel:getToolSize(), 0)
				self.currentToolNode:setParent(self:getGameView():getMapSceneNode(self.currentLayer))
				self.currentToolNode:fromMap(
					self:getGame():getStage():getMap(self.currentLayer),
					false,
					i - size,
					i + size,
					j - size,
					j + size)

				if self.isDragging then
					self.previousPaintI = self.currentPaintI or i
					self.previousPaintJ = self.currentPaintJ or j
					self.currentPaintI = i
					self.currentPaintJ = j
					self:paint()
				end
			end)
		elseif self.currentToolNode then
			self.currentToolNode:setParent(nil)
			self.currentToolNode = false
		end
	end

	if self.gizmo then
		local target = self.gizmo:getTarget()

		local sceneNode
		if Class.isCompatibleType(target, Prop) then
			local p = self:getGameView():getProp(target)
			if p then
				local min, max = target:getBounds()
				sceneNode = p:getRoot()
			end
		elseif Class.isCompatibleType(target, Decoration.Feature) then
			sceneNode = self:decorationFeatureToSceneNode(target)
		elseif Class.isCompatibleType(target, MapCurve.Value) then
			sceneNode = self:curveToSceneNode(target)
		elseif Class.isCompatibleType(target, MapPeep) then
			sceneNode = self:getGameView():getMapSceneNode(target:getLayer())
		end

		if sceneNode then
			local needsUpdate = false

			if not self.isGizmoGrabbed then
				self.gizmo:hover(x, y, self:getCamera(), sceneNode)
			else
				if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
					if self.gizmo:move(x, y, self.gizmoGrabX, self.gizmoGrabY, self:getCamera(), sceneNode, true) then
						self.gizmoGrabX = x
						self.gizmoGrabY = y
					end
				else
					needsUpdate = self.gizmo:move(x, y, x + dx, y + dy, self:getCamera(), sceneNode, false)
				end
			end

			local transform = sceneNode:getTransform()
			local translation = transform:getLocalTranslation()
			local rotation = transform:getLocalRotation()
			local scale = transform:getLocalScale()

			if Class.isCompatibleType(target, Prop) then
				Utility.Peep.setPosition(target:getPeep(), translation)
				Utility.Peep.setRotation(target:getPeep(), rotation)
				Utility.Peep.setScale(target:getPeep(), scale)
			elseif Class.isCompatibleType(target, Decoration.Feature) then
				target:setPosition(translation)
				target:setRotation(rotation)
				target:setScale(scale)

				local group, decoration = self.decorationList:getCurrentDecoration()
				if group and decoration then
					self:getGameView():decorate(group, decoration, self:getGameView():getDecorationLayer(decoration) or 1)
				end
			elseif Class.isCompatibleType(target, MapCurve.Value) and target:getIndex() then
				if Class.isCompatibleType(target, MapCurve.Position) then
					self.curve:getPositions():set(target:getIndex(), MapCurve.Position(translation:get()))
					self.gizmo:setTarget(self.curve:getPositions():get(target:getIndex()))
				elseif Class.isCompatibleType(target, MapCurve.Normal) then
					self.curve:getNormals():set(target:getIndex(), MapCurve.Normal(rotation:transformVector(Vector.UNIT_Y):getNormal():get()))
					self.gizmo:setTarget(self.curve:getNormals():get(target:getIndex()))
				elseif Class.isCompatibleType(target, MapCurve.Rotation) then
					self.curve:getRotations():set(target:getIndex(), MapCurve.Rotation(rotation:get()))
					self.gizmo:setTarget(self.curve:getRotations():get(target:getIndex()))
				elseif Class.isCompatibleType(target, MapCurve.Scale) then
					self.curve:getScales():set(target:getIndex(), MapCurve.Scale(scale:get()))
					self.gizmo:setTarget(self.curve:getScales():get(target:getIndex()))
				end

				if needsUpdate then
					self:updateCurve()
				end
			elseif Class.isCompatibleType(target, MapPeep) then
				Utility.Peep.setPosition(target, translation)
				Utility.Peep.setRotation(target, rotation)
				Utility.Peep.setScale(target, scale)
			end
		end
	end

	local hit
	do
		local hits = {}
		for prop in self:getGame():getStage():iterateProps() do
			local ray = self:shoot(x, y)
			local min, max = prop:getBounds()
			local s, p = ray:hitBounds(min, max)
			if s then
				table.insert(hits, { position = p, prop = prop })
			end
		end

		local eye = self:getCamera():getEye()
		table.sort(hits, function(a, b)
			return (a.position - eye):getLength() < (b.position - eye):getLength()
		end)

		hit = hits[1]
	end

	if hit then
		self.currentMapObject = self.propNames[hit.prop]
	end
end

function MapEditorApplication:mouseRelease(x, y, button)
	if not EditorApplication.mouseRelease(self, x, y, button) then
		if button == 1 then
			if self.motion then
				self.motion:onMouseReleased(self:makeMotionEvent(x, y, button))
				self.motion = false
			end

			self.paintingMotion = nil

			if self.isPainting then
				self:getGame():getStage():updateMap(self.motionLayer)
				self.isPainting = false
			end

			self.previousPaintI = nil
			self.previousPaintJ = nil
			self.currentPaintI = nil
			self.currentPaintJ = nil
		end
		self.isDragging = false
	end

	self.isGizmoGrabbed = false
end

function MapEditorApplication:keyDown(key, scan, isRepeat, ...)
	if not EditorApplication.keyDown(self, key, scan, isRepeat, ...) then
		local isWidgetFocused = self:getUIView():getInputProvider():getFocusedWidget()
		isWidgetFocused = isWidgetFocused and Class.isCompatibleType(isWidgetFocused, require "ItsyScape.UI.TextInput")

		if not isRepeat and not isWidgetFocused then
			if key == 'f1' then
				if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
					self:setTool(MapEditorApplication.TOOL_BRUSH)
				else
					self:setTool(MapEditorApplication.TOOL_TERRAIN)
				end
			elseif key == 'f2' then
				self:setTool(MapEditorApplication.TOOL_PAINT)
			elseif key == 'f3' then
				self:setTool(MapEditorApplication.TOOL_DECORATE)
			elseif key == 'f4' then
				self:setTool(MapEditorApplication.TOOL_PROP)
			elseif key == 'f5' then
				self:setTool(MapEditorApplication.TOOL_CURVE)
			end

			if self.currentTool == MapEditorApplication.TOOL_TERRAIN then
				if key == 'i' then
					local map = self:getGame():getStage():getMap(self.currentLayer)
					local tile = map:getTile(self.currentI, self.currentJ)
					if tile:hasFlag('impassable') then
						tile:unsetFlag('impassable')
					else
						tile:setFlag('impassable')
					end
				elseif key == 'b' then
					local map = self:getGame():getStage():getMap(self.currentLayer)

					local top = self.currentJ - (self.terrainToolPanel.toolSize - 1)
					local bottom = self.currentJ + (self.terrainToolPanel.toolSize - 1)
					local left = self.currentI - (self.terrainToolPanel.toolSize - 1)
					local right = self.currentI + (self.terrainToolPanel.toolSize - 1)

				 	top = math.max(top, 1)
					bottom = math.min(map:getHeight(), bottom)
					left = math.max(left, 1)
					right = math.min(map:getWidth(), right)

					for i = left, right do
						for j = top, bottom do
							local tile = map:getTile(i, j)
							if love.keyboard.isDown('lalt') or love.keyboard.isDown('ralt') then
								tile:unsetFlag('building')
							else
								tile:setFlag('building')
							end
						end
					end
				end
			end

			if self.currentTool == MapEditorApplication.TOOL_PROP and self.lastProp and self.lastProp:getPeep() then
				if key == "r" then
					self:createRotationGizmo(self.lastProp)
				elseif key == "g" then
					self:createTranslationGizmo(self.lastProp)
				elseif key == "s" then
					self:createScaleGizmo(self.lastProp)
				elseif key == "delete" or key == "backspace" then
					if self.gizmo and self.gizmo:getTarget() == self.lastProp then
						self:unsetGizmo()
					end

					if self.lastProp then
						self:getGame():getStage():removeProp(self.lastProp)
						self.lastProp = nil
					end
				else
					local position = Vector.ZERO
					if key == 'up' then
						position = position - Vector.UNIT_Z / 8
					elseif key == 'down' then
						position = position + Vector.UNIT_Z / 8
					elseif key == 'left' then
						position = position - Vector.UNIT_X / 8
					elseif key == 'right' then
						position = position + Vector.UNIT_X / 8
					elseif key == 'pageup' then
						position = position + Vector.UNIT_Y / 8
					elseif key == 'pagedown' then
						position = position - Vector.UNIT_Y / 8
					end

					local behavior = self.lastProp:getPeep():getBehavior('Position')
					behavior.position = behavior.position + position
				end
			end

			if self.currentTool == MapEditorApplication.TOOL_DECORATE then
				if key == "a" then
					local group, decoration = self.decorationList:getCurrentDecoration()
					local tile = self.decorationPalette:getCurrentGroup()
					if tile then
						local position = self:getCamera():getPosition()

						if Class.isCompatibleType(decoration, Spline) then
							local tileSetFilename = string.format(
								"Resources/Game/TileSets/%s/Layout.lstatic",
								decoration:getTileSetID())
							local staticMesh = self:getGameView():getResourceManager():load(
								StaticMeshResource,
								tileSetFilename)
							staticMesh = staticMesh and staticMesh:getResource()

							if staticMesh and staticMesh:hasGroup(tile) then
								local vertices = staticMesh:getVertices(tile)

								local min, max = Vector(math.huge), Vector(-math.huge)
								for _, vertex in ipairs(vertices) do
									local v = Vector(vertex[1], vertex[2], vertex[3])
									min = min:min(v)
									max = max:max(v)
								end

								local size = max - min
								local curve = MapCurve(nil, {
									width = 0,
									height = 0,
									unit = 1,
									min = { min:get() },
									max = { max:get() },
									axis = { 0, 0, 1 },
									positions = { { position:get() }, { (position + Vector(0, 0, size.z)):get() } },
									normals = { { Vector.UNIT_Y:get() }, { Vector.UNIT_Y:get() } },
									scales = { { Vector.ONE:get() }, { Vector.ONE:get() } },
									rotations = { { Quaternion.IDENTITY:get() } }
								})

								decoration:add(tile, curve, self.currentDecorationColor)
								self:getGame():getStage():decorate(group, decoration)
								self.currentFeatureIndex = decoration:getNumFeatures()

								self:beginEditCurve(false, curve:toConfig())
							end
						else
							local lastDecorationFeature = self:getLastDecorationFeature()
							local rotation, scale
							if lastDecorationFeature then
								rotation = lastDecorationFeature:getRotation()
								scale = lastDecorationFeature:getScale()
							end

							local feature = decoration:add(
								tile,
								position,
								rotation,
								scale,
								self.currentDecorationColor)
							self:getGame():getStage():decorate(group, decoration)
							self.currentFeatureIndex = decoration:getNumFeatures()
						end
					end
				end

				if self:getLastDecorationFeature() then
					local feature = self:getLastDecorationFeature()
					if Class.isCompatibleType(feature, Decoration.Feature) then
						if key == "r" then
							self:createRotationGizmo(feature)
						elseif key == "g" then
							self:createTranslationGizmo(feature)
						elseif key == "s" then
							self:createScaleGizmo(feature)
						elseif key == "d" then
							if self.gizmo then
								local feature = self.gizmo:getTarget()

								local group, decoration = self.decorationList:getCurrentDecoration()
								if group and decoration then
									local cameraRotation = self:getCamera():getCombinedRotation()
									local cameraForward = cameraRotation:transformVector(Vector.UNIT_Z)

									local decorationForward = Vector.UNIT_Z
									if cameraForward.z < 0 then
										decorationForward = -Vector.UNIT_Z
									end

									decorationForward = feature:getRotation():transformVector(decorationForward * 2)

									local newFeature = decoration:add(
										feature:getID(),
										feature:getPosition() - decorationForward,
										feature:getRotation(),
										feature:getScale(),
										feature:getColor())

									self:getGame():getStage():decorate(group, decoration, self:getGameView():getDecorationLayer(decoration) or 1)

									if newFeature then
										self:createBoundsGizmo(newFeature)
										self.currentFeatureIndex = decoration:getNumFeatures()
									end
								end
							end
						end
					end


					if key == "c" then
						if not (self.currentPalette and self.currentPalette:getParent()) then
							self.currentPalette = ColorPalette(self)
							local function _update(_, color)
								local currentFeature = self:getLastDecorationFeature()
								if currentFeature then
									currentFeature:setColor(color)

									local group, decoration = self.decorationList:getCurrentDecoration()
									if group and decoration then
										self:getGame():getStage():decorate(group, decoration)
									end

									self.currentDecorationColor = color
								end
							end

							self.currentPalette.onUpdate:register(_update)
							self.currentPalette.onSubmit:register(_update)
							self.currentPalette.onCancel:register(_update)

							local colors = {}
							local _, decoration = self.decorationList:getCurrentDecoration()
							for i = 1, decoration:getNumFeatures() do
								table.insert(colors, decoration:getFeatureByIndex(i):getColor())
							end

							local x = self.decorationPalette:getAbsolutePosition()
							x = x - ColorPalette.WIDTH

							local _, h = love.graphics.getScaledMode()
							local y = h - ColorPalette.HEIGHT

							self.currentPalette:open(feature:getColor(), colors, x, y)
						end
					elseif key == "delete" or key == "backspace" then
						if self.gizmo then
							local feature = self.gizmo:getTarget()
							self:unsetGizmo()

							local group, decoration = self.decorationList:getCurrentDecoration()
							if decoration then
								decoration:remove(feature)
							end

							self.currentFeatureIndex = nil

							self:getGame():getStage():decorate(group, decoration)
						end
					end
				end
			end

			if key == 's' and
			   (love.keyboard.isDown('lctrl') or love.keyboard.isDown('rctrl'))
			then
				local newSave
				if self.filename ~= false and
				   not (love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift'))
				then
					newSave = false
				else
					newSave = true
				end

				if newSave then
					local prompt = PromptWindow(self)
					prompt.onSubmit:register(function(_, filename)
						if not self:isResourceNameValid(filename) then
							local alert = AlertWindow(self)
							alert:open(string.format("Map name '%s' invalid.", filename))
						else
							local path = self:getOutputDirectoryName("Maps", filename)
							if love.filesystem.getInfo(path) then
								local confirm = ConfirmWindow(self)
								confirm.onSubmit:register(function()
									self:save(filename)
								end)
								confirm:open(string.format("Map '%s' already exists. Overwrite?", filename))
							else
								self:save(filename)
							end
						end
					end)
					prompt:open("What is the map name?", "Save", self.filename)
				else
					self:save(self.filename)
				end
			end

			if self.isEditingCurve then
				if key == "x" then
					self.curve:setAxis(Vector.UNIT_X)
				elseif key == "z" then
					self.curve:setAxis(Vector.UNIT_Z)
				elseif key == "tab" then
					local index
					local targetType
					if self.gizmo then
						local target = self.gizmo:getTarget()
						if Class.isCompatibleType(target, MapCurve.Value) then
							index = target:getIndex()
						end

						targetType = target:getType()
					end

					index = index or 1
					targetType = targetType or MapCurve.Position

					if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
						index = index - 1
					else
						index = index + 1
					end

					local length
					if targetType == MapCurve.Position or targetType == MapCurve.Normal or targetType == MapCurve.Scale then
						length = self.curve:getPositions():length()
					elseif targetType == MapCurve.Rotation then
						length = self.curve:getRotations():length()
					end

					if length then
						if index <= 0 then
							index = length
						elseif index > length then
							index = 1
						end

						local target = self.gizmo and self.gizmo:getTarget() or self.curve:getPositions():get(1)
						self:createCurveValueGizmo(target:getType(), index)
					end
				elseif key == "e" then
					if self.gizmo then
						local target = self.gizmo:getTarget()
						local targetType = target:getType()

						local targetIndex = target:getIndex() or 1
						local nextIndex
						if targetType == MapCurve.Position or targetType == MapCurve.Normal or targetType == MapCurve.Scale then
							self.curve:getPositions():split(targetIndex)
							self.curve:getNormals():split(targetIndex)
							self.curve:getScales():split(targetIndex)
							nextIndex = math.min(targetIndex + 1, self.curve:getPositions():length())
						elseif targetType == MapCurve.Rotation then
							self.curve:getRotations():split(targetIndex)
							nextIndex = math.min(targetIndex + 1, self.curve:getRotations():length())
						end

						self:createCurveValueGizmo(targetType, nextIndex or targetIndex)
					end
				elseif key == "delete" or key == "backspace" then
					if self.gizmo then
						local target = self.gizmo:getTarget()
						local targetType = target:getType()

						local targetIndex = target:getIndex() or 1
						if (targetType == MapCurve.Position and self.curve:getPositions():length() >= 2) or
						   (targetType == MapCurve.Normal and self.curve:getNormals():length() >= 2) or
						   (targetType == MapCurve.Scale and self.curve:getScales():length() >= 2)
						then
							self.curve:getPositions():remove(targetIndex)
							self.curve:getNormals():remove(targetIndex)
							self.curve:getScales():remove(targetIndex)
							self:createCurveValueGizmo(targetType, targetIndex - 1)
						elseif targetType == MapCurve.Rotation and self.curve:getRotations():length() >= 2 then
							self.curve:getRotations():remove(targetIndex)
							self:createCurveValueGizmo(targetType, targetIndex - 1)
						end
					end
				elseif key == "p" then
					self.curvePreview = not self.curvePreview
				elseif key == "g" then
					if self.gizmo then
						local target = self.gizmo:getTarget()
						local targetType = target:getType()

						local targetIndex = target:getIndex() or 1
						if targetType == MapCurve.Position or targetType == MapCurve.Normal or targetType == MapCurve.Scale then
							self:createTranslationGizmo(self.curve:getPositions():get(targetIndex))
						end
					end
				elseif key == "r" then
					if self.gizmo then
						local target = self.gizmo:getTarget()
						local targetType = target:getType()

						local targetIndex = target:getIndex() or 1
						if targetType == MapCurve.Position or targetType == MapCurve.Normal or targetType == MapCurve.Scale then
							self:createRotationGizmo(self.curve:getNormals():get(targetIndex))
						end
					end
				elseif key == "s" then
					if self.gizmo then
						local target = self.gizmo:getTarget()
						local targetType = target:getType()

						local targetIndex = target:getIndex() or 1
						if targetType == MapCurve.Position or targetType == MapCurve.Normal or targetType == MapCurve.Scale then
							self:createScaleGizmo(self.curve:getScales():get(targetIndex))
						end
					end
				elseif key == "return" then
					local curve = Log.dump(self.curve:toConfig())
					Log.info("Curve = %s", curve)
				end

				self:updateCurve()
			elseif self.currentTool == MapEditorApplication.TOOL_CURVE then
				local target = self.gizmo and self.gizmo:getTarget()
				if Class.isCompatibleType(target, MapPeep) then
					if key == "g" then
						self:createTranslationGizmo(target)
					elseif key == "r" then
						self:createRotationGizmo(target)
					elseif key == "s" then
						self:createScaleGizmo(target)
					elseif key == "c" then
						local map = self:getGame():getStage():getMap(target:getLayer())
						self:beginEditCurve(map, self.curve and self.curve:toConfig() or {
							min = { 0, 0, 0 },
							max = { map:getWidth() * map:getCellSize(), 0, map:getHeight() * map:getCellSize() },
							axis = { 0, 0, 1 },
							positions = { { map:getWidth() * map:getCellSize() / 2, 0, 0 }, { map:getWidth() * map:getCellSize() / 2, 0, map:getHeight() * map:getCellSize() } },
							normals = { { 0, 1, 0 }, { 0, 1, 0 } },
							scales = { { 1, 1, 1 }, { 1, 1, 1 } },
							rotations = { { Quaternion.IDENTITY:get() } }
						}, target:getLayer())
					end
				end
			end

			if key == 'o' and
			   (love.keyboard.isDown('lctrl') or love.keyboard.isDown('rctrl'))
			then
				local preferExisting = love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift')

				local prompt = PromptWindow(self)
				prompt.onSubmit:register(function(_, filename)
					if not self:isResourceNameValid(filename) then
						local alert = AlertWindow(self)
						alert:open(string.format("Map name '%s' invalid.", filename))
					else
						if self:load(filename, preferExisting) then
							self.filename = filename
						end
					end
				end)
				prompt:open("What is the map name?", "Load")
			end
		end
	end
end

function MapEditorApplication:_getPhysicalLayer(layer)
	for index, l in ipairs(self.mapScriptLayers) do
		if l == layer then
			return index
		end
	end

	return nil
end

function MapEditorApplication:save(filename)
	if self:makeOutputDirectory("Maps", filename) then
		if not self:makeOutputSubdirectory("Maps", filename, "Decorations") then
			Log.warn("Couldn't save map %s.", filename)
			return false
		end

		local decorations = self:getGameView():getDecorations()
		for group, decoration in pairs(decorations) do
			if self:getGameView():getDecorationLayer(decoration) == 1 and not group:match("_x") then
				local extension
				if Class.isCompatibleType(decoration, Decoration) then
					extension = "ldeco"
				elseif Class.isCompatibleType(decoration, Spline) then
					extension = "lspline"
				end

				if extension then
					local layer = self:_getPhysicalLayer(self:getDecorationLayer(decoration))
					if layer then
						local filename
						if layer == 1 then
							filename = self:getOutputFilename("Maps", filename, "Decorations", group .. "." .. extension)
						else
							filename = self:getOutputFilename("Maps", filename, "Decorations", group .. "@" .. layer .. "." .. extension)
						end

						local s, r = love.filesystem.write(filename, decoration:toString())
						if not s then
							Log.warn(
								"Couldn't save decoration '%s' to %s: %s",
								group, filename, r)
						end
					end
				end
			end
		end

		local layers = self.mapScriptLayers
		for i = 1, #layers do
			local map = self:getGame():getStage():getMap(layers[i])
			local index = tonumber(layers[i])
			if index then
				local filename = self:getOutputFilename(
					"Maps",
					filename,
					StringBuilder.stringify(i, "%d") .. ".lmap")
				local s, r = love.filesystem.write(filename, map:toString())
				if not s then
					Log.warn(
						"Couldn't save map layer %d to %s: %s",
						index, filename, r)
				end
			end
		end

		do
			local meta = {}
			for i = 1, #layers do
				local _, tileSetID = self:getGameView():getMapTileSet(layers[i])

				local map = self:getGame():getStage():getMap(layers[i])
				local mapScriptPeep = self.mapScriptPeeps[layers[i]]
				local translation = Utility.Peep.getPosition(mapScriptPeep)
				local rotation = Utility.Peep.getRotation(mapScriptPeep)
				local scale = Utility.Peep.getScale(mapScriptPeep)
				local offset = mapScriptPeep:hasBehavior(OriginBehavior) and mapScriptPeep:getBehavior(OriginBehavior).origin

				meta[layers[i]] = {
					tileSetID = tileSetID,
					maskID = self.meta and self.meta[layers[i]] and self.meta and self.meta[layers[i]].maskID,
					autoMask = self.meta and self.meta[layers[i]] and self.meta[layers[i]].autoMask,
					transform = {
						translation = { translation:get() },
						rotation = { rotation:get() },
						scale = { scale:get() },
						offset = { (offset or Vector(map:getWidth() * map:getCellSize() / 2, 0, map:getHeight() * map:getCellSize() / 2)):get() }
					}
				}
			end

			local filename = self:getOutputFilename("Maps", filename, "meta")
			love.filesystem.write(filename, StringBuilder.stringifyTable(meta))
		end

		do
			local s = StringBuilder()
			s:pushLine("local M = {}")
			s:pushLine()

			s:pushFormatLine("M._MAP = ItsyScape.Resource.Map %q", filename)
			s:pushLine()

			local props = {}
			for prop in self:getGame():getStage():iterateProps() do
				local name = self.propNames[prop]
				if name then
					table.insert(props, prop)
				end
			end

			table.sort(props, function(a, b)
				return self.gpropNames[a] < self.propNames[b]
			end)

			for _, prop in ipairs(props) do
				local position = prop:getPosition()
				local rotation = prop:getRotation()
				local scale = prop:getScale()
				local _, _, layer = prop:getTile()
				layer = self:_getPhysicalLayer(layer)
				local name = self.propNames[prop]
				if name and layer then
					s:pushFormatLine("M[%q] = ItsyScape.Resource.MapObject.Unique()", name)
					s:pushLine("do")
					s:pushLine("\tItsyScape.Meta.MapObjectLocation {")
					s:pushFormatLine("\t\tPositionX = %f,", position.x)
					s:pushFormatLine("\t\tPositionY = %f,", position.y)
					s:pushFormatLine("\t\tPositionZ = %f,", position.z)
					s:pushFormatLine("\t\tRotationX = %f,", rotation.x)
					s:pushFormatLine("\t\tRotationY = %f,", rotation.y)
					s:pushFormatLine("\t\tRotationZ = %f,", rotation.z)
					s:pushFormatLine("\t\tRotationW = %f,", rotation.w)
					s:pushFormatLine("\t\tScaleX = %f,", scale.x)
					s:pushFormatLine("\t\tScaleY = %f,", scale.y)
					s:pushFormatLine("\t\tScaleZ = %f,", scale.z)
					s:pushFormatLine("\t\tName = %q,", name)
					s:pushFormatLine("\t\tMap = M._MAP,")
					if layer > 1 then
						s:pushFormatLine("\t\tLayer = %d,", layer)
					end
					s:pushFormatLine("\t\tResource = M[%q]", name)
					s:pushFormatLine("\t}")
					s:pushLine()
					s:pushLine("\tItsyScape.Meta.PropMapObject {")
					s:pushFormatLine("\t\tProp = ItsyScape.Resource.Prop %q,", prop:getResourceName())
					s:pushFormatLine("\t\tMapObject = M[%q]", name)
					s:pushFormatLine("\t}")
					s:pushLine("end")
					s:pushLine()
				end
			end

			s:pushLine("return M")

			self:makeOutputSubdirectory("Maps", filename, "DB")

			local dbFilename = self:getOutputFilename("Maps", filename, "DB", "Default.lua")
			local s, r = love.filesystem.write(dbFilename, s:toString())
			if not s then
				Log.warn("couldn't save DB script: %s", r)
			end
		end

		self.filename = filename
		return true
	end

	return false
end

function MapEditorApplication:load(filename, preferExisting, baseLayer)
	if not baseLayer then
		self:unload()
	end

	local path
	if preferExisting then
		path = self:getDirectoryName("Maps", filename)
	end

	if not path or not love.filesystem.getInfo(path) then
		path = self:getOutputDirectoryName("Maps", filename)
	end

	if not love.filesystem.getInfo(path) then
		Log.warn("Map '%s' doesn't exist.", filename)

		return false
	end

	local meta
	do
		local metaFilename
		if preferExisting then
			metaFilename = self:getDirectoryName("Maps", filename) .. "meta"
		else
			metaFilename = self:getOutputFilename("Maps", filename, "meta")
		end
		local data = "return " .. (love.filesystem.read(metaFilename) or "")
		local chunk = assert(loadstring(data))
		meta = setfenv(chunk, {})() or {}
	end

	for _, item in ipairs(love.filesystem.getDirectoryItems(path)) do
		local layer = item:match(".*(-?%d)%.lmap$")
		if layer then
			layer = tonumber(layer)
			local map = Map.loadFromFile(path .. item)

			local tileSetID
			if meta[layer] then
				tileSetID = meta[layer].tileSetID
			end

			local layerMeta = meta[layer] or {}

			local stage = self:getGame():getStage()

			local realLayer = layer + (baseLayer or 0)
			stage:newMap(
				map:getWidth(), map:getHeight(), layerMeta.tileSetID, layerMeta.maskID, realLayer)
			stage:updateMap(realLayer, map)
			stage:onMapMoved(realLayer, Vector.ZERO, Quaternion.IDENTITY, Vector.ONE, Vector.ZERO, false)

			if not baseLayer then
				table.insert(self.mapScriptLayers, layer)
			end

			local peep = self:getGame():getDirector():addPeep("::orphan", MapPeep, resource)
			peep:poke("load", filename, {}, layer)

			self:getGame():getStage():getPeepInstance():addMapScript(layer, peep, filename)
			self.mapScriptPeeps[layer] = peep

			peep:addBehavior(require "ItsyScape.Peep.Behaviors.PositionBehavior")
			peep:addBehavior(require "ItsyScape.Peep.Behaviors.ScaleBehavior")
			peep:addBehavior(require "ItsyScape.Peep.Behaviors.RotationBehavior")

			if layerMeta.transform then
				Utility.Peep.setPosition(peep, Vector(unpack(layerMeta.transform.translation or {})))
				Utility.Peep.setRotation(peep, Quaternion(unpack(layerMeta.transform.rotation or {})))
				Utility.Peep.setScale(peep, Vector(unpack(layerMeta.transform.scale or {})))

				local _, origin = peep:addBehavior(OriginBehavior)
				origin.origin = Vector(unpack(layerMeta.transform.offset))

				stage:onMapMoved(
					realLayer,
					Utility.Peep.getPosition(peep),
					Utility.Peep.getRotation(peep),
					Utility.Peep.getScale(peep),
					origin.origin, false)
			end
		end
	end

	if not baseLayer then
		self.meta = meta
	end

	for _, item in ipairs(love.filesystem.getDirectoryItems(path .. "/Decorations")) do
		local decoration = item:match("(.*)%.ldeco$")
		local spline = item:match("(.*)%.lspline$")
		local layer = item:match(".*@(%d+)%.[^%.@]*$")
		if decoration then
			local d = Decoration(path .. "Decorations/" .. item)
			self:getGame():getStage():decorate(decoration, d, tonumber(layer) or 1)
		elseif spline then
			local s = Spline(path .. "Decorations/" .. item)
			self:getGame():getStage():decorate(spline, s, tonumber(layer) or 1)
		end
	end

	if love.filesystem.getInfo(path .. "/DB/Default.lua") then
		local gameDB = GameDB.create({
			"Resources/Game/DB/Init.lua",
			path .. "/DB/Default.lua"
		}, ":memory:")

		local resource = gameDB:getResource(filename, "Map")
		if resource then
			local objects = gameDB:getRecords("MapObjectLocation", {
				Map = resource
			})

			for i = 1, #objects do
				local x = objects[i]:get("PositionX") or 0
				local y = objects[i]:get("PositionY") or 0
				local z = objects[i]:get("PositionZ") or 0
				local qx = objects[i]:get("RotationX") or 0
				local qy = objects[i]:get("RotationY") or 0
				local qz = objects[i]:get("RotationZ") or 0
				local qw = objects[i]:get("RotationW") or 1
				local sx = objects[i]:get("ScaleX")
				local sy = objects[i]:get("ScaleY")
				local sz = objects[i]:get("ScaleZ")
				local layer = math.max(objects[i]:get("Layer"), 1)

				do
					local prop = gameDB:getRecord("PropMapObject", {
						MapObject = objects[i]:get("Resource")
					})

					if prop then
						prop = prop:get("Prop")
						if prop then
							local s, p = self:getGame():getStage():placeProp("resource://" .. prop.name, baseLayer or 1, "::orphan")

							if s then
								local peep = p:getPeep()
								local position = peep:getBehavior(require "ItsyScape.Peep.Behaviors.PositionBehavior")
								position.position = Vector(x, y, z)
								position.layer = layer
								local scale = peep:getBehavior(require "ItsyScape.Peep.Behaviors.ScaleBehavior")
								scale.scale = Vector(sx, sy, sz)
								local rotation = peep:getBehavior(require "ItsyScape.Peep.Behaviors.RotationBehavior")
								rotation.rotation = Quaternion(qx, qy, qz, qw)
							end

							if not baseLayer then
								local name = objects[i]:get("Name")
								self.propNames[name] = p
								self.propNames[p] = name
							end
						end
					end
				end
			end
		end
	end

	return true
end

function MapEditorApplication:unloadLayer(layer)
	local decorations = self:getGameView():getDecorations()
	for group, decoration in pairs(decorations) do
		local decorationLayer = self:getGameView():getDecorationLayer(decoration)
		if decorationLayer == layer then
			self:getGame():getStage():decorate(group, nil)
		end
	end

	for prop in self:getGame():getStage():iterateProps() do
		local _, _, propLayer = prop:getTile()
		if propLayer == layer then
			self:getGame():getStage():removeProp(prop)

			local propName = self.propNames[prop]
			if propName then
				self.propNames[propName] = nil
				self.propNames[prop] = nil
			end
		end
	end

	self:getGame():getStage():unloadMap(layer)

	self.mapScriptPeeps[layer] = nil
	for i = 1, #self.mapScriptLayers do
		if self.mapScriptLayers[i] == layer then
			table.remove(self.mapScriptLayers, i)
			break
		end
	end
end

function MapEditorApplication:unload()
	local layers = self:getGame():getStage():getLayers()
	for i = 1, #layers do
		self:getGame():getStage():unloadMap(layers[i])
	end

	table.clear(self.mapScriptPeeps)
	table.clear(self.mapScriptLayers)

	local decorations = self:getGameView():getDecorations()
	for group, decoration in pairs(decorations) do
		self:getGame():getStage():decorate(group, nil)
	end

	for prop in self:getGame():getStage():iterateProps() do
		self:getGame():getStage():removeProp(prop)
	end

	self.propNames = {}
end

function MapEditorApplication:drawFlags()
	local projectionView
	do
		local projection, view = self:getCamera():getTransforms()
		projectionView = projection * view
	end

	local w, h = love.window.getMode()

	local map = self:getGame():getStage():getMap(self.currentLayer)
	local transform = self:getGameView():getMapSceneNode(self.currentLayer):getTransform():getGlobalTransform()
	for j = 1, map:getHeight() do
		for i = 1, map:getWidth() do
			local x = (i - 1) * map:getCellSize()
			local y = map:getTileCenter(i, j).y
			local z = (j - 1) * map:getCellSize()
			x, y, z = transform:transformPoint(x, y, z)

			local s, t, r = projectionView:transformPoint(x, y, z)
			s = (s + 1) / 2 * w
			t = (t + 1) / 2 * h
			if r > 0 and r < 1 then
				local tile = map:getTile(i, j)
				for i = 1, #self.flagIcons do
					local flag = self.flagIcons[i]
					if tile:hasFlag(flag.name) then
						love.graphics.setColor(1, 1, 1, 1)
						love.graphics.draw(flag.icon, s, t, 0, 0.5, 0.5)
						s = s + flag.icon:getWidth() * 0.5
					end
				end
			end
		end
	end
end

function MapEditorApplication:drawCurve()
	love.graphics.push("all")
	love.graphics.setLineWidth(4)
	love.graphics.setLineJoin("none")

	if self.curve:getPositions():length() >= 2 then
		local worldPoints = self.curve:getPositions():render()
		local screenPoints = {}
		for _, worldPoint in ipairs(worldPoints) do
			local screenPoint = self:getCamera():project(worldPoint)
			table.insert(screenPoints, screenPoint.x)
			table.insert(screenPoints, screenPoint.y)
		end

		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.line(screenPoints)

		local normalPoints = self.curve:getPositions():render(2)
		local targetType = self.gizmo and self.gizmo:getTarget():getType()
		if targetType == MapCurve.Normal then
			local screenDirections = {}
			for i, directionPoint in ipairs(normalPoints) do
				local t = (i - 1) / (#normalPoints - 1)

				local normal = self.curve:evaluateNormal(t):getNormal()

				local screenPoint = self:getCamera():project(directionPoint)
				local screenDirection = self:getCamera():project(directionPoint + normal)

				table.insert(screenDirections, screenPoint.x)
				table.insert(screenDirections, screenPoint.y)
				table.insert(screenDirections, screenDirection.x)
				table.insert(screenDirections, screenDirection.y)
			end

			love.graphics.setColor(0.5, 0.5, 0.5, 1)
			for i = 1, #screenDirections, 4 do
				love.graphics.line(screenDirections[i], screenDirections[i + 1], screenDirections[i + 2], screenDirections[i + 3])
			end
		elseif targetType == MapCurve.Scale then
			local axes = { Vector.UNIT_X, Vector.UNIT_Y, Vector.UNIT_Z }
			for j, axis in ipairs(axes) do
				local screenScales = {}
				for i, normalPoint in ipairs(normalPoints) do
					local t = (i - 1) / (#normalPoints - 1)

					local scale = self.curve:evaluateScale(t)
					local screenPoint = self:getCamera():project(normalPoint)
					local screenScale = self:getCamera():project(normalPoint + axis * scale)

					table.insert(screenScales, screenPoint.x)
					table.insert(screenScales, screenPoint.y)
					table.insert(screenScales, screenScale.x)
					table.insert(screenScales, screenScale.y)
				end

				love.graphics.setColor(math.abs(axis.x), math.abs(axis.y), math.abs(axis.z), 1)
				for i = 1, #screenScales, 4 do
					love.graphics.line(screenScales[i], screenScales[i + 1], screenScales[i + 2], screenScales[i + 3])
				end
			end
		elseif targetType == MapCurve.Rotation then
			local map = self:getGame():getStage():getMap(self.curveLayer)
			local axes = { -Vector.UNIT_X, Vector.UNIT_X, Vector.UNIT_Y, Vector.UNIT_Z }
			local offset = self.currentTool == MapEditorApplication.TOOL_CURVE and { map:getWidth() * map:getCellSize() / 4, map:getWidth() * map:getCellSize() / 4, 1, 1 } or { 1, 1, 1, 1 }
			for j, axis in ipairs(axes) do
				local screenNormals = {}
				for i, normalPoint in ipairs(normalPoints) do
					local t = (i - 1) / (#normalPoints - 1)

					local rotation = self.curve:evaluateRotation(t):getNormal()
					local normal = rotation:transformVector(axis)
					local screenPoint = self:getCamera():project(normalPoint)
					local screenNormal = self:getCamera():project(normalPoint + normal * offset[j])

					table.insert(screenNormals, screenPoint.x)
					table.insert(screenNormals, screenPoint.y)
					table.insert(screenNormals, screenNormal.x)
					table.insert(screenNormals, screenNormal.y)
				end

				love.graphics.setColor(math.abs(axis.x), math.abs(axis.y), math.abs(axis.z), 1)
				for i = 1, #screenNormals, 4 do
					love.graphics.line(screenNormals[i], screenNormals[i + 1], screenNormals[i + 2], screenNormals[i + 3])
				end
			end
		end
	end

	local positions = self.curve:getPositions()
	local rotations = self.curve:getRotations()

	love.graphics.setColor(1, 1, 1, 1)

	for i = 1, positions:length() do
		local curvePoint = positions:get(i):getValue()
		local screenPoint = self:getCamera():project(curvePoint)

		love.graphics.rectangle("fill", screenPoint.x - 8, screenPoint.y - 8, 16, 16)
	end

	for i = 1, rotations:length() do
		local t = (i - 1) / (rotations:length() - 1)
		local curvePoint = positions:evaluate(t) + Vector(0, 4, 0)
		local screenPoint = self:getCamera():project(curvePoint)

		love.graphics.circle("fill", screenPoint.x, screenPoint.y, 8)
	end

	love.graphics.pop()
end

function MapEditorApplication:getBrushMotion()
	local mouseX, mouseY = love.mouse.getPosition()
	local motionEvent = self:makeMotionEvent(mouseX, mouseY, 1, self.currentLayer)
	local map = self:getGame():getStage():getMap(self.currentLayer)
	local motion = MapMotion(map)
	motion:onMousePressed(motionEvent)

	return motion
end

function MapEditorApplication:brush(delta)
	local isClamped = love.keyboard.isDown("lctrl") or love.keyboard.isDown("lctrl")
	local map = self:getGame():getStage():getMap(self.currentLayer)
	local motion = isClamped and self.paintingMotion or self:getBrushMotion()

	local tile, i, j = motion:getTile()
	if not tile then
		return
	end

	local corner = tile:findNearestCorner(motion:getPosition(), i, j, map:getCellSize())
	for _, c in ipairs(Tile.CORNERS) do
		if c.name == corner then
			i = i + (c.offsetX + 1)
			j = j + (c.offsetY + 1)
		end
	end

	local tileElevation = map:getTile(i, j).topLeft

	local brushToolSize = math.floor(self.brushToolPanel:getToolSize() / 2) + 1
	local startI = math.max(i - brushToolSize, 1)
	local stopI = math.min(i + brushToolSize, map:getWidth() + 1)
	local startJ = math.max(j - brushToolSize, 1)
	local stopJ = math.min(j + brushToolSize, map:getHeight() + 1)

	for currentI = startI, stopI do
		for currentJ = startJ, stopJ do
			local distance = math.sqrt((currentI - i) ^ 2 + (currentJ - j) ^ 2)
			if distance <= brushToolSize then
				local radiusDelta = 1 - ((distance / brushToolSize) ^ 2)
				local offset = self.brushToolPanel:getPressure() * delta * radiusDelta
				local clampFunc = offset < 0 and math.max or math.min

				local currentTile = map:getTile(currentI, currentJ)
				local currentElevation = currentTile.topLeft

				local isClamped = love.keyboard.isDown("lctrl") or love.keyboard.isDown("lctrl")
				if isClamped then
					if offset < 0 and currentElevation > tileElevation then
						currentElevation = math.max(currentElevation + offset, tileElevation)
					elseif offset > 0 and currentElevation < tileElevation then
						currentElevation = math.min(currentElevation + offset, tileElevation)
					end
				else
					currentElevation = currentElevation + offset
				end

				for offsetI = -1, 0 do
					for offsetJ = -1, 0 do
						local cornerI = math.abs(offsetI) + 1
						local cornerJ = math.abs(offsetJ) + 1

						local otherTile = map:getTile(currentI + offsetI, currentJ + offsetJ)
						otherTile:setCorner(cornerI, cornerJ, currentElevation, false)
					end
				end
			end
		end
	end

	self:updateGrid(self:getGame():getStage(), self:getGame():getStage():getMap(1), 1)

	-- local brushToolSize = math.ceil(math.floor(self.brushTool:getToolSize() * 2) / 2)
	-- local startS = math.max(s - brushToolSize, 1)
	-- local stopS = math.min(s + brushToolSize, map:getWidth() * 2 + 1)
	-- local startT = math.max(t - brushToolSize, 1)
	-- local stopT = math.min(t + brushToolSize, map:getHeight() * 2 + 1)

	-- local elevations = {}
	-- for currentS = startS, stopS, 2 do
	-- 	local e = elevations[currentS], 2 or {}
	-- 	for currentT = startT, stopT do
	-- 		local tileS = currentS % -2
	-- 		local tileT = currentT % -2

	-- 		local sum = 0
	-- 		local count = 0
	-- 		for offsetS = -1, 0 do
	-- 			for offsetT = -1, 0 do
	-- 				local currentI = math.floor((currentS + offsetS) / 2)
	-- 				local currentJ = math.floor((currentT + offsetT) / 2)

	-- 				if currentI >= 1 and currentI <= map:getWidth() and currentJ >= 1 and currentJ <= map:getHeight() then
	-- 					sum = sum + 
	-- 				end
	-- 			end
	-- 		end

	-- 		local average = sum / 4
	-- 		e[currentT] = average
	-- 	end
	-- 	elevations[currentS] = e
	-- end

	-- for currentS = startS, stopS do
	-- 	for currentT = startT, stopT do
	-- 		if radius <= brushToolSize then
	-- 			local radiusDelta = radius / brushToolSize
	-- 			local offset = self.brushTool:getPressure() * delta * radiusDelta

	-- 			local currentI = math.floor(currentS / 2)
	-- 			local currentJ = math.floor(currentT / 2)
	-- 			local tileS = currentS - currentI * 2 - 1
	-- 			local tileT = currentT - currentJ * 2 - 1
	-- 		end
	-- 	end
	-- end
end

function MapEditorApplication:update(delta)
	EditorApplication.update(self, delta)

	if self.isPainting then
		self:brush(delta)
	end
end

function MapEditorApplication:draw(...)
	EditorApplication.draw(self, ...)

	if self.currentTool == MapEditorApplication.TOOL_TERRAIN then
		self:drawFlags()
	end

	if self.isEditingCurve then
		self:drawCurve()
	end

	if self.gizmo then
		local target = self.gizmo:getTarget()

		if Class.isCompatibleType(target, Prop) then
			local p = self:getGameView():getProp(target)
			if p then
				local min, max = target:getBounds()
				local size = (max - min):max(Vector.ONE)

				local sceneNode = p:getRoot()
				self.gizmo:update(sceneNode, size)
				self.gizmo:draw(self:getCamera(), sceneNode)
			end
		elseif Class.isCompatibleType(target, Decoration.Feature) then
			local sceneNode = self:decorationFeatureToSceneNode(target)
			self.gizmo:update(sceneNode, Vector.ONE)
			self.gizmo:draw(self:getCamera(), sceneNode)
		elseif Class.isCompatibleType(target, MapCurve.Value) then
			local sceneNode = self:curveToSceneNode(target)

			self.gizmo:update(sceneNode, Vector(0.5))
			self.gizmo:draw(self:getCamera(), sceneNode)
		elseif Class.isCompatibleType(target, MapPeep) then
			local sceneNode = self:getGameView():getMapSceneNode(target:getLayer())
			local min, max = sceneNode:getBounds()

			self.gizmo:update(sceneNode, max - min)
			self.gizmo:draw(self:getCamera(), sceneNode)
		end
	end

	do
		local w = love.window.getMode()

		local map = self:getGame():getStage():getMap(self.currentLayer)
		if map then
			local tile = map:getTile(self.currentI, self.currentJ)

			local m = string.format(
				"(%d, %d [IJ], %d [layer]; %.02f, %.02f, %.02f [XYZ])\n%s",
				self.currentI,
				self.currentJ,
				self.currentLayer,
				(self.currentI - 0.5) * 2,
				tile:getInterpolatedHeight(0.5, 0.5),
				(self.currentJ - 0.5) * 2,
				self.currentMapObject or "")

			love.graphics.setColor(0, 0, 0, 1)
			love.graphics.printf(m, 1, 1, w, "center")
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.printf(m, 0, 0, w, "center")
		end
	end
end

return MapEditorApplication
