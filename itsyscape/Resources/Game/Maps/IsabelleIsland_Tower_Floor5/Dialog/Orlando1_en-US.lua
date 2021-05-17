speaker "Orlando"

_TARGET:getState():give("KeyItem", "CalmBeforeTheStorm_MetOrlando")

PLAYER_NAME = _TARGET:getName()
message {
	"Wow, is that %person{${PLAYER_NAME}}?!",
	"Hold on! I'm coming!"
}
