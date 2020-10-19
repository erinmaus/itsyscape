--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Drakkenson/BaseDrakkenson.lua
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
local FlyingBehavior = require "ItsyScape.Peep.Behaviors.FlyingBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local BaseDrakkenson = Class(Creep)
BaseDrakkenson.FLYING_RANGE     = 2
BaseDrakkenson.FLYING_ELEVATION = 4

BaseDrakkenson.ANIMATION_PRIORITY = 100

BaseDrakkenson.ANIMATION_WINGS_FLAP = 'Flap'
BaseDrakkenson.ANIMATION_WINGS_IDLE = 'Idle'
BaseDrakkenson.ANIMATION_TAIL_IDLE  = 'Idle'

function BaseDrakkenson:new(resource, name, ...)
	Creep.new(self, resource, name or 'Drakkenson_Base', ...)

	self:addBehavior(RotationBehavior)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1.5, 8, 1.5)
end

function BaseDrakkenson:playWingAnimation(name)
	local filename = string.format(
		"Resources/Game/Animations/Drakkenson_Wings_%s/Script.lua",
		name)
	local animation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		filename)

	local actor = self:getBehavior(ActorReferenceBehavior).actor
	actor:playAnimation(
		'drakkenson-wings',
		BaseDrakkenson.ANIMATION_PRIORITY,
		animation,
		true)
end

function BaseDrakkenson:playTailAnimation(name)
	local filename = string.format(
		"Resources/Game/Animations/Drakkenson_Tail_%s/Script.lua",
		name)
	local animation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		filename)

	local actor = self:getBehavior(ActorReferenceBehavior).actor
	actor:playAnimation(
		'drakkenson-tail',
		BaseDrakkenson.ANIMATION_PRIORITY,
		animation,
		true)
end

function BaseDrakkenson:isFlying()
	return self:hasBehavior(FlyingBehavior)
end

function BaseDrakkenson:onStartFlying()
	if not self:isFlying() then
		local _, flying = self:addBehavior(FlyingBehavior)
		flying.range = self.FLYING_RANGE
		flying.elevation = self.FLYING_ELEVATION

		self:playWingAnimation(BaseDrakkenson.ANIMATION_WINGS_FLAP)
	end
end

function BaseDrakkenson:onStopFlying()
	if self:isFlying() then
		local _, flying = self:addBehavior(FlyingBehavior)
		flying.range = self.FLYING_RANGE
		flying.elevation = self.FLYING_ELEVATION

		self:playWingAnimation(BaseDrakkenson.ANIMATION_WINGS_IDLE)
	end
end

function BaseDrakkenson:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Drakkenson.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Drakkenson_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	-- local walkAnimation = CacheRef(
	-- 	"ItsyScape.Graphics.AnimationResource",
	-- 	"Resources/Game/Animations/Drakkenson_Walk/Script.lua")
	-- self:addResource("animation-walk", walkAnimation)

	-- local dieAnimation = CacheRef(
	-- 	"ItsyScape.Graphics.AnimationResource",
	-- 	"Resources/Game/Animations/Drakkenson_Die/Script.lua")
	-- self:addResource("animation-die", dieAnimation)

	-- local attackAnimation = CacheRef(
	-- 	"ItsyScape.Graphics.AnimationResource",
	-- 	"Resources/Game/Animations/Drakkenson_Attack/Script.lua")
	-- self:addResource("animation-attack", attackAnimation)

	local extremities = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Drakkenson/Extremities.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_SELF, Equipment.SKIN_PRIORITY_BASE, extremities)

	local wings = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Drakkenson/Wings.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BACK, Equipment.SKIN_PRIORITY_BASE, wings)

	local tail = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Drakkenson/Tail.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_LEGS, Equipment.SKIN_PRIORITY_BASE, tail)

	self:playWingAnimation(BaseDrakkenson.ANIMATION_WINGS_IDLE)
	self:playTailAnimation(BaseDrakkenson.ANIMATION_TAIL_IDLE)

	Creep.ready(self, director, game)
end

function BaseDrakkenson:update(...)
	Creep.update(self, ...)
	Utility.Peep.face3D(self)
end

return BaseDrakkenson
