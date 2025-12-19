local CutsceneEntity = require "ItsyScape.Game.CutsceneEntity"
local Utility = require "ItsyScape.Game.Utility"

local doorPeep = ...
local Door = CutsceneEntity(doorPeep)

local position, layer = Utility.Peep.getOtherTileAnchor(doorPeep, Player:getPeep())
local playerLayer = Utility.Peep.getLayer(Player:getPeep())

local tileAbsolutePosition = Utility.Map.getAbsolutePosition(_DIRECTOR, position, layer)
local playerAbsolutePosition = Utility.Peep.getAbsolutePosition(Player:getPeep())

local time = playerAbsolutePosition:distance(tileAbsolutePosition) / 6
local relativePosition = Utility.Map.absolutePositionToRelativePosition(_DIRECTOR, playerLayer, tileAbsolutePosition)

return Sequence {
	Door:poke("open"),
	Player:wait(1),

	Player:playAnimation("Human_Walk_1", "x-cutscene-climb", 2),
	Player:lerpPosition(function() return relativePosition end, time),
	Player:stopAnimation("x-cutscene-climb"),

	Door:poke("close"),
	Player:wait(0.5)
}
