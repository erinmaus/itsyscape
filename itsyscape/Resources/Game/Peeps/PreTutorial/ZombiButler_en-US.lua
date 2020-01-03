speaker "Butler"

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
			"That power is called the Powernomicon.",
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
end
