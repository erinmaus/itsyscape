--------------------------------------------------------------------------------
-- ItsyScape/Peep/Effects/MovementEffect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Effect = require "ItsyScape.Peep.Effect"

local MovementEffect = Class(Effect)

function MovementEffect:applyToAcceleration(acceleration)
	return acceleration
end

function MovementEffect:applyToVelocity(velocity)
	return velocity
end

function MovementEffect:applyToPosition(position, elevation)
	return position
end

return MovementEffect
