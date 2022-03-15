--------------------------------------------------------------------------------
-- Resources/Game/Items/GhostBindersRing/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

local GhostBindersRing = Class(Equipment)

function GhostBindersRing:onEquip(peep)
	local gameDB = peep:getDirector():getGameDB()
	local resource = gameDB:getResource("GhostBindersRing", "Effect")
	Utility.Peep.applyEffect(peep, resource, true)

	Equipment.onEquip(self, peep)
end

return GhostBindersRing
