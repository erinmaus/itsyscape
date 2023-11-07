speaker "Lyra"

message {
	"Good tidings and welcome to Rumbridge.",
	"How may I help you, adventurer?"
}

PLAYER_NAME = _TARGET:getName()

do
	local WHO = option "Who are you?"
	local DO   = option "What do you do?"
	local FOLLOW_ME = option "Follow me!"
	local QUIT = option "Nevermind."

	local result
	while result ~= QUIT do
		result = select {
			WHO,
			DO,
			QUIT,
			FOLLOW_ME
		}

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
		elseif result == FOLLOW_ME then
			local _, lyraFollower = _SPEAKERS["Lyra"]:addBehavior(require "ItsyScape.Peep.Behaviors.FollowerBehavior")
			local _, oliverFollower = _SPEAKERS["Oliver"]:addBehavior(require "ItsyScape.Peep.Behaviors.FollowerBehavior")

			local player = Utility.Peep.getPlayerModel(_TARGET)
			lyraFollower.playerID = player:getID()
			lyraFollower.followAcrossMaps = true
			oliverFollower.playerID = player:getID()
			oliverFollower.followAcrossMaps = true

			Utility.Peep.setMashinaState(_SPEAKERS["Lyra"], "follow")
			Utility.Peep.setMashinaState(_SPEAKERS["Oliver"], "follow")

			return
		else
			message "Enjoy your time in Rumbridge."
		end
	end
end
