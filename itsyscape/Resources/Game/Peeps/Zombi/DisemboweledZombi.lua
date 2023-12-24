--------------------------------------------------------------------------------
-- Resources/Peeps/Zombi/DisemboweledZombi.lua
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
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local DisemboweledZombi = Class(Creep)

DisemboweledZombi.TYPES = 2
DisemboweledZombi.SIZES = {
	Vector(4.5, 1.5, 1.5),
	Vector(1.5, 5.5, 1.5)
}

function DisemboweledZombi:new(resource, name, ...)
	Creep.new(self, resource, name or 'DisemboweledZombi', ...)
end

function DisemboweledZombi:ready(director, game)
	Creep.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	if not actor then
		return
	end

	actor:setBody(
		CacheRef(
			"ItsyScape.Game.Body",
			"Resources/Game/Bodies/Human_Disemboweled.lskel"))

	local headSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/DisemboweledZombi/Head.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_BASE, headSkin)

	local eyesSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/DisemboweledZombi/Eyes.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, math.huge, eyesSkin)

	local bodySkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/DisemboweledZombi/Body.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, bodySkin)

	local handsSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/DisemboweledZombi/Hands.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HANDS, Equipment.SKIN_PRIORITY_BASE, handsSkin)

	local gutsSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/DisemboweledZombi/Guts.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_SELF, Equipment.SKIN_PRIORITY_BASE, gutsSkin)

	local bootsSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/DisemboweledZombi/Boots.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_FEET, Equipment.SKIN_PRIORITY_BASE, bootsSkin)

	local index = love.math.random(1, self.TYPES)

	local size = self:getBehavior(SizeBehavior)
	size.size = self.SIZES[index]

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		string.format("Resources/Game/Animations/Human_Idle_Disemboweled%d/Script.lua", index))
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		string.format("Resources/Game/Animations/Human_Walk_Disemboweled%d/Script.lua", index))
	self:addResource("animation-walk", walkAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		string.format("Resources/Game/Animations/Human_Die_Disemboweled%d/Script.lua", index))
	self:addResource("animation-die", dieAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		string.format("Resources/Game/Animations/Human_Attack_Disemboweled%d/Script.lua", index))
	self:addResource("animation-attack", attackAnimation)

	Utility.Peep.equipXWeapon(self, "DisemboweledSmash")
end

return DisemboweledZombi
