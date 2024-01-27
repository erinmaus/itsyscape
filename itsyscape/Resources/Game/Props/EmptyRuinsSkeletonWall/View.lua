--------------------------------------------------------------------------------
-- Resources/Game/Props/EmptyRuinsSkeletonWall.lua
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
local LayerTextureResource = require "ItsyScape.Graphics.LayerTextureResource"
local PropView = require "ItsyScape.Graphics.PropView"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"

local EmptyRuinsSkeletonWall = Class(PropView)
EmptyRuinsSkeletonWall.SHADER = ShaderResource()
do
	EmptyRuinsSkeletonWall.SHADER:loadFromFile("Resources/Shaders/EmptyRuinsSkullWall")
end

EmptyRuinsSkeletonWall.SceneNode = Class(SceneNode)

function EmptyRuinsSkeletonWall.SceneNode:new()
	SceneNode.new(self)

	self:getMaterial():setShader(EmptyRuinsSkeletonWall.SHADER)
	self:getMaterial():setIsLightTargetPositionEnabled(true)
	self:getMaterial():setIsTranslucent(true)

	self.mesh = false
end

function EmptyRuinsSkeletonWall.SceneNode:draw(renderer, delta)
	local shader = renderer:getCurrentShader()
	local texture = self:getMaterial():getTexture(1)
	if shader:hasUniform("scape_DiffuseTexture") and texture and texture:getIsReady() then
		shader:send("scape_DiffuseTexture", self:getMaterial():getTexture(1):getResource())
	end

	if self.mesh then
		love.graphics.draw(self.mesh)
	end
end

EmptyRuinsSkeletonWall.MIN_NUM_ATTEMPTS = 4
EmptyRuinsSkeletonWall.MAX_NUM_ATTEMPTS = 10

EmptyRuinsSkeletonWall.MIN_SKULL_SIZE = 1.25
EmptyRuinsSkeletonWall.MAX_SKULL_SIZE = 1.75

EmptyRuinsSkeletonWall.MIN_TIME = 0.25
EmptyRuinsSkeletonWall.MAX_TIME = 1

EmptyRuinsSkeletonWall.OFFSET = 1 / 8

EmptyRuinsSkeletonWall.SKULL_DIRECTION_FRONT = 0
EmptyRuinsSkeletonWall.SKULL_DIRECTION_LEFT  = 1
EmptyRuinsSkeletonWall.SKULL_DIRECTION_RIGHT = 2

EmptyRuinsSkeletonWall.SKULL_FADE_DIRECTION_TIME_SECONDS = 0.25

EmptyRuinsSkeletonWall.MESH_FORMAT = {
	{ "VertexPosition", "float", 3, },
	{ "VertexNormal", "float", 3 },
	{ "VertexTexture", "float", 2 },
	{ "VertexColor", "float", 4 },
	{ "VertexTextureLayer", "float", 2 },
	{ "VertexTextureTime", "float", 2 },
}

EmptyRuinsSkeletonWall.MESH_DATA = {
	{ Vector( 1, -1, 0), Vector(0, 0, 1), Vector(1.0, 0.0), Color(1.0, 1.0, 1.0, 1.0), 0, 0 },
	{ Vector(-1, -1, 0), Vector(0, 0, 1), Vector(0.0, 0.0), Color(1.0, 1.0, 1.0, 1.0), 0, 0 },
	{ Vector( 1,  1, 0), Vector(0, 0, 1), Vector(1.0, 1.0), Color(1.0, 1.0, 1.0, 1.0), 0, 0 },
	{ Vector(-1, -1, 0), Vector(0, 0, 1), Vector(0.0, 0.0), Color(1.0, 1.0, 1.0, 1.0), 0, 0 },
	{ Vector(-1,  1, 0), Vector(0, 0, 1), Vector(0.0, 1.0), Color(1.0, 1.0, 1.0, 1.0), 0, 0 },
	{ Vector( 1,  1, 0), Vector(0, 0, 1), Vector(1.0, 1.0), Color(1.0, 1.0, 1.0, 1.0), 0, 0 }
}

EmptyRuinsSkeletonWall.MESH_DATA_LAYER_INDEX = 13
EmptyRuinsSkeletonWall.MESH_DATA_TIME_INDEX  = 15

EmptyRuinsSkeletonWall.FADE_IN_DURATION = 1.25

function EmptyRuinsSkeletonWall:new(...)
	PropView.new(self, ...)

	self.skulls = {}
	self.vertices = {}
end

