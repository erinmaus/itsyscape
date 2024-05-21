--------------------------------------------------------------------------------
-- Resources/Peeps/Rumbridge/ChefAllon.lua
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

local ChefAllon = Class(Player)

function ChefAllon:new(resource, name, ...)
	Player.new(self, resource, name or 'ChefAllon', ...)

	self:addPoke('acceptQuest')
end

function ChefAllon:ready(director, game)
	Player.ready(self, director, game)

	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Head/Humanlike.lua",
		{ Player.Palette.SKIN_MEDIUM })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_ACCENT,
		"PlayerKit2/Hair/Messy1.lua",
		{ Player.Palette.HAIR_BLACK })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		math.huge,
		"PlayerKit2/Eyes/Eyes.lua",
		{ Player.Palette.HAIR_BLACK, Player.Palette.EYE_WHITE, Player.Palette.EYE_BLACK })
	self:applySkin(
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shirts/Chef.lua",
		{ Player.Palette.PRIMARY_WHITE:setHSL(nil, 0, nil) })
	self:applySkin(
		Equipment.PLAYER_SLOT_HANDS,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Hands/Gloves.lua",
		{ Player.Palette.PRIMARY_WHITE:setHSL(nil, 0, nil) })
	self:applySkin(
		Equipment.PLAYER_SLOT_FEET,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shoes/Boots1.lua",
		{ Player.Palette.PRIMARY_BLACK })
end

return ChefAllon
