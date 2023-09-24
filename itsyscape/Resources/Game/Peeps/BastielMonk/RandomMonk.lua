--------------------------------------------------------------------------------
-- Resources/Peeps/BastielMonk/RandomMonk.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local RandomMonk = Class(Player)

local SKIN = {
	"Light",
	"Medium",
	"Dark",
	"Minifig",
	"Zombi"
}

function RandomMonk:new(resource, name, ...)
	Player.new(self, resource, name or 'RandomMonk', ...)
end

function RandomMonk:ready(director, game)
	Player.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	if not actor then
		return
	end

	local skin = SKIN[love.math.random(#SKIN)]

	local head = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		string.format("Resources/Game/Skins/PlayerKit1/Head/%s.lua", skin))
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_BASE, head)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shirts/MonkRobe.lua")
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
end

return RandomMonk
