local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"
local isFollowing = _SPEAKERS["Lyra"]:hasBehavior(FollowerBehavior)

if isFollowing then
	defer "Resources/Game/Maps/Rumbridge_Town_Center_South/Dialog/LyraFollow_en-US.lua"
	return
end

local hasCompletedQuest = _TARGET:getState():has("Quest", "SuperSupperSaboteur")
if hasCompletedQuest then
	defer "Resources/Game/Maps/Rumbridge_Town_Center_South/Dialog/LyraPostQuest_en-US.lua"
	return
end

speaker "Lyra"
message {
	"Good tidings and welcome to Rumbridge.",
	"How may I help you, adventurer?"
}

PLAYER_NAME = _TARGET:getName()

do
	local WHO  = option "Who are you?"
	local DO   = option "What do you do?"
	local QUIT = option "Nevermind."

	local SUPER_SUPPER_SABOTEUR
	if _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_TalkedToGuardCaptain") then
		SUPER_SUPPER_SABOTEUR = option "Talk about Super Supper Saboteur."
	end

	local result
	while result ~= QUIT do
		if SUPER_SUPPER_SABOTEUR then
			result = select {
				WHO,
				DO,
				SUPER_SUPPER_SABOTEUR,
				QUIT
			}
		else
			result = select {
				WHO,
				DO,
				QUIT
			}
		end

		if result == WHO then
			message {
				"I'm Lyra, and that little wolf is my familar, Oliver.",
				"As a member of witch society,",
				"I help those who need it."
			}

			message {
				"I sense you'll be seeking me out in the future, %person{${PLAYER_NAME}}."
			}

			speaker "_TARGET"

			message {
				"How do you know that?!"
			}

			speaker "Lyra"

			message {
				"It's just a hunch.",
				"Nothing more, nothing less.",
				"Or maybe I just like messing with adventurers!"
			}

			speaker "_TARGET"

			message "That's not nice!"

			speaker "Lyra"

			message "Well, it's not mean either, is it now?"

		elseif result == DO then
			message {
				"Us witches have a natural affinity",
				"to sense even the smallest changes in magic.",
				"But there's something wrong."
			}

			message {
				"Our connection to magic has shifted.",
				"Before, we could do magic without runes.",
				"But year after year, it grows harder for us."
			}

			message "I'm trying to discover what is wrong."

			local RUNE = option "You can perform magic without runes?"
			local BAD  = option "That sounds bad!"

			local subResult = select { RUNE, BAD }

			if subResult == RUNE then
				speaker "_TARGET"

				message {
					"You can perform magic without runes? How?"
				}

				speaker "Lyra"

				if _TARGET:getState():count("Skill", "Magic", { ['skill-as-level'] = true }) < 5 then
					message {
						"Well, so could you for a time,",
						"if you had a higher magic to use Nirvana.",
						"We've had centuries to perfect our powers."
					}
				else
					message {
						"Well, so can you, for a time, using Nirvana.",
						"We've had centuries to perfect our powers,",
						"unlike mortals."
					}
				end
			elseif subResult == BAD then
				speaker "_TARGET"

				message {
					"That sounds bad!",
					"Is there anything I can do?"
				}

				speaker "Lyra"

				message {
					"That's kind of you to worry, adventurer...",
					"...but I'm still researching this anomaly.",
					"Maybe when I know more I'll need help."
				}
			end
		elseif result == SUPER_SUPPER_SABOTEUR then
			if Utility.Quest.isNextStep("SuperSupperSaboteur", "SuperSupperSaboteur_TalkedToLyra", _TARGET) then
				speaker "_TARGET"
				message {
					"%person{Lyra}, the Rumbridge butler, %person{Lear}, was killed.",
					"Do you know anything about that?"
				}

				speaker "Lyra"
				message {
					"Uh... That's horrible!",
					"And no! Why would I...?",
				}

				speaker "_TARGET"
				message {
					"I glimpsed the murderer and it looked",
					"suspiciously like %person{Oliver}..."
				}

				speaker "Lyra"
				message {
					"No! No!",
					"%person{Oliver} wouldn't hurt anyone!",
					"No even the Earl! Isn't that right, boy?"
				}

				speaker "Oliver"
				message "Woof!"

				speaker "_TARGET"
				message {
					"I said the butler was murdered.",
					"I never said anything about the Earl!"
				}

				speaker "Oliver"
				message "*whimper*"

				speaker "Lyra"
				message {
					"I get names mixed up...!",
					"There's nothing more to it!"
				}

				speaker "_TARGET"
				message {
					"The Earl's life is in danger according to %person{Chef Allon}.",
					"You're a suspect."
				}

				speaker "Lyra"
				message {
					"Well, um, I...",
					"It's just a coincidence!"
				}

				_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_TalkedToLyra")

				speaker "_TARGET"
				message "(She's not cooperating. Let's take a look around.)"

				speaker "_TARGET"
				message "Let's see about that..."
			elseif Utility.Quest.isNextStep("SuperSupperSaboteur", "SuperSupperSaboteur_FoundEvidence", _TARGET) then
				speaker "Lyra"
				message {
					"Leave me alone.",
					"I'm... not up to anything. I wouldn't hurt anyone!",
					"Especially not assassinate the Earl...!"
				}

				speaker "_TARGET"
				message {
					"Let's see about that."
				}
			elseif Utility.Quest.isNextStep("SuperSupperSaboteur", "SuperSupperSaboteur_GotConfessionFromLyra", _TARGET) then
				speaker "_TARGET"
				message {
					"I found poison in the coffin!",
					"Explain that!"
				}

				speaker "Lyra"
				message "..."

				speaker "Oliver"
				message "..."

				speaker "Lyra"
				message {
					"You discovered the truth.",
					"The Earl is plotting to kill the %empty{necromancer god}...",
					"Us witches worship %empty{Them}!",
					"He's committing sacrilege!"
				}

				speaker "_TARGET"
				message "Are you talking about %empty{The Empty King}?"

				speaker "Lyra"
				message "Yes!"

				speaker "_TARGET"
				message "Why would the Earl want to kill %empty{Them}?"

				speaker "Lyra"
				message {
					"The Earl, among others, are plotting with a shadow species.",
					"I've only heard whispers...",
					"But they definitely want to kill %empty{The Empty King}!"
				}

				speaker "_TARGET"
				message {
					"The Earl sold %person{Isabelle} that island...",
					"And %person{Isabelle} was conspiring with 'comrades'...",
					"I stopped her after she threatened to kill me!",
					"(Maybe there's merit to Lyra's story?)"
				}

				_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_GotConfessionFromLyra")

				speaker "Lyra"
				message {
					"Please, help me stop the Earl!",
					"Just like you stopped %person{Isabelle}!"
				}
			end

			if Utility.Quest.isNextStep("SuperSupperSaboteur", "SuperSupperSaboteur_AgreedToHelpLyra", _TARGET) then
				local YES = option "Agree to help Lyra"
				local NO  = option "Go and turn in Lyra"

				local yesOrno = select {
					YES,
					NO
				}

				if yesOrno == YES then
					speaker "_TARGET"
					message {
						"I'm with you!",
						"Let's kill the Earl!"
					}

					speaker "Lyra"
					message "Gosh, thank you!"

					speaker "Oliver"
					message "Woof!"

					speaker "_TARGET"
					message "What's then next step?"

					speaker "Lyra"
					message {
						"Well, I need to make a kursed candle.",
						"Then we can swap it out for the real thing.",
						"But I need Yendorian whale wax..."
					}

					speaker "_TARGET"
					message "Where in the Realm do we get whale wax?"

					speaker "Lyra"
					message {
						"%person{Cap'n Raven} and her crew found one recently!",
						"They've been bragging about it at the port.",
						"But they refuse to help me.",
						"Maybe you can convince her?"
					}

					speaker "_TARGET"
					message {
						"%person{Cap'n Raven} boarded our ship when",
						"I was sailing to %location{Isabelle Island}!",
						"I'm not sure if I'll be much help..."
					}

					_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_AgreedToHelpLyra")

					speaker "Lyra"
					message "We have to try!"
				elseif yesOrno == NO then
					speaker "_TARGET"
					message "I refuse! I'll turn you in!"

					speaker "Lyra"
					message {
						"I may be a bad liar, but I'm not a bad witch.",
						"You'll come to regret that choice...!"
					}

					speaker "Oliver"
					message "Grrr! Woof!"
				end
			end

			if _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_AgreedToHelpLyra") and
			   not _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_MadeCandle") then
				speaker "_TARGET"
				message "Follow me!"

				local _, lyraFollower = _SPEAKERS["Lyra"]:addBehavior(FollowerBehavior)
				local _, oliverFollower = _SPEAKERS["Oliver"]:addBehavior(FollowerBehavior)

				local player = Utility.Peep.getPlayerModel(_TARGET)
				lyraFollower.playerID = player:getID()
				lyraFollower.followAcrossMaps = true
				oliverFollower.playerID = player:getID()
				oliverFollower.followAcrossMaps = true

				Utility.Peep.setMashinaState(_SPEAKERS["Lyra"], "follow")
				Utility.Peep.setMashinaState(_SPEAKERS["Oliver"], "follow")
			end

			local GIVE_FLAGS = { ["item-inventory"] = true }
			local SEARCH_FLAGS = { ["item-inventory"] = true, ["item-bank"] = true }
			local hasDemonContract = _TARGET:getState():has("Item", "SuperSupperSaboteur_DemonContract", 1, SEARCH_FLAGS)
			local hasHellhoundContract = _TARGET:getState():has("Item", "SuperSupperSaboteur_HellhoundContract", 1, SEARCH_FLAGS)
			local giveContracts = not (hasDemonContract and hasHellhoundContract)

			if Utility.Quest.isNextStep("SuperSupperSaboteur", "SuperSupperSaboteur_GotContracts", _TARGET) then
				speaker "_TARGET"
				message "We made the %item{kursed candle} - what's next?"

				speaker "Lyra"
				message {
					"I have a Plan A and Plan B.",
					"The kursed candle is Plan B.",
					"Summoning demonic assassins is Plan A."
				}

				speaker "_TARGET"
				message "Demonic assassins?!"

				speaker "Lyra"
				message {
					"Yes! I have made some %item{demonic contracts}.",
					"The idea is if the assassins fail,",
					"then the %item{kursed candle} will be a fail-safe."
				}

				speaker "_TARGET"
				message "How strong are these assassins?"

				speaker "Lyra"
				message {
					"Well, the assassins are pretty strong....",
					"But there's something about %location{Rumbridge Castle}",
					"and its proximity to the %location{Rumbridge Monastery}",
					"that weakens the demons."
				}

				message {
					"My hypothesis is it's the Bastielian influence",
					"that excudes from the monastery."
				}

				message "Bastiel, an Old One, is an enemy of demons."

				speaker "_TARGET"
				message "I see..."

				speaker "Lyra"
				message {
					"The idea is if the assassins fail,",
					"we will be free-and-clear to kurse the cake",
					"without suspicion."
				}

				speaker "_TARGET"
				message "Good idea!"

				_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_GotContracts")
			end

			if Utility.Quest.isNextStep("SuperSupperSaboteur", "SuperSupperSaboteur_BlamedSomeoneElse", _TARGET) then
				speaker "Lyra"

				local hasInventorySpace = giveContracts
				if not hasDemonContract then
					if not _TARGET:getState():give("Item", "SuperSupperSaboteur_DemonContract", 1, GIVE_FLAGS) then
						hasInventorySpace = false
						message "You need to make space in your bag for the contract."
					else
						message "Here's the %item{demonic assassin contract}..."
					end
				else
					if not _TARGET:getState():has("Item", "SuperSupperSaboteur_DemonContract", 1, GIVE_FLAGS) then
						message "Looks like the %item{demon assassin contract} is in your bank."
					end
				end

				if not hasHellhoundContract then
					if not _TARGET:getState():give("Item", "SuperSupperSaboteur_HellhoundContract", 1, GIVE_FLAGS) then
						if hasInventorySpace then
							message "You need to make space in your bag for the contract."
						end
					else
						message "Here's the %item{hellhound contract}..."
					end
				else
					if not _TARGET:getState():has("Item", "SuperSupperSaboteur_HellhoundContract", 1, GIVE_FLAGS) then
						message "Looks like the %item{hellhound contract} is in your bank."
					end
				end

				if hasInventorySpace then
					message {
						"Now it's time to shine!",
						"Head to the second floor of %location{Rumbridge Castle}",
						"and summon the demon and hellhound!"
					}
				elseif not giveContracts then
					message {
						"No time to waste!",
						"Head to the second floor of %location{Rumbridge Castle}",
						"and summon the demon and hellhound!"
					}
				end
			end

			if Utility.Quest.isNextStep("SuperSupperSaboteur", "SuperSupperSaboteur_BetrayedLyra", _TARGET) then
				speaker "_TARGET"
				message "Looks like the demons didn't work."

				speaker "Oliver"
				message "*whimper*"

				speaker "Lyra"
				message {
					"It's ok boy.",
					"Plan B it is.",
					"Give the lit kursed candle to %person{Chef Allon}.",
					"%person{Earl Reddick} will face his justice."
				}
			end

			return
		else
			message "Enjoy your time in Rumbridge."
		end
	end
end
