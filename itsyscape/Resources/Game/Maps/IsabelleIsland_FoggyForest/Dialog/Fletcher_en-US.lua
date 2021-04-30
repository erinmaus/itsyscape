speaker "Fletcher"

message "Yo yo yo!"

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
				"Gotcha! You're in the %location{Foggy Forest}.",
				"Lots of undead creeps roam this area."
			}

			message {
				"But I'm prepared, ha ha ha!",
				"Those wood nymphs sure don't like bows! Poke!"
			}

		elseif result == DO then
			message {
				"I'm a self-sufficient archer!",
				"I gotta make my own arrows and bows.",
			}

			message {
				"With a knife, you can make little work of logs",
				"to make arrow shafts and bows like me."
			}

			message {
				"Gotta smith arrowheads and get some feathers",
				"if you want to make arrows.",
			}

			message {
				"Bows need bowstring, which is spun from flax.",
				"Luckily there's wild flax here."
			}

			message {
				"With some skill, you can make a longbow like me.",
				"It goes a lot further than a regular bow!"
			}

			message {
				"If you're good, you can run around and stay out of the range of anyone.",
				"Even those pesky wood nymphs!"
			}

			local YES = option "Yes!"
			local NO  = option "No!"

			message {
				"Wanna see the fletching skill guide?"
			}

			local openSkillGuide = select {
				YES,
				NO
			}

			if openSkillGuide == YES then
				Utility.UI.openInterface(_TARGET, "SkillGuide", true, "Fletching")
				result = QUIT
			else
				message "Gotcha."
			end
		else
			message "Later, yo."
		end
	end
end
