local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"

local INVENTORY_FLAGS = {
	["item-inventory"] = true
}

PLAYER_NAME = _TARGET:getName()

if Utility.Quest.isNextStep("PreTutorial", "PreTutorial_ArriveAtTheWhalingTemple", _TARGET) then
	_TARGET:addBehavior(DisabledBehavior)

	speaker "Jenkins"
	message {
		"We be at the %location{Whaling Temple}, mates...",
		"%person{Rosalind} and %person{Orlando}, stay with me 'n the crew.",
		"%person{${PLAYER_NAME}}, ye have the honor of explorin' the island."
	}

	speaker "Rosalind"
	message {
		"If I may, %person{Jenkins}, I think we should split into pairs.",
		"%person{Orlando} and you can stay near the ship,",
		"while %person{${PLAYER_NAME}} and me can explore the island.",
	}

	message {
		"I'll keep %hint{a scry open on the sea},",
		"in case %person{Cthulhu} or some of his minions come close.",
		"We'll turn around if that happens."
	}

	speaker "_TARGET"
	message {
		"I think that's a good idea...",
		"After all, I'm new to all this!"
	}

	speaker "Jenkins"
	message {
		"Hmmph. I s'pose that would be best.",
		"Bastiel knows what be out here..."
	}

	message {
		"Ye both best come back with supplies, then.",
		"We be needin' wood and food."
	}

	speaker "Rosalind"
	message {
		"We will!",
		"Alright, let's head out, %person{${PLAYER_NAME}}!"
	}

	speaker "_TARGET"
	message "Got it!"

	speaker "Orlando"
	message "Sigh... *mumble* %person{Rosalind} *mumble*..."

	speaker "Rosalind"
	message "Did you say something, %person{Orlando}?"

	speaker "Orlando"
	message {
		"Oh, um, yeah, good luck to both of you!",
		"Yeah, that's what I said..."
	}

	local mapScript = Utility.Peep.getMapScript(_TARGET)
	if mapScript then
		mapScript:makeRosalindFollowPlayer(_TARGET, false)
	end

	_TARGET:getState():give("KeyItem", "PreTutorial_ArriveAtTheWhalingTemple")
	_TARGET:removeBehavior(DisabledBehavior)
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_InformedJenkins", _TARGET) or
       Utility.Quest.isNextStep("PreTutorial", "PreTutorial_TurnedInSupplies", _TARGET)
