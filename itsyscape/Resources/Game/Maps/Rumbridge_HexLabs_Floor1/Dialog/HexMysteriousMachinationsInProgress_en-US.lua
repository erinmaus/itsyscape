local hasStartedQuest = _TARGET:getState():has("KeyItem", "MysteriousMachinations_Start")
local QUEST = Utility.Quest.build("MysteriousMachinations", _DIRECTOR:getGameDB())

if not hasStartedQuest then
	speaker "_TARGET"
	message "Can I help you with anything? I'm always looking for a quest!"

	speaker "Hex"
	message "You are exactly the person I need!"
	message {
		"You might have noticed those %hint{mysterious draconic creatures} in the life support vats.",
		"They are based off a race of sapient creatures of legend called the Drakkenson, who jump through time like we walk through a field.",
		"Few have lived to speak of their encounters."
	}
	message {
		"My hunch is these creatures reside in a split timeline called Azathoth...",
		"...but I've not been able to build a stable portal to Azathoth.",
		"The Old Ones built world gates connecting the two realities eons ago, before they were banished from the Realm."
	}
	message {
		"I need you to help me reverse engineer their tech to build a portal to Azathoth. Can you help me?"
	}

	Utility.Quest.promptToStart(
		"MysteriousMachinations",
		_TARGET,
		_SPEAKERS["Hex"])
elseif Utility.Quest.isNextStep(QUEST, "MysteriousMachinations_FindRuinsNearLeafyLake", _TARGET) then
	local state = _TARGET:getState()
	local flags = { ['item-inventory'] = true }
	local hasPrimordialTimeRune = state:has("Item", "PrimordialTimeRune", 1, flags)
	local hasTimeTugSpellScroll = state:has("Item", "MysteriousMachinations_TimeTugSpellScroll", 1, flags)

	if not hasPrimordialTimeRune or not hasTimeTugSpellScroll then
		speaker "Hex"
		message {
			"Awesome! So there's some ruins near the Leafy Lake, just south of here.",
			"I'll need you to use a %item{primordial time rune} and %item{time tug spell scroll} to pull the ruins out of time.",
			"Don't worry - I've already prepped the spell scroll to cast the eldritch spell.",
		}

		local gaveItems = true
		if not hasPrimordialTimeRune then
			gaveItems = gaveItems and state:give("Item", "PrimordialTimeRune", 1, flags)
		end

		if not hasTimeTugSpellScroll then
			gaveItems = gaveItems and state:give("Item", "MysteriousMachinations_TimeTugSpellScroll", 1, flags)
		end

		if not gaveItems then
			message "You need to make space for this stuff!"
		end
	else
		message {
			"Head to the ruins near the Leafy Lake, just south of here.",
			"With the %item{primordial time rune} and %item{time tug spell scroll}, you can cast %hint{Time Tug}.",
			"The spell will pull the ruins out of time."
		}
	end
else
	speaker "Hex"
	message "I can't help you right now. Maybe %hint{check your Nominomicon}?"
end
