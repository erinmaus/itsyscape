--------------------------------------------------------------------------------
-- Resources/Game/Items/MimicPickaxe/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Pickaxe = require "Resources.Game.Items.Common.Pickaxe"

local MimicPickaxe = Class(Pickaxe)

function MimicPickaxe:onEquip(peep)
	Utility.Peep.applyEffect(peep, "MimicPickaxe", true)
	Pickaxe.onEquip(self, peep)
end

function MimicPickaxe:onDequip(peep)
	local MimicPickaxeEffect = Utility.Peep.getEffectType("MimicPickaxe", peep:getDirector():getGameDB())
	for effect in peep:getEffects(MimicPickaxeEffect) do
		peep:removeEffect(effect)
	end

	Pickaxe.onDequip(self, peep)
end

function MimicPickaxe:getCooldown()
	return 1
end

return MimicPickaxe
