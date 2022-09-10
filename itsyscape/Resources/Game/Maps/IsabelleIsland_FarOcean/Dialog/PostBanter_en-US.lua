PLAYER_NAME = _TARGET:getName()

speaker "CapnRaven"
message "Ye fools! I'll take care of ye myself!"

speaker "Jenkins"
message {
	"Give up now, mate!",
	"There's just one of ye and there's four o' us."
}

speaker "CapnRaven"
message "What was that?"

do
	local director = _TARGET:getDirector()
	local game = director:getGameInstance()
	local stage = game:getStage()

	local map = Utility.Peep.getMapResource(_TARGET)
	local instance = stage:getPeepInstance(_TARGET)
	local mapScript = instance:getMapScriptByMapFilename(map.name)

	if mapScript then
		mapScript:poke('raiseCthulhu')
	end
end

speaker "Jenkins"
message {
	"%person{CTHULHU}! Abandon ship!",
	"Madness awaits us!"
}
