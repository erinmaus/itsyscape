--------------------------------------------------------------------------------
-- Resources/Peeps/Trailer/Warrior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local InfiniteInventoryStateProvider = require "ItsyScape.Game.InfiniteInventoryStateProvider"
local Weapon = require "ItsyScape.Game.Weapon"
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActiveSpellBehavior = require "ItsyScape.Peep.Behaviors.ActiveSpellBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local Warrior = Class(Player)

function Warrior:new(resource, name, ...)
	Player.new(self, resource, name or 'Warrior', ...)

	self:addBehavior(StanceBehavior)

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = math.huge
	status.maxHitpoints = math.huge
	status.maxChaseDistance = math.huge
end

function Warrior:ready(director, game)
	local stance = self:getBehavior(StanceBehavior)
	stance.stance = Weapon.STANCE_AGGRESSIVE

	Player.ready(self, director, game)
end

return Warrior
