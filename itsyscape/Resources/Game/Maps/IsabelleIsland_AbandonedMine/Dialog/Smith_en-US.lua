speaker "Smith"

TARGET_NAME = _TARGET:getName()
message "Finally! %person{${TARGET_NAME}}!"

do
	local INFO = option "Can you tell me about this place?"
	local DO   = option "What do you do?"
	local QUIT = option "Nevermind."

	local result
	while result ~= QUIT do
		result = select {
			INFO,
			DO,
			QUIT
		}

		if result == INFO then
			message {
				"This is the %location{Abandoned Mine}.",
				"But it's, like, super haunted!",
			}

			message {
				"Thankfully I found a place to hide.",
				"But I've lost my %item{hammer}!",
				"And am too scared to leave!"
			}

			if _TARGET:getState():has("Item", "Hammer", 1, { ['item-inventory'] = true }) then
				local OFFER  = option "Offer the smith your hammer."
				local IGNORE = option "Let the smith suffer."

				local offerOption = select {
					OFFER,
					IGNORE
				}

				if offerOption == OFFER then
					speaker "_TARGET"
					message "Why don't you take my %item{hammer}?"

					speaker "Smith"
					message {
						"I can't bear to deprive an up-and-coming smith!",
						"I'll get out of here... Eventually..."
					}
				end
			end
		elseif result == DO then
			message {
				"As a smith, I make armor and weapons from bars.",
				"And I smelt bars from ores."
			}

			message {
				"The more bars, the more experience you'll get.",
				"Try and make the best stuff you can--it will pay off!"
			}

			message "Wanna to show you what stuff you can make?"

			local YES = option "Absolutely!"
			local NO  = option "Spoilers are bad!"

			local openSkillGuide = select {
				YES,
				NO
			}

			if openSkillGuide == YES then
				Utility.UI.openInterface(_TARGET, "SkillGuide", true, "Smithing")
				result = QUIT
			else
				message "If you must."
			end
		else
			message {
				"Be safe! Make a tin can and a copper badge to hide among the Skelementals."
			}
		end
	end
end
