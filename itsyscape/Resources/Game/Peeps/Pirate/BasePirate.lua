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
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"

local BasePirate = Class(Player)

local SKIN = {
	"Light",
	"Medium",
	"Dark",
	"Minifig",
	"Zombi"
}

function BasePirate:new(resource, name, ...)
	Player.new(self, resource, name or 'Pirate', ...)
end

function BasePirate:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local skin = SKIN[math.random(#SKIN)]

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Human.lskel")
	actor:setBody(body)

	local head = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		string.format("Resources/Game/Skins/PlayerKit1/Head/%s.lua", skin))
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_BASE, head)
	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shirts/PirateVest.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)
	local eyes
	if skin == "Zombi" then
		eyes = CacheRef(
			"ItsyScape.Game.Skin.ModelSkin",
			"Resources/Game/Skins/PlayerKit1/Eyes/WhiteEyes_Green.lua")
	else
		eyes = CacheRef(
			"ItsyScape.Game.Skin.ModelSkin",
			"Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Brown.lua")
	end
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, math.huge, eyes)
	local hands = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		string.format("Resources/Game/Skins/PlayerKit1/Hands/%s.lua", skin))
	actor:setSkin(Equipment.PLAYER_SLOT_HANDS, Equipment.SKIN_PRIORITY_BASE, hands)
	local feet = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shoes/LongBoots1.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_FEET, Equipment.SKIN_PRIORITY_BASE, feet)

	Player.ready(self, director, game)
end

return BasePirate
