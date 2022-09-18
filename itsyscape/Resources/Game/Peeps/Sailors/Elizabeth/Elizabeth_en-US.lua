local Sailing = require "ItsyScape.Game.Skills.Sailing"
local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

local isSailing = Sailing.Orchestration.isInProgress(_TARGET)
local isActiveFirstMate = SailorsCommon.isActiveFirstMate(_TARGET, _SPEAKERS["_SELF"])

if isSailing then
	defer "Resources/Game/Peeps/Sailors/Elizabeth/ElizabethSailing_en-US.lua"
elseif isActiveFirstMate then
	defer "Resources/Game/Peeps/Sailors/Elizabeth/ElizabethActive_en-US.lua"
else
	defer "Resources/Game/Peeps/Sailors/Elizabeth/ElizabethRecruit_en-US.lua"
end
