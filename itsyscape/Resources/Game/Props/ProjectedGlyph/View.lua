--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Props/ProjectedGlyph/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local OldOneGlyphInstance = require "ItsyScape.Graphics.OldOneGlyphInstance"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local MapMeshSceneNode = require "ItsyScape.Graphics.MapMeshSceneNode"
local Map = require "ItsyScape.World.Map"
local MapMeshIslandProcessor = require "ItsyScape.World.MapMeshIslandProcessor"
local TileSet = require "ItsyScape.World.TileSet"
local MapMeshMask = require "ItsyScape.World.MapMeshMask"

local ProjectedGlyph = Class(PropView)

ProjectedGlyph.RESOLUTION = 256
ProjectedGlyph.MAX_TEXTURE_SIZE = 2048

function ProjectedGlyph:load()
	PropView.load(self)

	local resources = self:getResources()

	self.mask = MapMeshMask()

	self.shader = resources:load(
		ShaderResource,
		"Resources/Shaders/MapGroundProjection")

	self.tileSet = TileSet.loadFromFile(
		"Resources/Game/TileSets/Invisible/Layout.lua",
		false)

	self.light = PointLightSceneNode()
end

function ProjectedGlyph:generate()
	local gameView = self:getGameView()
	local map = gameView:getMap(self.currentLayer)
	if not map then
		return
	end

	local halfWidth = math.ceil(self.currentWidth / 2)
	local halfHeight = math.ceil(self.currentHeight / 2)

	local x = self.currentI - halfWidth
	local y = self.currentJ - halfHeight
	local w = halfWidth * 2 + 1
	local h = halfHeight * 2 + 1

	local center = map:getTileCenter(self.currentI, self.currentJ)
	center.y = 0

	local mapMesh = MapMeshSceneNode()
	mapMesh:fromMap(map, self.tileSet, x, y, w, h, MapMeshMask(), MapMeshIslandProcessor(map, self.tileSet))
	mapMesh:setParent(gameView:getMapSceneNode(self.currentLayer))
	mapMesh:getTransform():setLocalOffset(center)

	local canvasWidth = w * self.RESOLUTION
	local canvasHeight = h * self.RESOLUTION

	if canvasWidth > self.MAX_TEXTURE_SIZE or canvasHeight > self.MAX_TEXTURE_SIZE then
		if canvasWidth > canvasHeight then
			local ratio = self.MAX_TEXTURE_SIZE / canvasWidth
			canvasWidth = self.MAX_TEXTURE_SIZE
			canvasHeight = math.floor(canvasHeight * ratio)
		else
			local ratio = self.MAX_TEXTURE_SIZE / canvasHeight
			canvasWidth = math.floor(canvasWidth * ratio)
			canvasHeight = self.MAX_TEXTURE_SIZE
		end
	end

	self.canvas = love.graphics.newCanvas(canvasWidth, canvasHeight)
	self.texture = TextureResource(self.canvas)

	local material = mapMesh:getMaterial()
	material:send(material.UNIFORM_FLOAT, "scape_MapOffset", (x - 1) * map:getCellSize(), (y - 1) * map:getCellSize())
	material:send(material.UNIFORM_FLOAT, "scape_MapSize", w * map:getCellSize(), h * map:getCellSize())
	material:setTextures(self.texture)
	material:setShader(self.shader)
	material:setIsTranslucent(true)
	material:setIsFullLit(true)
	material:setOutlineThreshold(-1)
	material:setIsShadowCaster(false)

	self.mapMesh = mapMesh
	self.mapMeshCenter = center
end

function ProjectedGlyph:remove()
	PropView.remove(self)

	if self.mapMesh then
		self.mapMesh:setParent()
	end
end

function ProjectedGlyph:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	local width, height = state.width or 4, state.height or 4
	local i, j, layer = self:getProp():getTile()

	if not (i == self.currentI and j == self.currentJ and layer == self.currentLayer and width == self.currentWidth and height == self.currentHeight) then
		if self.mapMesh then
			self.mapMesh:setParent()
		end

		self.currentI, self.currentJ, self.currentLayer = i, j, layer
		self.currentWidth, self.currentHeight = width, height
		self:generate()

		self.mapMesh:onWillRender(function()
			love.graphics.setMeshCullMode("none")
		end)
	end

	if self.mapMesh then
		local yOffset = Vector(0, state.elevation or 0, 0)

		self.mapMesh:getTransform():setLocalTranslation(yOffset)
		self.mapMesh:getTransform():tick(1)
	end

	local glyph = state.glyph or 0
	if glyph ~= self.currentGlyph then
		local glyphManager = self:getGameView():getGlyphManager()

		if type(glyph) == "string" then
			self.glyphInstance = glyphManager:tokenize(glyph)
		else
			local g = glyphManager:get(glyph)
			self.glyphInstance = OldOneGlyphInstance(g, glyphManager)
		end

		self.currentGlyph = glyph
	end

	self.light:setColor(Color(unpack(state.glyphColor)))
	self.light:setAttenuation(math.max(width, height) * 2)
	self.light:getTransform():setLocalTranslation(Vector(0, math.min(width, height), 0))

	local nextTime = state.time or 0
	self.previousTime = self.currentTime or nextTime
	self.currentTime = nextTime
end

function ProjectedGlyph:_drawRite(glyph, projections, offset, color)
	local glyphManager = self:getGameView():getGlyphManager()
	local width, height = self.texture:getWidth(), self.texture:getHeight()

	love.graphics.push("all")
	love.graphics.setColor(color:get())
	love.graphics.setBlendMode("alpha")

	glyphManager:draw(
		glyph,
		projections,
		1, 1,
		width - 2, height - 2,
		math.max(width, height) / 4,
		offset)

	love.graphics.pop()
end

function ProjectedGlyph:update()
	local state = self:getProp():getState()

	if self.mapMesh then
		self.mapMesh:getMaterial():setAlpha(state.alpha or 1)
	end

	local time = math.lerp(self.previousTime or 0, self.currentTime or 0, _APP:getFrameDelta())

	local glowColor = Color(unpack(state.glowColor))
	local glyphColor = Color(unpack(state.glyphColor))
	local outlineColor = Color(unpack(state.outlineColor))

	local glyphManager = self:getGameView():getGlyphManager()
	local planeNormal, planeD = glyphManager:getStandardPlane(time)
	local projections = glyphManager:asyncProjectAll(self, self.glyphInstance, planeNormal, planeD, time)

	love.graphics.push("all")
	love.graphics.setCanvas({ self.canvas, stencil = true })
	love.graphics.clear(0, 0, 0, 0)

	self:_drawRite(
		self.glyphInstance,
		projections,
		math.abs(math.sin(time / 8 * math.pi)) * 0.5 + 1,
		glowColor,
		0.5)

	self:_drawRite(
		self.glyphInstance,
		projections,
		0.5,
		outlineColor,
		1)

	self:_drawRite(
		self.glyphInstance,
		projections,
		0,
		glyphColor,
		1)

	love.graphics.pop()
end

return ProjectedGlyph