function EmptyRuinsSkeletonWall:load(...)
	PropView.load(self, ...)

	local resources = self:getResources()
	resources:queue(
		LayerTextureResource,
		"Resources/Game/Props/EmptyRuinsSkeletonWall/Texture.lua",
		function(texture)
			self.skullTexture = texture
			self.skullTexture:getResource():setWrap("repeat")
		end)
end

function EmptyRuinsSkeletonWall:_initMesh()
	table.clear(self.vertices)

	local min = Vector(math.huge)
	local max = Vector(-math.huge)

	for _, skull in ipairs(self.skulls) do
		local index = #self.vertices + 1
		skull.index = index

		for i = 1, #EmptyRuinsSkeletonWall.MESH_DATA do
			local inputVertex = EmptyRuinsSkeletonWall.MESH_DATA[i]

			local position = skull.rotation:transformVector(inputVertex[1] * (skull.halfSize)) - skull.normal * EmptyRuinsSkeletonWall.OFFSET + skull.position
			local normal = skull.normal
			local texture = inputVertex[3]
			local color = inputVertex[4]

			local outputVertex = {
				position.x,
				position.y,
				position.z,
				normal.x,
				normal.y,
				normal.z,
				texture.x,
				texture.y,
				color.r,
				color.g,
				color.b,
				color.a,
				0, 0,
				love.math.random() * (EmptyRuinsSkeletonWall.MAX_TIME - EmptyRuinsSkeletonWall.MIN_TIME) + EmptyRuinsSkeletonWall.MIN_TIME,
				1
			}

			min = min:min(position)
			max = max:max(position)

			table.insert(self.vertices, outputVertex)
		end

		coroutine.yield()
	end

	if #self.vertices > 0 then
		self.mesh = love.graphics.newMesh(
			EmptyRuinsSkeletonWall.MESH_FORMAT,
			self.vertices,
			'triangles',
			'dynamic')

		for _, attribute in ipairs(EmptyRuinsSkeletonWall.MESH_FORMAT) do
			self.mesh:setAttributeEnabled(attribute[1], true)
		end

		self.wallSceneNode = EmptyRuinsSkeletonWall.SceneNode()
		self.wallSceneNode:setParent(self:getRoot())
		self.wallSceneNode:getMaterial():setTextures(self.skullTexture)
		self.wallSceneNode.mesh = self.mesh
		self.wallSceneNode:setBounds(min, max)
	end
end

