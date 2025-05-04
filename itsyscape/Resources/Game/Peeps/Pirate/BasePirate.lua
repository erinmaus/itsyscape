--------------------------------------------------------------------------------
-- Resources/Peeps/Pirate/BasePirate.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Peep = require "ItsyScape.Peep.Peep"
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"

local BasePirate = Class(Player)

local SKIN_COLOR = {
	Player.Palette.SKIN_LIGHT,
	Player.Palette.SKIN_MEDIUM,
	Player.Palette.SKIN_DARK,
	Player.Palette.SKIN_PLASTIC,
	Player.Palette.SKIN_ZOMBI
}

local HAIR_COLOR = {
	Player.Palette.HAIR_BROWN,
	Player.Palette.HAIR_BLACK,
	Player.Palette.HAIR_BLONDE
}

local HAIR_SKINS = {
	"PlayerKit2/Hair/Afro.lua",
	"PlayerKit2/Hair/Enby.lua",
	"PlayerKit2/Hair/Emo.lua",
	"PlayerKit2/Hair/Fade.lua",
	"PlayerKit2/Hair/Pixie.lua",
	"PlayerKit2/Hair/Messy1.lua",
	"PlayerKit1/Hair/Bald.lua"
}

function BasePirate:new(resource, name, ...)
	Player.new(self, resource, name or 'Pirate', ...)

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = 16
end

function BasePirate:ready(director, game)
	Player.ready(self, director, game)

	local skinColor = SKIN_COLOR[love.math.random(#SKIN_COLOR)]
	local hairColor = HAIR_COLOR[love.math.random(#HAIR_COLOR)]
	local hairSkin = HAIR_SKINS[love.math.random(#HAIR_SKINS)]

	if skinColor == Player.Palette.SKIN_ZOMBI then
		self:applySkin(
			Equipment.PLAYER_SLOT_HEAD,
			Equipment.SKIN_PRIORITY_BASE,
			"PlayerKit2/Head/Zombi.lua",
			{ skinColor, Player.Palette.ACCENT_GREEN })
		self:applySkin(
			Equipment.PLAYER_SLOT_HEAD,
			math.huge,
			"PlayerKit2/Eyes/Eyes.lua",
			{ hairColor, Player.Palette.EYE_BLACK, Player.Palette.EYE_WHITE })
	else
		self:applySkin(
			Equipment.PLAYER_SLOT_HEAD,
			Equipment.SKIN_PRIORITY_BASE,
			"PlayerKit2/Head/Humanlike.lua",
			{ skinColor })
		self:applySkin(
			Equipment.PLAYER_SLOT_HEAD,
			math.huge,
			"PlayerKit2/Eyes/Eyes.lua",
			{ hairColor, Player.Palette.EYE_WHITE, Player.Palette.EYE_BLACK })
		self:applySkin(
			Equipment.PLAYER_SLOT_HEAD,
			Equipment.SKIN_PRIORITY_ACCENT,
			hairSkin,
			{ hairColor })
	end

	self:applySkin(
		Equipment.PLAYER_SLOT_HANDS,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Hands/Humanlike.lua",
		{ skinColor })

	self:applySkin(
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shirts/PirateVest.lua",
		{ Player.Palette.PRIMARY_WHITE, Player.Palette.PRIMARY_BROWN:setHSL(nil, 0.2, nil), Player.Palette.PRIMARY_GREY })

	self:applySkin(
		Equipment.PLAYER_SLOT_FEET,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shoes/LongBoots1.lua",
		{ Player.Palette.PRIMARY_BLACK })
end

return BasePirate
