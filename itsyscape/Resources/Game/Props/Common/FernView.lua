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

				local function onWillRender(renderer)
					local currentShader = renderer:getCurrentShader()
					if not currentShader then
						return
					end

					if currentShader:hasUniform("scape_BumpHeight") then
						currentShader:send("scape_BumpHeight", 1)
					end

					local _, layer = self:getProp():getPosition()
					local map = self:getGameView():getMap(layer)
					local windDirection, windSpeed, windPattern, actorCanvas = self:getGameView():getWind(layer)

					if currentShader:hasUniform("scape_BumpCanvas") then
						currentShader:send("scape_BumpCanvas", actorCanvas)
					end

					if currentShader:hasUniform("scape_BumpForce") then
						currentShader:send("scape_BumpForce", 0.25)
					end

					if currentShader:hasUniform("scape_MapSize") and map then
						currentShader:send("scape_MapSize", { map:getWidth() * map:getCellSize(), map:getHeight() * map:getCellSize() })
					end

					if currentShader:hasUniform("scape_WindDirection") then
						currentShader:send("scape_WindDirection", { windDirection:get() })
					end

					if currentShader:hasUniform("scape_WindSpeed") then
						currentShader:send("scape_WindSpeed", windSpeed)
					end

					if currentShader:hasUniform("scape_WindPattern") then
						currentShader:send("scape_WindPattern", { windPattern:get() })
					end

					if currentShader:hasUniform("scape_WindMaxDistance") then
						currentShader:send("scape_WindMaxDistance", 0.5)
					end

					if currentShader:hasUniform("scape_WallHackWindow") then
						currentShader:send("scape_WallHackWindow", { 0, 0, 0, 0 })
					end
				end

				self.frondNode:onWillRender(onWillRender)
				self.stemNode:onWillRender(onWillRender)
			end)
		end)
end

return FernView
