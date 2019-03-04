--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_DoubleTake/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ProxyXWeapon = require "ItsyScape.Game.ProxyXWeapon"

-- Shoots two arrows. If the first attack hits, so does the second.
local DoubleTake = Class(ProxyXWeapon)

function DoubleTake:onAttackHit(peep, target, ...)
	local logic = self:getLogic()
	if logic then
		for i = 1, 2 do
			ProxyXWeapon.onAttackHit(self, peep, target, ...)
		end
	else
		return ProxyXWeapon.onAttackHit(self, peep, target)
	end
end

return DoubleTake
