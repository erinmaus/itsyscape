--------------------------------------------------------------------------------
-- Resources/Peeps/AncientSkeleton/AncientSkeleton.lua
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
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

local AncientSkeleton = Class(Player)

function AncientSkeleton:new(resource, name, ...)
	Player.new(self, resource, name or 'AncientSkeleton', ...)
end

function AncientSkeleton:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Human.lskel")
	actor:setBody(body)

	local head = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/AncientSkeleton/Head.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, 0, head)
	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/AncientSkeleton/Body.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)
	local hands = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/AncientSkeleton/Hands.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HANDS, 0, hands)
	local feet = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/AncientSkeleton/Feet.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_FEET, 0, feet)

	Player.ready(self, director, game)
end

return AncientSkeleton
