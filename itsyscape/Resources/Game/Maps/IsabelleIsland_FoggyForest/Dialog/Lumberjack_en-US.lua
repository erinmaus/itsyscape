speaker "Lumberjack"

message "'Ello."

do
	local INFO = option "Can you tell me about this place?"
	local DO   = option "What are you doing?"
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
				"'Ere's the Foggy Forest. Lots o' trees to cut.",
				"Y'see, that's what I'm doin'. Gotta get that 99..."
			}

			message {
				"I burn 'em to scare away zombis and other ghouls.",
				"Never be knowin' what's out there..."
			}
		elseif result == DO then
			message {
				"Oh? I'm cuttin' trees and lightin' fires."
			}

			message {
				"Cuttin' trees is heavy work and requires a hatchet.",
				"Burnin' them logs is a bit easier and just requires a good ol' tinderbox."
			}

			message {
				"You can make incense out of 'em logs, too.",
				"The creepy fellow in the cabin to the ... north-east-ish sells goods for that."
			}

			message {
				"If you feelin' 'specially fancy, you can make weapons'n'stuff out of 'em logs.",
				"You'll need a knife. I know there's a feller 'round here who does that sort o' stuff."
			}

			message {
				"Would ya like to 'ee one of 'o skill guides?"
			}

			local WOODCUTTING = option "How about wood choppin'?"
			local FIREMAKING  = option "Firemakin', please!"
			local NONE        = option "No thanks!"

			local skillGuideChoice = select {
				WOODCUTTING,
				FIREMAKING,
				NONE
			}

			if skillGuideChoice == WOODCUTTING then
				Utility.UI.openInterface(_TARGET, "SkillGuide", true, "Woodcutting")
				result = QUIT
			elseif skillGuideChoice == FIREMAKING then
				Utility.UI.openInterface(_TARGET, "SkillGuide", true, "Firemaking")
				result = QUIT
			else
				message "Yer choice."
			end
		else
			message "Be seein' ya."
		end
	end
end
