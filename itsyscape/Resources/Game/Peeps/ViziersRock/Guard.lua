--------------------------------------------------------------------------------
-- Resources/Game/Peeps/ViziersRock/Guard.lua
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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local Guard = Class(Player)

Guard.SKIN_COLORS = {
	Player.Palette.SKIN_LIGHT,
	Player.Palette.SKIN_MEDIUM,
	Player.Palette.SKIN_DARK,
	Player.Palette.SKIN_PLASTIC
}

Guard.HAIR_COLORS = {
	Player.Palette.HAIR_BROWN,
	Player.Palette.HAIR_BLACK,
	Player.Palette.HAIR_GREY,
	Player.Palette.HAIR_BLONDE
}

Guard.SHIRT_COLORS = {
	Player.Palette.PRIMARY_RED,
	Player.Palette.PRIMARY_GREEN,
	Player.Palette.PRIMARY_BLUE,
	Player.Palette.PRIMARY_YELLOW
}

Guard.HAIR_SKINS = {
	"PlayerKit2/Hair/Afro.lua",
	"PlayerKit2/Hair/Enby.lua",
	"PlayerKit2/Hair/Emo.lua",
	"PlayerKit2/Hair/Fade.lua",
	"PlayerKit2/Hair/Messy1.lua",
	"PlayerKit2/Hair/Pixie.lua"
}

function Guard:new(resource, name, ...)
	Player.new(self, resource, name or 'ViziersRockGuard', ...)

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = math.huge
end

function Guard:ready(director, game)
	Player.ready(self, director, game)

	local skinColor = Guard.SKIN_COLORS[love.math.random(#Guard.SKIN_COLORS)]
	local hairColor = Guard.HAIR_COLORS[love.math.random(#Guard.HAIR_COLORS)]
	local shirtColor = Guard.SHIRT_COLORS[love.math.random(#Guard.SHIRT_COLORS)]

	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Head/Humanlike.lua",
		{ skinColor })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_ACCENT,
		Guard.HAIR_SKINS[love.math.random(#Guard.HAIR_SKINS)],
		{ hairColor })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		math.huge,
		"PlayerKit2/Eyes/Eyes.lua",
		{ hairColor, Player.Palette.EYE_WHITE, Player.Palette.EYE_BLACK })
	self:applySkin(
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shirts/Plaid.lua",
		{ shirtColor, Player.Palette.PRIMARY_BROWN, Player.Palette.PRIMARY_GREY, Player.Palette.PRIMARY_BLACK, Player.Palette.PRIMARY_GREY })
	self:applySkin(
		Equipment.PLAYER_SLOT_HANDS,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Hands/Humanlike.lua",
		{ skinColor })
	self:applySkin(
		Equipment.PLAYER_SLOT_FEET,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shoes/Boots2.lua",
		{ Player.Palette.PRIMARY_BLACK })

end

return Guard
