speaker "Chicken"
message "Cluck cluck?"

local YES = option "Yes"
local NO  = option "No"
local result = select {
	YES,
	NO
}

if result == YES then
	local stage = _TARGET:getDirector():getGameInstance():getStage()
	stage:movePeep(
		_TARGET,
		"Minigame_ChickenPolitics",
		"Anchor_Spawn")
else
	message "Cluck."
end
