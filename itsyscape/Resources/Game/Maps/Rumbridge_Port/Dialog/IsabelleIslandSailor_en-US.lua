speaker "Sailor"
message {
	"Eh, um, how's it...?",
	"W-wanna, wanna sail b-back to %location{Isabelle Island}...?"
}

local YES = option "Yes"
local NO = option "No"

local option = select { YES, NO }

if option == YES then
	local stage = _TARGET:getDirector():getGameInstance():getStage()
	stage:movePeep(_TARGET, "IsabelleIsland_Port", "Anchor_Spawn")
end
