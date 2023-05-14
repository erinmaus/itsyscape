--------------------------------------------------------------------------------
-- Resources/Game/Items/X_TrashHeapSmash/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Musket = require "Resources.Game.Items.Common.Musket"

local TrashHeapSmash = Class(Musket)
TrashHeapSmash.AMMO = Equipment.AMMO_NONE

function TrashHeapSmash:getAttackRange(peep)
	return 3
end

function TrashHeapSmash:getBonusForStance(peep)
	return Weapon.BONUS_CRUSH
end

function TrashHeapSmash:probe(ray)
	local func = Musket.probe(self, ray)
	return function(p)
		local resource = Utility.Peep.getResource(p)
		return func(p) and (not resource or resource.name ~= "TrashHeap")
	end
end

function TrashHeapSmash:getCooldown()
	return 3
end

return TrashHeapSmash
