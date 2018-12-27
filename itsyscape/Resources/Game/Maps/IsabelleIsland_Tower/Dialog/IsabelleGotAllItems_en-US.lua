speaker "Isabelle"

PLAYER_NAME = _TARGET:getName()

message {
	"Thank you sincerely, ${PLAYER_NAME}!",
	"Now I have all the items needed to break the curse on this island."
}

message {
	"I've wired 10,000 coins and some supplies to your bank, per our agreement.",
	"Consider our deal done."
}

message {
	"Portmaster Jenkins should be able to take you off the island.",
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
