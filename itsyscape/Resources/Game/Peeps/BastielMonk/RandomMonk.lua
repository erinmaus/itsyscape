--------------------------------------------------------------------------------
-- Resources/Peeps/BastielMonk/RandomMonk.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local RandomMonk = Class(Player)

local SKIN = {
	Player.Palette.SKIN_LIGHT,
	Player.Palette.SKIN_MEDIUM,
	Player.Palette.SKIN_DARK,
	Player.Palette.SKIN_PLASTIC
}

local HAIR = {
	Player.Palette.HAIR_BROWN,
	Player.Palette.HAIR_BLACK,
	Player.Palette.HAIR_BLACK:setHSL(nil, nil, 0.7), -- Light grey
	Player.Palette.HAIR_RED,
	Player.Palette.HAIR_BLONDE
}

function RandomMonk:new(resource, name, ...)
	Player.new(self, resource, name or 'RandomMonk', ...)
end

function RandomMonk:ready(director, game)
	Player.ready(self, director, game)

	local skin = SKIN[love.math.random(#SKIN)]
	local hair = HAIR[love.math.random(#HAIR)]

	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Head/Humanlike.lua",
		{ skin })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		math.huge,
		"PlayerKit2/Eyes/Eyes.lua",
		{ hair, Player.Palette.EYE_WHITE, Player.Palette.EYE_BLACK })
	self:applySkin(
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shirts/Robe.lua",
		{ Player.Palette.PRIMARY_BROWN:setHSL(nil, 0.4, 0.6) })
	self:applySkin(
		Equipment.PLAYER_SLOT_HANDS,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Hands/Humanlike.lua",
		{ skin })
end

return RandomMonk
