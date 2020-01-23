speaker "Rosalind"

PLAYER_NAME = _TARGET:getName()
message {
	"Hello there, ${PLAYER_NAME}!",
	"I'm Rosalind, your local Idromancer. I can help you change your identity."
}

local INFO = option "What do you mean?"
local HELP = option "Can you help me?"
local QUIT = option "Later!"

local result
while result ~= QUIT do
	result = select {
		INFO,
		HELP,
		QUIT
	}

	if result == INFO then
		speaker "_TARGET"
		message {
			"What do you mean? What's an idromancer?"
		}

		speaker "Rosalind"
		message {
			"An idromancer uses transmogrification magic to change aspects of yourself.",
			"Personally, I can change your base look, gender, and name."
		}

		message {
			"And the best part is my services are free! I need the practice!"
		}

		speaker "_TARGET"
		message {
			"'Practice?' What exactly do you mean 'practice?'",
			"What if you turn me into a frog? Or worse, an invisible frog?!"
		}

		speaker "Rosalind"
		message {
			"Ha ha! I won't.",
			"I'm not skilled enough to make such a mistake.",
			"The worst that can happen is you make a decision you don't like."
		}

		message {
			"If it makes you feel better, I used to be Ganymede, but you'd never know!",
			"Pretty cool, huh?"
		}

		speaker "_TARGET"
		message "If you say so..."

		speaker "Rosalind"
	elseif result == HELP then
		message "Idro ick selfarus..."

		result = QUIT

		Utility.UI.openInterface(_TARGET, "CharacterCustomization", true)
	elseif result == QUIT then
		speaker "_TARGET"
		message "If I need your help I'll definitely visit!"

		speaker "Rosalind"
		message "Take care!"
	end
end
