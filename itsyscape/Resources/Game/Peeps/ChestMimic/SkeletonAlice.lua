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

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shirts/PinkDress.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)
end

return SkeletonAlice
