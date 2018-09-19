do
	if love.system.getOS() == "Android" then
		local sourceDirectory = love.filesystem.getSourceBaseDirectory()

		local cpath = package.cpath
		package.cpath = string.format(
			"%s/lib/lib?.so;%s/lib?.so;%s",
			sourceDirectory,
			sourceDirectory,
			cpath)
	else
		local sourceDirectory = love.filesystem.getSourceBaseDirectory()

		local cpath = package.cpath
		package.cpath = string.format(
			"%s/ext/?.dll;%s/ext/?.so;%s",
			sourceDirectory,
			sourceDirectory,
			cpath)

		local path = package.path
		package.path = string.format(
			"%s/ext/?.lua;%s/ext/?/init.lua;%s",
			sourceDirectory,
			sourceDirectory,
			cpath)
	end
end

do
	local B = require "B"
	B._ROOT = "ItsyScape.Mashina"
end

Log = require "ItsyScape.Common.Log"
_APP = false

math.randomseed(os.time())

function love.load(args)
	local main

	for i = 1, #args do
		if args[i] == "/main" or args[i] == "--main" then
			main = args[i + 1]
		end
	end

	if not main then
		main = "ItsyScape.DemoApplication"
	end

	local s, r = pcall(require, main)
	if not s then
		Log.warn("failed to run %s: %s", main, r)
	else
		_APP = r(args)
		_APP:initialize()
	end

	love.keyboard.setKeyRepeat(true)
end

function love.update(delta)
	if _APP then
		_APP:update(delta)
	end
end

function love.mousepressed(...)
	if _APP then
		_APP:mousePress(...)
	end
end

function love.mousereleased(...)
	if _APP then
		_APP:mouseRelease(...)
	end
end

function love.wheelmoved(...)
	if _APP then
		_APP:mouseScroll(...)
	end
end

function love.mousemoved(...)
	if _APP then
		_APP:mouseMove(...)
	end
end

function love.keypressed(...)
	if _APP then
		_APP:keyDown(...)
	end
end

function love.keyreleased(...)
	if _APP then
		_APP:keyUp(...)
	end
end

function love.textinput(...)
	if _APP then
		_APP:type(...)
	end
end

function love.draw()
	if _APP then
		_APP:draw()
	end
end
