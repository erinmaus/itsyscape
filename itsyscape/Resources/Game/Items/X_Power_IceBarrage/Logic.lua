--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_IceBarrage/Logic.lua
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

local IceBarrage = Class(ProxyXWeapon)
IceBarrage.MIN_DAMAGE = 1
IceBarrage.MAX_DAMAGE = 3

function IceBarrage:previewDamageRoll(roll)
	ProxyXWeapon.previewDamageRoll(self, roll)
	roll:setMinHit(roll:getMaxHit() * IceBarrage.MIN_DAMAGE)
	roll:setMaxHit(roll:getMaxHit() * IceBarrage.MAX_DAMAGE)
end

function IceBarrage:getProjectile()
	return "Power_IceBarrage"
end

return IceBarrage
