speaker "Isabelle"

PLAYER_NAME = _TARGET:getName()

message {
	"Thank you sincerely, %person{${PLAYER_NAME}}!",
	"Now I have all the items needed!",
	"Gosh, the kurse will be lifted... I'm so excited!"
}

message {
	"I've wired 10,000 coins to your bank.",
	"I also provided some supplies.",
	"Per our agreement, of course.",
	"Consider our deal done."
}

message {
	"Take a stroll to see %person{Portmaster Jenkins}.",
	"He should be able to take you to %location{Rumbridge}.",
	"Feel free to return any time!"
}

do
	local FLAGS = { ['item-bank'] = true }

	_TARGET:getState():give("Item", "Coins", 10000, FLAGS)
	_TARGET:getState():give("Item", "MooishLeatherHide", 20, FLAGS)
	_TARGET:getState():give("Item", "BlueCotton", 20, FLAGS)
	_TARGET:getState():give("Item", "BronzeBar", 20, FLAGS)
	_TARGET:getState():give("Item", "CommonLogs", 20, FLAGS)
	_TARGET:getState():give("Item", "WeakGum", 5, FLAGS)
end

_TARGET:getState():give("KeyItem", "CalmBeforeTheStorm_TalkedToIsabelle2")
