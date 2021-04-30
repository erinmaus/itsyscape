speaker "Priest"

TARGET_NAME = _TARGET:getName()
message {
	"Praise upon %person{Yendor}.",
	"Welcome, %person{${TARGET_NAME}}."
}

do
	local INFO = option "Can you tell me about this place?"
	local TREE = option "What is that creepy tree doing?"
	local SELF = option "Who are you?"
	local SELL = option "Do you have anything for sale?"
	local QUIT = option "Good-bye."

	local result
	while result ~= QUIT do
		result = select {
			INFO,
			TREE,
			SELF,
			SELL,
			QUIT
		}

		if result == INFO then
			message {
				"To your kind, this is the %location{Foggy Forest}.",
				"But to mine, this is a holy site of %person{Yendor}.",
				"Home to the graves of Her human followers."
			}

			message {
				"%person{Yendor} grants eternal life to all those faithful.",
				"So they still live."
			}

			message {
				"I am destined to wait Yendor's return,",
				"The same fate of all my people.",
				"She is near, I can feel Her. But I await Her call."
			}

			local YENDOR = option "What is Yendor?"
			local OKAY   = option "Alrighty!"

			local result = select {
				YENDOR,
				OKAY
			}

			if result == YENDOR then
				speaker "_TARGET"
				message "What is %person{Yendor}? Sounds pretty backwards."

				speaker "Priest"
				message {
					"%person{Yendor} is the god that found this world.",
					"She saw the beauty and opened a Dimensional Schism, to bring us and others across the planes."
				}

				message {
					"Her grace brings balance and guidance across all worlds, physical and spiritual."
				}

				message {
					"But She has not been seen since.",
					"Not in over a thousand years.",
					"No one knows what caused Her to sleep,",
					"But as She sleeps, my people's faith grows."
				}
			end
		elseif result == TREE then
			message {
				"The tree was once a magnificent oak,",
				"short of ten-thousand years old.",
				"A symbol of %person{Yendor's} promise to Her followers."
			}

			message {
				"But there was a force of nature that brought ruin to the world known as the %empty{The Empty King}.",
				"%empty{They} banished %hint{the Old Ones} from the world."
			}

			message {
				"%empty{The Empty King}...",
				"Defiled Her promise, bringing rot to the tree."
			}

			message {
				"Her weaker followers know not what %empty{They} did,",
				"and still protect the tree. Be warned."
			}
		elseif result == SELF then
			message {
				"I'm a high priest for %person{Yendor}.",
				"Yendorians are Her First Children.",
				"I prepare incense for my God to worship Her."
			}

			message {
				"You can make incense yourself,",
				"although for more selfish purposes.",
				"It provides benefits that last for a short time."
			}

			message {
				"Be warned!",
				"Sometimes those blessings come at a cost..."
			}
		elseif result == SELL then
			message {
				"Perhaps. I sell incense and bonfires.",
				"Be warned!",
				"I have no use for coin and require bone shards."
			}

			local SHARDS = option "How do I get bone shards?"
			local BROWSE = option "Can I see what you have?"
			local OKAY   = option "I have asthma!"

			local result = select {
				SHARDS,
				BROWSE,
				OKAY
			}

			if result == SHARDS then
				message {
					"We craft the dead's bones into shards,",
					"which we then use in rituals to clean their souls.",
					"Any bones will do."
				}
			elseif result == BROWSE then
				local gameDB = _DIRECTOR:getGameDB()
				local shop = gameDB:getResource("IsabelleIsland_FoggyForest_YendorianIncenseShop", "Shop")

				if not shop then
					message "I'm sorry, I've run out of stock of everything."
				else
					Utility.UI.openInterface(_TARGET, "ShopWindow", true, shop)
				end
			end
		end
	end
end