then
	if Utility.Quest.isNextStep("PreTutorial", "PreTutorial_InformedJenkins", _TARGET) then
		speaker "Jenkins"
		message "Ye look beat up. What's the matter?"

		speaker "Rosalind"
		message {
			"We defeated a Yendorian soldier at the temple ruins.",
			"It even opened a portal to %empty{Fate} knows where, but I managed to atune it to %location{Isabelle Island}."
		}

		speaker "Orlando"
		message {
			"AAAH! A Yendorian?! On this island?!",
			"The %hint{priest on Isabelle Island is scary enough}..."
		}

		speaker "Jenkins"
		message {
			"The hells? There was a Yendorian 'ere?",
			"And it opened a portal? And ye two defeated it?! Really?"
		}

		if _TARGET:getState():has("KeyItem", "PreTutorial_InsultedYendorian") then
			speaker "Rosalind"	
			message {
				"We might've been able to reason with it, but %person{${PLAYER_NAME}} had a fit of madness and insulted it!",
				"The Yendorian was severely injured and sick, which gave us the edge."
			}

			speaker "_TARGET"
			message "Easy-peasy! It was a push-over!"

			speaker "Rosalind"
			message {
				"*sigh* %person{${PLAYER_NAME}}, you shouldn't be so arrogant.",
				"You're just an up-and-coming adventurer, not a hero.",
				"Temper your ego."
			}
		elseif _TARGET:getState():has("KeyItem", "PreTutorial_ReasonedWithYendorian") then
			speaker "_TARGET"
			message "We tried to reason with it, but the Yendorian was having none of it."

			speaker "Rosalind"
			message {
				"Lucky for us, the Yendorian was injured and sick. This gave us the edge in the fight.",
				"Otherwise, I'm not sure what would've happened!"
			}

			message "And %person{${PLAYER_NAME}} did most of the work!"

			speaker "Jenkins"
			message {
				"Aye, that be impressive, " .. Utility.Text.getPronoun(_TARGET, Utility.Text.FORMAL_ADDRESS, "en-US", false) .. "!",
				"%person{Isabelle} ain't no slouch in pickin' 'er help."
			}
		elseif _TARGET:getState():has("KeyItem", "PreTutorial_DidACowardlyThing") or true then
			speaker "Rosalind"
			message "Unfortunately, %person{${PLAYER_NAME}} tried to flee."
			message {
				"This didn't land well with the Yendorian.",
				"But lucky for us, it was injured and sick, which gave us the edge."
			}

			speaker "Orlando"
			message "Well, I sure wouldn't wanna fight a Yendorian, either!"

			speaker "Jenkins"
			message {
				"%person{Orlando}, if it were'nt for yer sister, I'd have left you in %location{Rumbridge}.",
				"Shame %person{${PLAYER_NAME}} be a bit cowardly, too, aye."
			}

			speaker "Rosalind"
			message {
				"No need to insult anyone, %person{Jenkins}. Not all of us are brave."
			}

			speaker "Orlando"
			message "..."

			speaker "_TARGET"
			message "..."
		end

		_TARGET:getState():give("KeyItem", "PreTutorial_InformedJenkins")
	end

	speaker "Jenkins"
	message "So did ye both get some supplies?"

	local hasFish = _TARGET:getState():has("Item", "CookedSardine", 1, INVENTORY_FLAGS)
	local hasLogs = _TARGET:getState():has("Item", "ShadowLogs", 1, INVENTORY_FLAGS)

	if not hasFish or not hasLogs then
		speaker "_TARGET"

		if not hasFish and not hasLogs then
			message "(Looks like I'm missing logs and fish...)"
		elseif not hasFish then
			message "(Looks like I'm missing some fish...)"
		elseif not hasLogs then
			message "(Looks like I'm missing some logs...)"
		end
	end

	local YES  = option "Yes, here you go!"
	local NO   = option "Nope!"
	local WAIT = option "Wait, let me go gather some more!"

	local result = select { YES, NO, WAIT }

	if result == YES then
		if hasFish and hasLogs then
			speaker "_TARGET"
			message "I got some supplies right here!"

			speaker "Jenkins"
			message {
				"Aye, good job, mate.",
				"It ain't much but it'll do.",
				"Let me take some off yer hands."
			}

			local fishCount = _TARGET:getState():count("Item", "CookedSardine", INVENTORY_FLAGS)
			local logCount = _TARGET:getState():count("Item", "ShadowLogs", INVENTORY_FLAGS)

			_TARGET:getState():take("Item", "CookedSardine", math.min(fishCount, 3), INVENTORY_FLAGS)
			_TARGET:getState():take("Item", "ShadowLogs", math.min(logCount, 3), INVENTORY_FLAGS)

			_TARGET:getState():give("KeyItem", "PreTutorial_TurnedInSupplies")
		else
			speaker "_TARGET"
			if hasFish then
				message "I got... wait, I just have some fish!"
			elseif hasLogs then
				message "I got... wait, I just have some logs!"
			else
				message "I got... wait, I have nothing!"
			end

			speaker "Jenkins"
			message "Yer jokin' right?"

			speaker "Rosalind"
			message "Don't worry, I gathered some supplies while %person{${PLAYER_NAME}} slept."

			speaker "Jenkins"
			message "Thank ye god for ye, %person{Rosalind}. Yer a blessin'."

			speaker "Orlando"
			message "Yes, %person{Rosalind}! You're amazing!"

			speaker "Rosalind"
			message "It was no trouble!"

			_TARGET:getState():give("KeyItem", "PreTutorial_DidNotTurnInSupplies")
		end
	elseif result == NO then
		if hasFish or hasLogs then
			speaker "_TARGET"
			message "I got... yeah, I got nothing."

			speaker "Rosalind"
			message {
				"I think %person{${PLAYER_NAME}} might be fibbing...",
				"But anyway, I gathered some supplies when " .. Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_SUBJECT, "en-US") .. " " .. Utility.Text.getEnglishBe(_TARGET).past .. " sleeping."
			}
		else
			speaker "_TARGET"
			message "I got... nothing!"

			speaker "Jenkins"
			message "Yer jokin' right?"

			speaker "Rosalind"
			message "Don't worry, I gathered some supplies while %person{${PLAYER_NAME}} slept."

			speaker "Jenkins"
			message "Thank ye god for ye, %person{Rosalind}. Yer a blessin'."

			speaker "Orlando"
			message "Yes, %person{Rosalind}! You're amazing!"

			speaker "Rosalind"
			message "It was no trouble!"
		end

		_TARGET:getState():give("KeyItem", "PreTutorial_DidNotTurnInSupplies")
	elseif result == WAIT then
		if not hasFish and not hasLogs then
			speaker "_TARGET"
			message "Wait, I'll be right back! I gotta get... well, everything!"
		elseif not hasFish then
			speaker "_TARGET"
			message "Wait, I'll be right back! I gotta get some fish!"
		elseif not hasLogs then
			speaker "_TARGET"
			message "Wait, I'll be right back! I gotta get some logs!"
		else
			speaker "_TARGET"
			message "Wait, I'll be right back! I just wanna get some more supplies!"
		end

		return
	end

	speaker "Rosalind"
	message "%person{${PLAYER_NAME}} will go through the portal to %location{Isabelle Island}."
	message {
		Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_SUBJECT, "en-US", true) .. " can let %person{Isabelle} know what happened ahead of us taking the ship."
	}

	speaker "Jenkins"
	message "Aye, that's a swell idea. We'll meet ye at %location{Isabelle Island} in a days time, %person{${PLAYER_NAME}}. Godspeed."

	speaker "Rosalind"
	message "Let's go to the portal."

	speaker "_TARGET"
	message "Got it!"
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_Teleported", _TARGET) then
	speaker "Jenkins"
	message "Aye, go through the portal and let %person{Isabelle} know what be goin' on."

	speaker "Rosalind"
	message "%person{${PLAYER_NAME}}, let's go to the portal at the ruined temple to the north."

	speaker "_TARGET"
	message "Got it!"
else
	speaker "Jenkins"
	message "I be busy, mate. Talk to %person{Rosalind} if ye need 'elp."
end
