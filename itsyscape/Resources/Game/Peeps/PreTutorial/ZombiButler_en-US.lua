speaker "Butler"

local Z = _SPEAKERS["Butler"]
local P = _TARGET

TARGET_FORMAL_ADDRESS = Utility.Text.getPronoun(P, Utility.Text.FORMAL_ADDRESS)
PLAYER_NAME = P:getName()

if Z:isIn(P, 'ocean') then
	message {
		"There's no time for talking, %person{${PLAYER_NAME}}!",
		"Enter the portal!"
	}

	return
end

P:getState():give('KeyItem', "PreTutorial_Start")

local firstTalk = false
if not P:getState():has('KeyItem', "PreTutorial_TalkedToButler1") then
	message {
		"Thank goodness for an adventurer like you, %person{${TARGET_FORMAL_ADDRESS} ${PLAYER_NAME}}!"
	}

	message {
		"My charges, %person{Elizabeth} and %person{Edward}, passed on many moons ago to disease.",
		"If only I could %hint{speak with the dead}, I'd ask those poor souls why they haven't moved on."
	}

	message {
		"If I can be of any help to you, then please ask me anything.",
		"I'll be at your side at all times on this urgent matter.",
		"All the resources I can give you, like the %item{tools from the crate in the shed} or the %location{library on the second floor}, are yours to use."
	}

	P:getState():give('KeyItem', "PreTutorial_TalkedToButler1")

	_SPEAKERS["Butler"]:poke('followPlayer', P)
	firstTalk = true
end

local Common = require "Resources.Game.Peeps.PreTutorial.Common"

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
		"So unless you have a death-wish..."
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
		"If you want to fish, you'll need to equip a fishing rod.",
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
elseif not firstTalk then
	message "If you need any help, feel free to ask me."
end

local didPreReqs =
	P:getState():has('KeyItem', "PreTutorial_ReadPowernomicon") and
	P:getState():has('KeyItem', "PreTutorial_SearchedCrate")
if not didPreReqs then
	if firstTalk then
		message {
			"I see you have the Nominomicon. I can show you how to use that, if you wish."
		}
	else
		message {
			"Remember, the %item{tools from the crate in the shed} or the %location{library on the second floor}, are yours to use.",
			"I see you have the Nominomicon. I can show you how to use that, if you wish."
		}
	end

	local WHERE_LIBRARY = option "Where's the library?"
	local WHERE_SHED    = option "Where's the shed?"
	local WHERE_WHAT    = option "What's the Nominomicon?"
	local THANK_YOU     = option "Thank you!"

	local option
	repeat
		option = select { WHERE_SHED, WHERE_LIBRARY, WHERE_WHAT, THANK_YOU }
		if option == WHERE_LIBRARY then
			speaker "_TARGET"
			message "This place is massive! Where's the library?"

			speaker "Butler"
			message {
				"The library is on the second floor.",
				"Take the stairs in the %location{foyer} then head %hint{north-west}.",
				"I've set a book on the table you might find useful."
			}
		elseif option == WHERE_SHED then
			speaker "_TARGET"
			message "I didn't see a shed on the way in!"

			speaker "Butler"
			message {
				"The toolshed is to the east of the %location{courtyard}.",
				"And the %location{courtyard} is on the first floor, just north of the %location{foyer}."
			}
		elseif option == WHERE_WHAT then
			speaker "_TARGET"
			message "I'm not sure what to do!"

			speaker "Butler"
			message {
				"The Nominomicon is a book that records your personal history.",
				"Here, let me show you how to use it."
			}

			Common.showQuestTip(_TARGET)
			return
		elseif option == THANK_YOU then
			speaker "_TARGET"
			message "Thank you!"

			speaker "Butler"
			message "Anything, ${TARGET_FORMAL_ADDRESS}."
		end
	until option == THANK_YOU
else

	local savedChildren =
		P:getState():has('KeyItem', "PreTutorial_SavedGhostGirl") and
		P:getState():has('KeyItem', "PreTutorial_SavedGhostBoy")

	if savedChildren then
		local WAKE_UP  = option "What do I do next?"
		local QUESTION = option "Can I ask you a different question?"

		local option = select { WAKE_UP, QUESTION }
		if option == WAKE_UP then
			speaker "_TARGET"
			message "I've saved %person{Edward} and %person{Elizabeth}. What's next, %person{Hans}?"

			speaker "Butler"
			message "Well, you need to wake up, ${TARGET_FORMAL_ADDRESS} ${PLAYER_NAME}."

			P:getState():give('KeyItem', "PreTutorial_TalkedToButler2")

			local stage = _TARGET:getDirector():getGameInstance():getStage()
			stage:movePeep(
				_TARGET,
				"IsabelleIsland_Tower_Floor5",
				"Anchor_StartGame")

			P:getState():give('KeyItem', "PreTutorial_WokeUp")
		end
	end

	if P:getState():has('KeyItem', "PreTutorial_ReadPowernomicon") then
		local FIND_COPPER    = option "Where do I find copper?"
		local CRAFT_COPPER   = option "How do I make copper into an amulet?"
		local ENCHANT_COPPER = option "How do I enchant copper?"
		local THANK_YOU      = option "Thanks, but I'm good."

		local result
		repeat
			result = select { FIND_COPPER, CRAFT_COPPER, ENCHANT_COPPER, THANK_YOU }

			if result == FIND_COPPER then
				message "You may find %item{copper} in the basement. You'll need to equip a pick-axe to mine it."
			elseif result == CRAFT_COPPER then
				message {
					"You may go to the %location{shed} and smelt %item{copper} into a %item{copper bar}.",
					"After that, take a %item{hammer} and smith it into what shape you want on the %item{anvil}."
				}
			elseif result == ENCHANT_COPPER then
				message "You'll need to have a %item{copper amulet}, then you can cast the Enchant spell."

				if P:getState():has('Item', "CopperAmulet", 1, { ['item-inventory'] = true }) then
					local YES = option "Yes, please!"
					local NO  = option "No, I can figure it out myself."

					message "I see you have a %item{copper amulet}. I can show you how to enchant it, if you want."

					local result = select { YES, NO }
					if result == YES then
						Common.showEnchantTip(P)
						return
					end
				end
			end
		until result == THANK_YOU

		speaker "_TARGET"
		message "Thank you!"

		speaker "Butler"
		message "I'm here to help you, ${TARGET_FORMAL_ADDRESS}."
	end
end
