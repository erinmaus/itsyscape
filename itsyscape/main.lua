local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Ray = require "ItsyScape.Common.Math.Ray"
local LocalGame = require "ItsyScape.Game.LocalModel.Game"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Color = require "ItsyScape.Graphics.Color"
local Renderer = require "ItsyScape.Graphics.Renderer"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local DebugCubeSceneNode = require "ItsyScape.Graphics.DebugCubeSceneNode"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local DirectionalLightSceneNode = require "ItsyScape.Graphics.DirectionalLightSceneNode"
local GameView = require "ItsyScape.Graphics.GameView"
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
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local ButtonRenderer = require "ItsyScape.UI.ButtonRenderer"
local DraggablePanel = require "ItsyScape.UI.DraggablePanel"
local WidgetInputProvider = require "ItsyScape.UI.WidgetInputProvider"
local WidgetRenderManager = require "ItsyScape.UI.WidgetRenderManager"
local Map = require "ItsyScape.World.Map"
local MapPathFinder = require "ItsyScape.World.MapPathFinder"
local Path = require "ItsyScape.World.Path"
local TilePathNode = require "ItsyScape.World.TilePathNode"
local TileSet = require "ItsyScape.World.TileSet"

do
	local cpath = package.cpath
	local sourceDirectory = love.filesystem.getSourceBaseDirectory()
	package.cpath = string.format(
		"%s/ext/?.dll;%s/ext/?.so;%s",
		sourceDirectory,
		sourceDirectory,
		cpath)
end

do
	local GameDB = require "ItsyScape.GameDB.GameDB"
	local g = GameDB.create("Resources/Game/DB/Init.lua", ":memory:")
	print "Success!"
end

local Instance = {}
local Input = {
	isCameraDragging = false
}
TICK_RATE = 1 / LocalGame.TICKS_PER_SECOND

function love.load()
	Instance.Camera = ThirdPersonCamera()
	Instance.Camera:setDistance(30)
	Instance.Camera:setUp(Vector(0, -1, 0))
	Instance.Camera:setHorizontalRotation(-math.pi / 8)
	Instance.Camera:setVerticalRotation(-math.pi / 2)
	Instance.Camera:setPosition(Vector(5, 0, 5))
	Instance.previousTickTime = love.timer.getTime()
	Instance.startDrawTime = false
	Instance.time = 0
	Instance.Game = LocalGame()
	Instance.GameView = GameView(Instance.Game)
	Instance.GameView:getRenderer():setCamera(Instance.Camera)

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

	Instance.Game:getStage():updateMap(1)

	Instance.GameView:tick()
	Instance.Game:tick()
	
	local position = Instance.Game:getPlayer():getActor():getPosition()
	Instance.playerPreviousPosition = position
	Instance.playerCurrentPosition = position

	Instance.UI = DraggablePanel()
	Instance.UI:setSize(200, 200)
	local button = Button()
	button:setSize(128, 32)
	button:setPosition(32, 32)
	button:setText("Teleport")
	button.onClick:register(function()
		local player = Instance.Game:getPlayer():getActor()
		local map = Instance.Game:getStage():getMap(1)
		local x = math.floor(math.random(0, map:getWidth() - 1)) + 0.5
		local y = math.floor(math.random(0, map:getHeight() - 1)) + 0.5
		player:teleport(Vector(x * map:getCellSize(), 2, y * map:getCellSize()))
	end)
	button:setStyle(ButtonStyle {
		inactive = "Resources/Test/button.9.png",
		hover = "Resources/Test/button-hover.9.png",
		pressed = "Resources/Test/button-pressed.9.png",
		color = { 1, 1, 1, 1 }
	})
	Instance.UI:addChild(button)

	Instance.WidgetInput = WidgetInputProvider(Instance.UI)
	Instance.WidgetRenderer = WidgetRenderManager()
	Instance.WidgetRenderer:addRenderer(Button, ButtonRenderer())
end

function love.update(delta)
	-- Accumulator. Stores time until next tick.
	Instance.time = Instance.time + delta

	-- Only update at TICK_RATE intervals.
	while Instance.time > TICK_RATE do
		Instance.playerPreviousPosition = Instance.playerCurrentPosition
		Instance.playerCurrentPosition = Instance.Game:getPlayer():getActor():getPosition()

		Instance.GameView:tick()
		Instance.Game:tick()

		-- Handle cases where 'delta' exceeds TICK_RATE
		Instance.time = Instance.time - TICK_RATE

		-- Store the previous frame time.
		Instance.previousTickTime = love.timer.getTime()
	end

	Instance.GameView:update(delta)
end

function love.mousepressed(x, y, button)
	if Instance.WidgetInput:isBlocking(x, y) then
		Instance.WidgetInput:mousePress(x, y, button)
	else
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
				local player = Instance.Game:getPlayer()
				player:walk(best[Map.RAY_TEST_RESULT_I], best[map.RAY_TEST_RESULT_J], 1)
			end
		elseif button == 2 then
			Input.isCameraDragging = true
		end
	end
end

function love.mousereleased(x, y, button)
	Instance.WidgetInput:mouseRelease(x, y, button)

	if button == 2 then
		Input.isCameraDragging = false
	end
end

function love.wheelmoved(x, y)
	local distance = Instance.Camera:getDistance() - y * 0.5
	Instance.Camera:setDistance(math.min(math.max(distance, 1), 40))
end

function love.mousemoved(x, y, dx, dy)
	Instance.WidgetInput:mouseMove(x, y, dx, dy)

	if Input.isCameraDragging then
		local angle1 = dx / 128
		local angle2 = -dy / 128
		Instance.Camera:setVerticalRotation(Instance.Camera:getVerticalRotation() + angle1)
		Instance.Camera:setHorizontalRotation(Instance.Camera:getHorizontalRotation() + angle2)
	end
end

function love.keypressed(...)
	Instance.WidgetInput:keyDown(...)
end

function love.keyreleased(...)
	Instance.WidgetInput:keyUp(...)
end

function love.draw()
	local currentTime = love.timer.getTime()
	local previousTime = Instance.previousTickTime

	-- Generate a delta (0 .. 1 inclusive) between the current and previous frames
	local delta = (currentTime - previousTime) / TICK_RATE

	local width, height = love.window.getMode()
	Instance.Camera:setWidth(width)
	Instance.Camera:setHeight(height)

	if not Instance.startDrawTime then
		Instance.startDrawTime = currentTime
	end

	-- Update camera position.
	do
		local previous = Instance.playerPreviousPosition
		local current = Instance.playerCurrentPosition
		Instance.Camera:setPosition(previous:lerp(current, delta))
	end

	-- Draw the scene.
	Instance.GameView:getRenderer():draw(Instance.GameView:getScene(), delta)

	-- Draw UI
	--local width, height = love.window.getMode()
	love.graphics.setBlendMode('alpha')
	love.graphics.origin()
	love.graphics.ortho(width, height)

	Instance.WidgetRenderer:start()
	Instance.WidgetRenderer:draw(Instance.UI)
	Instance.WidgetRenderer:stop()
end
