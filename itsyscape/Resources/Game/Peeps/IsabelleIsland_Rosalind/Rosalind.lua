--------------------------------------------------------------------------------
-- Resources/Peeps/IsabelleIsland_Rosalind/Rosalind.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Color = require "ItsyScape.Graphics.Color"
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local Rosalind = Class(Player)

function Rosalind:new(resource, name, ...)
	Player.new(self, resource, name or 'Rosalind', ...)

	local _, status = self:addBehavior(CombatStatusBehavior)
	status.maxChaseDistance = math.huge
end

function Rosalind:ready(director, game)
	Player.ready(self, director, game)

	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Head/Humanlike.lua",
		{ Player.Palette.SKIN_MEDIUM })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_ACCENT,
		"PlayerKit2/Hair/ZombiPunk.lua",
		{ Player.Palette.HAIR_GREEN })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		math.huge,
		"PlayerKit2/Eyes/Eyes.lua",
		{ Player.Palette.HAIR_GREEN, Player.Palette.EYE_WHITE, Player.Palette.EYE_BLACK })
	self:applySkin(
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shirts/WinterTunic.lua",
		{
			Color.fromHexString("4f6666"),
			Color.fromHexString("aabcbe"),
			Color.fromHexString("787051")
		})
	self:applySkin(
		Equipment.PLAYER_SLOT_HANDS,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Hands/Gloves.lua",
		{ Player.Palette.PRIMARY_BLACK })
	self:applySkin(
		Equipment.PLAYER_SLOT_FEET,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shoes/Boots1.lua",
		{ Player.Palette.PRIMARY_BLACK })
end

return Rosalind
