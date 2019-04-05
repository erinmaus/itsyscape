speaker "Priest"

TARGET_NAME = _TARGET:getName()
message "Praise upon Yendor. Welcome His High Chambers, ${TARGET_NAME}."

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
				"This is the High Chambers of Yendor. Yendor only allows His most faithful into the lower chambers.",
				"The rest of His covenant are granted eternal life to roam the endless halls of the High Chambers.",
			}

			message {
				"Here, they are given the divine luxury of protecting the entrance to the lower chambers.",
				"Unfortunately, someone--a person with fierce weaponry and excellent combat prowess--managed to escape."
			}

			message {
				"They dwell at the bottom of the High Chambers in search of the entrance to the Low Chambers.",
				"They will not succeed."
			}

			message {
				"You may try and help them, or stop them. I won't get in the way.",
				"I sense Yendor's will, and He has a role for you yet."
			}

			speaker "_TARGET"

			message "But I've never even met Yendor!"

			speaker "Priest"

			message {
				"And neither have I. No one has seen Yendor in nearly a thousand years."
			}
		elseif result == BOTTOM then
			message {
				"A person flew through these halls and slayed dozens of Yendor's children.",
				"They carried a multitude of weapons and had extreme skill with blade, staff, and bow."
			}

			message {
				"Whoever they were, they lay at the bottom of this dungeon. Yendor tells me they seek his home.",
				"But no human has ever seen Yendor, for He wills against it. Only us, his First Children, may lay eyes upon His holiness."
			}
		elseif result == SELF then
			message {
				"I am a High Priest for Yendor. I serve at His command.",
				"Yendor tells me you will be useful in the days to come, so I'm here to guide you."
			}

			speaker "_TARGET"

			message {
				"Of course! I'm ${TARGET_NAME} after all, up-and-coming adventure extraordinare."
			}

			speaker "Priest"

			message "Yendor knows. Yendor knows all."
		elseif result == QUIT then
			message "Farewell, ${TARGET_NAME}. Stop the intruder and bring peace to these chambers."
		end
	end
end
