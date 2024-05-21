--------------------------------------------------------------------------------
-- Resources/Peeps/ChestMimic/SkeletonAlice.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local CacheRef = require "ItsyScape.Game.CacheRef"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local BaseSkeleton = require "Resources.Game.Peeps.Skeleton.BaseSkeleton"

local SkeletonAlice = Class(BaseSkeleton)

function SkeletonAlice:new(resource, name, ...)
	BaseSkeleton.new(self, resource, name or 'SkeletonAlice', ...)
end

function SkeletonAlice:ready(director, game)
	BaseSkeleton.ready(self, director, game)

	self:applySkin(
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shirts/Dress.lua",
		{ Player.Palette.PRIMARY_BLUE })
end

return SkeletonAlice
