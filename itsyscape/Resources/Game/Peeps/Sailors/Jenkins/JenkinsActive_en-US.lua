local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

PLAYER_NAME = _TARGET:getName()

speaker "_SELF"
message {
	"Ahoy! We meet 'gain, %person{${PLAYER_NAME}}"
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
				"I used to be a pirate, mate, but those days a long behind me.",
				"I %hint{refuse sail under the Jolly Roger}."
			},
			{
				"Cap'n Raven and I go ways back.",
				"She's the finest Cap'n I ever 'new, and the finest sailor I've ever met.",
				"If ye face her on the seas, may the gods be with ye, mate."
			},
			{
				"I used to be Cap'n Raven's first mate.",
				"We 'unted Cthulhu to the ends of the world, but never found him 'til you were on board.",
				"We gots lucky that he only sunk our ship, and didn't make us one of his thralls."
			}
		}
		local m = MESSAGES[math.random(#MESSAGES)]
		message(m)

		speaker "_TARGET"
		message "I would've never known!"

		speaker "_SELF"
		message "'Ere's to that, mate."
	elseif result == SAIL then
		local map = Utility.Peep.getMapResource(_TARGET)
		local anchor = string.format("Anchor_Chart_%s", map.name)
		local destination = string.format("MapTable_Main?playerAnchor=%s,returnAnchor=Anchor_MapTable", map.name)

		local stage = _TARGET:getDirector():getGameInstance():getStage()
		stage:movePeep(_TARGET, destination, anchor)
	elseif result == DISMISS then
		speaker "_TARGET"
		message "I'm afraid I'm looking for someone better."

		speaker "_SELF"
		message "I knew this day would be comin'. Don't worry, no hard feelin's."

		local YES = option "Yes, dismiss Jenkins"
		local NO  = option "No, keep Jenkins"
		local yesOrNo = select { YES, NO }

		if yesOrNo == YES then
			speaker "_SELF"
			message {
				"Later, mate. I'll be 'ere for a little bit longer.",
				"If ye change ye mind, I don't hold no grudges."
			}

			SailorsCommon.unsetActiveFirstMateResource(_TARGET)
			return
		elseif yesOrNo == NO then
			speaker "_SELF"
			message "Gods be good. Thanks, mate."
		end
	end
until result == NEVERMIND

speaker "_SELF"
message "See ye 'round, Cap'n %person{${PLAYER_NAME}}."
