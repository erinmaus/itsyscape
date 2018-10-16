--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Projectile/Interpolator/Linear.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Interpolator = require "ItsyScape.Graphics.Projectile.Interpolator"

local LinearInterpolator = Class(Interpolator)

function LinearInterpolator:new()
	self.start = 0
	self.stop = 0
	self.duration = 0
end

function LinearInterpolator:getValue(time)
	local delta
	if self.duration <= 0 then
		delta = 0
	else
		delta = time / self.duration
	end

	return start * (1 - delta) + (stop - start) * delta
end

function LinearInterpolator:poke(t)
	self.start = t.start or self.start
	self.stop = t.stop or self.stop
	self.duration = t.duration or self.duration
end

return LinearInterpolator
