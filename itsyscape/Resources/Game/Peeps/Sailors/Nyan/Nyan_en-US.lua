local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"
local isActiveFirstMate = SailorsCommon.isActiveFirstMate(_TARGET, _SPEAKERS["_SELF"])
if isActiveFirstMate then
	defer "Resources/Game/Peeps/Sailors/Nyan/NyanActive_en-US.lua"
else
	defer "Resources/Game/Peeps/Sailors/Nyan/NyanRecruit_en-US.lua"
end
