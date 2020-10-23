PLAYER_NAME = _TARGET:getName()

local hasStartedQuest = _TARGET:getState():has("KeyItem", "MysteriousMachinations_Started")
local hasCompletedQuest = _TARGET:getState():has("Quest", "MysteriousMachinations")

local WHAT_R_U_DOING = option "What are you doing?"
local WHO_R_U        = option "Who are you?"
local CAN_I_HELP     = option "Can I help?"
local NOPE_IM_GOOD   = option "Nope, I'm good!"

local result
repeat
	result = select {
		WHAT_R_U_DOING,
		WHO_R_U,
		CAN_I_HELP,
		NOPE_IM_GOOD
	}

	if result == WHAT_R_U_DOING then
		speaker "_TARGET"
		message "What are you doing? This place is scary and impressive!"

		speaker "Hex"
		message {
			"Bwahahahaha! I detected a massive energy pulse frozen in time a thousand years ago.",
			"But time travel is messy! So I'm trying to bypass the whole 'paradox' thing by using my expertise with Antilogika."
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
				"Why, Antilogika is the the reality-warping, logic-defying powers of the Old Ones themselves!",
				"By using Antilogika, you cut out those silly obstacles known as plot-holes by rewriting reality to your whim.",
				"The limit is your imagination! Or lack there of."
			}

			speaker "_TARGET"
			message "That doesn't make any sense!"

			speaker "Hex"
			message {
				"It's not supposed to!",
				"You gotta let sense go, %person{${PLAYER_NAME}}, when you experiment with Antilogika!"
			}
		elseif result == OKAY_COOL_CRAZY then
			speaker "_TARGET"
			message "Okay, cool, you crazy lady!"

			speaker "Hex"
			message "Bwahahahaha! What makes YOU think I'm crazy?"

			speaker "Emily"
			message "Bleep bloop bleep."

			PRONOUN = Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_SUBJECT)

			speaker "Hex"
			message "Exactly! ${PRONOUN} crazy, that's all, %person{Emily}!"

			speaker "_TARGET"
			message "I'm right here, %person{Hex}!"

			speaker "Hex"
			message "Oh, I forgot. How rude of me. %person{Emily}, speak %hint{Squeakish}, puh-LEASE!"

			speaker "Emily"
			message {
				"Bleep bloop bleep.",
				"",
				"...Apologies for speaking %hint{Beepish}. I told %person{Hex} she is the most sane person in the Realm while you are a bonafide loon.",
				"Your reputation exceeds the incorrectly understood casuality of the universe and time itself."
			}

			speaker "_TARGET"
			message "Wooooow."
		end
	elseif result == WHO_R_U then
		speaker "_TARGET"
		message "I'm %person{${PLAYER_NAME}}, as you might know. Who are you?"

		speaker "Hex"
		message {
			"Bwahahahaha! I'm Hex, the Techromancer! A lady of the most devious of sciences!",
			"%person{Emily}, introduce yourself, too!"
		}

		speaker "Emily"
		message {
			"I am %person{Emily}. Emily stands for %hint{Emergent Intelligence Life Ynit}.",
			"My %hint{core processing unit} exists outside of the time-space continuum.",
			"In other words, I am seeing you now and also as you stand before %empty{The Empty King} at Skull Island."
		}

		local WAIT_WHAT        = option "Wait, what?! The Empty King?!"
		local OK_SURE_WHATEVER = option "Okay, sure, whatever."

		result = select {
			WAIT_WHAT,
			OK_SURE_WHATEVER
		}

		if result == WAIT_WHAT then
			speaker "_TARGET"
			message {
				"Wait, what?! %empty{The Empty King}?!",
				"How do you know of them?",
			}

			speaker "Hex"
			message {
				"Well, that's obvious! Emily must be with you when you face %empty{The Empty King}!",
				"I wish she told me this earlier, it would have sped up my research..."
			}

			speaker "Emily"
			message {
				"By my calculations, telling you now was the most efficient time."
			}

			speaker "Hex"
			message "Interesting... THUH-THANK you, %person{Emily}!"
		elseif result == OK_SURE_WHATEVER then
			speaker "_TARGET"
			message {
				"Okay, sure, sure, whatever. I'd rather hit my head on a space bar."
			}

			speaker "Hex"
			message "What's that?"

			speaker "Emily"
			message "It's a fourth-wall immersion-breaking reference to pressing the space bar on the player's keyboard to skip dialog."

			speaker "Hex"
			message "Oh, the fourth-wall. Who cares. TUH-ME FOR SCIENCE!"
		end
	elseif result == CAN_I_HELP then
		speaker "_TARGET"
		message "Can I help you with anything? I'm always looking for a quest!"

		speaker "Hex"
		message "You are exactly the person I need!"
		message {
			"You might have noticed those %hint{mysterious draconic creatures} in the life support vats.",
			"They are based off a race of sapient creatures of legend called the Drakkenson, who jump through time like we walk through a field.",
			"Few have lived to speak of their encounters."
		}
		message {
			"My hunch is these creatures reside in a split timeline called Azathoth...",
			"...but I've not been able to build a stable portal to Azathoth.",
			"The Old Ones built world gates connecting the two realities eons ago, before they were banished from the Realm."
		}
		message {
			"I need you to help me reverse engineer their tech to build a portal to Azathoth. Can you help me?"
		}

		-- TODO QUEST ACCEPT SCREEN
		local YES = option "Yes"
		local NO  = option "No"
		result = select {
			YES,
			NO
		}

		if result == YES then
			speaker "_TARGET"
			message "Of course I can!"

			local started = Utility.Quest.start("MysteriousMachinations", _TARGET)
			if not started then
				speaker "Hex"
				message "WAIT! LIAR! You can't! Try again when you're more skilled."
			else
				speaker "Hex"
				message "Great!"
			end
		elseif result == NO then
			speaker "_TARGET"
			message "I'm not in the mood for a quest anymore."
		end
	end
until option == NOPE_IM_GOOD

speaker "_TARGET"
message "Nope! I'm good as a goober!"
