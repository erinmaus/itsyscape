--------------------------------------------------------------------------------
-- Resources/Peeps/Yenderling/BaseYenderling.lua
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
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

local BaseYenderling = Class(Creep)

function BaseYenderling:new(resource, name, ...)
	Creep.new(self, resource, name or 'Yenderling', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(3.5, 3.5, 3.5)

	self:addBehavior(RotationBehavior)
end

function BaseYenderling:ready(director, game)
	Creep.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	if not actor then
		return
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Yenderling.lskel")
	actor:setBody(body)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Yenderling/Yenderling.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)

	local shield = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Yenderling/Yenderling_Shield.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_RIGHT_HAND, Equipment.SKIN_PRIORITY_BASE, shield)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Yenderling_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	actor:playAnimation("idle", 0, idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Yenderling_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Yenderling_Attack/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	local defendAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Yenderling_Defend/Script.lua")
	self:addResource("animation-defend", defendAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Yenderling_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	local _, stance = self:addBehavior(StanceBehavior)
	stance.stance = Weapon.STANCE_DEFENSIVE

	Utility.Peep.equipXWeapon(self, "Yenderling_Slap")
end

function BaseYenderling:update(...)
	Creep.update(self, ...)

	Utility.Peep.face3D(self)
end

return BaseYenderling
