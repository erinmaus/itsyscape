--------------------------------------------------------------------------------
-- ItsyScape/Common/MirrorSandbox.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

-- Creates a less safe sandbox.
local function MirrorSandbox(writeThrough)
	local M = {}

	local s = {}
	local g = _G
	function M:__index(key)
		return s[key] or g[key]
	end

	if writeThrough then
		function M:__newindex(key, value)
			if g[key] then
				g[key] = value
			else
				s[key] = value
			end
		end
	else
		function M:__newindex(key, value)
			s[key] = value
		end
	end

	return setmetatable({}, M), s
end

return MirrorSandbox
