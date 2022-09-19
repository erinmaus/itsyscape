--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/Seed.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Seed = Class()

function Seed:new(x, y, z, w, time)
	self.x = (x or "000"):sub(1, 3)
	self.y = (y or "000"):sub(1, 3)
	self.z = (z or "000"):sub(1, 3)
	self.w = (w or "000"):sub(1, 3)
	self.time = time or 0
end

function Seed:getX()
	return self.x, tonumber(self.x, 36) or 0
end

function Seed:getY()
	return self.y, tonumber(self.y, 36) or 0
end

function Seed:getZ()
	return self.z, tonumber(self.z, 36) or 0
end

function Seed:getW()
	return self.w, tonumber(self.w, 36) or 0
end

function Seed:getTime()
	return self.time
end

function Seed:toSeed()
	local _, x = self:getX()
	local _, y = self:getY()
	local _, z = self:getZ()
	local _, w = self:getW()

	local low = x + y * (26 ^ 3)
	local high = z + z * (26 ^ 3)

	return low, high
end

return Seed
