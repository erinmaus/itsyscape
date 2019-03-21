PLAYER_NAME = _TARGET:getName()

speaker "CapnRaven"
message "Ye fools! I'll take care of ye myself!"

speaker "Jenkins"
message "Give up now, mate! There's just one of ye and four o' us."

speaker "CapnRaven"
message "What was that?"

do
	local director = _TARGET:getDirector()
	local game = director:getGameInstance()
	local stage = game:getStage()

	local map = Utility.Peep.getMap(_TARGET)
	local mapScript = stage:getMapScript(map.name)

	if mapScript then
		mapScript:poke('raiseCthulhu')
	end
end

speaker "Jenkins"
message "CTHULHU! Abandon ship! Madness awaits us!"