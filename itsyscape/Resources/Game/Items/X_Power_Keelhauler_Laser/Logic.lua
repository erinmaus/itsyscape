--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_Keelhauler_Laser/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local ProxyXWeapon = require "ItsyScape.Game.ProxyXWeapon"
local Weapon = require "ItsyScape.Game.Weapon"

-- Always hits.
local Laser = Class(ProxyXWeapon)

function Laser:previewAttackRoll(roll)
	roll:setAlwaysHits(true)
end

function Laser:getProjectile()
	return "MantokBeam"
end

return Laser
