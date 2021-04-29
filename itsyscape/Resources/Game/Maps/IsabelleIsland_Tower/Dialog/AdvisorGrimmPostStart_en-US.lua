speaker "AdvisorGrimm"
message "What would you like to know?"

PLAYER_NAME = _TARGET:getName()

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
				"There's some %item{kursed ore} in the %location{abandoned mine}.",
				"The %person{last miner foreman} guards the ore with his life.",
				"Or, perhaps better said, his %hint{afterlife}."
			}

			message {
				"%person{Isabelle's} older brother, %person{Orlando}, guards the door.",
				"He can let you in, assuming he's not busy writing a sonnet or something silly."
			}

			message {
				"There's %hint{hostile creeps} in the mine, so I suggest ensuring you have supplies, such as food.",
				"%person{Portmaster Jenkins} can help you with that."
			}

			if not _TARGET:getState():has("Item", "BronzePickaxe", 1, SEARCH_FLAGS) then
				if _TARGET:getState():give("Item", "BronzePickaxe", 1, TAKE_FLAGS) then
					message "Here's a %item{pickaxe} to help you mine."
				else
					message "If you had more inventory space, I could give you a %hint{pickaxe}."
				end
			end

			if not _TARGET:getState():has("Item", "Hammer", 1, SEARCH_FLAGS) then
				if _TARGET:getState():give("Item", "Hammer", 1, TAKE_FLAGS) then
					message "And here's a %item{hammer} to help you smith."
				else
					message "If you had more inventory space, I could give you a %item{hammer}."
				end
			end

			if _TARGET:getState():has("Item", "IsabelleIsland_CrawlingCopperOre", 1, TAKE_FLAGS) or
			   _TARGET:getState():has("Item", "IsabelleIsland_TenseTinOre", 1, TAKE_FLAGS)
			then
				message {
					"I see you have some %item{kursed ore}.",
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

			message {
				"If you--by any chance--obtain more, you might be able to make something of it."
			}
		end
	elseif option == ANCIENT_DRIFTWOOD then
		if not _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_GotAncientDriftwood") then
			message {
				"There's an ancient, living driftwood tree.",
				"While it stands, it kurses the forest, allowing %hint{zombies and nymphs} to roam freely."
			}

			message {
				"Cut it down and bring me four ancient splinters.",
			}

			message {
				"Heed my warning!",
				"The ghouls will stop at nothing to protect the tree.",
				"The danger is real, so be prepared."
			}

			message "I've heard you can make a mask from the splinters if you're strong enough."

			message "Head east, past the cow pen, to enter the forest."

			local gaveItem = false

			if not _TARGET:getState():has("Item", "BronzeHatchet", 1, SEARCH_FLAGS) then
				if _TARGET:getState():give("Item", "BronzeHatchet", 1, TAKE_FLAGS) then
					message "Here's a %item{hatchet} to help you woodcut."
				else
					message "If you had more inventory space, I could give you a %item{hatchet}."
				end

				gaveItem = true
			end

			if not _TARGET:getState():has("Item", "Tinderbox", 1, SEARCH_FLAGS) then
				if _TARGET:getState():give("Item", "Tinderbox", 1, TAKE_FLAGS) then
					message "And here's a %item{tinderbox} to help you make fires."
				else
					message "If you had more inventory space, I could give you a %item{tinderbox}."
				end

				gaveItem = true
			end

			if gaveItem then
				message {
					"I'm afraid I don't have other tools you may need.",
					"But shopkeep %person{Bob}, on the third floor,",
					"can sell you more useful tools and materials."
				}

				message {
					"You might find a %item{knife} useful for %hint{fletching},",
					"or a %item{needle} and %item{thread} for %hint{crafting}."
				}

				speaker "_TARGET"
				message "That's useful!"

				speaker "AdvisorGrimm"
				message {
					"Definitely.",
					"%person{Isabelle} wired you a small allowance.",
					"You'll find it in your bank."
				}
			end

			if _TARGET:getState():has("Item", "IsabelleIsland_FoggyForest_AncientSplinters", 4, TAKE_FLAGS) then
				message {
					"I see you're in possession of %item{four ancient splinters}.",
					"%person{Isabelle} sends her thanks, %person{${PLAYER_NAME}}. That must have been difficult to obtain."
				}

				if _TARGET:getState():take("Item", "IsabelleIsland_FoggyForest_AncientSplinters", 4, TAKE_FLAGS) then
					_TARGET:getState():give("KeyItem", "CalmBeforeTheStorm_GotAncientDriftwood")
				end
			end
		else
			message {
				"You've already obtained the ancient splinters.",
				"I've heard rumors that it's possible to craft a powerful artefact from the splinters if you're able to obtain glue."
			}
		end
	elseif option == SQUID_SKULL then
		if not _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_GotSquidSkull") then
			message {
				"As you might have seen on your sail here,",
				"giant undead squids attack nearby ships.",
				"They must be stopped %hint{before you can leave}."
			}

			message {
				"See %person{Portmaster Jenkins},",
				"he knows more of the specifics.",
				"Remember, the port is to the north."
			}

			if _TARGET:getState():has("Item", "SquidSkull", 1, TAKE_FLAGS) then
				message {
					"You've slain Mn'thrw? Impressive!",
					"Guessing you don't believe in superstitions, eh?"
				}

				message "I'll take that off your hands."

				if _TARGET:getState():take("Item", "SquidSkull", 1, TAKE_FLAGS) then
					_TARGET:getState():give("KeyItem", "CalmBeforeTheStorm_GotSquidSkull")
				end
			end
		else
			message {
				"The squid skull remains in Isabelle's possession.",
				"But the undead don't often stay dead, so if you happen to come across Mn'thrw again...",
				"...feel free to slay the beast and take his skull for your own purposes."
			}
		end
	end

	if  _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_GotCrawlingCopper") and
	    _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_GotTenseTin") and
	    _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_GotAncientDriftwood") and
	    _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_GotSquidSkull")
	then
		message {
			"Well done! You've obtained all the artefacts requested.",
			"Please see Isabelle to claim your reward."
		}

		if not _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_GotAllItems") then
			_TARGET:getState():give("KeyItem", "CalmBeforeTheStorm_GotAllItems")
		end
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
	"Be careful.",
	"If you're weary, feel free to rest in the guest room."
}
