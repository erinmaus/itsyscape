speaker "Priest"

TARGET_NAME = _TARGET:getName()
message {
	"Praise upon Yendor.",
	"Welcome to Her High Chambers, ${TARGET_NAME}."
}

do
	local INFO   = option "What's this place?"
	local BOTTOM = option "What's at the bottom of the chambers?"
	local SELF   = option "Who are you?"
	local QUIT   = option "Good-bye."

	local result
	while result ~= QUIT do
		result = select {
			INFO,
			BOTTOM,
			SELF,
			QUIT
		}

		if result == INFO then
			message {
				"This is the High Chambers of Yendor.",
				"Only the most devout may see the chambers that lay below these."
			}

			message {
				"Unfortunately, someone has slain dozens",
				"of her covenant on a foolhardy quest.",
				"They seem formidable with all kinds of weapons."
			}

			message {
				"They dwell at the bottom of the High Chambers in search of the entrance to the Low Chambers.",
				"They will not succeed."
			}

			message {
				"You may try and help them or stop them.",
				"I won't get in the way.",
				"I sense Yendor's will. She has a role for you yet."
			}

			speaker "_TARGET"

			message "But I've never even met Yendor!"

			speaker "Priest"

			message {
				"And neither have I.",
				"No one has seen Yendor in centuries."
			}
		elseif result == BOTTOM then
			message {
				"A person rode through these halls,",
				"slaying dozens of Yendor's children.",
				"They carried a few weapons,",
				"showing mastery of blade, staff, and bow."
			}

			message {
				"Whoever they are, they lay at the bottom of the Chambers.",
				"But no human has ever seen Yendor,",
				"and neither will this invader."
			}
		elseif result == SELF then
			message {
				"I am a High Priest for Yendor.",
				"I serve at Her command.",
				"She has a role for you yet."
			}

			speaker "_TARGET"

			message {
				"Of course! I'm ${TARGET_NAME} after all,",
				"up-and-coming adventure extraordinare!"
			}

			speaker "Priest"

			message "Yendor knows. Yendor knows all."
		elseif result == QUIT then
			message {
				"Farewell, ${TARGET_NAME}.",
				"Stop the intruder and bring peace to these chambers."
			}
		end
	end
end
