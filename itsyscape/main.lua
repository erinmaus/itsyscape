local Vector = require "ItsyScape.Common.Math.Vector"
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
local ModelResource = require "ItsyScape.Graphics.ModelResource"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Instance = {}
TICK_RATE = 1 / 5

function love.load()
	Instance.Renderer = Renderer()
	Instance.Camera = ThirdPersonCamera()
	Instance.Camera:setDistance(15)
	Instance.Camera:setUp(Vector(0, 1, 0))
	Instance.Camera:setHorizontalRotation(math.pi / 8)
	Instance.Renderer:setCamera(Instance.Camera)
	Instance.SceneRoot = SceneNode()
	Instance.previousTickTime = love.timer.getTime()
	Instance.startDrawTime = false
	Instance.time = 0
	Instance.ModelNodes = {}

	local cube = DebugCubeSceneNode()
	cube:getTransform():setLocalScale(Vector(1 / 2))
	cube:getTransform():setLocalTranslation(Vector(0, 1, 0))
	cube:setParent(Instance.SceneRoot)

	local ambientLight = AmbientLightSceneNode()
	ambientLight:setAmbience(0.4)
	ambientLight:setParent(Instance.SceneRoot)

	local directionalLight = DirectionalLightSceneNode()
	directionalLight:setColor(Color(1, 1, 1))
	directionalLight:setDirection(Vector(0, 0, -1):getNormal())
	directionalLight:setParent(Instance.SceneRoot)

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

	table.insert(Instance.ModelNodes, bodySceneNode)
	table.insert(Instance.ModelNodes, faceSceneNode)

	local animation = SkeletonAnimation("Resources/Test/Human_Walk.lanim", skeleton)
	Instance.Animation = animation
end

function love.update(delta)
	-- Accumulator. Stores time until next tick.
	Instance.time = Instance.time + delta

	-- Only update at TICK_RATE intervals.
	while Instance.time > TICK_RATE do
		Instance.SceneRoot:tick()

		-- Rotate scene 360 degrees every 4 seconds
		Instance.SceneRoot:getTransform():rotateByAxisAngle(Vector(0, 1, 0), -TICK_RATE * math.pi / 2)

		-- Handle cases where 'delta' exceeds TICK_RATE
		Instance.time = Instance.time - TICK_RATE

		-- Store the previous frame time.
		Instance.previousTickTime = love.timer.getTime()
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

	-- Draw the scene.
	Instance.Renderer:draw(Instance.SceneRoot, delta)
end
