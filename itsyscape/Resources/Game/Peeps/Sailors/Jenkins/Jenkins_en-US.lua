local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"
local isActiveFirstMate = SailorsCommon.isActiveFirstMate(_TARGET, _SPEAKERS["_SELF"])
if isActiveFirstMate then
	defer "Resources/Game/Peeps/Sailors/Jenkins/JenkinsActive_en-US.lua"
else
	defer "Resources/Game/Peeps/Sailors/Jenkins/JenkinsRecruit_en-US.lua"
end
