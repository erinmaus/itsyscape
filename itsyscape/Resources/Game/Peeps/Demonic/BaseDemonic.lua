--------------------------------------------------------------------------------
-- Resources/Peeps/Demonic/BaseDemonic.lua
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

local BaseDemonic = Class(Player)

function BaseDemonic:new(resource, name, ...)
	Player.new(self, resource, name or 'Demonic', ...)
end

function BaseDemonic:ready(director, game)
	Player.ready(self, director, game)

	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Head/SnakeLike.lua",
		{ Player.Palette.PRIMARY_RED })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_ACCENT,
		"PlayerKit2/Hair/Horns.lua",
		{ Player.Palette.PRIMARY_BLACK })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		math.huge,
		"PlayerKit2/Eyes/SnakeEyes.lua",
		{ Player.Palette.HAIR_BLACK, Player.Palette.EYE_WHITE, Player.Palette.EYE_BLACK })
	self:applySkin(
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shirts/XUtilityBelt.lua",
		{ Player.Palette.PRIMARY_RED:setHSL(nil, 0.4, 0.2) })
	self:applySkin(
		Equipment.PLAYER_SLOT_HANDS,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Hands/SnakeLike.lua",
		{ Player.Palette.PRIMARY_RED })

end

return BaseDemonic
