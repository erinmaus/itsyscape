local Vector = require "ItsyScape.Common.Math.Vector"
local Ray = require "ItsyScape.Common.Math.Ray"
local Map = require "ItsyScape.World.Map"
local MapMesh = require "ItsyScape.World.MapMesh"
local MapMotion = require "ItsyScape.World.MapMotion"
local TileSet = require "ItsyScape.World.TileSet"
local ForwardLitModelShader = require "ItsyScape.Graphics.Shaders.ForwardLitModelShader"

local map = Map(4, 4, 2)
local tileSet
local mapMesh = nil
local motion = nil
local shader = nil

function love.load()
	for j = 1, map.height do
		for i = 1, map.width do
			local tile = map:getTile(i, j)
			tile.topLeft = 1
			tile.topRight = 1
			tile.bottomLeft = 1
			tile.bottomRight = 1
			tile:snapCorners('max')

			tile.flat = 1
			tile.edge = 2
		end
	end

	local t = map:getTile(2, 3)
	t.topLeft = 2
	t = map:getTile(1, 3)
	t.topRight = 1
	t = map:getTile(2, 2)
	t.bottomLeft = 2
	t = map:getTile(1, 2)
	t.bottomRight = 2

	tileSet = TileSet()
	tileSet:setTileProperty(1, 'colorRed', 128)
	tileSet:setTileProperty(1, 'colorGreen', 192)
	tileSet:setTileProperty(1, 'colorBlue', 64)
	tileSet:setTileProperty(2, 'colorRed', 255)
	tileSet:setTileProperty(2, 'colorGreen', 192)
	tileSet:setTileProperty(2, 'colorBlue', 64)

	mapMesh = MapMesh(map, tileSet)

	local centerX = map.width * map.cellSize / 2
	local centerZ = map.height * map.cellSize / 2

	shader = ForwardLitModelShader()
	shader:setNumLights(1)

	motion = MapMotion(map)
end

local transform = love.math.newTransform()
local t = 0
function love.update(dt)
	local w, h = love.window.getMode()
	local x = (love.mouse.getX() - w / 2) / 32
	local y = (love.mouse.getY() - h * 1.5) / 32

	shader:setLight(1, {
		position = { x, 8, -y, 1 },
		color = { 1, 1, 1 },
		attenuation = 4,
		ambientCoefficient = 0.2
	})


	local centerX = map.width * map.cellSize / 2
	local centerZ = map.height * map.cellSize / 2
	transform:reset()
	transform:translate(centerX, 0, centerZ)
	--transform:rotate(0, 1, 0, t / math.pi)
	transform:translate(-centerX, 0, -centerZ)

	t = t + dt
end

local corner = nil
local isDragging

function setCamera()
	local centerX = map.width * map.cellSize / 2
	local centerZ = map.height * map.cellSize / 2
	local offsetX = (love.mouse.getX() - love.window.getMode() / 2) / 40
	love.graphics.origin()
	love.graphics.lookAt(
		-centerX, 12, 24,
		centerX, 0, centerZ,
		0, 1, 0)

	local width, height = love.window.getMode()
	love.graphics.perspective(math.rad(35), width / height, 0.1, 500.0)
end

function love.mousepressed(x, y, button)
	setCamera()

	local a = Vector(love.graphics.unproject(x, y, 0))
	local b = Vector(love.graphics.unproject(x, y, 0.01))
	local ray = Ray(a, b - a)

	local event = {
		x = x,
		y = y,
		button = button,
		ray = ray
	}

	motion:onMousePressed(event)
end

function love.mousereleased(x, y, button)
	setCamera()

	local a = Vector(love.graphics.unproject(x, y, 0))
	local b = Vector(love.graphics.unproject(x, y, 0.01))
	local ray = Ray(a, b - a)

	local event = {
		x = x,
		y = y,
		button = button,
		ray = ray
	}

	motion:onMouseReleased(event)
end

function love.mousemoved(x, y)
	setCamera()

	local a = Vector(love.graphics.unproject(x, y, 0))
	local b = Vector(love.graphics.unproject(x, y, 0.01))
	local ray = Ray(a, b - a)

	local event = {
		x = x,
		y = y,
		button = button,
		ray = ray
	}

	if motion:onMouseMoved(event) then
		mapMesh:release()
		mapMesh = MapMesh(map, tileSet)
	end
end

function love.draw()
	love.graphics.setMeshCullMode('back')

	setCamera()

	shader:use()
	do
		love.graphics.setDepthMode('less', true)
		love.graphics.setWireframe(false)
		mapMesh:draw(nil, transform)

		shader:resetLight(1)
		love.graphics.translate(0, 0.01, 0)
		love.graphics.setDepthMode('lequal', false)
		love.graphics.setWireframe(true)
		mapMesh:draw(nil, transform)
	end
end
