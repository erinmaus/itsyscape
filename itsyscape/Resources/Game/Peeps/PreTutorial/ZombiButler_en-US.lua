speaker "Butler"

_TARGET:getState():give('KeyItem', "PreTutorial_Start")

PLAYER_NAME = _TARGET:getName()
TARGET_FORMAL_ADDRESS = Utility.Text.getPronoun(_TARGET, Utility.Text.FORMAL_ADDRESS)

if not _TARGET:getState():has('KeyItem', "PreTutorial_TalkedToButler1") then
	message {
		"Thank goodness for an adventurer like you, ${TARGET_FORMAL_ADDRESS} ${PLAYER_NAME}!"
	}

	message {
		"My charges passed on many moons ago to disease.",
		"If only I could speak with the dead, I'd ask those poor souls why they haven't moved on."
	}

	message {
		"If I can be of any help to you, then please ask me anything.",
		"All the resources I can give you, like the tools from the crate in the shed, are yours to take."
	}

	_TARGET:getState():give('KeyItem', "PreTutorial_TalkedToButler1")

	_SPEAKERS["Butler"]:poke('followPlayer', _TARGET)
else
	local Z = _SPEAKERS["Butler"]
	local P = _TARGET

	if Z:isIn(P, 'kitchen') then
		message "Kitchens are useful for cooking."

		local MEAN = option "Of course they are!"
		local NICE = option "Definitely!"


		local option = select {
			MEAN,
			NICE
		}

		if option == MEAN then
			speaker "_TARGET"
			message "Of course they are! Do you think I'm a moron?"

			speaker "Butler"
			message "No, ${TARGET_FORMAL_ADDRESS}, I meant no offense."
		elseif option == NICE then
			speaker "_TARGET"
			message "Definitely!"
		end

		speaker "Butler"
		message {
			"You can also use a tinderbox and light logs on fire to cook...",
			"...but food tastes better when cooked properly, right?"
		}
	elseif Z:isIn(P, 'dining-room')then
		message {
			"Unfortunately, this food is poisonous to the living.",
			"Ectoplasm glaze was used on all the food here.",
			"So unless you have a deathwish..."
		}
	elseif Z:isIn(P, 'boys-room')then
		message {
			"Edward is the younger child. He is always afraid.",
			"When he was alive, he would wake up in the night yelling about a monster."
		}
	elseif Z:isIn(P, 'girls-room')then
		message {
			"Elizabeth was very sick and did not eat for weeks before she passed on.",
			"I can hear her ghostly stomach rumbling as I speak."
		}
	elseif Z:isIn(P, 'courtyard') then
		message {
			"If you want to fish, you'll need a fishing rod.",
			"You may find one in the toolshed."
		}
	elseif Z:isIn(P, 'shed') then
		message {
			"Take any of the tools. They're yours."
		}
	elseif Z:isIn(P, 'butler-quarters')then
		message {
			"This is where I slept when I was alive.",
			"It's not too comfortable, but it makes do."
		}
	elseif Z:isIn(P, 'study') then
		message {
			"That book is called the Powernomicon.",
			"An ancient book that describes magics over death."
		}
	elseif Z:isIn(P, 'library') then
		message {
			"I think the only useful book for you is the Powernomicon.",
			"I've already moved it to the table in the study on your behalf."
		}
	elseif Z:isIn(P, 'ballroom') then
		message {
			"Feel free to dance, but I'm not sure there's much else to do here."
		}
	else
		message "If you need any help, feel free to ask me."
	end

	local savedChildren =
		P:getState():has('KeyItem', "PreTutorial_SavedGhostGirl") and
		P:getState():has('KeyItem', "PreTutorial_SavedGhostBoy")

	if savedChildren then
		local WAKE_UP  = option "What do I do next?"
		local QUESTION = option "Can I ask you a different question?"

		local option = select { WAKE_UP, QUESTION }
		if option == WAKE_UP then
			speaker "_TARGET"
			message "I've saved Edward and Elizabeth, what's next, Hans?"

			speaker "Butler"
			message "Well, you need to wake up, ${TARGET_FORMAL_ADDRESS} ${PLAYER_NAME}."

			P:getState():give('KeyItem', "PreTutorial_TalkedToButler2")

			local stage = _TARGET:getDirector():getGameInstance():getStage()
			stage:movePeep(
				_TARGET,
				"IsabelleIsland_Tower",
				"Anchor_StartGame")

			P:getState():give('KeyItem', "PreTutorial_WokeUp")
		end
	end

	if P:getState():has('KeyItem', "PreTutorial_ReadPowernomicon") then
		local FIND_COPPER    = option "Where do I find copper?"
		local CRAFT_COPPER   = option "How do I make copper into an amulet?"
		local ENCHANT_COPPER = option "How do I enchant copper?"
		local THANK_YOU      = option "Thanks, but I'm good."

		local option
		repeat
			option = select { FIND_COPPER, CRAFT_COPPER, ENCHANT_COPPER, THANK_YOU }

			if option == FIND_COPPER then
				message "You may find copper in the basement. You'll need to equip a pick-axe to mine it."
			elseif option == CRAFT_COPPER then
				message {
					"You may go to the shed and smelt copper into a bar.",
					"After that, take a hammer and smith it into what shape you want on the anvil."
				}
			elseif option == ENCHANT_COPPER then
				message "You'll need to have a copper amulet, then you can cast the Enchant spell."
			end
		until option == THANK_YOU

		speaker "_TARGET"
		message "Thank you!"

		speaker "Butler"
		message "I'm here to help you, ${TARGET_FORMAL_ADDRESS}."
	end
end
