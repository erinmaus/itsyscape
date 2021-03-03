speaker "Nyarlathotep"

PLAYER_NAME = _TARGET:getName()

message "Nightmares... They're frightening things."
message "Sometimes we dream them. Sometimes we live them."

if _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_KursedByCthulhu") then
	message {
		"Seems to be worse for you, though, huh? You didn't just drown, there's more than that: a horror, a kurse, wrought into your soul.",
		"Maybe you should've listened to %person{Hans} when he told you to enter the portal."
	}

	message "That's right, %person{${PLAYER_NAME}}. I know everything."

	message "Watch yourself."
end

message "%empty{The Empty King} wants me to keep an eye on you."
message {
	"You're special. You can't die. That's unique. Only few can claim such a gift.",
	"But that gift comes with a price."
}

message "I will be watching you."
message "Now wake up and stop perceiving me."

Utility.Quest.wakeUp(_TARGET)
