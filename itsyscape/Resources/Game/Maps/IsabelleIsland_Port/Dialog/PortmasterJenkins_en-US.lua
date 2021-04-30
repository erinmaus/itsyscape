speaker "Jenkins"

JENKINS_NAME = _SPEAKERS["Jenkins"]:getName()
TARGET_NAME = _TARGET:getName()
message {
	"Ahoy, %person{${TARGET_NAME}}.",
	"Sorries 'bout ye trip here.",
	"Glad ye made it, however the hells ye did.",
	"Most others ain't so lucky."
}

local INFO      = option "Can you tell me about the squid?"
local SAIL      = option "Let's set sail!"
local RUMBRIDGE = option "Let's head to Rumbridge!"
local NEVERMIND = option "I've gotta run."
local result
repeat
	if _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_TalkedToIsabelle2") then
		result = select {
			INFO,
			SAIL,
			RUMBRIDGE,
			NEVERMIND
		}
	else
		result = select {
			INFO,
			SAIL,
			NEVERMIND
		}
	end

	if result == INFO then
		message {
			"Squids were the holiest of %person{Yendor}'s pets.",
			"Them crazy priests of 'ers would bring 'em to land",
			"only to then smother 'em 'til they croaked!"
		}

		message {
			"The squids were reborn and haunt the seas.",
			"Much like all of %person{Yendor's} loons.",
			"They guard %location{The City in the Sea}... *shiver*"
		}

		speaker "_TARGET"

		message {
			"So what's going on now?",
			"%person{Grimm} mentioned we're stuck at port."
		}

		speaker "Jenkins"

		message {
			"Aye, ye be right on 'at.",
			"They've grown restless since recent times.",
			"%person{Mun'throo} is the strongest of 'er pets,",
			"and he's being causing us nothin' but grief."
		}

		message {
			"According to %person{Miss Isabelle}, %person{Mun'throo} gots a skull!",
			"Without 'at skull, he's a goner!",
			"Ever heard of 'at, a squid with a skull?"
		}

		speaker "_TARGET"

		message {
			"Can't say I have!",
			"But you pirates have had weirder tales!"
		}

		speaker "Jenkins"
		message {
			"Watch yer mouth.",
			"I ain't no pirate no more."
		}
	elseif result == SAIL then
		message {
			"I'll give ye the supplies to man the ship,",
			"and ye've got the help of my crew.",
			"But it's a %hint{bad omen to slay the undead} on the seas,",
			"so yer on yer own with the killin'."
		}

		speaker "_TARGET"

		message "I don't believe in sailors' superstitions!"

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
			local count = _TARGET:getState():count("Item", "IronCannonball", { ['item-inventory'] = true })
			local difference = math.max(15 - count, 0)
			if difference > 0 and not Utility.Item.spawnInPeepInventory(_TARGET, "IronCannonball", difference) then
				message {
					"Arr, we ain't be sailin' with yer full inventory.",
					"Make some room for supplies! Ye need a slot for cannonballs."
				}
			else
				message {
					"'Ere be some cannonballs to help ye.",
					"%hint{Try'n aim for the squid} 'n fire from the cannons.",
					"Or, y'know, ye might as well jump overboard.",
				}

				message {
					"And if the ship takes damage, patch 'er up and plug any leaks."
				}

				message "Anchors away!"

				local stage = _TARGET:getDirector():getGameInstance():getStage()
				stage:movePeep(
					_TARGET,
					"Ship_IsabelleIsland_PortmasterJenkins?map=IsabelleIsland_Ocean,jenkins_state=0,i=16,j=16,shore=IsabelleIsland_Port,shoreAnchor=Anchor_ReturnFromSea",
					"Anchor_Spawn")
				result = NEVERMIND
			end
		elseif choice == NO then
			message "Wet feet, aye? Har har har!"
		end
	elseif result == RUMBRIDGE then
		message {
			"AAAAAH! Earthquake!" 
		}

		message "..."

		message {
			"No way in 'ell we'll be sailin' now.",
			"The waters will be angry, mate.",
			"Might be wanting to see what caused that."
		}

		speaker "_TARGET"

		message {
			"It felt like it came from direction of the %location{Abandoned Mine}."
		}

		speaker "Jenkins"

		message {
			"Best be investigatin', then."
		}

		_TARGET:getState():give("KeyItem", "CalmBeforeTheStorm_TalkedToJenkins")
	elseif result == NEVERMIND then
		message {
			"Ye best plan yer route.",
			"The %hint{mines are dangerous}.",
			"And the %hint{forest even deadlier}.",
			"The squid might be the easiest o' the three."
		}

		message {
			"But it's yer choice in the end, mate."
		}
	end
until result == NEVERMIND
