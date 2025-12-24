--------------------------------------------------------------------------------
-- Resources/Game/Props/ParadoxGate/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Decoration = require "ItsyScape.Graphics.Decoration"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local OldOneGlyphInstance = require "ItsyScape.Graphics.OldOneGlyphInstance"
local Material = require "ItsyScape.Graphics.Material"
local PropView = require "ItsyScape.Graphics.PropView"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local FlickerGreeble = require "Resources.Game.Props.Common.Greeble.FlickerGreeble"
local StaticGreeble = require "Resources.Game.Props.Common.Greeble.StaticGreeble"

local ParadoxGate = Class(PropView)

ParadoxGate.GLYPH_ANCHOR = Vector(6.7, 13.9, 0)

ParadoxGate.GLYPH_COLOR = Color.fromHexString("463779")
ParadoxGate.GLOW_COLOR = Color.fromHexString("f26722")
ParadoxGate.OUTLINE_COLOR = Color.fromHexString("000000")

ParadoxGate.FLOATING_CRYSTAL_MATERIAL = DecorationMaterial({
	shader = "Resources/Shaders/FloatingSpecularTriplanar",
	texture = "Resources/Game/Props/ParadoxGate/Crystal.png",

	uniforms = {
		scape_TriplanarScale = { "float", -0.5 },
		scape_TriplanarExponent = { "float", 0 },
		scape_TriplanarOffset = { "float", 0 },
		scape_SpecularWeight = { "float", 0 },
		scape_NumPatterns = { "integer", 4 },
		scape_Pattern = {
			"float",
			0.3, math.pi / 3, 0.1,
			0.2, math.pi / 4, 0.15,
			0.4, math.pi / 7, 0.05,
			0.5, math.pi / 5, 0.1,
		},
	},

	properties = {
		color = "a02c4b",
		outlineThreshold = 0.5,
		glassThickness = 0.5
	}
})

ParadoxGate.GLYPH_MATERIAL = DecorationMaterial({
	properties = {
		isTranslucent = true,
		isFullLit = true,
		alpha = 1,
		outlineThreshold = -1,
		glassThickness = 0.5
	}
})

ParadoxGate.MIN_NUM_FLOATING_CRYSTALS = 6
ParadoxGate.MIN_NUM_FLOATING_CRYSTALS = 10
ParadoxGate.MIN_NUM_ROWS              = 2
ParadoxGate.MAX_NUM_ROWS              = 4
ParadoxGate.MIN_FLOATING_CRYSTAL_OFFSET = -math.pi
ParadoxGate.MAX_FLOATING_CRYSTAL_OFFSET = math.pi
ParadoxGate.MIN_RADIUS = 4
ParadoxGate.MAX_RADIUS = 6
ParadoxGate.MIN_SCALE = 1
ParadoxGate.MAX_SCALE = 1.5

ParadoxGate.CANVAS_WIDTH  = 512
ParadoxGate.CANVAS_HEIGHT = 512

function ParadoxGate:new(...)
	PropView.new(self, ...)

	self.baseMarbleGreeble = self:addGreeble(StaticGreeble, {
		MESH = "Resources/Game/Props/ParadoxGate/Model.lstatic",
		GROUP = "base.marble",
		MATERIAL = DecorationMaterial({
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/ParadoxGate/Marble.png",

			properties = {
				outlineThreshold = 0.5,
				color = "a2a0b6"
			},

			uniforms = {
				scape_TriplanarScale = { "float", 0 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 1 }
			}
		})
	})

	self.baseCrystalGreeble = self:addGreeble(StaticGreeble, {
		MESH = "Resources/Game/Props/ParadoxGate/Model.lstatic",
		GROUP = "base.crystal",
		MATERIAL = DecorationMaterial({
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/ParadoxGate/Crystal.png",

			properties = {
				color = "a02c4b",
				outlineThreshold = 0.5,
				glassThickness = 0.5
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 1 }
			}
		})
	})

	self.baseMetalGreeble = self:addGreeble(StaticGreeble, {
		MESH = "Resources/Game/Props/ParadoxGate/Model.lstatic",
		GROUP = "base.metal",
		MATERIAL = DecorationMaterial({
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/ParadoxGate/Metal.png",

			properties = {
				outlineThreshold = -0.01,
				color = "ffa100"
			},

			uniforms = {
				scape_TriplanarScale = { "float", 0 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 1 }
			}
		})
	})

	self.flickerGreeble = self:addGreeble(FlickerGreeble, {
		MIN_ATTENUATION = 8,
		MAX_ATTENUATION = 12,

		COLORS = {
			self.GLYPH_COLOR
		}
	})
end

function ParadoxGate:load()
	PropView.load(self)

	self.glyphCanvas = love.graphics.newCanvas(self.CANVAS_WIDTH, self.CANVAS_HEIGHT)
	self.glyphTexture = TextureResource(self.glyphCanvas)

	self:buildCrystals()
	self:buildGlyph()
end

