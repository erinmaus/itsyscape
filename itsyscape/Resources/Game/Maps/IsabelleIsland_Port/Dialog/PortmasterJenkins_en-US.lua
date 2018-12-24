speaker "Jenkins"

JENKINS_NAME = _SPEAKERS["Jenkins"]:getName()
TARGET_NAME = _TARGET:getName()
message "Ahoy, ${TARGET_NAME}, I'm ${JENKINS_NAME}."
message "Ye be timing yer visit badly."

local INFO      = option "Can you tell me about the squid?"
local SAIL      = option "Let's set sail!"
local NEVERMIND = option "I've gotta run."
local result
repeat
	result = select {
		INFO,
		SAIL,
		NEVERMIND
	}

	if result == INFO then
		message {
			"Squids were the holiest of Yendor's pets.",
			"Them crazy priests of 'is would bring 'em to land and smother 'em."
		}

		message {
			"The squids were reborn, like all of 'is loons, and haunt the seas.",
			"They lurked at the deepest oceans guarding The City in the Sea.",
			"...or as us pirates would call it, Davy Jone's Tomb."
		}

		speaker "_TARGET"

		message {
			"So what's gone on now?",
			"Grimm mentioned there's one squid that's keeping us at port."
		}

		speaker "Jenkins"

		message {
			"Aye, ye be right on 'at.",
			"They've grown restless since 'is vanishin'.",
			"Mun'throo is the strongest of his pets, and he's being causing us nothin' but trouble."
		}

		message {
			"According to Miss Isabelle, Mun'throo gots a skull!",
			"Without 'at skull, he's a goner and the enchantments broken.",
			"Ever heard of 'at, a squid with a skull?"
		}

		speaker "_TARGET"

		message "Can't say I have, but you pirates have had weirder tales!"

		speaker "Jenkins"
		message {
			"Watch yer mouth.",
			"I ain't no pirate no more."
		}
	elseif result == SAIL then
		message {
			"I'll give ye the supplies to man the ship, and ye've got the help of my crew.",
			"But it's a bad omen to slay the undead on the seas, so yer on yer own with the killin'."
		}

		speaker "_TARGET"

		message "I don't believe in sailors superstitions!"

		speaker "Jenkins"
		message {
			"Aye, ye be sure ye wantin' to do that?",
			"Sink or sail, there's no turning back, mate."
		}

		local YES = option "Raise the sails!"
		local NO  = option "I'm a landlubber!"

		local choice = select {
			YES,
			NO
		}

		if choice == YES then
			local stage = _TARGET:getDirector():getGameInstance():getStage()
			stage:movePeep(
				_TARGET,
				"Ship_IsabelleIsland_PortmasterJenkins?map=IsabelleIsland_Ocean,i=16,j=16",
				"Anchor_Spawn")
			result = NEVERMIND
		elseif choice == NO then
			message "Wet feet, aye? Har har har!"
		end
	elseif result == NEVERMIND then
		message {
			"Ye best plan yer route.",
			"The mines are dangerous and the forest even deadlier.",
			"I suggest ye deal with this squid to prepare ye for the rest."
		}

		message {
			"But it's yer choice in the end, mate."
		}
	end
until result == NEVERMIND
