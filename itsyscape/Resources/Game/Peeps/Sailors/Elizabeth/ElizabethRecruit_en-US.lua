local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

PLAYER_NAME = _TARGET:getName()

speaker "_SELF"
message {
	"'Ey! Nice seeing ya, %person{${PLAYER_NAME}}!"
}

local WHO_ARE_YOU = option "Who are you?"
local WHY_ARE_YOU = option "Why should I recruit you?"
local RECRUIT     = option "Do you want to be my first mate?"
local NEVERMIND   = option "Good-bye."
local result

repeat
	result = select {
		WHO_ARE_YOU,
		WHY_ARE_YOU,
		RECRUIT,
		NEVERMIND
	}

	if result == WHO_ARE_YOU then
		speaker "_TARGET"
		message "Who are you?"

		speaker "_SELF"
		message {
			"I'm a green sailor! The name's %person{Elizabeth}!",
			"I'm new to this whole sailing thing, but I've got the raw talent to succeed!"
		}

		speaker "_TARGET"
		message "Where did you learn to sail?"

		speaker "_SELF"
		message {
			"I learned from the Seafarer's Guild at White Castle upon the Rock!",
			"My instructors were the most prestigious, and I may not have much practical experience, I have the theory down!",
			"Plus I'm great with a blunderbuss!"
		}
	elseif result == WHY_ARE_YOU then
		speaker "_TARGET"
		message "Why should I recruit you? You're new to this whole thing."

		speaker "_SELF"
		message {
			"I may be knew, but we can grow together!",
			"I'll %hint{follow you no matter what}, and my services aren't too expensive."
		}

		message {
			"I've always dreamed of sailing the seas and the adventures that may come!"
		}

		speaker "_TARGET"
		message "Well, maybe..."
	elseif result == RECRUIT then
		speaker "_TARGET"
		message "You know what, I'll give you a chance!"

		speaker "_SELF"
		message "Oh my gosh? Really? Thank you so much, friend!"

		local resource = Utility.Peep.getResource(_SPEAKERS["_SELF"])
		local buyAction = SailorsCommon.getBuyAction(
			_DIRECTOR:getGameInstance(),
			resource,
			'SailingBuy')
		if not buyAction then
			message "But I'm getting wet feet. Maybe later..."
		else
			Utility.UI.openInterface(
				_TARGET,
				"ExpensiveBuy",
				true,
				resource, buyAction, _SPEAKERS["_SELF"])
			return
		end
	end
until result == NEVERMIND

speaker "_TARGET"
message "Well, that's all for now. Good-bye."

speaker "_SELF"
message "Safe travels, friend!"
