local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

PLAYER_NAME = _TARGET:getName()

speaker "_SELF"
message {
	"'Ey! Nice seeing ya, %person{${PLAYER_NAME}}!"
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
				"I'm new to this whole sailing thing, but I studied at the Seafarer's Guild at White Castle upon the Rock.",
				"I may only know the theory, but I'm a quickly learner and will help ya the best I can!"
			},
			{
				"I can use a blunderbuss like the best of 'em!",
				"I've trained for years in marksmanship. You won't be disappointed!"
			},
			{
				"My favorite color is yellow, but...",
				"Yellow doesn't garner the same respect as blue when you're a sailor or first mate, right?"
			}
		}
		local m = MESSAGES[math.random(#MESSAGES)]
		message(m)

		speaker "_TARGET"
		message "You've got this!"

		speaker "_SELF"
		message "Thanks for the kind words, %person{${PLAYER_NAME}}!"
	elseif result == SAIL then
		local map = Utility.Peep.getMapResource(_TARGET)
		local anchor = string.format("Anchor_Chart_%s", map.name)
		local destination = string.format("MapTable_Main?playerAnchor=%s,returnAnchor=Anchor_MapTable", map.name)

		local stage = _TARGET:getDirector():getGameInstance():getStage()
		stage:movePeep(_TARGET, destination, anchor)
	elseif result == DISMISS then
		speaker "_TARGET"
		message "I'm afraid I need someone more weathered on the seas."

		speaker "_SELF"
		message "Oh no! I'm so sorry you aren't happy with my services!"

		local YES = option "Yes, dismiss Elizabeth"
		local NO  = option "No, keep Elizabeth"
		local yesOrNo = select { YES, NO }

		if yesOrNo == YES then
			speaker "_SELF"
			message {
				"Oh well. It was nice working with you.",
				"I'll be here if you change your mind."
			}

			SailorsCommon.unsetActiveFirstMateResource(_TARGET)
			return
		elseif yesOrNo == NO then
			speaker "_SELF"
			message "Oh gosh, thanks!"
		end
	end
until result == NEVERMIND

speaker "_SELF"
message "Be seeing ya, Cap'n %person{${PLAYER_NAME}}! May your adventures be good!"
