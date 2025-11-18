--------------------------------------------------------------------------------
-- Resources/Game/Items/X_GlyphboundYendorian_Punch/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"

local Punch = Class(MeleeWeapon)

function Punch:previewDamageRoll(roll)
	roll:setMinHit(math.floor(roll:getMaxHit() / 2))
end

return Punch
