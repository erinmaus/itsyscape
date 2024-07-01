--------------------------------------------------------------------------------
-- Resources/Peeps/PortmasterJenkins/PortmasterJenkins.lua
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
local Utility = require "ItsyScape.Game.Utility"
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

local PortmasterJenkins = Class(Player)

function PortmasterJenkins:new(resource, name, ...)
	Player.new(self, resource, name or 'PortmasterJenkins', ...)
end

function PortmasterJenkins:ready(director, game)
	Player.ready(self, director, game)

	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Head/Humanlike.lua",
		{ Player.Palette.SKIN_MEDIUM })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_ACCENT,
		"PlayerKit2/Hair/SailorsBeard.lua",
		{ Player.Palette.HAIR_GREY })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		math.huge,
		"PlayerKit2/Eyes/Eyes.lua",
		{ Player.Palette.HAIR_GREY, Player.Palette.EYE_WHITE, Player.Palette.EYE_BLACK })
	self:applySkin(
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shirts/Plain.lua",
		{ Player.Palette.PRIMARY_WHITE, Player.Palette.PRIMARY_BLUE, Player.Palette.PRIMARY_YELLOW })
	self:applySkin(
		Equipment.PLAYER_SLOT_HANDS,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Hands/Gloves.lua",
		{ Player.Palette.PRIMARY_BLUE })
	self:applySkin(
		Equipment.PLAYER_SLOT_FEET,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shoes/Boots3.lua",
		{ Player.Palette.PRIMARY_BLUE })
end

function PortmasterJenkins:onSoldResource(player, resource)
	local selfResource = Utility.Peep.getResource(self)
	if selfResource.id.value ~= resource.id.value then
		Log.warn("%s unlocked %s? How?",
			selfResource.name,
			resource.name)
	end

	SailorsCommon.setActiveFirstMateResource(
		player,
		resource,
		false)
end

return PortmasterJenkins
