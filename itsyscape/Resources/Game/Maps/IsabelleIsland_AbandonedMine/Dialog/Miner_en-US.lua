speaker "Miner"

TARGET_NAME = _TARGET:getName()
message "There's hope yet!"

do
	local INFO = option "What's wrong?"
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
				"I've been gravely wounded by those evil Skelementals roaming the halls.",
				"They're stronger than they look."
			}

			message "I'm too weak to leave, so I'm resting here."
		elseif result == DO then
			message {
				"I was mining when I was ambushed by undead!",
				"I'm a miner, not a fighter, so I fled."
			}

			message {
				"Mining is slow work and prestigious.",
				"Every ore is a hardship!",
				"You should be proud of every XP you get."
			}

			message "Do you want to see the mining skill guide?"

			local YES = option "Go for it."
			local NO  = option "Not really."

			local openSkillGuide = select {
				YES,
				NO
			}

			if openSkillGuide == YES then
				Utility.UI.openInterface(_TARGET, "SkillGuide", true, "Mining")
				result = QUIT
			else
				message "Of course, time is of the essence."
			end
		else
			message {
				"Be prepared! Find Joe.",
				"He has food and can help you find the foreman."
			}
		end
	end
end
