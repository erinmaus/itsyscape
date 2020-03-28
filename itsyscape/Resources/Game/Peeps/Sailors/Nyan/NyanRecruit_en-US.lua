local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

PLAYER_NAME = _TARGET:getName()

speaker "_SELF"
message {
	"Oi! %person{${PLAYER_NAME}}, how's things going? Uh, woof!"
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
		message "Who are you? I've never met a talking dog... that wants to sail a ship!"

		speaker "_SELF"
		message {
			"Well, I'm %person{Nyan}. I've been around for a long time...",
			"I suppose I'm immortal.",
			"I've been sailing the seas, plundering and exploring, longer than you've been alive."
		}

		speaker "_TARGET"
		message "That's a bold claim!"

		speaker "_SELF"
		message {
			"Doubt me all you want.",
			"Anyone who knows me, or heck, even of me, will say the same."
		}

		message {
			"I've sailed %hint{under the Jolly Roger and the Navy} all the same.",
			"I've met gods before they were banished, and fought them I suppose...",
			"If I'm your first mate, I've got your back, friend."
		}
	elseif result == WHY_ARE_YOU then
		speaker "_TARGET"
		message "Why should I recruit you? I mean, besides the fact you're a talking dog."

		speaker "_SELF"
		message {
			"I'm more than capable of fighting in hand-to-hand combat, or suppose in my case, hand-to-paw.",
			"I'll sail %hint{under the Jolly Roger}, if that's your inclination, as well.",
			"My reputation is legendary and my feats uncountable."
		}

		speaker "_TARGET"
		message "Really? So what's your biggest feat, then?"

		speaker "_SELF"
		speaker "I have too many, but if I have to choose one..."

		local FEATS = {
			{
				"Before the Empty King banished the Gods from the world, I encountered Cthulhu while sailing the City in the Sea.",
				"The fight was ferocious--entire islands were warped into horrors and remain desolate to this day.",
				"Yendor intervened, right before I land the killing below, pulling Cthulhu into Azathoth and sinking my ship."
			},

			{
				"When the Empty King performed their horrific ritual to banish gods from the world, I was sailing near what's now the Empty Ruins.",
				"The undead that rose from the ocean sunk my ship quicker than I could fight them off.",
				"I washed up on the shores of the Empty Ruins right upon the ritual, and succeeded in persuading the Empty King to let me live.",
				"The cost was heavy, and I will not speak of it..."
			},

			{
				"I'm a talking dog that's lived ten thousand years.",
				"I've seen kingdoms rise and fall. I've seen gods walk the world and witnessed the moment they were torn from this world into some other.",
				"I know more about the ocean than anyone or anything else, and I will gladly assist you on your quest."
			}
		}

		local feat = FEATS[math.random(#FEATS)]
		message(feat)

		speaker "_TARGET"
		message "That's a big tale for a small dog."

		speaker "_SELF"
		message "In time, you will find my claims to be true, whether I'm your first mate or not."
	elseif result == RECRUIT then
		speaker "_TARGET"
		message "No more! I will recruit you immediately!"

		speaker "_SELF"
		message "My services are not expensive, but neither are they cheap."

		local resource = Utility.Peep.getResource(_SPEAKERS["_SELF"])
		local buyAction = SailorsCommon.getBuyAction(
			_DIRECTOR:getGameInstance(),
			resource,
			'SailingBuy')
		if not buyAction then
			message "But I fear it's not the right time."
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
message "Fair travels, friend. We will meet time and time again, whether you realize it or not..."
