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
	Player.ready(self, director, game)

	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_BASE,
		"Skeleton/Head.lua",
		{ Player.Palette.BONE_ANCIENT })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		math.huge,
		"PlayerKit2/Eyes/Holes.lua",
		{ Player.Palette.EYE_BLACK })
	self:applySkin(
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"Skeleton/Body.lua",
		{ Player.Palette.BONE_ANCIENT })
	self:applySkin(
		Equipment.PLAYER_SLOT_HANDS,
		Equipment.SKIN_PRIORITY_BASE,
		"Skeleton/Hands.lua",
		{ Player.Palette.BONE_ANCIENT })
	self:applySkin(
		Equipment.PLAYER_SLOT_FEET,
		Equipment.SKIN_PRIORITY_BASE,
		"Skeleton/Feet.lua",
		{ Player.Palette.BONE_ANCIENT })
end

return AncientSkeleton
