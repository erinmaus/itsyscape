--------------------------------------------------------------------------------
-- Resources/Peeps/Isabelle/KursedIsabelle.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Player = require "ItsyScape.Peep.Peeps.Player"
local ImmortalBehavior = require "ItsyScape.Peep.Behaviors.ImmortalBehavior"

local KursedIsabelle = Class(Player)

function KursedIsabelle:new(resource, name, ...)
	Player.new(self, resource, name or 'KursedIsabelle', ...)
end

function KursedIsabelle:ready(director, game)
	Player.ready(self, director, game)

	self:addBehavior(ImmortalBehavior)

	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_BASE,
		"KursedIsabelle/Head.lua")
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_ACCENT,
		"KursedIsabelle/Hair.lua")
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		math.huge,
		"PlayerKit2/Eyes/SnakeEyes.lua",
		{ Player.Palette.HAIR_BLACK, Player.Palette.PRIMARY_ORANGE, Player.Palette.EYE_BLACK })
	self:applySkin(
		Equipment.PLAYER_SLOT_NECK,
		Equipment.SKIN_PRIORITY_ACCENT,
		"Amulets/AmuletOfYendor.lua")
end

return KursedIsabelle
