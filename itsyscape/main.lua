_LOG_SUFFIX = "client"
require "bootstrap"

local NLuaRuntime = require "nbunny.luaruntime"

if _MOBILE then
	local p = print

	print = function(...)
		local t = { n = select("#", ...), ... }

		for i = 1, t.n do
			t[i] = tostring(t[i])
		end

		if _APP then
			if _APP:getGame():getPlayer() then
				_APP:getGame():getPlayer():addExclusiveChatMessage(table.concat(t, " "))
			end
		end

		p(...)
	end
end

local _GAME_THREAD_ERROR = false

do
	local NSentry = require "nbunny.sentry"
	love.filesystem.createDirectory(".sentry")

	NSentry.init(
		"https://98b5ff6214224dbbb0b94a4f1643c82e@o4505002174840832.ingest.sentry.io/4505002177986560",
		string.format("%s/%s", love.filesystem.getSaveDirectory(), ".sentry"),
		_ITSYREALM_VERSION)
end

itsyrealm = {
	graphics = {
		impl = {}
	},

	mouse = {}
}

_ARGS = {}

_ANALYTICS_ENABLED = false
do
	local AnalyticsClient = require "ItsyScape.Analytics.AnalyticsClient"
	local config = AnalyticsClient.getConfig()
	if config and config.enabled then
		_ANALYTICS_ENABLED = true
	end
end

function love.load(args)
	local main

	for i = 1, #args do
		if args[i] == "/main" or args[i] == "--main" then
			main = args[i + 1]
		end

		if args[i] == "/debug" or args[i] == "--debug" then
			_DEBUG = true
		end

		if args[i] == "/debugplus" or args[i] == "--debugplus" then
			_DEBUG = "plus"
		end

		if args[i] == "/phantom" then
			_ANALYTICS_KEY = args[i + 1]
		end

		local c = args[i]:match("/f:(%w+)") or args[i]:match("--f:(%w+)")
		if c then
			_ARGS[c:lower()] = true
		end

		local c, o = args[i]:match("/f:(%w+)=(.+)")
		if not (c and o) then
			c, o = args[i]:match("--f:(%w+)=(.+)")
		end

		if c and o then
			_ARGS[c:lower()] = o
		end

		table.insert(_ARGS, args[i])
	end

	_ARGS["anonymous"] = true
	_DEBUG = _MOBILE or (_DEBUG or _CONF.debug) or false

	if not main then
		if _CONF.server then
			main = "ItsyScape.Application"
		else
			main = "ItsyScape.DemoApplication"
		end
	end

	_APP_REQUIRE = main

	local s, r = xpcall(require, debug.traceback, main)
	if not s then
		Log.warn("Failed to load %s: %s", main, r)
		Log.quit()

		if _DEBUG then
			os.exit(1)
		else
			error(r, 0)
		end
	else
		s, r = xpcall(r, debug.traceback, args)
		if not s then
			error(string.format("Failed to create %s: %s", main, r))
		else
			_APP = r

			s, r = xpcall(_APP.initialize, debug.traceback, _APP)
			if not s then
				error(string.format("Failed to initialize %s: %s", main, r))
			end
		end
	end

	Log.info("Game initialized.")

	if not _CONF.server then
		love.keyboard.setKeyRepeat(true)
		love.audio.setVolume(_CONF.volume or 1)
		Log.info("Volume: %d%%.", love.audio.getVolume() * 100)
		Log.info("Settings applied.")
	end
end

function love.update(delta)
	if _APP then
		_APP:update(delta)
	end
end

function love.mousepressed(x, y, button, isTouch)
	if _APP and not _CONF.server and not isTouch then
		_APP:mousePress(x, y, button)
	end
end

function love.mousereleased(x, y, button, isTouch)
	if _APP and not _CONF.server and not isTouch then
		_APP:mouseRelease(x, y, button)
	end
end

function love.wheelmoved(...)
	if _APP and not _CONF.server then
		_APP:mouseScroll(...)
	end
end

function love.mousemoved(x, y, dx, dy, isTouch)
	if _APP and not _CONF.server and not isTouch then
		_APP:mouseMove(x, y, dx, dy)
	end
end

function love.joystickadded(...)
	if _APP and not _CONF.server then
		_APP:joystickAdd(...)
	end
end

function love.joystickeremoved(...)
	if _APP and not _CONF.server then
		_APP:joystickRemove(...)
	end
end

function love.gamepadaxis(...)
	if _APP and not _CONF.server then
		_APP:gamepadAxis(...)
	end
end

function love.gamepadreleased(...)
	if _APP and not _CONF.server then
		_APP:gamepadRelease(...)
	end
end

function love.gamepadpressed(...)
	if _APP and not _CONF.server then
		_APP:gamepadPress(...)
	end
end

-- Uncomment to test single-touch controls
-- _MOBILE = true

-- function love.mousepressed(x, y, button)
-- 	love.touchpressed(button, x, y)
-- end

