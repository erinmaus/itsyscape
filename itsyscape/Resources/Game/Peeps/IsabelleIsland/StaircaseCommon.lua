--------------------------------------------------------------------------------
-- Resources/Game/Peeps/IsabelleIsland/StaircaseCommon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Vector = require "ItsyScape.Common.Math.Vector"

local StaircaseCommon = {}

StaircaseCommon.START_ANGLE = math.pi / 2
StaircaseCommon.END_ANGLE   = 0

StaircaseCommon.HEIGHT = 18
StaircaseCommon.RADIUS = 9
StaircaseCommon.STEPS  = 36

StaircaseCommon.CELL_SIZE = 2

StaircaseCommon.PATTERN_COUNT = 4

StaircaseCommon.PATTERN = {
	0.3, math.pi / 3, 0.1,
	0.2, math.pi / 4, 0.15,
	0.4, math.pi / 7, 0.05,
	0.5, math.pi / 5, 0.1,
}

function StaircaseCommon.position(index, time)
	local radius = StaircaseCommon.RADIUS * StaircaseCommon.CELL_SIZE

	local delta = (index - 1) / (StaircaseCommon.STEPS - 1)
	local angle = math.lerp(StaircaseCommon.START_ANGLE, StaircaseCommon.END_ANGLE, delta)

	local x = math.cos(angle) * radius
	local y = math.lerp(0, StaircaseCommon.HEIGHT, delta)
	local z = math.sin(angle) * radius - radius

	if time then
		local wrappedIndex = math.wrap(index, 1, StaircaseCommon.PATTERN_COUNT)
		local offset, scale, distance = unpack(StaircaseCommon.PATTERN, (wrappedIndex - 1) * 3 + 1, wrappedIndex * 3)

		y = y - (math.sin(time * scale + offset) * distance)
	end

	return Vector(x, y, z)
end

return StaircaseCommon
