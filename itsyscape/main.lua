local Vector = require "ItsyScape.Common.Math.Vector"
local Ray = require "ItsyScape.Common.Math.Ray"
local LocalGame = require "ItsyScape.Game.LocalModel.Game"
local Color = require "ItsyScape.Graphics.Color"
local Renderer = require "ItsyScape.Graphics.Renderer"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local DebugCubeSceneNode = require "ItsyScape.Graphics.DebugCubeSceneNode"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local DirectionalLightSceneNode = require "ItsyScape.Graphics.DirectionalLightSceneNode"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Model = require "ItsyScape.Graphics.Model"
local Skeleton = require "ItsyScape.Graphics.Skeleton"
local SkeletonAnimation = require "ItsyScape.Graphics.SkeletonAnimation"
local MapMeshSceneNode = require "ItsyScape.Graphics.MapMeshSceneNode"
local ModelResource = require "ItsyScape.Graphics.ModelResource"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local Map = require "ItsyScape.World.Map"
local MapPathFinder = require "ItsyScape.World.MapPathFinder"
local Path = require "ItsyScape.World.Path"
local TilePathNode = require "ItsyScape.World.TilePathNode"
local TileSet = require "ItsyScape.World.TileSet"

local Instance = {}
local Input = {
	isCameraDragging = false
}
TICK_RATE = 1 / LocalGame.TICKS_PER_SECOND

function love.load()
	Instance.Renderer = Renderer()
	Instance.Camera = ThirdPersonCamera()
	Instance.Camera:setDistance(30)
	Instance.Camera:setUp(Vector(0, -1, 0))
	Instance.Camera:setHorizontalRotation(-math.pi / 8)
	Instance.Camera:setVerticalRotation(-math.pi / 2)
	Instance.Camera:setPosition(Vector(5, 0, 5))
	Instance.Renderer:setCamera(Instance.Camera)
	Instance.SceneRoot = SceneNode()
	Instance.previousTickTime = love.timer.getTime()
	Instance.startDrawTime = false
	Instance.time = 0
	Instance.ModelNodes = {}
	Instance.Game = LocalGame()

	local cube = DebugCubeSceneNode()
	cube:getTransform():setLocalTranslation(Vector(3, 2, 4))
	cube:setParent(Instance.SceneRoot)

	local ambientLight = AmbientLightSceneNode()
	ambientLight:setAmbience(0.4)
	ambientLight:setParent(Instance.SceneRoot)

	local directionalLight = DirectionalLightSceneNode()
	directionalLight:setColor(Color(0.6, 0.6, 0.6))
	directionalLight:setDirection(Vector(0, 0, 1):getNormal())
	directionalLight:setParent(Instance.SceneRoot)
	Instance.Sun = directionalLight

	local skeleton = Skeleton("Resources/Test/Human.lskel")

	local bodyModelResource = ModelResource(skeleton)
	bodyModelResource:loadFromFile("Resources/Test/Body.lmesh")

	local faceModelResource = ModelResource(skeleton)
	faceModelResource:loadFromFile("Resources/Test/Face.lmesh")

	local shader = ShaderResource()
	shader:loadFromFile("Resources/Shaders/SkinnedModel")

	local bodyTextureResource = TextureResource()
	bodyTextureResource:loadFromFile("Resources/Test/Body.png")

	local faceTextureResource = TextureResource()
	faceTextureResource:loadFromFile("Resources/Test/Face.png")

	local human = SceneNode()
	human:setParent(Instance.SceneRoot)
	human:getTransform():translate(Vector.UNIT_Y, 1)

	local bodySceneNode = ModelSceneNode()
	bodySceneNode:getMaterial():setTextures(bodyTextureResource)
	bodySceneNode:getMaterial():setShader(shader)
	bodySceneNode:setModel(bodyModelResource)
	bodySceneNode:setIdentity()
	bodySceneNode:setParent(human)

	local faceSceneNode = ModelSceneNode()
	faceSceneNode:getMaterial():setTextures(faceTextureResource)
	faceSceneNode:getMaterial():setShader(shader)
	faceSceneNode:setModel(faceModelResource)
	faceSceneNode:setIdentity()
	faceSceneNode:setParent(human)

	Instance.Human = human
	table.insert(Instance.ModelNodes, bodySceneNode)
	table.insert(Instance.ModelNodes, faceSceneNode)

	local animation = SkeletonAnimation("Resources/Test/Human_Walk.lanim", skeleton)
	Instance.Animation = animation

	Instance.Game:getStage():newMap(8, 8, 1)
	local map = Instance.Game:getStage():getMap(1)
	for j = 1, map:getHeight() do
		for i = 1, map:getWidth() do
			local tile = map:getTile(i, j)
			tile.flat = 1
			tile.edge = 2
			tile.topLeft = 1
			tile.topRight = 1
			tile.bottomLeft = 1
			tile.bottomRight = 1
		end
	end

	for i = 2, map:getWidth() do
		local tile = map:getTile(i, 1)
		tile.topLeft = math.min(i - 1, math.ceil(map:getWidth() / 2))
		tile.topRight = math.min(i, math.ceil(map:getWidth() / 2))
		tile.bottomLeft = math.min(i - 1, math.ceil(map:getWidth() / 2))
		tile.bottomRight = math.min(i, math.ceil(map:getWidth() / 2))
	end

	for j = 2, map:getHeight() / 2 do
		for i = 1, map:getWidth() / 2 do
			if i % 2 ~= j % 2 then
				local tile = map:getTile(i * 2, j * 2)
				tile.topLeft = 2
				tile.topRight = 2
				tile.bottomLeft = 2
				tile.bottomRight = 2
			end
		end
	end

	for j = 2, map:getHeight() do
		local tile = map:getTile(3, j)
		tile.topLeft = 1
		tile.topRight = 1
		tile.bottomLeft = 1
		tile.bottomRight = 1
	end

	local tileSet = TileSet()
	tileSet:setTileProperty(1, 'colorRed', 128)
	tileSet:setTileProperty(1, 'colorGreen', 192)
	tileSet:setTileProperty(1, 'colorBlue', 64)
	tileSet:setTileProperty(2, 'colorRed', 255)
	tileSet:setTileProperty(2, 'colorGreen', 192)
	tileSet:setTileProperty(2, 'colorBlue', 64)

	local mapMesh = MapMeshSceneNode()
	mapMesh:fromMap(map, tileSet)
	mapMesh:setParent(Instance.SceneRoot)

	local _, actor = Instance.Game:getStage():spawnActor("ItsyScape.Peep.Peep")
	local _, movement = actor.peep:addBehavior(MovementBehavior)
	movement.maxSpeed = 16
	movement.maxAcceleration = 16
	movement.decay = 0.6
	movement.velocityMultiplier = 1
	movement.accelerationMultiplier = 1
	movement.stoppingForce = 3
	local _, position = actor.peep:addBehavior(PositionBehavior)
	position.position.y = 1
	actor.peep:addBehavior(SizeBehavior)

	local pathFinder = MapPathFinder(map)
	local path = pathFinder:find({ i = 1, j = 1 }, { i = 3, j = 4 })
	if path then
		--path:activate(actor.peep)
	end

	Instance.Peep = actor.peep
