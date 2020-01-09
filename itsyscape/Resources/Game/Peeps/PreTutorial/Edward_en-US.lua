PLAYER_NAME = _TARGET:getName()
speaker "_TARGET"
message "Hello, Edward, it's me, the adventurer ${PLAYER_NAME}!"

local state = _TARGET:getState()
local hasGhostSpeakEquipped = state:has('Item', "GhostspeakAmulet", 1, { ['item-equipment'] = true })
if not hasGhostSpeakEquipped then
	speaker "Edward"
	message "Woo woooo wooo!"

	speaker "_TARGET"
	message "It's useless, I can't speak to him right now."

	hasGhostSpeakInInventory = state:has('Item', "GhostspeakAmulet", 1, { ['item-equipment'] = true })
	if hasGhostSpeakInInventory then
		message "Maybe if I equip that Ghostspeak amulet..."
	end
else
	local saved = state:has('KeyItem', "PreTutorial_SavedGhostBoy")
	local hasToyWeaponEquipped =
		state:has('Item', "ToyLongsword", 1, { ['item-equipment'] = true }) or
		state:has('Item', "ToyWand", 1, { ['item-equipment'] = true }) or
		state:has('Item', "ToyBoomerang", 1, { ['item-equipment'] = true })
	local hasToyWeaponInventory =
		state:has('Item', "ToyLongsword", 1, { ['item-inventory'] = true }) or
		state:has('Item', "ToyWand", 1, { ['item-inventory'] = true }) or
		state:has('Item', "ToyBoomerang", 1, { ['item-inventory'] = true })
	if not saved then
		speaker "Edward"
		message "H-h-hello, ${PLAYER_NAME}. There's a monster under my bed!"

		speaker "_TARGET"
		message "Are you sure it's not your imagination?"

		speaker "Edward"
		message {
			"I'm d-d-d-definitely s-s-sure!",
			"I'm too weak to fight it.",
			"Anyway, you n-n-n-need a special type of weapon to fight it."
		}

		if hasToyWeaponEquipped then
			speaker "Edward"
			message "L-l-looks like you've got one in y-y-your hand!"

			local maggot = Utility.spawnMapObjectAtAnchor(
				_TARGET,
				"Maggot",
				"Anchor_Maggot")

			speaker "Edward"
			message "S-S-SAVE ME!"

			Utility.Peep.attack(maggot:getPeep(), _TARGET)
		elseif hasToyWeaponInventory then
			speaker "Edward"
			message {
				"L-l-looks like you've got one in y-y-your bag!",
				"Equip it then t-t-t-talk to me again."
			}
		else
			speaker "_TARGET"
			message "What kind of weapon do you need?"

			speaker "Edward"
			message {
				"You n-n-n-need a toy weapon.",
				"I once hurt it with a w-w-w-w-wooden sword, but it just made the m-m-m-monster angrier."
			}

			speaker "_TARGET"
			message "Got it! I'll figure out how to help you, Edward."

			speaker "Edward"
			message "Thank you!"
		end
	else
		speaker "Edward"
		message "T-thank you for saving me! I'll stick around for a little while longer before I enter the light."
	end
end
