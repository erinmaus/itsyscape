speaker "Grimm"

_TARGET:getState():give("KeyItem", "CalmBeforeTheStorm_MetGrimm")

PLAYER_NAME = _TARGET:getName()
message {
	"Blessings! Is that %person{${PLAYER_NAME}}?",
	"Hold on! I'm coming!"
}