function ParadoxGate:buildCrystals()
	local resources = self:getResources()
	local root = self:getRoot()

	local decoration = Decoration()

	local tileI, tileJ = self:getProp():getTile()
	local rng = love.math.newRandomGenerator(tileI, tileJ)

	local numCrystals = rng:random(self.MIN_NUM_FLOATING_CRYSTALS, self.MAX_NUM_FLOATING_CRYSTALS)
	local offsetTheta = math.lerp(self.MIN_FLOATING_CRYSTAL_OFFSET, self.MAX_FLOATING_CRYSTAL_OFFSET, rng:random())
	local offsetPhi = math.lerp(self.MIN_FLOATING_CRYSTAL_OFFSET, self.MAX_FLOATING_CRYSTAL_OFFSET, rng:random())
	for i = 1, numCrystals do
		local radius = math.lerp(self.MIN_RADIUS, self.MAX_RADIUS, rng:random())

		local theta = offsetTheta * i
		local phi = offsetPhi * i
		local x = radius * math.cos(theta) * math.cos(phi)
		local y = radius * math.cos(theta) * math.sin(phi)
		local z = radius * math.sin(phi)

		local position = Vector(x, y, z)
		local scale = Vector(math.lerp(self.MIN_SCALE, self.MAX_SCALE, rng:random()))
		local rotation = Quaternion.fromEulerXYZ(
			math.lerp(self.MIN_FLOATING_CRYSTAL_OFFSET, self.MAX_FLOATING_CRYSTAL_OFFSET, rng:random()),
			math.lerp(self.MIN_FLOATING_CRYSTAL_OFFSET, self.MAX_FLOATING_CRYSTAL_OFFSET, rng:random()),
			math.lerp(self.MIN_FLOATING_CRYSTAL_OFFSET, self.MAX_FLOATING_CRYSTAL_OFFSET, rng:random()))

		decoration:add(
			"floating.crystal",
			self.GLYPH_ANCHOR + position,
			rotation,
			scale)
	end

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/ParadoxGate/Model.lstatic",
		function(mesh)
			self.mesh = mesh

			if self.crystalsNode then
				self.crystalsNode:setParent(false)
			end

			self.crystalsNode = DecorationSceneNode()
			self.crystalsNode:fromDecoration(decoration, mesh:getResource())
			self.crystalsNode:setParent(root)

			self.FLOATING_CRYSTAL_MATERIAL:apply(self.crystalsNode, self:getResources())
		end)
end

function ParadoxGate:buildGlyph()
	local resources = self:getResources()
	local root = self:getRoot()

	local tileI, tileJ = self:getProp():getTile()
	local rng = love.math.newRandomGenerator(tileI, tileJ)

	local glyphManager = self:getGameView():getGlyphManager()
	local glyphIndex = rng:random(1, 255)
	local glyph = glyphManager:get(glyphIndex)

	self.glyphInstance = OldOneGlyphInstance(glyph, glyphManager)

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/ParadoxGate/Model.lstatic",
		function(mesh)
			self.mesh = mesh

			if self.glyphNode then
				self.glyphNode:setParent(false)
			end

			self.glyphNode = DecorationSceneNode()
			self.glyphNode:fromGroup(mesh:getResource(), "glyph")
			self.glyphNode:setParent(root)
			self.glyphNode:getTransform():setLocalTranslation(self.GLYPH_ANCHOR)

			self.GLYPH_MATERIAL:apply(self.glyphNode, self:getResources())

			self:getResources():queueEvent(function()
				self.glyphNode:getMaterial():setTextures(self.glyphTexture)
			end)
		end)
end

function ParadoxGate:tick()
	PropView.tick(self)

	local state = self:getProp():getState()

	local nextTime = state.time or 0
	self.previousTime = self.currentTime or nextTime
	self.currentTime = nextTime

	local tileI, tileJ = self:getProp():getTile()
	if tileI ~= self.currentI and tileJ ~= self.currentJ then
		self.currentI = tileI
		self.currentJ = tileJ
		self:buildCrystals()
		self:buildGlyph()
	end
end

function ParadoxGate:update(delta)
	PropView.update(self, delta)

	if self.crystalsNode then
		self.crystalsNode:getMaterial():send(Material.UNIFORM_FLOAT, "scape_Time", love.timer.getTime())
	end

	self:drawGlyph()
end

function ParadoxGate:drawGlyph()
	local time = math.lerp(self.previousTime or 0, self.currentTime or 0, _APP:getFrameDelta())

	local glyphManager = self:getGameView():getGlyphManager()
	local planeNormal, planeD = glyphManager:getStandardPlane(time)
	local projections = glyphManager:asyncProjectAll(self, self.glyphInstance, planeNormal, planeD, time)

	love.graphics.push("all")
	love.graphics.setCanvas({ self.glyphCanvas, depthstencil = true })
	love.graphics.clear(0, 0, 0, 0)

	self:_drawGlyph(
		self.glyphInstance,
		projections,
		math.abs(math.sin(time / 8 * math.pi)) * 0.5 + 0.6,
		self.GLOW_COLOR,
		0.5)

	self:_drawGlyph(
		self.glyphInstance,
		projections,
		0.5,
		self.OUTLINE_COLOR,
		1)

	self:_drawGlyph(
		self.glyphInstance,
		projections,
		0,
		self.GLYPH_COLOR,
		1)

	love.graphics.pop()
end

function ParadoxGate:_drawGlyph(glyph, projections, offset, color, alpha)
	local glyphManager = self:getGameView():getGlyphManager()
	local width, height = self.glyphTexture:getWidth(), self.glyphTexture:getHeight()

	love.graphics.push("all")

	local r, g, b = color:get()
	love.graphics.setColor(r, g, b, alpha)

	glyphManager:draw(
		glyph,
		projections,
		0, 0,
		width, height,
		math.max(width, height) / 2,
		offset)

	love.graphics.pop()
end

return ParadoxGate
