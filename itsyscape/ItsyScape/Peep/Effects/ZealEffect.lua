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

-- Should return (multiplier, offset)
function ZealEffect:modifyTierCost(tier)
	return 0, 0
end

function ZealEffect:modifyZealEvent(zealPoke, peep)
	-- Nothing.
end

-- Should return (multiplier, offset)
function ZealEffect:modifyZeal()
	return 0, 0
end

return ZealEffect
