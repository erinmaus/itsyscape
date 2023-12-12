_LOG_SUFFIX = "client"
require "bootstrap"

if _MOBILE then
	local p = print

	print = function(...)
		local t = { n = select("#", ...), ... }

		for i = 1, t.n do
			t[i] = tostring(t[i])
		end

		if _APP then
			_APP:getGame():getPlayer():addExclusiveChatMessage(table.concat(t, " "))
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
	}
}

_ARGS = {}

_ANALYTICS_ENABLED = false

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
			_DEBUG = 'plus'
		end

		if args[i] == "/phantom" then
			_ANALYTICS_KEY = args[i + 1]
		end

		local c = args[i]:match("/f:(%w+)") or args[i]:match("--f:(%w+)")
		if c then
			_ARGS[c:lower()] = true
		end

		table.insert(_ARGS, args[i])
	end

	_ARGS["anonymous"] = true
	_DEBUG = _DEBUG or _CONF.debug or false

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
			Log.warn("Failed to create %s: %s", main, r)
		end

		_APP = r
		s, r = xpcall(r.initialize, debug.traceback, r)
		if not s then
			Log.warn("Failed to initialize %s: %s", main, r)
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

function love.mousepressed(...)
	if _APP and not _CONF.server and not _MOBILE then
		_APP:mousePress(...)
	end
end

function love.mousereleased(...)
	if _APP and not _CONF.server and not _MOBILE then
		_APP:mouseRelease(...)
	end
end

function love.wheelmoved(...)
	if _APP and not _CONF.server and not _MOBILE then
		_APP:mouseScroll(...)
	end
end

function love.mousemoved(...)
	if _APP and not _CONF.server and not _MOBILE then
		_APP:mouseMove(...)
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
local oldDebug = _DEBUG
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
			else
				_APP.showDebug = not _APP.showDebug
			end
		elseif (select(1, ...) == 'f2') then
			_APP.showUI = not _APP.showUI
		elseif (select(1, ...) == 'f3') then
			_APP.show2D = not _APP.show2D
		elseif (select(1, ...) == 'f4') then
			_APP.show3D = not _APP.show3D
		elseif (select(1, ...) == 'f5') then
			itsyrealm.graphics.disable()
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

	love.graphics.setCanvas()
	love.graphics.setBlendMode('alpha')

	local function draw()
		love.graphics.setCanvas()

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

function love.errorhandler(message)
	if not _GAME_THREAD_ERROR then
		Log.sendError(message, 3)

		local s = pcall(_APP.quit, _APP, true)
		if not s then
			Log.warn("Couldn't safely quit game as a last resort on error.")
		else
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
