--------------------------------------------------------------------------------
-- Resources/Game/Items/IronZweihander/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Zweihander = require "Resources.Game.Items.Common.Zweihander"

local IronZweihander = Class(Zweihander)

function IronZweihander:rollDamage(peep, purpose, target)
	local roll = Zweihander.rollDamage(self, peep, purpose, target)
	roll:setMinHit(roll:getMinHit() + 2)

	return roll
end

return IronZweihander
