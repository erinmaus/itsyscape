--------------------------------------------------------------------------------
-- Resources/Peeps/Human/RandomHuman.lua
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

local RandomHuman = Class(Player)

local SKIN_COLORS = {
	Player.Palette.SKIN_LIGHT,
	Player.Palette.SKIN_MEDIUM,
	Player.Palette.SKIN_DARK,
	Player.Palette.SKIN_PLASTIC
}

local HAIR_COLORS = {
	Player.Palette.HAIR_BROWN,
	Player.Palette.HAIR_BLACK,
	Player.Palette.HAIR_GREY,
	Player.Palette.HAIR_BLONDE
}

local SHIRT_COLORS = {
	Player.Palette.PRIMARY_RED,
	Player.Palette.PRIMARY_GREEN,
	Player.Palette.PRIMARY_BLUE,
	Player.Palette.PRIMARY_YELLOW,
	Player.Palette.PRIMARY_PURPLE,
	Player.Palette.PRIMARY_BROWN,
	Player.Palette.PRIMARY_WHITE,
	Player.Palette.PRIMARY_GREY,
	Player.Palette.PRIMARY_BLACK
}

local SHOE_COLORS = {
	Player.Palette.PRIMARY_BROWN,
	Player.Palette.PRIMARY_BLACK
}

local SHIRT_SKINS = {
	"PlayerKit2/Shirts/Plain.lua",
	"PlayerKit2/Shirts/Dress.lua"
}

local SHOE_SKINS = {
	"PlayerKit2/Shoes/Boots1.lua",
	"PlayerKit2/Shoes/Boots2.lua",
	"PlayerKit2/Shoes/Boots3.lua",
	"PlayerKit2/Shoes/LongBoots1.lua"
}

local HAIR_SKINS = {
	"PlayerKit2/Hair/Afro.lua",
	"PlayerKit2/Hair/Enby.lua",
	"PlayerKit2/Hair/Emo.lua",
	"PlayerKit2/Hair/Fade.lua",
	"PlayerKit2/Hair/Pixie.lua",
	"PlayerKit2/Hair/Messy1.lua"
}

function RandomHuman:new(resource, name, ...)
	Player.new(self, resource, name or 'Person', ...)
end

function RandomHuman:ready(director, game)
	Player.ready(self, director, game)

	local skinColor = SKIN_COLORS[love.math.random(#SKIN_COLORS)]
	local hairColor = HAIR_COLORS[love.math.random(#HAIR_COLORS)]
	local shoeColor = SHOE_COLORS[love.math.random(#SHOE_COLORS)]
	local shirtColor = SHIRT_COLORS[love.math.random(#SHIRT_COLORS)]

	local shirt = SHIRT_SKINS[love.math.random(#SHIRT_SKINS)]
	local shoe = SHOE_SKINS[love.math.random(#SHOE_SKINS)]
	local hair = HAIR_SKINS[love.math.random(#HAIR_SKINS)]

	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Head/Humanlike.lua",
		{ skinColor })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_ACCENT,
		hair,
		{ hairColor })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		math.huge,
		"PlayerKit2/Eyes/Eyes.lua",
		{ hairColor, Player.Palette.EYE_WHITE, Player.Palette.EYE_BLACK })
	self:applySkin(
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		shirt,
		{ shirtColor, Player.Palette.PRIMARY_BROWN, Player.Palette.PRIMARY_GREY })
	self:applySkin(
		Equipment.PLAYER_SLOT_HANDS,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Hands/Humanlike.lua",
		{ skinColor })
end

return RandomHuman
