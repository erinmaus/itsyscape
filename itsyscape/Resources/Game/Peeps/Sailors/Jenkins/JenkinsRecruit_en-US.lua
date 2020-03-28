local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

PLAYER_NAME = _TARGET:getName()

speaker "_SELF"
message {
	"Ahoy! We meet 'gain, %person{${PLAYER_NAME}}"
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
		message "Well, ye should know who I be..."

		speaker "_TARGET"
		message "Good! That was a test! You passed."

		speaker "_SELF"
		message "What a terrible test, ye loon."
	elseif result == WHY_ARE_YOU then
		speaker "_TARGET"
		message "Why should I recruit you? You were a terrible Portmaster for Isabelle."

		speaker "_SELF"
		message {
			"Well, I still be needing money in me old age.",
			"Pensions and 401ks haven't been invented, yar."
		}

		message {
			"Anyways, I've got decades of 'sperience with the sea.",
			"I may not be too good with fightin' or anythin', but I can get ye where ye want.",
			"And I have some %hint{influence with pirates}, which mayhaps useful."
		}

		speaker "_TARGET"
		message "Well, we'll see about that, mate."
	elseif result == RECRUIT then
		speaker "_TARGET"
		message "I'm just pathetic and desperate! I have no other choice but to recruit you!"

		speaker "_SELF"
		message "...thanks? I be a bit desperate too, so I'm not asking for much..."

		local resource = Utility.Peep.getResource(_SPEAKERS["_SELF"])
		local buyAction = SailorsCommon.getBuyAction(
			_DIRECTOR:getGameInstance(),
			resource,
			'SailingBuy')
		if not buyAction then
			message "...but my bones are achy, I'm not ready to be sailin', mate."
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
message "Be seein' ye."
