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
		message "Maybe if I equip thet Ghostspeak amulet..."
	end
else
	local saved = state:has('KeyItem', "PreTutorial_SavedGhostBoy")
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
	else
		speaker "Edward"
		message "T-thank you for saving me! I'll stick around for a little while longer before I enter the light."
	end
end
