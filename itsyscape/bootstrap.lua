require "love"
require "love.data"
require "love.event"
require "love.filesystem"
require "love.image"
require "love.keyboard"
require "love.math"
require "love.mouse"
require "love.physics"
require "love.system"
require "love.thread"
require "love.timer"

local version = love.filesystem.read("version.meta")
_ITSYREALM_VERSION = version or "mainline"

math.randomseed(os.time())

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
		_ANALYTICS_DISABLED = true
	else
		local sourceDirectory = love.filesystem.getSourceBaseDirectory()

		local cpath = package.cpath
		package.cpath = string.format(
			"%s/ext/?.dll;%s/ext/?.so;%s/../Frameworks/?.dylib;%s",
			sourceDirectory,
			sourceDirectory,
			sourceDirectory,
			cpath)

		local path = package.path
		package.path = string.format(
			"%s/ext/?.lua;%s/ext/?/init.lua;%s",
			sourceDirectory,
			sourceDirectory,
			path)
		
		if love.system.getOS() == "OS X" or love.system.getOS() == "Linux" then
			_ANALYTICS_DISABLED = true
		end
	end
end

require "nbunny.init"

do
	local B = require "B"
	B._ROOT = "ItsyScape.Mashina"

	local Node = B.Node

	B.Node = function(name)
		local node = Node(name)

		local Metatable = getmetatable(node)
		local oldNewIndex = Metatable.__newindex

		function Metatable:__newindex(key, value)
			if type(value) == "function" or (getmetatable(value) and getmetatable(value).__call) then
				rawset(self, key, function(...)
					local s, r = xpcall(value, debug.traceback, ...)
					if not s then
						Log.error("Error executing node.%s: %s", key, r)
						return B.Status.Failure
					end

					return r
				end)
			else
				oldNewIndex(self, key, value)
			end
		end

		return node
	end
end

do
	table.clear = require "table.clear"
end

Log = require "ItsyScape.Common.Log"
function Log.analytic(...)
	Log.warnOnce("Analytics not installed.")
end

Log.setLogSuffix(_LOG_SUFFIX)
if _LOG_SUFFIX then
	Log.info("ItsyRealm version '%s' bootstrapped (%s).\n", _ITSYREALM_VERSION, _LOG_SUFFIX)
else
	Log.engine("ItsyRealm version '%s' bootstrapped.", _ITSYREALM_VERSION)
end

if love.system.getOS() == "OS X" then
	Log.info("Running on macOS, disabling JIT.")
	require("jit").off()
end
