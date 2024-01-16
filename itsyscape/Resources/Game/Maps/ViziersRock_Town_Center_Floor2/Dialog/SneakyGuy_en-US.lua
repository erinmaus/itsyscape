speaker "SneakyGuy"
message "Pssst... heard you wanna sneak into Ginsville."

local hasKilledBehemoth = _TARGET:getState():has("Boss", "Behemoth", 1)

local GO_BEHEMOTH = option "Take me to the Behemoth."
local GO_ENTRANCE = option "Take me to Ginsville."
local NEVERMIND   = option "Nevermind! I'm a coward!"

local option
if hasKilledBehemoth then
	option = select {
		GO_BEHEMOTH,
		GO_ENTRANCE,
		NEVERMIND
	}
else
	option = select {
		GO_ENTRANCE,
		NEVERMIND
	}
end

local gameDB = _DIRECTOR:getGameDB()
local raid = gameDB:getResource("EmptyRuinsDragonValley", "Raid")

if option == GO_BEHEMOTH then
	local map = gameDB:getResource("EmptyRuins_DragonValley_Mine", "Map")

	Utility.UI.openInterface(
		_TARGET,
		"PartyQuestion",
		true,
		raid,
		"Anchor_FromGinsville",
		map)
elseif option == GO_ENTRANCE then
	Utility.UI.openInterface(
		_TARGET,
		"PartyQuestion",
		true,
		raid)
end
