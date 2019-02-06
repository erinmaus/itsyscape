--------------------------------------------------------------------------------
-- ItsyScape/Graphics/TitleScreen.lua
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
local XYZQuadSceneNode = require "ItsyScape.Graphics.XYZQuadSceneNode"
local Renderer = require "ItsyScape.Graphics.Renderer"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local FontResource = require "ItsyScape.Graphics.FontResource"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local WaterMeshSceneNode = require "ItsyScape.Graphics.WaterMeshSceneNode"
local DebugCubeSceneNode = require "ItsyScape.Graphics.DebugCubeSceneNode"
local WaterMesh = require "ItsyScape.World.WaterMesh"

local TitleScreen = Class()
TitleScreen.SPEED = math.pi / 16

function TitleScreen:new(resources, id)
	self.id = id
	self.resources = resources
	self.time = 0

	local filename = string.format("Resources/Game/TitleScreens/%s/", id)
	local data = "return " .. (love.filesystem.read(filename .. "Scene.lua") or "")
	local chunk = assert(loadstring(data))
	local t = setfenv(chunk, {})() or {}

	self:load(filename, t)

	self.renderer = Renderer()
	self.camera = ThirdPersonCamera()
	self.camera:setUp(Vector(0, -1, 0))
	self.camera:setHorizontalRotation(-math.pi / 6)
	self.camera:setVerticalRotation(-math.pi / 2)
	self.camera:setDistance(15)
	self.camera:setPosition(Vector(0, 1, 16))
end

function TitleScreen:getScene()
	return self.scene
end

function TitleScreen:getResources()
	return self.resources
end

function TitleScreen:getID()
	return self.id
end

function TitleScreen:getCamera()
	return self.camera
end

function TitleScreen:load(filename, t)
	self.scene = SceneNode()

	self.groundWidth = 0
	self.groundHeight = 0

	self.resources:queue(
		TextureResource,
		"Resources/Game/TitleScreens/Logo.png",
		function(texture)
			self.logo = texture
		end)
	self.resources:queue(
		FontResource,
		"Resources/Renderers/Widget/Common/Serif/Bold.ttf@48",
		function(font)
			self.font = font
		end)

	local ground = t.ground or {}
	self.ground = {}
	for i = 1, #ground do
		self.resources:queue(
			TextureResource,
			filename .. ground[i][1],
			function(texture)
				local root = SceneNode()
				root:setParent(self.scene)

				local quad = XYZQuadSceneNode(0.5, 0.5, 0.5)
				quad:getMaterial():setTextures(texture)
				quad:getTransform():setLocalRotation(Quaternion.fromAxisAngle(-Vector.UNIT_X, math.pi / 2))
				quad:setParent(root)

				self.groundWidth = math.max(texture:getWidth(), self.groundWidth)
				self.groundHeight = math.max(texture:getHeight(), self.groundHeight)

				table.insert(self.ground, {
					node = root,
					quad = quad
				})
			end)
	end

	local definitions = t.models or {}
	local models = t.scene or {}
	self.models = {}
	for i = 1, #models do
		local model = models[i]
		local definition = definitions[model.model]
		if definition then
			self.resources:queue(
				TextureResource,
				filename .. definition,
				function(texture)
					local scaleX = texture:getWidth() / self.groundWidth / 2
					local scaleY = texture:getHeight() / self.groundHeight / 2
					local positionX = model.x / self.groundWidth - 0.5
					local positionZ = (1 - model.z / self.groundHeight) + 0.5

					local root = SceneNode()
					root:setParent(self.scene)
					root:getTransform():setLocalTranslation(Vector(0, 0, 1))
					local quad = XYZQuadSceneNode(scaleX, scaleY, 1)
					quad:getMaterial():setTextures(texture)

					quad:setParent(root)
					quad:getTransform():setLocalTranslation(Vector(positionX, scaleY - 0.5, positionZ))

					table.insert(self.models, {
						node = root,
						quad = quad,
						x = positionX,
						y = scaleY,
						z = positionZ
					})
				end)
		end
	end

	local water = t.water or {}
	self.water = {}
	for i = 1, #water do
		local filename = string.format("Resources/Game/Water/%s/Texture.png", water[i][1])
		self.resources:queue(
			TextureResource,
			filename,
			function(texture)
				local node = SceneNode()
				node:setParent(self.scene)
				node:getTransform():setLocalScale(Vector(1 / 8, 1, 1 / 8))
				local waterMesh = WaterMesh(64, 64)
				local water = WaterMeshSceneNode()
				water:setYOffset(1 / 64)
				water:setMesh(waterMesh)
				water:getTransform():setLocalTranslation(Vector(-32, -0.55, -32))
				water:setParent(node)
				water:getMaterial():setTextures(texture)

				table.insert(self.water, {
					node = node,
					water = water
				})
			end)
	end

	self.resources:queueEvent(function()
		local scale = math.max(self.groundWidth, self.groundHeight) / 32
		self.scene:getTransform():setLocalScale(Vector(scale))
	end)
end

function TitleScreen:update(delta)
	self.time = self.time + delta

	local angle = self.time * self.SPEED
	local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, angle)

	for i = 1, #self.ground do
		local ground = self.ground[i].node
		ground:getTransform():setLocalRotation(rotation)
	end

	for i = 1, #self.water do
		local water = self.water[i].node
		water:getTransform():setLocalRotation(rotation)
	end
	--self.scene:getTransform():setLocalRotation(rotation)
	--self.scene:getTransform():setPreviousTransform(nil, rotation, nil)

	local antiRotation = Quaternion.fromAxisAngle(-Vector.UNIT_Y, angle)
	for i = 1, #self.models do
		local t = self.models[i]
		local position
		do
			local tx = t.x
			local tz = t.z - 1
			local x = tx * math.cos(-angle) - tz * math.sin(-angle)
			local y = t.y - 0.5
			local z = tz * math.cos(-angle) + tx * math.sin(-angle)
			position = Vector(x, y, z)
		end

		t.quad:getTransform():setLocalTranslation(position)
		--t.node:getTransform():setLocalRotation(antiRotation)
		t.quad:getTransform():setPreviousTransform(position, nil, nil)
		--t.node:getTransform():setPreviousTransform(nil, antiRotation, nil)
	end
end

function TitleScreen:draw()
	local width, height = love.window.getMode()

	self.camera:setWidth(width)
	self.camera:setHeight(height)

	love.graphics.push('all')
	self.renderer:setCamera(self.camera)
	self.renderer:draw(self.scene, 0)
	self.renderer:present()
	love.graphics.pop()

	if self.logo and self.font then
		love.graphics.draw(
			self.logo:getResource(),
			width / 2 - self.logo:getWidth() / 2,
			self.logo:getHeight() / 4)

		local alpha = math.abs(math.sin(self.time)) * 0.5 + 0.5
		local previousFont = love.graphics.getFont()
		love.graphics.setFont(self.font:getResource())
		love.graphics.setColor(0, 0, 0, alpha)
		love.graphics.printf(
			"Click to Play",
			4,
			height - self.font:getResource():getHeight() * 2 + 4,
			width,
			'center')
		love.graphics.setColor(1, 1, 1, alpha)
		love.graphics.printf(
			"Click to Play",
			0,
			height - self.font:getResource():getHeight() * 2,
			width,
			'center')
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setFont(previousFont)
	end
end


return TitleScreen
