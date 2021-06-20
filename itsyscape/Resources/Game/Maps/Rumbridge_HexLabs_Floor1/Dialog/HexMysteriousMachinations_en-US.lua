PLAYER_NAME = _TARGET:getName()

local hasStartedQuest = _TARGET:getState():has("KeyItem", "MysteriousMachinations_Started")

local WHAT_R_U_DOING = option "What are you doing?"
local WHO_R_U        = option "Who are you?"
local QUEST
do
	if hasStartedQuest then
		QUEST        = option "What's next?"
	else
		QUEST        = option "Can I help?"
	end
end
local NOPE_IM_GOOD   = option "Nope, I'm good!"

local result
repeat
	result = select {
		WHAT_R_U_DOING,
		WHO_R_U,
		QUEST,
		NOPE_IM_GOOD
	}

	if result == WHAT_R_U_DOING then
		speaker "_TARGET"
		message {
			"What are you doing?",
			"This place is scary!"
		}

		speaker "Hex"
		message {
			"Bwahaha!",
			"I'm a %hint{Techromancer}! A scholar! A scientist!",
			"And most of all, a master of %hint{Antilogika}..."
		}

		local WHAT_IS_ANTILOGIKA = option "Woah! What's Antilogika?"
		local OKAY_COOL_CRAZY      = option "Okay, cool, you crazy lady!"

		result = select {
			WHAT_IS_ANTILOGIKA,
			OKAY_COOL_CRAZY
		}

		if result == WHAT_IS_ANTILOGIKA then
			speaker "_TARGET"
			message "Woah! What is Antilogika? Sounds dangerous!"

			speaker "Hex"
			message {
				"Antilogika is totally dangerous!",
				"I'm harnessing Old One's tech!",
				"Gotta understand their %hint{reality-warping, logic-defying} powers!"
			}

			message {
				"Make water dry and circles square!",
				"Bend the very fabric of space-time to your whim!",
				"It's like a comic book superhero!",
				"Just without the puh-LOT holes!"
			}

			speaker "_TARGET"
			message "That doesn't make any sense!"

			speaker "Hex"
			message {
				"It's not supposed to!",
				"You gotta let sense go when",
				"you experiment with Antilogika!"
			}
		elseif result == OKAY_COOL_CRAZY then
			speaker "_TARGET"
			message "Okay, cool, you crazy lady!"

			speaker "Hex"
			message "Bwahaha! What makes YOU think I'm crazy?"

			speaker "Emily"
			message "Bleep bloop bleep."

			PRONOUN = Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_SUBJECT, "en-US", true)
			IS_OR_ARE = Utility.Text.getEnglishBe(_TARGET).present

			speaker "Hex"
			message "Exactly! ${PRONOUN} ${IS_OR_ARE} crazy, that's all, %person{Emily}!"

			speaker "_TARGET"
			message "I'm right here, %person{Hex}!"

			speaker "Hex"
			message {
				"Oh, I forgot.",
				"How rude of me!",
				"%person{Emily}, speak %hint{Squeakish}, puh-LEASE!"
			}

			speaker "Emily"
			message "Bleep bloop bleep."

			message {
				"Apologies for speaking %hint{Beepish}.",
				"To a higher-dimensional entity like myself,",
				"your primitive, three-dimensional understanding",
				"of reality is... profoundly silly."
			}

			speaker "_TARGET"
			message {
				"Wooooow.",
				"Thanks for that."
			}

			speaker "Emily"
			message "You are most welcome!"
		end
	elseif result == WHO_R_U then
		speaker "_TARGET"
		message "I'm %person{${PLAYER_NAME}}, as you might know. Who are you?"

		speaker "Hex"
		message {
			"Bwahaha! I'm %person{Hex}, a Techromancer!",
			"A lady of the most devious of sciences!",
			"%person{Emily}, introduce yourself, too, puh-LEASE!"
		}

		speaker "Emily"
		message {
			"I am %person{Emily}.",
			"%person{Emily} stands for %hint{Emergent Intelligence Life Ynit}.",
			"My %hint{core processing unit} is four-dimensional."
		}

		local WAIT_WHAT        = option "How does that work?"
		local OK_SURE_WHATEVER = option "Okay, sure, whatever."

		result = select {
			WAIT_WHAT,
			OK_SURE_WHATEVER
		}

		if result == WAIT_WHAT then
			speaker "_TARGET"
			message "How does that work?"

			speaker "Hex"
			message {
				"Don't you know? %hint{Antilogika defies logic!}",
				"Emily is my finest creation! She's UH-MAZING!",
				"She can see that past, present, and future at once!"
			}

			message {
				"Using %hint{exotic materials} while %hint{exploring},",
				"I was able to build a four-dimensional CPU!",
				"She's now my finest assistant."
			}
		elseif result == OK_SURE_WHATEVER then
			speaker "_TARGET"
			message {
				"Okay, sure, sure, whatever.",
				"I'd rather hit my head on a space bar."
			}

			speaker "Hex"
			message "What's that?"

			speaker "Emily"
			message {
				"It's a fourth-wall immersion-breaking reference.",
				"Pressing the space bar on a keyboard skips dialog."
			}

			speaker "Hex"
			message {
				"Oh, the fourth-wall?! Who cares!",
				"TUH-IME FOR SCIENCE!"
			}
		end
	elseif result == QUEST then
		defer "Resources/Game/Maps/Rumbridge_HexLabs_Floor1/Dialog/HexMysteriousMachinationsInProgress_en-US.lua"
	end
until result == NOPE_IM_GOOD

speaker "_TARGET"
message "Nope! I'm good as a goober!"
