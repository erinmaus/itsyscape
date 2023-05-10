--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Rat/SkeletalRat.lua
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
local BaseRat = require "Resources.Game.Peeps.Rat.BaseRat"

local SkeletalRat = Class(BaseRat)

function SkeletalRat:new(resource, name, ...)
	BaseRat.new(self, resource, name or 'SkeletalRat', ...)
end

function SkeletalRat:ready(director, game)
	BaseRat.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Rat/SkeletalRat.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)
end

return SkeletalRat
