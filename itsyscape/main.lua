_MOBILE = false

do
	if love.system.getOS() == "Android" then
		local sourceDirectory = love.filesystem.getSourceBaseDirectory()

		local cpath = package.cpath
		package.cpath = string.format(
			"%s/lib/lib?.so;%s/lib?.so;%s",
			sourceDirectory,
			sourceDirectory,
			cpath)

		_DEBUG = true
		_MOBILE = true
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
_ARGS = {}

_ANALYTICS = false
_ANALYTICS_KEY = false

math.randomseed(os.time())

function love.load(args)
	local main

	for i = 1, #args do
		if args[i] == "/main" or args[i] == "--main" then
			main = args[i + 1]
		end

		if args[i] == "/debug" or args[i] == "--debug" then
			_DEBUG = true
		end

		if args[i] == "/phantom" then
			_ANALYTICS_KEY = args[i + 1]
		end

		local c = args[i]:match("/f:(%w+)") or args[i]:match("--f:(%w+)")
		if c then
			_ARGS[c:lower()] = true
		end

		table.insert(_ARGS, c)
	end

	do
		if not _MOBILE then
			local AnalyticsClient = require "ItsyScape.Analytics.Client"
			_ANALYTICS = AnalyticsClient("analytics.cfg", _ANALYTICS_KEY)
		end

		local function printAnalytic(key, value)
			if not _ANALYTICS then
				Log.warn("Analytics not installed.")
				return
			end

			key = _ANALYTICS.EVENTS[key]
			if key and type(key) == 'string' then
				if not value then
					Log.print("analytic", string.format("%s: <event>", key))
				else
					if type(value) == 'string' then
						Log.print("analytic", string.format("%s: '%s'", key, value))
					elseif type(value) == 'number' then
						Log.print("analytic", string.format("%s: %.02f", key, value))
					end
				end
			end
		end

		if _ANALYTICS and _ANALYTICS:getIsEnabled() then
			Log.analytic = function(key, value)
				printAnalytic(key, value)
				_ANALYTICS:push(key, value)
			end
		else
			Log.analytic = function(key, value)
				printAnalytic(key, value)
			end
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

	Log.info("Game initialized.")

	love.keyboard.setKeyRepeat(true)
	love.audio.setVolume(_CONF.volume or 1)

	Log.info("Settings applied.")
	Log.info("Volume: %d%%.", love.audio.getVolume() * 100)
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

	if _DEBUG then
		if (select(1, ...) == 'f1') then
			_APP.showDebug = not _APP.showDebug
		elseif (select(1, ...) == 'f2') then
			_APP.show2D = not _APP.show2D
		elseif (select(1, ...) == 'f3') then
			_APP.show3D = not _APP.show3D
		elseif (select(1, ...) == 'f12') then
			local p = require "ProFi"
			jit.off()
			p:setGetTimeMethod(love.timer.getTime)
			p:start()
		end
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

function love.quit()
	if _DEBUG then
		local p = require "ProFi"
		p:stop()
		p:writeReport("itsyscape.log")
	end

	local result = _APP:quit()

	do	
		local Keybinds = require "ItsyScape.UI.Keybinds"
		for i = 1, #Keybinds do
			Keybinds[i]:save()
		end

		local serpent = require "serpent"
		local serializedConf = serpent.block(_CONF, { comment = false })

		love.filesystem.write("settings.cfg", serializedConf)
	end

	return result
end

function love.threaderror(m, e)
	error(e, 0)
end
