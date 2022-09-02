require "love"
require "love.data"
require "love.event"
require "love.filesystem"
require "love.keyboard"
require "love.math"
require "love.mouse"
require "love.physics"
require "love.system"
require "love.thread"
require "love.timer"

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
		
		if love.system.getOS() == "OS X" then
			_ANALYTICS_DISABLED = true
		end
	end
end

do
	local B = require "B"
	B._ROOT = "ItsyScape.Mashina"
end

do
	table.clear = require "table.clear"
end

Log = require "ItsyScape.Common.Log"
function Log.analytic(...)
	Log.warnOnce("Analytics not installed.")
end

Log.setLogSuffix(_LOG_SUFFIX)
Log.write("ItsyRealm bootstrapped.\n")
