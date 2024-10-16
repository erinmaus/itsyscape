--------------------------------------------------------------------------------
-- Resources/Peeps/HighChambersYendor/SkeletonWarrior.lua
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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local SkeletonWarrior = Class(BaseSkeleton)

function SkeletonWarrior:new(resource, name, ...)
	BaseSkeleton.new(self, resource, name or 'SkeletonWarrior', ...)

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = 8
end

function SkeletonWarrior:ready(director, game)
	BaseSkeleton.ready(self, director, game)
end

return SkeletonWarrior
