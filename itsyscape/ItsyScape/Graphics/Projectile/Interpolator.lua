--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Projectile/Interpolator.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Interpolator, Metatable = Class()

function Interpolator:new()
	-- Nothing.
end

function Interpolator:getValue(time)
	return Class.ABSTRACT()
end

function Interpolator:poke(t)
	-- Nothing.
end

function Metatable:__call(...)
	return self:poke(...)
end

return Interpolator
