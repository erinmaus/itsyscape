--------------------------------------------------------------------------------
-- Resources/Peeps/HighChambersYendor/SkeletonArcher.lua
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

local SkeletonArcher = Class(BaseSkeleton)

function SkeletonArcher:new(resource, name, ...)
	BaseSkeleton.new(self, resource, name or 'SkeletonArcher', ...)

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = 12
end

function SkeletonArcher:ready(director, game)
	BaseSkeleton.ready(self, director, game)
end

return SkeletonArcher
