--------------------------------------------------------------------------------
-- Resources/Peeps/Sailors/Elizabeth.lua
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

local Elizabeth = Class(Player)

function Elizabeth:new(resource, name, ...)
	Player.new(self, resource, name or 'Elizabeth', ...)
end

function Elizabeth:ready(director, game)
	Player.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	actor:setBody(
		CacheRef(
			"ItsyScape.Game.Body",
			"Resources/Game/Bodies/Human.lskel"))

	local head = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Head/Light.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_BASE, head)
	local hair = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Hair/DarkRedBraid.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_ACCENT, hair)
	local hat = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/SeafarerHat/SeafarerHat.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_EQUIPMENT, hat)
	local eyes = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Eyes/Eyes_DarkRed.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, math.huge, eyes)
	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shirts/PrestigiousSailorsDress.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)
	local hands = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Hands/SeaMedallionGloves.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HANDS, Equipment.SKIN_PRIORITY_BASE, hands)
	local feet = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shoes/Boots_Seafarer2.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_FEET, Equipment.SKIN_PRIORITY_BASE, feet)
end

function Elizabeth:onSoldResource(player, resource)
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

return Elizabeth
