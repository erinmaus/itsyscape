local Sailing = require "ItsyScape.Game.Skills.Sailing"
local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

local isSailing = Sailing.Orchestration.isInProgress(_TARGET)
local isActiveFirstMate = SailorsCommon.isActiveFirstMate(_TARGET, _SPEAKERS["_SELF"])

if isSailing then
	defer "Resources/Game/Peeps/Sailors/Nyan/NyanSailing_en-US.lua"
elseif isActiveFirstMate then
	defer "Resources/Game/Peeps/Sailors/Nyan/NyanActive_en-US.lua"
else
	defer "Resources/Game/Peeps/Sailors/Nyan/NyanRecruit_en-US.lua"
end
