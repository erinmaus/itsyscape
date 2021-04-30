speaker "Crafter"

TARGET_NAME = _TARGET:getName()
message "Hello, dear."

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
				"This is %location{Isabelle Tower}.",
				"It's not very tall, or fancy, but it serves its purpose."
			}

			message {
				"There's useful stuff around these parts.",
				"You can use them to craft a variety of goods.",
				"Let me know if you have any questions, dear."
			}
		elseif result == DO then
			message {
				"I make all kinds of clothes and armor from fabrics.",
				"With some thread and a needle,",
				"anything is possible."
			}

			message {
				"There's more you can do with crafting:",
				"you can make weapons and incense, too.",
				"Very useful stuff for your adventures, dear."
			}

			message {
				"Would you like to see the crafting skill guide?"
			}

			local YES = option "Alright!"
			local NO  = option "No thank you!"

			local openSkillGuide = select {
				YES,
				NO
			}

			if openSkillGuide == YES then
				Utility.UI.openInterface(_TARGET, "SkillGuide", true, "Crafting")
				result = QUIT
			else
				message "Understood, dear."
			end
		else
			message {
				"Safe travels, %person{${TARGET_NAME}}.",
				"May %person{Bastiel} guide you."
			}
		end
	end
end
