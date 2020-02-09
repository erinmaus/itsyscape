speaker "Robert"

PLAYER_NAME = _TARGET:getName()

local hasShip = _TARGET:getState():has("SailingItem", "Ship")
if hasShip then
	message {
		"'Ey, welcome back, %person{${PLAYER_NAME}}.",
		"Need to manage yer ship?"
	}

	local YES = option "Yes"
	local NO  = option "No"

	local option = select {
		YES,
		NO
	}

	if option == YES then
		Utility.UI.openInterface(_TARGET, "ShipCustomization", true)
		return
	end
else
	message {
		"How be you, %person{${PLAYER_NAME}}?",
		"Name's Robert, yer local Rumbridge Seafarer's Guild master.",
		"I can be seeing yer need of a ship."
	}

	local YES_I_NEED_A_SHIP_PLEASE      = option "Yes, I need a ship! Arr!"
	local NO_IM_FINANCIALLY_RESPONSIBLE = option "No, I'm financially responsible!"
	local WHY_THAT                      = option "Why's that?"
	local NEVERMIND                     = option "Nevermind."

	local option
	repeat
		option = select {
			YES_I_NEED_A_SHIP_PLEASE,
			NO_IM_FINANCIALLY_RESPONSIBLE,
			WHY_THAT,
			NEVERMIND
		}

		if option == YES_I_NEED_A_SHIP_PLEASE then
			speaker "_TARGET"
			message {
				"Yes, I be needin' a ship! Arr!"
			}

			speaker "Robert"
			message {
				"Har har har, yer funny, I give yer that, landlubber.",
				"A ship is %hint{mighty expensive}. Ye need lots o' %item{supplies and coin}.",
				"Ye'll need to %hint{recruit a first mate and some crew}, too, to sail 'er."
			}

			Utility.UI.openInterface(_TARGET, "BuyBoat", true, _SPEAKERS["Robert"])
			return
		elseif option == NO_IM_FINANCIALLY_RESPONSIBLE then
			speaker "_TARGET"
			message {
				"I'm a financially responsible adventurer! A ship will only cost me more than I'll ever get back!"
			}

			speaker "Robert"
			message {
				"Good luck with yer story if yer gonna be doin' that.",
				"Sooner or later yer gonna be needin' a ship, and when ye do, I'll be here for ye."
			}

			speaker "_TARGET"
			message {
				"We'll see about that!"
			}

			speaker "Robert"
			message {
				"Har har har...",
				"We'll be seein' bout that, all rights."
			}
			return
		elseif option == WHY_THAT then
			speaker "_TARGET"
			message {
				"Why's that? Wouldn't a ship be expensive?"
			}

			speaker "Robert"
			message {
				"Aye, mayhaps, but the rewards are worth it.",
				"Ye'll find %hint{new lands, new supplies, and new friends}.",
				"But ye might encounter %hint{pirates, monsters, and worse} out there..."
			}
		elseif option == NEVERMIND then
			speaker "_TARGET"
			message "Nevermind, I left the stove on! Gotta run."
		end
	until option == NEVERMIND
end
