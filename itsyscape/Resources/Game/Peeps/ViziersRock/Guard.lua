--------------------------------------------------------------------------------
-- Resources/Game/Peeps/ViziersRock/Guard.lua
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

local Guard = Class(Player)

Guard.SKIN = {
	"Light",
	"Medium",
	"Dark",
	"Minifig"
}

Guard.HAIR = {
	"Afro",
	"Enby",
	"Emo",
	"Fade",
	"Messy_Black",
	"Pixie"
}

Guard.SHIRT = {
	"RedPlaid",
	"BluePlaid",
	"GreenPlaid"
}

function Guard:new(resource, name, ...)
	Player.new(self, resource, name or 'ViziersRockGuard', ...)

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = math.huge
end

function Guard:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local skinName = Guard.SKIN[love.math.random(#Guard.SKIN)]
	local hairName = Guard.HAIR[love.math.random(#Guard.HAIR)]
	local shirtName = Guard.SHIRT[love.math.random(#Guard.SHIRT)]

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Human.lskel")
	actor:setBody(body)

	local head = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		string.format("Resources/Game/Skins/PlayerKit1/Head/%s.lua", skinName))
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_BASE, head)
	local eyes = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Eyes/Eyes.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, math.huge, eyes)
	local hair = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		string.format("Resources/Game/Skins/PlayerKit1/Hair/%s.lua", hairName))
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_ACCENT, hair)
	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		string.format("Resources/Game/Skins/PlayerKit1/Shirts/%s.lua", shirtName))
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)
	local hands = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		string.format("Resources/Game/Skins/PlayerKit1/Hands/%s.lua", skinName))
	actor:setSkin(Equipment.PLAYER_SLOT_HANDS, 0, hands)
	local feet = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shoes/Boots2.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_FEET, 0, feet)

	Player.ready(self, director, game)
end

return Guard
