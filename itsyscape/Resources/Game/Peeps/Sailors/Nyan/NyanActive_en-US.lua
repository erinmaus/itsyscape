local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

PLAYER_NAME = _TARGET:getName()

speaker "_SELF"
message {
	"Oi! %person{${PLAYER_NAME}}, how's things going? Uh, woof!"
}

local CHAT      = option "Let's chat."
local SAIL      = option "Let's sail the seas!"
local DISMISS   = option "I'm afraid I don't need your services anymore."
local NEVERMIND = option "Good-bye."
local result

repeat
	result = select {
		CHAT,
		SAIL,
		DISMISS,
		NEVERMIND
	}

	if result == CHAT then
		local MESSAGES = {
			{
				"I've been itching to sail like I have a bad case of fleas. Come on, let's go!"
			},
			{
				"I fear no monster that resides in the sea.",
				"Instead, it's the other way around.",
				"Even Cthulhu fears me... Uh, woof!"
			},
			{
				"Woof woof woof!"
			}
		}
		local m = MESSAGES[math.random(#MESSAGES)]
		message(m)

		speaker "_TARGET"
		message "Awesome!"

		speaker "_SELF"
		message "I'm aware that's the case, yes. Uh, woof!"
	elseif result == SAIL then
		speaker "_TARGET"
		message "Let's set sail!"

		speaker "_SELF"
		message "Let's go the map table..."

		local map = Utility.Peep.getMapResource(_TARGET)
		local anchor = string.format("Anchor_Chart_%s", map.name)
		local destination = string.format("MapTable_Main?playerAnchor=%s,returnAnchor=Anchor_MapTable", map.name)

		local stage = _TARGET:getDirector():getGameInstance():getStage()
		stage:movePeep(_TARGET, destination, anchor)
	elseif result == DISMISS then
		speaker "_TARGET"
		message "I'm afraid our adventures must diverge now."

		speaker "_SELF"
		message "You may think that, but you will find you're wrong when the time comes."

		local YES = option "Yes, dismiss Nyan"
		local NO  = option "No, keep Nyan"
		local yesOrNo = select { YES, NO }

		if yesOrNo == YES then
			speaker "_SELF"
			message {
				"Farewell for now. If you change your mind, I'll be here for the rest of the day...",
				"But you're going to be paying for your stupidity."
			}

			SailorsCommon.unsetActiveFirstMateResource(_TARGET)
			return
		elseif yesOrNo == NO then
			speaker "_SELF"
			message "I thought not."

			speaker "_TARGET"
			message "You're just too cute!"

			speaker "_SELF"
			message "Thanks, I suppose? Uh, woof!"
		end
	end
until result == NEVERMIND

speaker "_SELF"
message "See you around, %person{${PLAYER_NAME}}."
