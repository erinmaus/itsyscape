--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local function lazy(root, t, common)
	local function __index(self, k)
		local value = false

		if type(k) == "string" then
			local path = string.format("%s.%s", root, k)
			local filename = string.format("%s.lua", path:gsub("%.", "/"))
			if love.filesystem.getInfo(filename) then
				Log.info("Lazy loading '%s'...", path)
				value = lazy(path, require(path))
				Log.info("Lazy loaded '%s'.", path)
			elseif common then
				Log.info("Lazy loading '%s.%s.%s'...", root, common, k)

				local commonPath = string.format("%s.%s", root, common)
				local common = require(commonPath)
				value = common[k] or false

				if value then
					Log.info("Lazy loaded '%s.%s.%s'.", root, common, k)
				else
					Log.info("Failed to lazy load '%s.%s.%s'.", root, common, k)
				end
			end
		end

		rawset(self, k, value)
		return value
	end

	return setmetatable(t, { __index = __index })
end

local Utility = lazy("ItsyScape.Game.Utility", {}, "Common")

return Utility
