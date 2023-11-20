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
	START_GAME = "Start Game",
	END_GAME = "End Game",
	GOT_KEY_ITEM = "Made Quest Progress",
	STARTED_QUEST = "Started Quest",
	COMPLETED_QUEST = "Completed Quest",
	DREAMED = "Dreamed",
	GAINED_XP = "Gained XP",
	GOT_LEVEL_UP = "Leveled Up",
	PERFORMED_ACTION = "Performed Action",
	FAILED_ACTION = "Failed Action",
	COOKED_RECIPE = "Cooked Recipe",
	GAINED_COMBAT_LEVEL = "Gained Combat Level",
	KILLED_NPC = "Killed NPC",
	TALKED_TO_NPC = "Talked to NPC",
	SELECTED_DIALOGUE_OPTION = "Selected Dialogue Option",
	NPC_DROPPED_ITEM = "NPC Dropped Item",
	DIED = "Died",
	REZZED = "Rezzed",
	GOT_SAILING_ITEM = "Purchased Sailing Item",
	OPENED_INTERFACE = "Opened Interface",
	CLOSED_INTERFACE = "Closed Interface",
	STARTED_RAID = "Started Raid",
	TRAVELED = "Traveled",
	PLAYED_CUTSCENE = "Played Cutscene"
}

local index = function(_, key)
	if type(key) ~= 'string' then
		Log.error("Analytic event must be string.")
	else
		key = key:upper()
		if EVENTS[key] then
			return EVENTS[key]
		else
			Log.error("Analytic '%s' not found.", key)
		end
	end

	return nil
end

return setmetatable({}, { __index = index })
