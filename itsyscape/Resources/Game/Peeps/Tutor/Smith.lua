--------------------------------------------------------------------------------
-- Resources/Peeps/Tutors/Smith.lua
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

local Smith = Class(Player)

function Smith:new(resource, name, ...)
	Player.new(self, resource, name or 'Smith', ...)
end

function Smith:ready(director, game)
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
		"Resources/Game/Skins/PlayerKit1/Head/Medium.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_BASE, head)
	local hair = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Hair/Afro.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_ACCENT, hair)
	local eyes = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Grey.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, math.huge, eyes)
	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shirts/PaleBrown.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)
	local hands = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Hands/BlackGloves.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HANDS, Equipment.SKIN_PRIORITY_BASE, hands)
	local boots = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shoes/Boots2.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_FEET, Equipment.SKIN_PRIORITY_BASE, boots)
end

return Smith
