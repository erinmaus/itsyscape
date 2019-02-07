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
local Color = require "ItsyScape.Graphics.Color"
local Renderer = require "ItsyScape.Graphics.Renderer"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local FontResource = require "ItsyScape.Graphics.FontResource"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local WaterMeshSceneNode = require "ItsyScape.Graphics.WaterMeshSceneNode"
local WaterMesh = require "ItsyScape.World.WaterMesh"
local XYZQuadSceneNode = require "ItsyScape.Graphics.XYZQuadSceneNode"

local TitleScreen = Class()
function TitleScreen.performRotate(position, angle)
	local tx = position.x
	local tz = position.z - 1

	local x = tx * math.cos(-angle) - tz * math.sin(-angle)
	local y = position.y - 0.5
	local z = tz * math.cos(-angle) + tx * math.sin(-angle)

	return Vector(x, y, z)
end

TitleScreen.SPEED = math.pi / 16

TitleScreen.Model = Class()
function TitleScreen.Model:new(node, quad, position)
	self.node = node
	self.quad = quad
	self.position = position
end

function TitleScreen.Model:getNode()
	return self.node
end

function TitleScreen.Model:getQuad()
	return self.quad
end

function TitleScreen.Model:getPosition()
	return self.position
end

function TitleScreen.Model:rotate(angle)
	local position = TitleScreen.performRotate(self.position, angle)

	self.quad:getTransform():setLocalTranslation(position)
	self.quad:getTransform():setPreviousTransform(position, nil, nil)
end

TitleScreen.Ground = Class()
function TitleScreen.Ground:new(node, quad)
	self.node = node
	self.quad = quad
end

function TitleScreen.Ground:getNode()
	return self.node
end

function TitleScreen.Ground:getQuad()
	return self.quad
end

function TitleScreen.Ground:rotate(angle)
	local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, angle)
	self.node:getTransform():setLocalRotation(rotation)
	self.node:getTransform():setPreviousTransform(nil, rotation, nil)
end

TitleScreen.Water = Class()
function TitleScreen.Water:new(node, water)
	self.node = node
	self.water = water
end

function TitleScreen.Water:getNode()
	return self.node
end

function TitleScreen.Water:getQuad()
	return self.water
end

function TitleScreen.Water:rotate(angle)
	local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, angle)
	self.node:getTransform():setLocalRotation(rotation)
	self.node:getTransform():setPreviousTransform(nil, rotation, nil)
end

function TitleScreen:new(gameView, id)
	self.gameView = gameView
	self.id = id
	self.resources = gameView:getResourceManager()
	self.time = 0

	local filename = string.format("Resources/Game/TitleScreens/%s/", id)
	local data = "return " .. (love.filesystem.read(filename .. "Scene.lua") or "")
	local chunk = assert(loadstring(data))
	local t = setfenv(chunk, {})() or {}

	self:load(filename, t)

	self.renderer = Renderer()
	self.renderer:setClearColor(Color(0, 0, 0, 0))
	self.camera = ThirdPersonCamera()
	self.camera:setUp(Vector(0, -1, 0))
	self.camera:setHorizontalRotation(-math.pi / 12)
	self.camera:setVerticalRotation(-math.pi / 2)
	self.camera:setDistance(15)
	self.camera:setPosition(Vector(0, -1, 16))
end

function TitleScreen:getGameView()
	return self.gameView
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

function TitleScreen:getTime()
	return self.time
end

function TitleScreen:getAngle()
	return self.time * self.SPEED
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

				table.insert(self.ground, TitleScreen.Ground(root, quad))
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

					local position = Vector(positionX, scaleY, positionZ)

					local root = SceneNode()
					root:setParent(self.scene)
					root:getTransform():setLocalTranslation(Vector(0, 0, 1))

					local quad = XYZQuadSceneNode(scaleX, scaleY, 1)
					quad:getMaterial():setTextures(texture)
					quad:setParent(root)

					table.insert(self.models, TitleScreen.Model(root, quad, position))
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

				table.insert(self.water, TitleScreen.Water(node, water))
			end)
	end

	self.resources:queueEvent(function()
		local scale = math.max(self.groundWidth, self.groundHeight) / 32
		self.scene:getTransform():setLocalScale(Vector(scale))
	end)
end

function TitleScreen:getGround()
	return self.ground
end

function TitleScreen:getWater()
	return self.water
end

function TitleScreen:getModels()
	return self.models
end

function TitleScreen:update(delta)
	self.time = self.time + delta

	local angle = self:getAngle()

	for i = 1, #self.ground do
		self.ground[i]:rotate(angle)
	end

	for i = 1, #self.water do
		self.water[i]:rotate(angle)
	end

	for i = 1, #self.models do
		self.models[i]:rotate(angle)
	end
end

function TitleScreen:drawSkybox()
	local width, height = love.window.getMode()
	love.graphics.setColor(0, 0, 1, 1)
	love.graphics.rectangle('fill', 0, 0, width, height)

	love.graphics.setColor(1, 1, 1, 1)
end

function TitleScreen:draw()
	local width, height = love.window.getMode()

	self.camera:setWidth(width)
	self.camera:setHeight(height)

	self:drawSkybox()

	love.graphics.push('all')
	self.renderer:setCamera(self.camera)
	self.renderer:draw(self.scene, 0)
	love.graphics.pop()

	love.graphics.ortho(width, height)
	self.renderer:presentCurrent()

	self:drawTitle()
end

function TitleScreen:drawTitle()
	local width, height = love.window.getMode()

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
