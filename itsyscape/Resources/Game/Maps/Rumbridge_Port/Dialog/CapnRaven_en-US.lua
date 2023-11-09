PLAYER_NAME = _TARGET:getName()

speaker "CapnRaven"
message {
	"'Ey, how's my favorite scoundrel?",
	"Glad t' see ye survived.",
	"Seeing as %person{Cthulhu} was there'n'all..."
}

local followerBehavior = _SPEAKERS["Lyra"] and _SPEAKERS["Lyra"]:getBehavior(require "ItsyScape.Peep.Behaviors.FollowerBehavior")
local hasLyra = followerBehavior and followerBehavior.playerID == Utility.Peep.getPlayerModel(_TARGET):getID()

if Utility.Quest.isNextStep("SuperSupperSaboteur", "SuperSupperSaboteur_TalkedToCapnRaven", _TARGET) then
	if not hasLyra then
		speaker "_TARGET"
		message "I wanted to talk to you, but I need to get %person{Lyra}."

		speaker "CapnRaven"
		message {
			"Oh, that witch?",
			"Well, whatever ye need to do."
		}

		return
	end

	speaker "_TARGET"
	message {
		"I heard %hint{you found a Yendorian whale}...",
		"But you're keeping it a secret."
	}

	speaker "CapnRaven"
	message "What's it to yer?"

	speaker "_TARGET"
	message {
		"Well... %person{Lyra} and me are on a quest...",
		"...to assassinate the Earl."
	}

	speaker "CapnRaven"
	message {
		"Oh, yer in on it?",
		"Didn't know ye had the guts."
	}

	speaker "Lyra"
	message {
		"Well, %person{${PLAYER_NAME}} is a skilled adventurer.",
		Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_SUBJECT, "en-US", true) .. " stopped Isabelle from doing something horrible."
	}

	speaker "CapnRaven"
	message {
		"Oh, did " .. Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_SUBJECT, "en-US") .. " now?",
		"'Ey, didn't know ye had it our for 'er, too.",
		"Looks like I was wrong 'bout ye."
	}

	speaker "_TARGET"
	message {
		"Will you help us?",
		"We just need to collect some fat from the whale",
		"to make a candle for the Earl's cake."
	}

	speaker "CapnRaven"
	message {
		"Well, I like the cut of yer jib.",
		"No 'ard feelings about the %person{Cthulhu} incident, eh?",
		"I'll 'elp ye."
	}

	message {
		"Yer gonna have to stay in the brig, though.",
		"Can't 'ave ye knowin' where the island is, ye hear?"
	}

	_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_TalkedToCapnRaven")

	speaker "_TARGET"
	message "Well, I think that's just fine."

	speaker "Lyra"
	message "Let's do this!"

	speaker "Oliver"
	message "Woof!"
end

if Utility.Quest.isNextStep("SuperSupperSaboteur", "SuperSupperSaboteur_MadeCandle", _TARGET) then
	local GO   = option "I'm ready to sail!"
	local STAY = option "I think I'm going to be sea sick."

	local result = select {
		GO,
		STAY
	}

	if result == GO then
		if not hasLyra then
			speaker "_TARGET"
			message "(I better get %person{Lyra} from %location{town}...)"

			return
		else
			speaker "_TARGET"
			message "We're ready to go whenever you are!"

			speaker "CapnRaven"
			message "Anchors away!"
		end
	else
		speaker "_TARGET"
		message {
			"I think I'm going to be sea sick.",
			"I'll come back later."
		}

		speaker "CapnRaven"
		message "Har har har, landlubber!"
	end
end
