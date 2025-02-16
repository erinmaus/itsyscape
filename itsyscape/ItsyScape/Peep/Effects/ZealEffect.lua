--------------------------------------------------------------------------------
-- ItsyScape/Peep/Effects/ZealEffect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Effect = require "ItsyScape.Peep.Effect"

local ZealEffect = Class(Effect)

function ZealEffect:modifyPowerCost(power, cost)
	return cost
end

function ZealEffect:modifyZealEvent(zealPoke, zeal)
	return zeal
end

function ZealEffect:modifyZeal(zeal)
	return zeal
end

return ZealEffect
