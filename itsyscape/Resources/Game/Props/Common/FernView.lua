--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/FernView.lua
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
local PropView = require "ItsyScape.Graphics.PropView"
local Decoration = require "ItsyScape.Graphics.Decoration"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local MapCurve = require "ItsyScape.World.MapCurve"

local FernView = Class(PropView)

FernView.MIN_FROND_CIRCLES = 1
FernView.MAX_FROND_CIRCLES = 4
FernView.MIN_FRONDS_PER_CIRCLE = 3
FernView.MAX_FRONDS_PER_CIRCLE = 5
FernView.MIN_SCALE = 0.3
FernView.MAX_SCALE = 0.5
FernView.MIN_TILT = 0
FernView.MAX_TILT = math.pi / 8
FernView.MIN_RADIUS = 0
FernView.MAX_RADIUS = 0.25

function FernView:new(prop, gameView)
	PropView.new(self, prop, gameView)
end

function FernView:getBaseFilename()
	return Class.ABSTRACT()
end

function FernView:getResourcePath(resource)
	return string.format("%s/%s", self:getBaseFilename(), resource)
end

function FernView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.frondNode = DecorationSceneNode()
	self.stemNode = DecorationSceneNode()

	resources:queue(
		TextureResource,
		self:getResourcePath("Frond.png"),
		function(texture)
			self.frondTexture = texture
		end)
	resources:queue(
		TextureResource,
		self:getResourcePath("Bark.png"),
		function(texture)
			self.barkTexture = texture
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/BendyTriplanar",
		function(shader)
			self.stemShader = shader
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/BendyLeaf",
		function(shader)
			self.frondShader = shader
		end)
	resources:queue(
		StaticMeshResource,
		self:getResourcePath("Fern.lstatic"),
		function(mesh)
			self.mesh = mesh
		end)
	resources:queueEvent(
		function()
			resources:queueAsyncEvent(function()
				local i, j = self:getProp():getTile()
				local rng = love.math.newRandomGenerator(i, j)

				local numCircles = rng:random(self.MIN_FROND_CIRCLES, self.MAX_FROND_CIRCLES)

				local frondDecoration = Decoration()
				local stemDecoration = Decoration()
				for i = 1, numCircles do
					local circleDelta = (i - 1) / (numCircles - 1)
					local numFronds = math.floor(math.lerp(self.MIN_FRONDS_PER_CIRCLE, self.MAX_FRONDS_PER_CIRCLE, circleDelta))
					local radius = math.lerp(self.MIN_RADIUS, self.MAX_RADIUS, circleDelta)
					local scale = Vector(math.lerp(self.MIN_SCALE, self.MAX_SCALE, circleDelta))
					local offset = rng:random() * math.pi * 2
					local tilt = Quaternion.fromAxisAngle(Vector.UNIT_X, -math.lerp(self.MIN_TILT, self.MAX_TILT, circleDelta))

					for j = 1, numFronds do
						local frondDelta = (j - 1) / numFronds

						local angle = frondDelta * math.pi * 2 + offset
						local x = math.cos(angle)
						local z = math.sin(angle)

						local position = Vector(x * radius, 0, z * radius)
						local rotation = Quaternion.lookAt(Vector(x, 0, z), Vector.ZERO, Vector.UNIT_Z) * tilt
						rotation = rotation:getNormal()

						frondDecoration:add("Fronds", position, rotation, scale)
						stemDecoration:add("Stem", position, rotation, scale)
					end
				end

				self.frondNode:fromDecoration(frondDecoration, self.mesh:getResource())
				self.frondNode:getMaterial():setShader(self.frondShader)
				self.frondNode:getMaterial():setTextures(self.frondTexture)
				self.frondNode:setParent(root)

				self.stemNode:fromDecoration(stemDecoration, self.mesh:getResource())
				self.stemNode:getMaterial():setShader(self.stemShader)
				self.stemNode:getMaterial():setTextures(self.barkTexture)
				self.stemNode:getMaterial():setOutlineThreshold(-0.01)
				self.stemNode:setParent(root)
			end)
		end)
end

function FernView:_updateNodeUniforms(node)
	local _, layer = self:getProp():getPosition()
	local map = self:getGameView():getMap(layer)
	if not map then
		return
	end

	local windDirection, windSpeed, windPattern, bumpCanvas = self:getGameView():getWind(layer)

	local material = node:getMaterial()
	material:send(material.UNIFORM_FLOAT, "scape_BumpHeight", 1)
	material:send(material.UNIFORM_FLOAT, "scape_MapSize", map:getWidth() * map:getCellSize(), map:getHeight() * map:getCellSize())
	material:send(material.UNIFORM_FLOAT, "scape_WindDirection", windDirection:get())
	material:send(material.UNIFORM_FLOAT, "scape_WindSpeed", windSpeed)
	material:send(material.UNIFORM_FLOAT, "scape_BumpForce", 0.25)
	material:send(material.UNIFORM_TEXTURE, "scape_BumpCanvas", bumpCanvas)
	material:send(material.UNIFORM_FLOAT, "scape_WindPattern", windPattern:get())
	material:send(material.UNIFORM_FLOAT, "scape_WindMaxDistance", 0.25)
	material:send(material.UNIFORM_FLOAT, "scape_WallHackWindow", 0, 0, 0, 0)
end


function FernView:tick(...)
	PropView.tick(self, ...)

	self:_updateNodeUniforms(self.frondNode)
	self:_updateNodeUniforms(self.stemNode)
end

return FernView
