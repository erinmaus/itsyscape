local CutsceneEntity = require "ItsyScape.Game.CutsceneEntity"
local Utility = require "ItsyScape.Game.Utility"
local StaircaseCommon = require "Resources.Game.Peeps.IsabelleIsland.StaircaseCommon"

local staircasePeep = ...
local Staircase = CutsceneEntity(staircasePeep)

local sequence = {}
for i = StaircaseCommon.STEPS + 1, 1, -1 do
	local firstPosition = StaircaseCommon.position(i)
	local secondPosition = StaircaseCommon.position(i - 1)
	local time = secondPosition:distance(firstPosition) / 12

	table.insert(sequence, Player:lerpPosition(function()
		local playerPeep = Player:getPeep()

		local playerParentTransform = Utility.Peep.getParentTransform(playerPeep)
		local staircaseParentTransform = Utility.Peep.getParentTransform(staircasePeep)
		local staircaseLocalTransform = Utility.Peep.getTransform(staircasePeep)

		local staircaseLocalPosition = StaircaseCommon.position(i, love.timer.getTime()):transform(staircaseLocalTransform)
		local absolutePosition = staircaseLocalPosition:transform(staircaseParentTransform)
		local playerLocalPosition = absolutePosition:inverseTransform(playerParentTransform)

		return playerLocalPosition
	end, time))
end

return Sequence {
	Player:playAnimation("Human_Walk_1", "x-cutscene-climb", 2),

	Sequence(sequence),

	Player:stopAnimation("x-cutscene-climb")
}
