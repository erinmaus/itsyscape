local Vector = require "ItsyScape.Common.Math.Vector"
local Renderer = require "ItsyScape.Graphics.Renderer"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local DebugCubeSceneNode = require "ItsyScape.Graphics.DebugCubeSceneNode"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"

local Instance = {}
TICK_RATE = 1 / 5

function love.load()
	Instance.Renderer = Renderer()
	Instance.Renderer:setCamera(ThirdPersonCamera())
	Instance.SceneRoot = SceneNode()
	Instance.previousTickTime = love.timer.getTime()
	Instance.time = 0

	local cube = DebugCubeSceneNode()
	cube:setParent(Instance.SceneRoot)
end

function love.update(delta)
	-- Accumulator. Stores time until next tick.
	Instance.time = Instance.time + delta

	-- Only update at TICK_RATE intervals.
	while Instance.time > TICK_RATE do
		Instance.SceneRoot:tick()

		-- Rotate cube 360 degrees every 2 seconds
		Instance.SceneRoot:getTransform():rotateByAxisAngle(Vector(0, 1, 0), TICK_RATE * math.pi)

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

	-- Draw the scene.
	Instance.Renderer:draw(Instance.SceneRoot, delta)
end
