--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/Fungal.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"

local Fungal = {}

function Fungal:perform(peep, target)
	local gameDB = peep:getDirector():getGameDB()
	local resource = gameDB:getResource("FungalInfection", "Effect")

	local coolDown = self:getCooldown(peep)

	-- Roughly expects to activate 50% of the time every 30 seconds.
	-- The math here could be wrong.
	local chance = 1 / (30 / coolDown)
	local roll = math.random()
	if roll <= chance then
		Utility.Peep.applyEffect(target, resource, true, peep)
	end
end

return Fungal
