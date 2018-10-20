speaker "AdvisorGrimm"
message "What would you like to know?"

local CURSED_ORE = option "Cursed Ore"
local ANCIENT_DRIFTWOOD = option "Ancient Driftwood"
local SQUID_SKULL = option "Squid Skull"
local NEVERMIND = option "Nevermind."
local THANK_YOU = option "Thank you. Good-bye!"

local option = select {
	CURSED_ORE,
	ANCIENT_DRIFTWOOD,
	SQUID_SKULL,
	NEVERMIND
}

while option ~= NEVERMIND and option ~= THANK_YOU do
	local SEARCH_FLAGS = {
		['item-equipment'] = true,
		['item-inventory'] = true,
		['item-bank'] = true
	}

	local TAKE_FLAGS = {
		['item-inventory'] = true
	}

	if option == CURSED_ORE then
		if not _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_GotCrawlingCopper") or
		   not _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_GotTenseTin") then

			message {
				"There's some cursed ore in the abandoned mine to the south-east.",
				"Specifically, tin and copper. If destroyed, they should end the enchantment in the mine."
			}

			message {
				"There is a helpful ... man, Joe, I think, deep in the dungeon.",
				"I suggest finding him as quickly as possible; he knows more."
			}

			message {
				"There's hostile creeps in the mine, so I suggest ensuring you have supplies, such as food.",
				"Portmaster Jenkins can help you with that."
			}

			if not _TARGET:getState():has("Item", "BronzePickaxe", 1, SEARCH_FLAGS) then
				if _TARGET:getState():give("Item", "BronzePickaxe", 1, SEARCH_FLAGS) then
					message "Here's a pick-axe to help you mine."
				else
					message "If you had more inventory space, I could give you a pick-axe."
				end
			end

			if not _TARGET:getState():has("Item", "IsabelleIsland_AbandonedMine_WroughtBronzeKey", 1, SEARCH_FLAGS) then
				if _TARGET:getState():give("Item", "IsabelleIsland_AbandonedMine_WroughtBronzeKey", 1, SEARCH_FLAGS) then
					message {
						"Here's a key to enter the dungeon.",
						"Please close the door behind yourself--we can't have the creeps surfacing."
					}
				else
					message "If you had more inventory space, I could give you the key to enter the mine."
				end
			end

			if _TARGET:getState():has("Item", "IsabelleIsland_CrawlingCopperOre", 1, TAKE_FLAGS) or
			   _TARGET:getState():has("Item", "IsabelleIsland_TenseTinOre", 1, TAKE_FLAGS)
			then
				message {
					"I see you have some cursed ore.",
					"I'll take it off your hands."
				}

				if _TARGET:getState():take("Item", "IsabelleIsland_CrawlingCopperOre", 1, TAKE_FLAGS) then
					_TARGET:getState():give("KeyItem", "CalmBeforeTheStorm_GotCrawlingCopper")
				end

				if _TARGET:getState():take("Item", "IsabelleIsland_TenseTinOre", 1, TAKE_FLAGS) then
					_TARGET:getState():give("KeyItem", "CalmBeforeTheStorm_GotTenseTin")
				end

				speaker "_TARGET"
				message "Here you go!"

				speaker "AdvisorGrimm"
				message "Thank you."
			end
		else
			message {
				"You managed to find the crawling copper and tense tin.",
				"Thank you for that.",
			}
		end
	elseif option == ANCIENT_DRIFTWOOD then
		message {
			"There's an ancient, living driftwood tree.",
			"While it stands, it curses the forest, allowing specters and nymphs to roam freely."
		}

		message {
			"Cut it down and bring me the logs.",
			"Be warned, the ghouls will stop at nothing to protect it.",
			"The danger is real, and the tree is massive; it will take time to cut it down."
		}

		message "Head east, past the cow pen, to enter the forest."
	elseif option == SQUID_SKULL then
		message {
			"A giant, undead squid has started attacking the ships.",
			"I'm afraid it must be stopped before you can leave."
		}

		message {
			"See Portmaster Jenkins; he knows more of the specifics.",
			"Remember, the port is to the north."
		}
	end

	option = select {
		CURSED_ORE,
		ANCIENT_DRIFTWOOD,
		SQUID_SKULL,
		THANK_YOU
	}
end

if option == NEVERMIND then
	message "That's fine."
elseif option == THANK_YOU then
	message "You're welcome."
end

message {
	"I'm here if you have any questions.",
	"Be careful. If you're weary, feel free to rest in the guest room."
}