-- function love.mousereleased(x, y, button)
-- 	love.touchreleased(button, x, y)
-- end

-- function love.mousemoved(x, y, dx, dy)
-- 	love.touchmoved(1, x, y, dx, dy)
-- end

function love.touchpressed(...)
	if _APP and not _CONF.server then
		_APP:touchPress(...)
	end
end

function love.touchreleased(...)
	if _APP and not _CONF.server then
		_APP:touchRelease(...)
	end
end

function love.touchmoved(...)
	if _APP and not _CONF.server then
		_APP:touchMove(...)
	end
end

local isCollectingGarbage = true
local isProfiling = false
local oldDebug = _DEBUG
local dumpNbunnyFuncCalls = false
function love.keypressed(...)
	if _APP and not _CONF.server then
		_APP:keyDown(...)
	end

	if _DEBUG then
		if (select(1, ...) == 'f1') then
			if love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift') then
				if isCollectingGarbage then
					isCollectingGarbage = false
					collectgarbage("stop")
					oldDebug = _DEBUG
					_DEBUG = 'plus'
				else
					isCollectingGarbage = true
					collectgarbage("restart")
					collectgarbage()
					_DEBUG = oldDebug
				end
			end
		elseif (select(1, ...) == 'f2') then
			_APP.showUI = not _APP.showUI
		elseif (select(1, ...) == 'f3') then
			_APP.show2D = not _APP.show2D
		elseif (select(1, ...) == 'f4') then
			_APP.show3D = not _APP.show3D
		elseif (select(1, ...) == 'f5') then
			itsyrealm.graphics.disable()
		elseif (select(1, ...) == "f6") then
			if love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift') then
				if isProfiling then
					isProfiling = true
					require("jit.p").stop()
				else
					isProfiling = false
					require("jit.p").start("3lm1i1")
				end
			elseif love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
				local file = love.filesystem.read("settings.cfg")
				if file then
					local r, e = loadstring('return ' .. file)
					if r then
						r, e = pcall(r)
						if r then
							_CONF = e
							_DEBUG = _CONF.debug

							love.window.setMode(_CONF.width, _CONF.height, {
								fullscreen = _CONF.fullscreen,
								vsync = _CONF.vsync,
								display = _CONF.display
							})

							itsyrealm.graphics.dirty()
							_APP:getGameView():dirty()
						end
					end
				end
			else
				dumpNbunnyFuncCalls = true
			end
		end
	end
end

function love.keyreleased(...)
	if _APP and not _CONF.server then
		_APP:keyUp(...)
	end
end

function love.textinput(...)
	if _APP and not _CONF.server then
		_APP:type(...)
	end
end

function love.draw()
	if _APP and not _CONF.server then
		_APP:draw()
	end
end

function love.focus(isInFocus)
	if not isInFocus and _MOBILE then
		if _APP then
			_APP:background()
		end

		local serpent = require "serpent"
		local serializedConf = serpent.block(_CONF, { comment = false })

		love.filesystem.write("settings.cfg", serializedConf)
	end
end

function love.quit()
	if isProfiling then
		require("jit.p").stop()
	end

	local result = _APP:quit()

	if result then
		return result
	end

	do	
		local Keybinds = require "ItsyScape.UI.Keybinds"
		for i = 1, #Keybinds do
			Keybinds[i]:save()
		end

		local serpent = require "serpent"
		local serializedConf = serpent.block(_CONF, { comment = false })

		love.filesystem.write("settings.cfg", serializedConf)
	end

	if _DEBUG then
		local DebugStats = require "ItsyScape.Graphics.DebugStats"

		if not _CONF.server then
			_APP:getGameView():getRenderer():getNodeDebugStats():dumpStatsToCSV("Renderer_Nodes")
			_APP:getGameView():getRenderer():getPassDebugStats():dumpStatsToCSV("Renderer_Passes")
			_APP:getGameView():dumpStatsToCSV()
			_APP:getUIView():getRenderManager():getDebugStats():dumpStatsToCSV("Widget_Renderer")
		end

		DebugStats.GLOBAL:dumpStatsToCSV("Global")
	end

	Log.quit()

	local NSentry = require "nbunny.sentry"
	NSentry.close()

	return result
end

