--------------------------------------------------------------------------------
-- Resources/Game/Peeps/ViziersRock/SerCommander.lua
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

local SerCommander = Class(Player)

function SerCommander:new(resource, name, ...)
	Player.new(self, resource, name or 'ViziersRockSerCommander', ...)

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = math.huge
end

function SerCommander:ready(director, game)
	Player.ready(self, director, game)

	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Head/Humanlike.lua",
		{ skinColor })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_ACCENT,
		"PlayerKit2/Hair/Messy1.lua",
		{ Player.Palette.HAIR_BLONDE })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		math.huge,
		"PlayerKit2/Eyes/Eyes.lua",
		{ Player.Palette.HAIR_BLONDE, Player.Palette.EYE_WHITE, Player.Palette.EYE_BLACK })
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

return SerCommander
