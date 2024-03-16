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
_ITSYREALM_VERSION = _ITSYREALM_VERSION:gsub("%s*(%S*)%s*", "%1")
_ITSYREALM_MAJOR   = tonumber(_ITSYREALM_VERSION:match("^(%d+)%.%d+%.%d+")) or 0
_ITSYREALM_MINOR   = tonumber(_ITSYREALM_VERSION:match("^%d+%.(%d+)%.%d+")) or 0
_ITSYREALM_BUILD   = tonumber(_ITSYREALM_VERSION:match("^%d+%.%d+%.(%d+)")) or 0

math.randomseed(os.time())

_MOBILE = love.system.getOS() == "iOS" or love.system.getOS() == "Android"

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
			"%s/ext/?.dll;%s/ext/?.so;%s/../Frameworks/?.dylib;%s/../Frameworks/?.so;%s/Frameworks/?.framework/?;%s",
			sourceDirectory,
			sourceDirectory,
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

	math.clamp = function(a, min, max)
		return math.max(math.min(a, max or 1), min or 0)
	end

	math.lerp = function(from, to, delta)
		return to * delta + from * (1 - delta)
	end

	local utf8 = require "utf8"
	function utf8.sub(s, i, j)
		local stringI = utf8.offset(s, i or 1) or #s + 1
		local stringJ = (j and utf8.offset(s, j) and utf8.offset(s, j) - 1) or #s
		return s:sub(stringI, stringJ)
	end
end

Log = require "ItsyScape.Common.Log"

Log.setLogSuffix(_LOG_SUFFIX)
if _LOG_SUFFIX then
	Log.info("ItsyRealm version '%s' bootstrapped (%s).\n", _ITSYREALM_VERSION, _LOG_SUFFIX)
else
	Log.engine("ItsyRealm version '%s' bootstrapped.", _ITSYREALM_VERSION)
end

if love.system.getOS() == "OS X" and jit and jit.arch == "arm64" then
	Log.info("Running on macOS (arch = '%s'), disabling JIT.", jit and jit.arch or "???")
	require("jit").off()
end

local _collectgarbage = collectgarbage
local gcStops = 0

function collectgarbage(opt, arg)
	if opt == "stop" then
		if gcStops == 0 then
			local result = _collectgarbage("stop")
		end

		gcStops = gcStops + 1

		return result
	elseif opt == "restart" then
		gcStops = math.max(gcStops - 1, 0)

		if gcStops == 0 then
			return _collectgarbage("restart")
		end
	else
		return _collectgarbage(opt, arg)
	end
end
