speaker "Joe"

JOE_NAME = _SPEAKERS["Joe"]:getName()
message "Hey, I'm %person{${JOE_NAME}}."
message "I'm just mining my own business. He he he..."

if Utility.Item.spawnInPeepInventory(_TARGET, "CavePotato", 1) then
	message {
		"Here's something you can use.",
		"It has lots of iron. He he he..."
	}
end

do
	local INFO       = option "Can you tell me about this place?"
	local BOSS       = option "Can you tell me what's behind the scary door?"
	local EARTHQUAKE = option "Did you feel an earthquake?"

	local result
	if _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_TalkedToJenkins") then
		result = select {
			INFO,
			BOSS,
			EARTHQUAKE
		}
	else
		result = select {
			INFO,
			BOSS
		}
	end

	if result == INFO then
		message {
			"These are said to be the first mines in the Realm.",
			"The %hint{Lady of the Shroud}, %person{Yendor},",
			"used copper to speak to the dead."
		}

		message {
			"The skelemental serve to protect this mine,",
			"but they ain't the brightest.",
			"A tin can covering your noggin",
			"makes some of 'em friendly.",
		}

		message "He... He... He."
	elseif result == BOSS then
		message {
			"The miner foreman...",
			"His soul was bound by the %empty{Necromancer}.",
			"Now he's a treacheous zealot."
		}

		local INFO = option "How do I open the secret door?"
		local SCARED = option "I'm a wimp, I'll stay out!"
		local result = select {
			INFO,
			SCARED
		}

		if result == INFO then
			message {
				"You're reckless...",
				"But you've got soul,",
				"I'll give you that."
			}

			message "Bring my five bronze bars and I'll make you a key."


			if _TARGET:getState():has("Item", "BronzeBar", 5, { ['item-inventory'] = true }) then
				message {
					"I see you have enough...",
					"Want me to make you that key?"
				}

				local YES = option "Yes, please!"
				local NO = option "I changed my mind, I'm a wimp!"
				local result = select {
					YES,
					NO
				}

				if result == YES then
					if _TARGET:getState():take("Item", "BronzeBar", 5, { ['item-inventory'] = true }) then
						if _TARGET:getState():give("Item", "IsabelleIsland_AbandonedMine_ReinforcedBronzeKey", 1, { ['item-inventory'] = true }) then
							message "There you go..."
						else
							message "Whoops, I broke it."
						end
					end
				elseif result == NO then
					message "That's smart..."
				end
			end
		else
			message "That's smart..."
		end

		message "Just run away... You'll never defeat him."
	elseif result == EARTHQUAKE then
		message "I did. Happened when someone lit those torches."
		message {
			"She went through, then I heard fighting.",
			"Never seen her before, or I must be going blind."
		}

		speaker "_TARGET"
		message "But you don't even have eyes!"

		speaker "Joe"
		message "Since when did skeletons need eyes to see?"

		speaker "_TARGET"
		message "Nevermind. What did she look like?"

		speaker "Joe"
		message {
			"She was wearing some tough looking armor and carrying a bunch of weapons.",
			"Looked mighty tough. Best be careful."
		}
	end

	message "Be safe... Leave this place."
end
