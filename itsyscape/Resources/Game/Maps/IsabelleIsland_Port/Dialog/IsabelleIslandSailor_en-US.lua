speaker "Sailor"
message {
	"Psst... hey!",
	"I can smuggle ya in to Rumbridge, if ya want...",
	"Won't cost ya anythin'.",
	"Just tryin' be helpful, y'know...?"
}

local YES = option "Yes"
local NO = option "No"

local option = select { YES, NO }

if option == YES then
	local stage = _TARGET:getDirector():getGameInstance():getStage()
	stage:movePeep(_TARGET, "Rumbridge_Port", "Anchor_Spawn")
end
