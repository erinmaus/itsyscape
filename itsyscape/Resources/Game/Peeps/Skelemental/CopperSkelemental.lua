--------------------------------------------------------------------------------
-- Resources/Peeps/Skelemental/CopperSkelemental.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local BaseSkelemental = require "Resources.Game.Peeps.Skelemental.BaseSkelemental"

local CopperSkelemental = Class(BaseSkelemental)

function CopperSkelemental:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local head = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Skelemental/Copper.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, head)

	BaseSkelemental.ready(self, director, game)
end

return CopperSkelemental