function EmptyRuinsSkeletonWall:_initSkulls()
	self:getResources():queueEvent(function()
		local gameView = self:getGameView()
		local decorations = gameView:getDecorations()
		local staticMeshes = gameView:getDecorationMeshes()
		local walls = {}

		for name, decoration in pairs(decorations) do
			if decoration:getTileSetID():match("EmptyRuinsSkull") and staticMeshes[name] then
				Log.info("Found '%s' to skull-ify.", name)	

				table.insert(walls, { decoration = decoration, name = name })
			end
		end

		table.clear(self.skulls)

		for _, d in ipairs(walls) do
			local decoration = d.decoration
			local name = d.name

			local triangles = {}

			for feature in decoration:iterate() do
				if feature:getID():match("skull") then
					feature:map(function(v1, v2, v3, normal) 
						if (math.abs(normal.x) > math.abs(normal.y) or math.abs(normal.z) > math.abs(normal.y))then
							table.insert(triangles, { vertices = { v1, v2, v3 }, normal = normal })
						end
					end, staticMeshes[name]:getResource())

					coroutine.yield()
				end
			end

			if #triangles > 0 then
				local numSkulls = love.math.random(EmptyRuinsSkeletonWall.MIN_NUM_ATTEMPTS, EmptyRuinsSkeletonWall.MAX_NUM_ATTEMPTS) * decoration:getNumFeatures()
				local skulls = {}
				for i = 1, numSkulls do
					local a = (love.math.random() + 1) / 4
					local b = (love.math.random() + 1) / 4

					local triangle = triangles[love.math.random(#triangles)]

					if a + b > 1 then
						a = 1 - a
						b = 1 - b
					end

					local v1 = triangle.vertices[1] - triangle.vertices[3]
					local v2 = triangle.vertices[2] - triangle.vertices[3]

					local p = a * v1 + b * v2 + triangle.vertices[3]
					local size = love.math.random() * (EmptyRuinsSkeletonWall.MAX_SKULL_SIZE - EmptyRuinsSkeletonWall.MIN_SKULL_SIZE) + EmptyRuinsSkeletonWall.MIN_SKULL_SIZE

					local isValid = true
					for _, skull in ipairs(skulls) do
						local distance = (skull.position - p):getLength()
						if distance < skull.size + size then
							isValid = false
							break
						end
					end

					local rotation
					do
						local x = triangle.normal.x
						local z = triangle.normal.z

						if x > 0 then
							rotation = Quaternion.Y_90
						elseif x < 0 then
							rotation = -Quaternion.Y_90
						elseif z > 0 then
							rotation = Quaternion.IDENTITY
						else -- z < 0 or a catch all case if somehow a +Y normal slipped through
							rotation = Quaternion.Y_180
						end
					end

					if isValid then
						local s = {
							position = p,
							size = size,
							halfSize = size / 2,
							normal = triangle.normal,
							rotation = rotation,
							time = love.timer.getTime()
						}

						table.insert(skulls, s)
						table.insert(self.skulls, s)
					end

					coroutine.yield()
				end
			end
		end

		self:_initMesh()

		self.isLoading = false
		self.isLoaded = true
	end)
end

function EmptyRuinsSkeletonWall:_updateSkulls(actors)
	for _, skull in ipairs(self.skulls) do
		local distance = math.huge
		local position = Vector.ZERO

		for _, actor in ipairs(actors) do
			local p = actor:getPosition()
			local d = ((p - skull.position) * Vector.PLANE_XZ):getLengthSquared()
			if d < distance then
				distance = d
				position = p
			end
		end

		if distance < math.huge then
			local direction
			do
				if math.abs(skull.normal.x) > math.abs(skull.normal.z) then
					local differenceZ = position.z - skull.position.z
					if differenceZ < -skull.halfSize then
						if skull.normal.x < 0 then
							direction = EmptyRuinsSkeletonWall.SKULL_DIRECTION_LEFT
						else
							direction = EmptyRuinsSkeletonWall.SKULL_DIRECTION_RIGHT
						end
					elseif differenceZ > skull.halfSize then
						if skull.normal.x < 0 then
							direction = EmptyRuinsSkeletonWall.SKULL_DIRECTION_RIGHT
						else
							direction = EmptyRuinsSkeletonWall.SKULL_DIRECTION_LEFT
						end
					else
						direction = EmptyRuinsSkeletonWall.SKULL_DIRECTION_FRONT
					end
				else
					local differenceX = position.x - skull.position.x
					if differenceX < -skull.halfSize then
						if skull.normal.z < 0 then
							direction = EmptyRuinsSkeletonWall.SKULL_DIRECTION_RIGHT
						else
							direction = EmptyRuinsSkeletonWall.SKULL_DIRECTION_LEFT
						end
					elseif differenceX > skull.halfSize then
						if skull.normal.z < 0 then
							direction = EmptyRuinsSkeletonWall.SKULL_DIRECTION_LEFT
						else
							direction = EmptyRuinsSkeletonWall.SKULL_DIRECTION_RIGHT
						end
					else
						direction = EmptyRuinsSkeletonWall.SKULL_DIRECTION_FRONT
					end
				end
			end

			if skull.currentDirection ~= direction then
				skull.previousDirection = skull.currentDirection or 0
				skull.currentDirection = direction

				skull.time = love.timer.getTime()
			end

			for i = skull.index, skull.index + #EmptyRuinsSkeletonWall.MESH_DATA - 1 do
				self.vertices[i][EmptyRuinsSkeletonWall.MESH_DATA_LAYER_INDEX] = skull.previousDirection
				self.vertices[i][EmptyRuinsSkeletonWall.MESH_DATA_LAYER_INDEX + 1] = skull.currentDirection
				self.vertices[i][EmptyRuinsSkeletonWall.MESH_DATA_TIME_INDEX + 1] = math.min((love.timer.getTime() - skull.time) / EmptyRuinsSkeletonWall.SKULL_FADE_DIRECTION_TIME_SECONDS, 1)
			end
		end
	end

	if self.mesh then
		self.mesh:setVertices(self.vertices)
	end
end

function EmptyRuinsSkeletonWall:tick()
	PropView.tick(self)

	if not next(self.skulls) and not self.isLoading then
		self.isLoading = true
		self:_initSkulls()
	end

	local gameView = self:getGameView()
	local stage = gameView:getGame():getStage()

	local actors = {}
	for actor in stage:iterateActors() do
		table.insert(actors, actor)
	end

	if self.isLoaded then
		self:_updateSkulls(actors)
	end
end

function EmptyRuinsSkeletonWall:update(delta)
	PropView.update(self, delta)

	if not self.isLoading then
		self.fadeInTime = (self.fadeInTime or 0) + delta
		local alpha = math.min(self.fadeInTime / EmptyRuinsSkeletonWall.FADE_IN_DURATION, 1)

		if self.wallSceneNode then
			self.wallSceneNode:getMaterial():setColor(Color(1, 1, 1, alpha))
		end
	end
end

return EmptyRuinsSkeletonWall
