speaker "Joe"

JOE_NAME = _SPEAKERS["Joe"]:getName()
message "Hey, I'm ${JOE_NAME}."
message "I'm just mining my own business. He he he..."

if Utility.Item.spawnInPeepInventory(_TARGET, "CavePotato", 1) then
	message "Here's something you can use."
	message "It has lots of iron. He he he..."
end

do
	local INFO = option "Can you tell me about this place?"
	local BOSS = option "Can you tell me what's behind the scary door?"

	local result = select {
		INFO,
		BOSS
	}

	if result == INFO then
		message "An evil necromancer sought something secret in this mine."
		message {
			"He killed all us miners, and brought them back...",
			"I escaped his control, but the others didn't, and they changed."
		}
		message "They're dull and will ignore you if you disguise yourself."
		message "I heard tin cans are pretty fashionable here... He he he."
	elseif result == BOSS then
		message {
			"The miner foreman...",
			"His soul was bound by the Necromancer to protect the secret."
		}

		local INFO = option "How do I open the secret door?"
		local SCARED = option "I'm a wimp, I'll stay out!"
		local result = select {
			INFO,
			SCARED
		}

		if result == INFO then
			message "You're reckless... But you've got soul, I'll give you that."
			message "Bring my five bronze bars and I'll make you a key."


			if _TARGET:getState():has("Item", "BronzeBar", 5, { ['item-inventory'] = true }) then
				message "I see you have enough... Want me to make you that key?"

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
	end

	message "Be safe... Leave this place."
end
