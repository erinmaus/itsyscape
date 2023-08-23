_LOG_SUFFIX = "client"
require "bootstrap"

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
	}
}

_ARGS = {}

_ANALYTICS = false
_ANALYTICS_KEY = false

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

	_ARGS["anonymous"] = true
	_DEBUG = _DEBUG or _CONF.debug or false

	do
		if not _ANALYTICS_DISABLED then
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
		if _CONF.server then
			main = "ItsyScape.Application"
		else
			main = "ItsyScape.DemoApplication"
		end
	end

	_APP_REQUIRE = main

	local s, r = xpcall(require, debug.traceback, main)
	if not s then
		Log.warn("Failed to run %s: %s", main, r)
		Log.quit()

		if _DEBUG then
			os.exit(1)
		else
			error(r, 0)
		end
	else
		_APP = r(args)
		_APP:initialize()
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

function love.mousepressed(...)
	if _APP and not _CONF.server then
		_APP:mousePress(...)
	end
end

function love.mousereleased(...)
	if _APP and not _CONF.server then
		_APP:mouseRelease(...)
	end
end

function love.wheelmoved(...)
	if _APP and not _CONF.server then
		_APP:mouseScroll(...)
	end
end

function love.mousemoved(...)
	if _APP and not _CONF.server then
		_APP:mouseMove(...)
	end
end

function love.keypressed(...)
	if _APP and not _CONF.server then
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

	if love.audio then
		love.audio.stop()
	end

	local function draw()
		love.graphics.setCanvas()

		love.graphics.clear(0, 0, 0)

		love.graphics.setColor(1, 1, 1, 1)
		if logo then
			love.graphics.draw(
				logo,
				love.graphics.getWidth() / 2 - logo:getWidth() / 2,
				love.graphics.getHeight() / 2 - logo:getHeight())
		end

		if qrCode then
			love.graphics.draw(
				qrCode,
				love.graphics.getWidth() - qrCode:getWidth() / 2 - 16,
				love.graphics.getHeight() - qrCode:getHeight() / 2 - 16,
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
			love.graphics.getHeight() / 2 + 32,
			love.graphics.getWidth(),
			'center')

		if _ITSYREALM_VERSION then
			love.graphics.print(
				_ITSYREALM_VERSION,
				love.graphics.getWidth() - love.graphics.getFont():getWidth(_ITSYREALM_VERSION) - 16,
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

function love.errorhandler(message)
	if not _GAME_THREAD_ERROR then
		Log.sendError(message, 3)
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
