local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"
local isActiveFirstMate = SailorsCommon.isActiveFirstMate(_TARGET, _SPEAKERS["_SELF"])
if isActiveFirstMate then
	defer "Resources/Game/Peeps/Sailors/Elizabeth/ElizabethActive_en-US.lua"
else
	defer "Resources/Game/Peeps/Sailors/Elizabeth/ElizabethRecruit_en-US.lua"
end
