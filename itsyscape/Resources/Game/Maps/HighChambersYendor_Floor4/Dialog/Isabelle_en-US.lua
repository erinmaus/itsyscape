speaker "Isabelle"

PLAYER_NAME = _TARGET:getName()

message {
	"You've discovered me, ${PLAYER_NAME}! How interesting.",
	"I'm willing to let you leave alive, for now, should you return to whence you came..."
}

local WHAT      = option "What are you doing?!"
local WHO       = option "Who do you think you are?"
local DIE       = option "Die, traitor!"
local NEVERMIND = option "Nevermind, I'll take you up on that offer!"

local option
repeat
	option = select {
		WHAT,
		WHO,
		DIE,
		NEVERMIND
	}

	if option == WHAT then
		speaker "_TARGET"
		message { 
			"What are you doing?! I thought you wanted to rid the island of the curse!"
		}

		speaker "Isabelle"
		message {
			"I will rid the entire world of the curse! The Empty King is beyond understanding.",
			"They must be dealt with by whatever means necessary."
		}

		message {
			"I have... a group of like-minded comrades who want to see The Empty King killed.",
		}

		message {
			"The Empty King threatens to bring ruin to the balance of things.",
			"This must not stand!",
			"They must be stopped at whatever cost!"
		}
	elseif option == WHO then
		speaker "_TARGET"
		message {
			"Who do you think you are?"
		}

		speaker "Isabelle"
		message {
			"I'm no helpless merchant. I was an expert warrior, inclined to all styles of combat.",
			"But then I was tricked into wearing this kursed amulet, and it drains so much of my potential."
		}

		message {
			"A group known as the Drakkenson offered to remove the kurse should I stop The Empty King.",
			"So here I am, on the verge of success! This ends now!"
		}
	elseif option == DIE then
		speaker "_TARGET"
		message {
			"You will die for lying to me!"
		}

		speaker "Isabelle"
		message {
			"Take it as you will. I will smite you."
		}
	end
until option == NEVERMIND or option == DIE

-- Transmute map object back.
local mapObject = Utility.Map.getMapObject(
	_DIRECTOR:getGameInstance(),
	"HighChambersYendor_Floor4",
	"Isabelle")
local isabelle = _SPEAKERS["Isabelle"]
Utility.Peep.setMapObject(isabelle, mapObject)

if option == DIE then
	Utility.Peep.attack(isabelle, _TARGET)
end
