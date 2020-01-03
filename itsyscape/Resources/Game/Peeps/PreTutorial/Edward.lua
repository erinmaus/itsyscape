--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Pretutorial/Edward.lua
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
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"

local Edward = Class(Player)

function Edward:new(resource, name, ...)
	Player.new(self, resource, name or 'Edward', ...)
end

function Edward:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local movement = self:getBehavior(MovementBehavior)
	movement.stoppingForce = 0.5
	movement.maxSpeed = 8
	movement.maxAcceleration = 6

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Human.lskel")
	actor:setBody(body)

	local head = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Head/Ghost_Pink.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_BASE, head)
	local hair = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Hair/ZombiPunk_PinkGhost.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_ACCENT, hair)
	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shirts/Ghost_Pink.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)
	local eyes = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Eyes/WhiteEyes_Black.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, math.huge, eyes)
	local hands = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Hands/Ghost_Pink.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HANDS, Equipment.SKIN_PRIORITY_BASE, hands)

	Player.ready(self, director, game)
end

return Edward
