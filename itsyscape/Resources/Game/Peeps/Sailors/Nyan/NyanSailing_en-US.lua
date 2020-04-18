local Sailing = require "ItsyScape.Game.Skills.Sailing"
local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

PLAYER_NAME = _TARGET:getName()

speaker "_SELF"
message {
	"Oi! %person{${PLAYER_NAME}}, nice weather, eh? Uh, woof!"
}

local CONTINUE  = option "Let's continue our voyage."
local GOTO_BOAT = option "I need to visit the ship."
local EXPLORE   = option "I'm going to explore."
local result

repeat
	result = select {
		CONTINUE,
		GOTO_BOAT,
		EXPLORE
	}

	if result == CONTINUE then
		speaker "_TARGET"
		message "I'm ready to go; let's continue our voyage."

		speaker "_SELF"
		message "Alright, got it! Off we go! Uh, woof!"

		Sailing.Orchestration.step(_TARGET)
		return
	elseif result == GOTO_BOAT then
		speaker "_TARGET"
		message "I need to visit the ship."

		speaker "_SELF"
		message "I can't let you do that, %person{Dave}."
	elseif result == EXPLORE then
		local map = Utility.Peep.getMapResource(_TARGET)
		MAP_NAME = Utility.getName(map, _TARGET:getDirector():getGameDB())

		speaker "_TARGET"
		message "I'm going to explore; %location{${MAP_NAME}} looks cool!"
	end
until result == EXPLORE

speaker "_SELF"
message "Have fun, be safe, don't die!"