function itsyrealm.errorhandler()
	if not love.graphics then
		return function()
			return 1
		end
	end

	local logo
	do
		local s, v = pcall(love.graphics.newImage, "Resources/Game/TitleScreens/Logo.png")
		if s then
			logo = v
		end
	end

	local qrCode
	do
		local s, v = pcall(love.graphics.newImage, "Resources/Game/TitleScreens/DiscordQRCode.png")
		if s then
			qrCode = v
		end
	end

	do
		local s, v = pcall(love.graphics.newFont, "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf", 32)
		if s then
			love.graphics.setFont(v)
		else
			love.graphics.setNewFont(32)
		end
	end

	local width, height, scale
	do
		local s, w, h, scaleX, scaleY = pcall(love.graphics.getScaledMode)
		if s then
			scale = math.min(scaleX, scaleY)
			width = love.graphics.getWidth() / scale
			height = love.graphics.getHeight() / scale
		else
			scale = 1
			width = love.graphics.getWidth()
			height = love.graphics.getHeight()
		end
	end

	if love.audio then
		love.audio.stop()
	end

	love.graphics.reset()

	local function draw()
		love.graphics.clear(0, 0, 0)
		love.graphics.setColor(1, 1, 1, 1)

		love.graphics.origin()
		love.graphics.scale(scale, scale)

		if logo then
			love.graphics.draw(
				logo,
				width / 2,
				height / 2 - height / 4,
				0,
				scale,
				scale,
				logo:getWidth() / 2,
				logo:getHeight() / 2)
		end

		if qrCode and not _MOBILE then
			love.graphics.draw(
				qrCode,
				width - qrCode:getWidth() / 2 - 16,
				height - qrCode:getHeight() / 2 - 16,
				0,
				0.5,
				0.5)
		end

		local message = 
			"Whoops! ItsyRealm encountered an error!\n" ..
			"The game will send the developer a crash report.\n" ..
			"If you want to be extra helpful,\n" ..
			"join the ItsyRealm Discord and report the error!\n" ..
			"Just scan the QR code!\n\n" ..
			"Press ESC to quit."

		love.graphics.printf(
			message,
			0,
			height / 2 + 32,
			width,
			'center')

		if _ITSYREALM_VERSION then
			love.graphics.print(
				_ITSYREALM_VERSION,
				width - love.graphics.getFont():getWidth(_ITSYREALM_VERSION) - 16,
				16)
		end

		love.graphics.present()
	end

	return function()
		love.event.pump()

		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return 1
			elseif e == "keypressed" and a == "escape" then
				return 1
			end
		end

		draw()

		if love.timer then
			love.timer.sleep(0.1)
		end
	end
end

local isCI = os.getenv("CI")
function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
		local oldDumpNbunnyFuncCalls = dumpNbunnyFuncCalls
		
		if _DEBUG then
			NLuaRuntime.startMeasurements()

			if oldDumpNbunnyFuncCalls then
				NLuaRuntime.startDebug()
			end
		end

		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
		if love.update then
			if _APP then
				_APP:measure("love.update()", love.update, dt)
			else
				love.update(dt)
			end
		end

		if love.graphics and love.graphics.isActive() and not isCI then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then
				if _APP then
					_APP:measure("love.draw()", love.draw)
				else
					love.draw()
				end
			end

			if _APP then
				_APP:measure("love.graphics.present()", love.graphics.present)
			else
				love.graphics.present()
			end
		end

		if love.timer then love.timer.sleep((_CONF.clientSleepMS or 0) / 1000) end

		if _DEBUG then
			NLuaRuntime.stopMeasurements()

			if oldDumpNbunnyFuncCalls then
				NLuaRuntime.stopDebug()

				do
					local calls, totalTime = NLuaRuntime.getMeasurements()
					local totalNumCalls = NLuaRuntime.getNumCalls()

					local csv = {}
					for method, stats in pairs(calls) do
						table.insert(csv, string.format("%s, %d, %f", method, stats.calls, stats.time))
					end

					table.sort(csv, function(a, b)
						return a < b
					end)

					Log.info("Nbunny function calls (%d total, %.2f ms):\n%s", totalNumCalls, totalTime * 1000, table.concat(csv, "\n"))
				end

				do
					local json = require "json"

					local calls = NLuaRuntime.getCalls()
					table.sort(calls, function(a, b)
						return a.time > b.time
					end)

					for _, call in ipairs(calls) do
						call.arguments = Log.dump(call.arguments)
						call.returnValue = Log.dump(call.returnValue)
					end

					local result = json.encode(calls)

					local filename = string.format("nbunny-%s.json", os.date("%Y%m%d_%H%M%S"))
					love.filesystem.write(filename, result)
				end

				dumpNbunnyFuncCalls = false
			end
		end
	end
end

function love.errorhandler(message)
	Log.error("Encountered an error: %s", message)

	if not _GAME_THREAD_ERROR then
		Log.sendError(message, 3)

		if _APP then
			_APP:quit(true)
			Log.info("Safely quit game as a last resort on error.")
		end
	end

	local NSentry = require "nbunny.sentry"
	NSentry.close()

	local Class = require "ItsyScape.Common.Class"
	if _DEBUG or (Class.isDerived(require(_APP_REQUIRE), require "ItsyScape.Editor.EditorApplication")) then
		return love.errhand(message)
	else
		return itsyrealm.errorhandler()
	end
end

function love.threaderror(thread, e)
	_GAME_THREAD_ERROR = _APP:isGameThread(thread)
	if _GAME_THREAD_ERROR then
		Log.warn("Error in game thread: %s", e)
	else
		Log.warn("Error in other thread: %s", e)
	end

	error(e, 0)
end
