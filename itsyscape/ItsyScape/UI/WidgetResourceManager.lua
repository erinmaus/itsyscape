--------------------------------------------------------------------------------
-- ItsyScape/UI/WidgetResourceManager.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local WidgetResourceTable = Class()
function WidgetResourceTable:new(func)
	self.func = func

	-- We don't want to keep the value (the resource) if it otherwise should be
	-- disposed. For example, say 3 buttons load the same image, then are later
	-- destroyed. We'd be holding the last reference thus the image would never
	-- be collected.
	self.resources = setmetatable({}, { __mode = 'v' })
end

function WidgetResourceTable:load(...)
	local key = { n = select('#', ...), ... }
	for k, v in pairs(self.resources) do
		local match = true
		if k.n == key.n then
			for i = 1, k.n do
				if k[i] ~= key[i] then
					match = false
					break
				end
			end
		end

		if match then
			return v
		end
	end

	local v = self.func(...)
	self.resources[key] = v

	return v
end

-- Prevents loading duplicate resources (for widgets).
local WidgetResourceManager = Class()

function WidgetResourceManager:new()
	-- We don't want to keep the key (the load function) if it's disposed.
	self.tables = setmetatable({}, { __mode = 'k' })
end

-- Loads a resource, using 'func'.
--
-- Extra arguments are passed to 'func'. For every unique combination of
-- (func, ...), only a single resource is loaded
--
-- The resource is eventually unloaded when the last widget style (or whatever)
-- references it.
function WidgetResourceManager:load(func, ...)
	local t = self.tables[func]
	if not t then
		t = WidgetResourceTable(func)
		self.tables[func] = t
	end

	return t:load(...)
end

return WidgetResourceManager