end

function love.update(delta)
	-- Accumulator. Stores time until next tick.
	Instance.time = Instance.time + delta

	-- Only update at TICK_RATE intervals.
	while Instance.time > TICK_RATE do
		Instance.SceneRoot:tick()
		Instance.Game:tick()

		-- Handle cases where 'delta' exceeds TICK_RATE
		Instance.time = Instance.time - TICK_RATE

		-- Store the previous frame time.
		Instance.previousTickTime = love.timer.getTime()

		-- Update Peep position.
		local position = Instance.Peep:getBehavior(PositionBehavior).position
		Instance.Human:getTransform():setLocalTranslation(position)

		local forward = -Instance.Camera:getForward()
		Instance.Sun:setDirection(forward:getNormal())
	end
end

function love.mousepressed(x, y, button)
	if button == 1 then
		local width, height = love.window.getMode()
		y = height - y

		love.graphics.origin()
		Instance.Camera:apply()

		local a = Vector(love.graphics.unproject(x, y, 0.0))
		local b = Vector(love.graphics.unproject(x, y, 0.1))
		local r = Ray(a, b - a)

		local map = Instance.Game:getStage():getMap(1)
		local tiles = map:testRay(r)
		local function sortFunc(a, b)
			local i = a[Map.RAY_TEST_RESULT_POSITION]
			local j = b[Map.RAY_TEST_RESULT_POSITION]
			local s = Vector(love.graphics.project(i.x, i.y, i.z))
			local t = Vector(love.graphics.project(j.x, j.y, j.z))

			return s.z < t.z
		end
		table.sort(tiles, sortFunc)

		local best = tiles[1]
		if best then
			local pathFinder = MapPathFinder(map)
			local position = Instance.Peep:getBehavior(PositionBehavior).position 
			local _, i, j = map:getTileAt(position.x, position.z)
			local path = pathFinder:find(
				{ i = i, j = j },
				{ i = best[Map.RAY_TEST_RESULT_I], j = best[Map.RAY_TEST_RESULT_J] })

			if path then
				path:activate(Instance.Peep)
			else
				local movement = Instance.Peep:getBehavior(MovementBehavior)
				movement.velocity.y = movement.velocity.y + 200
			end
		end
	elseif button == 2 then
		Input.isCameraDragging = true
	end
end

function love.mousereleased(x, y, button)
	if button == 2 then
		Input.isCameraDragging = false
	end
end

function love.wheelmoved(x, y)
	local distance = Instance.Camera:getDistance() - y * 0.5
	Instance.Camera:setDistance(math.min(math.max(distance, 1), 40))
end

function love.mousemoved(x, y, dx, dy)
	if Input.isCameraDragging then
		local angle1 = dx / 128
		local angle2 = -dy / 128
		Instance.Camera:setVerticalRotation(Instance.Camera:getVerticalRotation() + angle1)
		Instance.Camera:setHorizontalRotation(Instance.Camera:getHorizontalRotation() + angle2)
	end
end

function love.draw()
	local currentTime = love.timer.getTime()
	local previousTime = Instance.previousTickTime

	-- Generate a delta (0 .. 1 inclusive) between the current and previous frames
	local delta = (currentTime - previousTime) / TICK_RATE

	local width, height = love.window.getMode()
	Instance.Renderer:getCamera():setWidth(width)
	Instance.Renderer:getCamera():setHeight(height)

	if not Instance.startDrawTime then
		Instance.startDrawTime = currentTime
	end

	local animationTime = currentTime - Instance.startDrawTime
	local transforms = {}
	Instance.Animation:computeTransforms(animationTime, transforms)
	for i = 1, #Instance.ModelNodes do
		Instance.ModelNodes[i]:setTransforms(transforms)
	end

	-- Update camera position.
	do
		local transform = Instance.Human:getTransform():getGlobalDeltaTransform(delta)
		local position = Vector(transform:transformPoint(0, 0, 0))
		Instance.Camera:setPosition(position)
	end

	-- Draw the scene.
	Instance.Renderer:draw(Instance.SceneRoot, delta)
end
