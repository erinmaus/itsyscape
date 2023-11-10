PLAYER_NAME = _TARGET:getName()

local SEARCH_FLAGS = {
	['item-inventory'] = true
}

local GIVE_FLAGS = {
	['item-inventory'] = true,
}

local hasWhaleBlubber = _TARGET:getState():has("Item", "YendorianWhaleBlubber", 1, SEARCH_FLAGS)
local hasCandleWick   = _TARGET:getState():has("Item", "CottonCandleWick", 1, SEARCH_FLAGS)
local hasKursedCandle = _TARGET:getState():has("Item", "UnlitKursedCandle", 1, SEARCH_FLAGS) or
                        _TARGET:getState():has("Item", "LitKursedCandle", 1, SEARCH_FLAGS)

local isPending = (
	not _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_LitKursedCandle") or
	not _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_LitBirthdayCandle")
) and not _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_Complete")

if isPending and not hasKursedCandle then
	if not hasKursedCandle and not hasWhaleBlubber then
		if _SPEAKERS["Lyra"] then
			speaker "Lyra"
			message {
				"This is the whale!",
				"I need you to take some blubber and make a candle.",
			}

			speaker "_TARGET"
			message "Why me?"

			speaker "Lyra"
			message {
				"I don't have %hint{the firemaking skills} required",
				"to make a kursed candle but you do!"
			}
		end

		speaker "_TARGET"
		message "Alright, here goes nothing..."

		local success = _TARGET:getState():give("Item", "YendorianWhaleBlubber", 1, GIVE_FLAGS)
		if success then
			speaker "Whale"
			message "(You take some blubber from the whale.)"
		else
			speaker "Whale"
			message {
				"(You try and take some blubber,",
				"but your inventory seems to be full.)"
			}
		end
	end

	if not hasKursedCandle and not hasCandleWick and _SPEAKERS["Lyra"] then
		local success = _TARGET:getState():give("Item", "CottonCandleWick", 1, GIVE_FLAGS)
		if not success then
			speaker "Lyra"
			message {
				"I can't give you a cotton wick",
				"because your inventory is full."
			}
		else
			speaker "Lyra"
			message "Here's a cotton wick."
		end
	end

	if _SPEAKERS["Lyra"] then
		speaker "Lyra"
		message "Speak to me when you make the candle."
	end
else
	speaker "_TARGET"
	message {
		"I've had enough misfortune",
		"desecrating this whale carcass."
	}
end
