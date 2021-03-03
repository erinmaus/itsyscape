speaker "TheEmptyKing"

PLAYER_NAME = _TARGET:getName()
message {
	"%person{${PLAYER_NAME}} falls into a slumber, only to dream of %empty{me}.",
	"But of course " .. Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_SUBJECT) .. " would, for %empty{I} willed it so."
}

speaker "_TARGET"
message {
	"Who are %empty{you}?!"
}

speaker "TheEmptyKing"
message {
	" %empty{I} am %empty{The Empty King} - or rather, that is %empty{my title}.",
	"I see some %hint{pitiable person} sent " .. Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_OBJECT) .. " on a quest.",
	"What does %person{${PLAYER_NAME}} say?"
}

local I_WANT_MONEY = option "I want money!"
local I_WANT_FAME  = option "I want fame!"
local I_DONT_KNOW  = option "I don't know what I want!"

local result = select {
	I_WANT_MONEY,
	I_WANT_FAME,
	I_DONT_KNOW
}

speaker "_TARGET"
if result == I_WANT_MONEY then
	message {
		"I want money! Gimme gimme!"
	}

	speaker "TheEmptyKing"
	message {
		"Foolish. Money is a most cruel invention, binding the brightest to serve.",
		"%person{${PLAYER_NAME}}, %empty{I} expect a better response should " .. Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_SUBJECT) .. " meet %empty{me} again."
	}
elseif result == I_WANT_FAME then
	message {
		"I want fame! Everyone should know my name!"
	}

	speaker "TheEmptyKing"
	message {
		"How arrogant. I expected a better response from " .. Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_OBJECT) .. "."
	}
elseif result == I_DONT_KNOW then
	message {
		"I don't know what I want!"
	}

	speaker "TheEmptyKing"
	message {
		"Adequate. Think about why " .. Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_SUBJECT) .. " boarded that boat."
	}

	select { option "Why did I board that boat?" }

	speaker "_TARGET"
	message {
		"I don't remember how, or why, I boarded the boat.",
		"Everything... it's blank!"
	}

	speaker "TheEmptyKing"
	message {
		"In a more opportune time, everything will be made apparent.",
		"But now is not that time."
	}
end

message {
	"But for now, " .. Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_SUBJECT) .. " must wake up.",
	"%empty{I} will keep an eye on " .. Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_OBJECT) .. " and if " .. Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_SUBJECT) .. " satisfy %empty{my} curiosity... Well, %empty{I} will see."
}

Utility.Quest.wakeUp(_TARGET)
