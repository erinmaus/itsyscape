speaker "Priest"

TARGET_NAME = _TARGET:getName()
message "Praise upon Yendor. Welcome, ${TARGET_NAME}."

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
				"This is better known to humans as the Foggy Forest.",
				"Home to the graves of Yendor's human followers."
			}

			message {
				"Yendor grants eternal life to all those faithful, however...",
				"So some still live, in a way."
			}

			message {
				"I am destined to wait Yendor's return.",
				"He is near, I can feel Him. But I await His call."
			}

			local YENDOR = option "What is Yendor?"
			local OKAY   = option "Alrighty!"

			local result = select {
				YENDOR,
				OKAY
			}

			if result == YENDOR then
				speaker "_TARGET"
				message "What is Yendor? Sounds pretty backwards."

				speaker "Priest"
				message {
					"Yendor is the god that built this world and all others.",
					"This was His most beautiful creation, so he stayed and protected us.",
				}

				message {
					"His grace brings balance and guidance across all worlds, physical and spiritual."
				}

				message {
					"But He has not been seen since His most holy island was defiled.",
					"I await His return. Praise upon Yendor!"
				}
			end
		elseif result == TREE then
			message {
				"A human necromancer approached the gods in raw power.",
				"They warped the once beautiful forest oak into a driftwood tree.",
			}

			message {
				"A beacon of Yendor's grace, now corrupted to control Yendor's followers.",
				"Fell the tree, but be warned; Yendor's followers are blind to the corruption",
				"and will seek your destruction."
			}
		elseif result == SELF then
			message {
				"I'm a high priest for Yendor. Yendorians are His First Children.",
				"I prepare incense for my God, as a means of worship."
			}

			message {
				"You can make incense yourself, although for more selfish purposes.",
				"It provides benefits that last for a short time."
			}

			message {
				"Be warned, sometimes those blessings come at a cost..."
			}
		elseif result == SELL then
			message {
				"I help fellow priests with supplies for incense and bonfires.",
				"But be warned, I have no use for coin and only accept bone shards."
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
					"To respect the dead, we craft their bones into shards.",
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