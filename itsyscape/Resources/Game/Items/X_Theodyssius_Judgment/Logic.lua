--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Theodyssius_Judgment/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"

local Judgment = Class(MeleeWeapon)

function Judgment:getAttackRange(peep)
	return 4
end

function Judgment:getProjectile()
	return 'ShockwaveSplosion'
end

function Judgment:getCooldown()
	return 2.4
end

return Judgment
