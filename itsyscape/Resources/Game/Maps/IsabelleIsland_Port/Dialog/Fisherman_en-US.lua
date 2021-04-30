speaker "Fisherman"

TARGET_NAME = _TARGET:getName()
message {
	"'Ey, there " ..
		Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_SUBJECT) ..
		" " ..
		Utility.Text.getEnglishBe(_TARGET).present ..
		".",
	"How's it goin', %person{${TARGET_NAME}}?"
}

do
	local INFO = option "What's going on?"
	local DO   = option "Who are you?"
	local QUIT = option "See ya, chum!"

	local result
	while result ~= QUIT do
		result = select {
			INFO,
			DO,
			QUIT
		}

		if result == INFO then
			message {
				"'Ere's Port Isabelle.",
				"Normally we'd be bustlin' with peeps...",
				"...but an awesome squid is terrorizing the waters."
			}

			message {
				"The squid is vicious, but none wanna fight it.",
				"See, it's a bad omen to kill the undead at sea.",
				"And y'know how superstitious sailors are..."
			}
		elseif result == DO then
			message {
				"I'm a fisherman. I'd be out fishin' but the undead give me the chills.",
			}

			message {
				"I buy my bait from the shop nearby,",
				"and with my trust fishin' rod,",
				"find some fish near the surface."
			}

			message {
				"I go 'n toss out my line and wait.",
				"Every nibble takes some bait,",
				"so best be carrying lots o' it.",
			}

			message {
				"You can cook 'em fish for food that can heal ya.",
				"Helps when you're in a pickle fightin'."
			}

			message {
				"Wanna see what's ahead of you on your fishy adventure?"
			}

			local YES = option "Definitely, mate!"
			local NO  = option "No thanks, chum!"

			local option = select {
				YES,
				NO
			}

			if option == YES then
				Utility.UI.openInterface(_TARGET, "SkillGuide", true, "Fishing")
				result = QUIT
			elseif option == NO then
				message "Alright, mate."
			end
		else
			message "You too, mate."
		end
	end
end
