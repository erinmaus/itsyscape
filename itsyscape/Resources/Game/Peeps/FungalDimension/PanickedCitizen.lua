--------------------------------------------------------------------------------
-- Resources/Peeps/FungalDimension/PanickedCitizen.lua
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
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local Citizen = Class(Player)

function Citizen:new(resource, name, ...)
	Player.new(self, resource, name or 'PanickedCitizen', ...)
end

local HEADS = {
	"Resources/Game/Skins/PlayerKit1/Head/Light.lua",
	"Resources/Game/Skins/PlayerKit1/Head/Medium.lua",
	"Resources/Game/Skins/PlayerKit1/Head/Dark.lua",
	"Resources/Game/Skins/PlayerKit1/Head/Minifig.lua",
	fungal = "Resources/Game/Skins/PlayerKit1/Head/Fungal.lua",
}

local HAIRS = {
	"Resources/Game/Skins/PlayerKit1/Hair/Bald.lua",
	"Resources/Game/Skins/PlayerKit1/Hair/Enby.lua",
	"Resources/Game/Skins/PlayerKit1/Hair/Emo.lua",
	"Resources/Game/Skins/PlayerKit1/Hair/ForwardSpike.lua",
	fungal = "Resources/Game/Skins/PlayerKit1/Hair/FungalPunk.lua",
}

local BODY = {
	"Resources/Game/Skins/PlayerKit1/Shirts/Red.lua",
	"Resources/Game/Skins/PlayerKit1/Shirts/Green.lua",
	"Resources/Game/Skins/PlayerKit1/Shirts/Blue.lua",
	"Resources/Game/Skins/PlayerKit1/Shirts/Yellow.lua"
}

local HANDS = {
	fungal = "Resources/Game/Skins/PlayerKit1/Hands/Fungal.lua",
}

local EYES = {
	fungal = "Resources/Game/Skins/PlayerKit1/Eyes/WhiteEyes_Pink.lua",
}

local EFFECT = {
	fungal = "Resources/Game/Skins/PlayerKit1/Effects/Mush.lua",
}

function Citizen:ready(director, game)
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
		HEADS[math.random(#HEADS)])
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_BASE, head)
	local hair = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		HAIRS[math.random(#HAIRS)])
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_ACCENT, hair)
	local eyes = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Eyes/Eyes.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, math.huge, eyes)
	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		BODY[math.random(#BODY)])
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)
	local hands = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Hands/BlackGloves.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HANDS, Equipment.SKIN_PRIORITY_BASE, hands)
	local feet = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shoes/Boots1.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_FEET, Equipment.SKIN_PRIORITY_BASE, feet)

	local runAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Run_Crazy_1/Script.lua")
	self:addResource("animation-walk", runAnimation)
end

function Citizen:onRun()
	local _, _, layer = Utility.Peep.getTile(self)
	local map = self:getDirector():getMap(layer)

	if map then
		local foundTile = false
		repeat
			local i, j = math.random(map:getWidth()), math.random(map:getHeight())

			local tile = map:getTile(i, j)
			if not tile:hasFlag('impassable') then
				if Utility.Peep.walk(self, i, j, layer, 0) then
					foundTile = true
				end
			end
		until foundTile
	end
end

function Citizen:onFungify()
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local hands = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		HANDS.fungal)
	actor:setSkin(Equipment.PLAYER_SLOT_HANDS, Equipment.SKIN_PRIORITY_BASE, hands)
	local head = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		HEADS.fungal)
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_BASE, head)
	local hair = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		HAIRS.fungal)
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_ACCENT, hair)
	local eyes = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		EYES.fungal)
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, math.huge, eyes)
	local effect = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		EFFECT.fungal)
	actor:setSkin(Equipment.PLAYER_SLOT_EFFECT, Equipment.SKIN_PRIORITY_BASE, effect)
end

return Citizen
