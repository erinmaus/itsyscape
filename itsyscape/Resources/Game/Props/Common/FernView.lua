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
local Spline = require "ItsyScape.Graphics.Spline"
local SplineSceneNode = require "ItsyScape.Graphics.SplineSceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local MapCurve = require "ItsyScape.World.MapCurve"

local FernView = Class(PropView)

FernView.MIN_FROND_CIRCLES = 2
FernView.MAX_FROND_CIRCLES = 4
FernView.MIN_FRONDS_PER_CIRCLE = 3
FernView.MAX_FRONDS_PER_CIRCLE = 5
FernView.MIN_SCALE = 0.2
FernView.MAX_SCALE = 0.3
FernView.MIN_RADIUS = 0.1
FernView.MAX_RADIUS = 1.0
FernView.STEP1 = 0.3
FernView.STEP2 = 0.6
FernView.STEP3 = 1.1

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

	self.frondNode = SplineSceneNode()
	self.stemNode = SplineSceneNode()

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
		"Resources/Shaders/TriPlanar",
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
	resources:queueEvent(function()
		local i, j = self:getProp():getTile()
		local rng = love.math.newRandomGenerator(i, j)

		local numCircles = rng:random(self.MIN_FROND_CIRCLES, self.MAX_FROND_CIRCLES)

		local frondsMin, frondsMax = self.mesh:getResource():computeBounds("Fronds")
		local frondSpline = Spline()
		local stemSpline = Spline()
		for i = 1, numCircles do
			local circleDelta = (i - 1) / (numCircles - 1)
			local numFronds = math.floor(math.lerp(self.MIN_FRONDS_PER_CIRCLE, self.MAX_FRONDS_PER_CIRCLE, circleDelta))
			local radius = math.lerp(self.MIN_RADIUS, self.MAX_RADIUS, circleDelta)
			local scale = math.lerp(self.MIN_SCALE, self.MAX_SCALE, circleDelta)
			local offset = rng:random() * math.pi * 2

			for j = 1, numFronds do
				local frondDelta = (j - 1) / numFronds

				local angle = frondDelta * math.pi * 2 + offset
				local x = math.cos(angle)
				local z = math.sin(angle)
				local rotation = Quaternion.lookAt(Vector.ZERO, Vector(x, 0, z), Vector.UNIT_Z)

				local mapCurve = MapCurve(nil, {
					width = 0,
					height = 0,
					unit = 1,
					min = { frondsMin:get() },
					max = { frondsMax:get() },
					axis = { 0, 0, 1 },
					positions = {
						{
							x * radius,
							0,
							z * radius,
						},
						{
							x * (radius + self.STEP1),
							(frondsMax.z - frondsMin.z) / 3 * scale,
							z * (radius + self.STEP1),
						},
						{
							x * (radius + self.STEP2),
							(frondsMax.z - frondsMin.z) * scale,
							z * (radius + self.STEP2),
						},
						{
							x * (radius + self.STEP3),
							(frondsMax.z - frondsMin.z) * (2 / 3) * scale,
							z * (radius + self.STEP3),
						}
					},

					normals = {
						{ -x, 0, -z }
					},

					rotations = {
						{ rotation:get() }
					},

					scales = {
						{ scale, scale, scale }
					}
				})

				frondSpline:add("Fronds", mapCurve)
				stemSpline:add("Stem", mapCurve)
			end
		end

		self.frondNode:fromSpline(frondSpline, self.mesh:getResource())
		self.frondNode:getMaterial():setShader(self.frondShader)
		self.frondNode:getMaterial():setTextures(self.frondTexture)
		self.frondNode:setParent(root)

		self.stemNode:fromSpline(stemSpline, self.mesh:getResource())
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

			if currentShader:hasUniform("scape_ActorCanvas") then
				currentShader:send("scape_ActorCanvas", actorCanvas)
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

			if currentShader:hasUniform("scape_EnableActorBump") then
				currentShader:send("scape_EnableActorBump", 1)
			end

			if currentShader:hasUniform("scape_WallHackWindow") then
				currentShader:send("scape_WallHackWindow", { 0, 0, 0, 0 })
			end
		end

		self.frondNode:onWillRender(onWillRender)
		self.stemNode:onWillRender(onWillRender)
	end)
end

return FernView
