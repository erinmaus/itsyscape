--------------------------------------------------------------------------------
-- Resources/Peeps/HighChambersYendor/WizardSkeleton.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Peep = require "ItsyScape.Peep.Peep"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local InfiniteInventoryStateProvider = require "ItsyScape.Game.InfiniteInventoryStateProvider"
local BaseSkeleton = require "Resources.Game.Peeps.Skeleton.BaseSkeleton"
local ActiveSpellBehavior = require "ItsyScape.Peep.Behaviors.ActiveSpellBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local WizardSkeleton = Class(BaseSkeleton)

function WizardSkeleton:new(resource, name, ...)
	BaseSkeleton.new(self, resource, name or 'SkeletonMage', ...)

	self:addBehavior(StanceBehavior)

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = 12
end

function WizardSkeleton:ready(director, game)
	local runes = InfiniteInventoryStateProvider(self)
	runes:add("AirRune")
	runes:add("EarthRune")
	runes:add("WaterRune")
	runes:add("FireRune")

	self:getState():addProvider("Item", runes)

	local stance = self:getBehavior(StanceBehavior)
	stance.stance = Weapon.STANCE_AGGRESSIVE
	stance.useSpell = true

	local spell = self:getBehavior(ActiveSpellBehavior)
	spell.spell = Utility.Magic.newSpell("FireStrike", game)

	BaseSkeleton.ready(self, director, game)
end

return WizardSkeleton
