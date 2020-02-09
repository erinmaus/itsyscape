--------------------------------------------------------------------------------
-- ItsyScape/Analytics/Events.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local EVENTS = {
	START_GAME = true,
	END_GAME = true,
	PLAYER_GOT_KEY_ITEM = true,
	PLAYER_GOT_LEVEL_UP = true,
	PLAYER_DIED = true,
	PLAYER_REZZED = true,
	PLAYER_GOT_SAILING_ITEM = true,
}

local index = function(_, key)
	if type(key) ~= 'string' then
		Log.error("Analytic event must be string.")
	else
		key = key:upper()
		if EVENTS[key] then
			return key
		else
			Log.error("Analytic '%s' not found.", key)
		end
	end

	return nil
end

return setmetatable({}, { __index = index })
