--------------------------------------------------------------------------------
-- Resources/Peeps/Sailors/PanickedSailor.lua
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

local Sailor = Class(Player)

function Sailor:new(resource, name, ...)
	Player.new(self, resource, name or 'PanickedSailor', ...)
end

local SKIN_COLORS = {
	Player.Palette.SKIN_LIGHT,
	Player.Palette.SKIN_MEDIUM,
	Player.Palette.SKIN_DARK,
	Player.Palette.SKIN_PLASTIC
}

local HAIR_COLORS = {
	Player.Palette.HAIR_BROWN,
	Player.Palette.HAIR_BLACK,
	Player.Palette.HAIR_GREY,
	Player.Palette.HAIR_BLONDE
}

local HAIR_SKINS = {
	"PlayerKit2/Hair/Afro.lua",
	"PlayerKit2/Hair/Enby.lua",
	"PlayerKit2/Hair/Emo.lua",
	"PlayerKit2/Hair/Fade.lua",
	"PlayerKit2/Hair/Pixie.lua",
	"PlayerKit2/Hair/Messy1.lua",
	"PlayerKit1/Hair/Bald.lua"
}

local HIT_MESSAGES = {
	"We've been hit!",
	"Aaaaaah!",
	"Nooooooo!",
	"We're all gonna die!"
}

function Sailor:ready(director, game)
	Player.ready(self, director, game)

	local skinColor = SKIN_COLORS[love.math.random(#SKIN_COLORS)]
	local hairColor = HAIR_COLORS[love.math.random(#HAIR_COLORS)]
	local hair = HAIR_SKINS[love.math.random(#HAIR_SKINS)]

	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Head/Humanlike.lua",
		{ skinColor })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_ACCENT,
		hair,
		{ hairColor })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		math.huge,
		"PlayerKit2/Eyes/Eyes.lua",
		{ hairColor, Player.Palette.EYE_WHITE, Player.Palette.EYE_BLACK })
	self:applySkin(
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shirts/Plain.lua",
		{ Player.Palette.PRIMARY_WHITE, Player.Palette.PRIMARY_BROWN, Player.Palette.PRIMARY_GREY })
	self:applySkin(
		Equipment.PLAYER_SLOT_HANDS,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Hands/Humanlike.lua",
		{ skinColor })
	self:applySkin(
		Equipment.PLAYER_SLOT_FEET,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shoes/Boots3.lua",
		{ Player.Palette.PRIMARY_BLUE })

	local runAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Run_Crazy_1/Script.lua")
	self:addResource("animation-walk", runAnimation)

	local map = Utility.Peep.getMapScript(self)
	if map then
		map:listen('hit', function(_, p)
			local health = self:getBehavior(CombatStatusBehavior)
			if health and health.currentHitpoints == 0 then
				return
			end

			if p:getDamageType() ~= 'leak' then
				self.hasPendingMessage = true
			end
		end)
	end
end

function Sailor:onDie()
	local health = self:getBehavior(CombatStatusBehavior)
	if health then
		local mapScript = Utility.Peep.getMapScript(self)
		if mapScript then
			mapScript:poke('hit', AttackPoke({
				damage = health.maximumHitpoints * 2,
				aggressor = self
			}))
		end
	end
end

function Sailor:update(...)
	Player.update(self, ...)

	if self.hasPendingMessage then
		local message = HIT_MESSAGES[love.math.random(#HIT_MESSAGES)]
		local actor = self:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor
		if actor then
			actor:flash('Message', 1, message)
		end

		self.hasPendingMessage = false
	end
end

return Sailor
