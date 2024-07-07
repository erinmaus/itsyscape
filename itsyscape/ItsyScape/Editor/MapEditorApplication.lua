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
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local GameDB = require "ItsyScape.GameDB.GameDB"
local Utility = require "ItsyScape.Game.Utility"
local Prop = require "ItsyScape.Game.Model.Prop"
local EditorApplication = require "ItsyScape.Editor.EditorApplication"
local AlertWindow = require "ItsyScape.Editor.Common.AlertWindow"
local ColorPalette = require "ItsyScape.Editor.Common.ColorPalette"
local ConfirmWindow = require "ItsyScape.Editor.Common.ConfirmWindow"
local PromptWindow = require "ItsyScape.Editor.Common.PromptWindow"
local DecorationList = require "ItsyScape.Editor.Map.DecorationList"
local DecorationPalette = require "ItsyScape.Editor.Map.DecorationPalette"
local Gizmo = require "ItsyScape.Editor.Map.Gizmo"
local LandscapeToolPanel = require "ItsyScape.Editor.Map.LandscapeToolPanel"
local PropPalette = require "ItsyScape.Editor.Map.PropPalette"
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
local TileSet = require "ItsyScape.World.TileSet"

local MapEditorApplication = Class(EditorApplication)
MapEditorApplication.TOOL_NONE = 0
MapEditorApplication.TOOL_TERRAIN = 1
MapEditorApplication.TOOL_PAINT = 2
MapEditorApplication.TOOL_DECORATE = 3
MapEditorApplication.TOOL_PROP = 4
MapEditorApplication.TOOL_CURVE = 5

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

	self.decorationList.onSelect:register(self.onSelectDecorationGroup, self)

	self.windows = {
		self.decorationList,
		self.decorationPalette,
		self.landscapeToolPanel,
		self.terrainToolPanel,
		self.tileSetPalette,
		self.propPalette
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

	self.currentFeatureIndex = false
	self.lastProp = false
	self.filename = false

	self.propNames = {}

	self:getGameView():getRenderer():setClearColor(self:getGameView():getRenderer():getClearColor() * 0.7)

	self:getGameView():getResourceManager():setFrameDuration(1)
end

function MapEditorApplication:beginEditCurve(map, curve)
	if curve then
		self.curve = MapCurve(map == nil and self:getGame():getStage():getMap(1) or map, curve)
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

		local map = self:getGame():getStage():getMap(1)
		self:beginEditCurve(nil, self.curve and self.curve:toConfig() or {
			min = { 0, 0, 0 },
			max = { map:getWidth() * map:getCellSize(), 0, map:getHeight() * map:getCellSize() },
			axis = { 0, 0, 1 },
			positions = { { map:getWidth() * map:getCellSize() / 2, 0, map:getHeight() * map:getCellSize() / 2 } },
			normals = { { 0, 1, 0 } },
			scales = { { 1, 1, 1 } },
			rotations = { { Quaternion.IDENTITY:get() } }
		})

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
		if self.curve:getPositions():length() >= 2 then
			self:getGameView():bendMap(1, self.curve:toConfig())
		else
			self:getGameView():bendMap(1)
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
	if layer == 1 then
		self.mapGridSceneNode:fromMap(map, false)
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

		local s = self.landscapeToolPanel:getToolSize()
		if s >= 0 then
			i = i - s
			j = j - s
			s = s * 2 + 1
			width, height = s, s
		end
	end

	local map = self:getGame():getStage():getMap(1)
	local mode = self.landscapeToolPanel:getMode()

	if map then
		if width and height then
			for t = 1, height do
				for s = 1, width do
					local u = i + s - 1
					local v = j + t - 1

					if u >= 1 and u <= map:getWidth() and
					   v >= 1 and v <= map:getHeight()
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
				self:makeMotion(x, y, button)
				self.motion:onMousePressed(self:makeMotionEvent(x, y, button))

				if not self.currentToolNode then
					self:makeCurrentToolNode()
				end

				local _, i, j = self.motion:getTile()
				self.currentToolNode:fromMap(
					self:getGame():getStage():getMap(1),
					motion,
					i, i, j, j)
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
						local tile = self.decorationPalette:getCurrentGroup()
						if tile then
							local motion = MapMotion(self:getGame():getStage():getMap(1))
							motion:onMousePressed(self:makeMotionEvent(x, y, button))

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
								self:getGame():getStage():decorate(group, decoration)
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
							local motion = MapMotion(self:getGame():getStage():getMap(1))
							motion:onMousePressed(self:makeMotionEvent(x, y, button))

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
			local motion
			if self.motion then
				motion = self.motion
			else
				motion = MapMotion(self:getGame():getStage():getMap(1))
				motion:onMousePressed(self:makeMotionEvent(x, y, 1))
			end

			local _, i, j = motion:getTile()
			self.previousI = self.currentI
			self.previousJ = self.currentJ
			self.currentI = i
			self.currentJ = j
		end

		if self.currentTool == MapEditorApplication.TOOL_TERRAIN then
			local motion
			if self.motion then
				motion = self.motion
			else
				motion = MapMotion(self:getGame():getStage():getMap(1))
				motion:onMousePressed(self:makeMotionEvent(x, y, 1))
			end

			local _, i, j = motion:getTile()
			if not self.currentToolNode then
				self:makeCurrentToolNode()
			end

			local size = math.max(self.terrainToolPanel.toolSize - 1, 0)
			self.currentToolNode:fromMap(
				self:getGame():getStage():getMap(1),
				motion,
				i - size,
				i + size,
				j - size,
				j + size)

			local isShiftDown = love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift')

			if love.keyboard.isDown('i') and isShiftDown then
				local map = self:getGame():getStage():getMap(1)
				local tile = map:getTile(self.currentI, self.currentJ)
				tile:setFlag('impassable')
			elseif love.keyboard.isDown('b') and isShiftDown then
				local map = self:getGame():getStage():getMap(1)
				local tile = map:getTile(self.currentI, self.currentJ)
				tile:setFlag('building')
			end
		elseif self.currentTool == MapEditorApplication.TOOL_PAINT then
			if not self.currentToolNode then
				self:makeCurrentToolNode()
			end

			local motion
			if not self.motion then
				motion = MapMotion(self:getGame():getStage():getMap(1))
				motion:onMousePressed(self:makeMotionEvent(x, y, 1))
			else
				motion = self.motion
			end

			local _, i, j = motion:getTile()
			local size = math.max(self.landscapeToolPanel:getToolSize(), 0)
			self.currentToolNode:fromMap(
				self:getGame():getStage():getMap(1),
				false,
				i - size,
				i + size,
				j - size,
				j + size)

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
					self:getGameView():decorate(group, decoration, 1)
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
		if button == 1 and self.motion then
			self.motion:onMouseReleased(self:makeMotionEvent(x, y, button))
			self.motion = false
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
				self:setTool(MapEditorApplication.TOOL_TERRAIN)
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
					local map = self:getGame():getStage():getMap(1)
					local tile = map:getTile(self.currentI, self.currentJ)
					if tile:hasFlag('impassable') then
						tile:unsetFlag('impassable')
					else
						tile:setFlag('impassable')
					end
				elseif key == 'b' then
					local map = self:getGame():getStage():getMap(1)

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
				elseif key == "delete" then
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

									self:getGame():getStage():decorate(group, decoration)

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
					elseif key == "delete" then
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
				elseif key == "delete" then
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

function MapEditorApplication:save(filename)
	if self:makeOutputDirectory("Maps", filename) then
		if not self:makeOutputSubdirectory("Maps", filename, "Decorations") then
			Log.warn("Couldn't save map %s.", filename)
			return false
		end

		local decorations = self:getGameView():getDecorations()
		for group, decoration in pairs(decorations) do
			local extension
			if Class.isCompatibleType(decoration, Decoration) then
				extension = "ldeco"
			elseif Class.isCompatibleType(decoration, Spline) then
				extension = "lspline"
			end

			if extension then
				local filename = self:getOutputFilename("Maps", filename, "Decorations", group .. "." .. extension)
				local s, r = love.filesystem.write(filename, decoration:toString())
				if not s then
					Log.warn(
						"Couldn't save decoration '%s' to %s: %s",
						group, filename, r)
				end
			end
		end

		local layers = { 1 }
		for i = 1, #layers do
			local map = self:getGame():getStage():getMap(layers[i])
			local index = tonumber(layers[i])
			if index then
				local filename = self:getOutputFilename(
					"Maps",
					filename,
					StringBuilder.stringify(index, "%d") .. ".lmap")
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
				meta[layers[i]] = {
					tileSetID = tileSetID,
					maskID = self.meta and self.meta[layers[i]] and self.meta and self.meta[layers[i]].maskID,
					autoMask = self.meta and self.meta[layers[i]] and self.meta[layers[i]].autoMask
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

			for prop in self:getGame():getStage():iterateProps() do
				local position = prop:getPosition()
				local rotation = prop:getRotation()
				local scale = prop:getScale()
				local name = self.propNames[prop]
				if name then
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

function MapEditorApplication:load(filename, preferExisting)
	self:unload()

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
			stage:newMap(
				map:getWidth(), map:getHeight(), layerMeta.tileSetID, layerMeta.maskID, 1)
			stage:updateMap(layer, map)
			stage:onMapMoved(layer, Vector.ZERO, Quaternion.IDENTITY, Vector.ONE, Vector.ZERO, false)
		end
	end

	self.meta = meta

	for _, item in ipairs(love.filesystem.getDirectoryItems(path .. "/Decorations")) do
		local decoration = item:match("(.*)%.ldeco$")
		local spline = item:match("(.*)%.lspline$")
		if decoration then
			local d = Decoration(path .. "Decorations/" .. item)
			self:getGame():getStage():decorate(decoration, d)
		elseif spline then
			local s = Spline(path .. "Decorations/" .. item)
			self:getGame():getStage():decorate(spline, s)
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

				do
					local prop = gameDB:getRecord("PropMapObject", {
						MapObject = objects[i]:get("Resource")
					})

					if prop then
						prop = prop:get("Prop")
						if prop then
							local s, p = self:getGame():getStage():placeProp("resource://" .. prop.name, 1, "::orphan")

							if s then
								local peep = p:getPeep()
								local position = peep:getBehavior(require "ItsyScape.Peep.Behaviors.PositionBehavior")
								position.position = Vector(x, y, z)
								local scale = peep:getBehavior(require "ItsyScape.Peep.Behaviors.ScaleBehavior")
								scale.scale = Vector(sx, sy, sz)
								local rotation = peep:getBehavior(require "ItsyScape.Peep.Behaviors.RotationBehavior")
								rotation.rotation = Quaternion(qx, qy, qz, qw)
							end

							local name = objects[i]:get("Name")
							self.propNames[name] = p
							self.propNames[p] = name
						end
					end
				end
			end
		end
	end

	return true
end

function MapEditorApplication:unload()
	local layers = self:getGame():getStage():getLayers()
	for i = 1, #layers do
		self:getGame():getStage():unloadMap(layers[i])
	end

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

	local map = self:getGame():getStage():getMap(1)
	for j = 1, map:getHeight() do
		for i = 1, map:getWidth() do
			local x = (i - 1) * map:getCellSize()
			local y = map:getTileCenter(i, j).y
			local z = (j - 1) * map:getCellSize()

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
			local map = self:getGame():getStage():getMap(1)
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
			sceneNode = self:curveToSceneNode(target)

			self.gizmo:update(sceneNode, Vector(0.5))
			self.gizmo:draw(self:getCamera(), sceneNode)
		end
	end

	do
		local w = love.window.getMode()

		local map = self:getGame():getStage():getMap(1)
		local tile = map:getTile(self.currentI, self.currentJ)

		local m = string.format(
			"(%d, %d [IJ]; %.02f, %.02f, %.02f [XYZ])\n%s",
			self.currentI,
			self.currentJ,
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

return MapEditorApplication
