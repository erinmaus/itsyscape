local gaveItem = false

PLAYER_NAME = _TARGET:getName()
speaker "_TARGET"
message {
	"Hello, %person{Elizabeth}!",
	"It's me, the adventurer %person{${PLAYER_NAME}}!"
}

local state = _TARGET:getState()
local hasGhostSpeakEquipped = state:has('Item', "GhostspeakAmulet", 1, { ['item-equipment'] = true })
if not hasGhostSpeakEquipped then
	speaker "Elizabeth"
	message "Woo woooo wooo!"

	speaker "_TARGET"
	message "It's useless, I can't speak to her right now."

	hasGhostSpeakInInventory = state:has('Item', "GhostspeakAmulet", 1, { ['item-inventory'] = true })
	if hasGhostSpeakInInventory then
		message "Maybe if I equip that Ghostspeak amulet..."
	end
else
	state:give('KeyItem', "PreTutorial_TalkedToGhostGirl")

	local saved = state:has('KeyItem', "PreTutorial_SavedGhostGirl")
	if not saved then
		local hasCookedLarry = state:has('Item', "CookedLarry", 1, { ['item-inventory'] = true })
		local hasBurntLarry = state:has('Item', "BurntLarry", 1, { ['item-inventory'] = true })

		if not hasCookedLarry then
			if hasBurntLarry then
				speaker "Elizabeth"
				message "I'm not eating a burnt pet! You might as well try feeding me his ashes."
			else
				speaker "Elizabeth"
				message {
					"How's it, %person{${PLAYER_NAME}}?",
					"I can barely think!"
				}

				speaker "_TARGET"
				message "What's wrong?"

				speaker "Elizabeth"
				message {
					"I'm starving!",
					"The food in the dining room makes me sick.",
					"I need something more dramatic and horrifying."
				}

				speaker "_TARGET"
				message "I'll see what I can do."

				speaker "Elizabeth"
				message "Thank you, adventurer!"
			end
		else
			local success = state:take('Item', "CookedLarry", 1, { ['item-inventory'] = true })
			if success then
				speaker "Elizabeth"
				message {
					"Thank you so much!",
					"Larry was so very tasty and hit the spot!"
				}

				speaker "_TARGET"
				message "Oookay."

				if state:give('KeyItem', "PreTutorial_SavedGhostGirl") then
					speaker "Elizabeth"
					message "I'll leave soon. Finally!"
				else
					speaker "Elizabeth"
					message "More! I need more!"
				end
			else
				speaker "Elizabeth"
				message "Can you give me the cooked goldfish?"
			end
		end
	else
		speaker "Elizabeth"
		message "Larry was delicious! I'll be ready to pass on soon."
	end
end
