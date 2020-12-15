--------------------------------------------------------------------------------
-- Resources/Game/Items/GanymedesBow/Logic.lua
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
local Bow = require "Resources.Game.Items.Common.Bow"

local GanymedesBow = Class(Bow)

function GanymedesBow:getAttackRange()
	return 16
end

function GanymedesBow:getCooldown()
	return 3
end

function GanymedesBow:onEquip(peep)
	local gameDB = peep:getDirector():getGameDB()
	local resource = gameDB:getResource("GanymedesStunningStrike", "Effect")
	Utility.Peep.applyEffect(peep, resource, true)

	Equipment.onEquip(self, peep)
end

return GanymedesBow
