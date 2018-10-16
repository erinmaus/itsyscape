--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Projectile/Interpolator/Interpolator.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Interpolator = require "ItsyScape.Graphics.Projectile.Interpolator"

local ConstantInterpolator = Class(Interpolator)

function ConstantInterpolator:new(value)
	self.value = value or 0
end

function ConstantInterpolator:getValue(time)
	return self.value
end

function ConstantInterpolator:poke(t)
	self.value = t.value or 0
end

return ConstantInterpolator
