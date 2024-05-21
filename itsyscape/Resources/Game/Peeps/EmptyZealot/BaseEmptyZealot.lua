--------------------------------------------------------------------------------
-- Resources/Peeps/EmptyZealot/BaseEmptyZealot.lua
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

local BaseEmptyZealot = Class(Player)

function BaseEmptyZealot:new(resource, name, ...)
	Player.new(self, resource, name or 'BaseEmptyZealot', ...)
end

function BaseEmptyZealot:ready(director, game)
	Player.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_BASE,
		"AncientCeremonial/Helmet.lua")
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		math.huge,
		"PlayerKit1/Eyes/Eyes.lua",
		{ Player.Palette.HAIR_PURPLE, Player.Palette.EYE_WHITE, Player.Palette.EYE_BLACK })
	self:applySkin(
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"AncientCeremonial/Body.lua")
	self:applySkin(
		Equipment.PLAYER_SLOT_HANDS,
		Equipment.SKIN_PRIORITY_BASE,
		"AncientCeremonial/Gloves.lua")
	self:applySkin(
		Equipment.PLAYER_SLOT_FEET,
		Equipment.SKIN_PRIORITY_BASE,
		"AncientCeremonial/Boots.lua")
end

return BaseEmptyZealot
