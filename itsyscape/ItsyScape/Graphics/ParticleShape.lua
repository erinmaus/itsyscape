--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ParticleShape.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"

local ParticleShape = Class()

function ParticleShape:new()
	-- Nothing.
end

function ParticleShape:getPosition()
	return Vector.ZERO
end

return ParticleShape
