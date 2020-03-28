--------------------------------------------------------------------------------
-- Resources/Peeps/Sailors/Nyan.lua
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
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

local Nyan = Class(Creep)
Nyan.SIT = 2

function Nyan:new(resource, name, ...)
	Creep.new(self, resource, name or 'Nyan', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2.5, 2, 1)
	size.pan = Vector(-1, 1, 0)
	size.zoom = 2

	self.isSitting = false
	self.sittingDuration = 0
end

function Nyan:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Dog.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Dog_IdleStand/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local idleStandAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Dog_IdleStand/Script.lua")
	self:addResource("animation-idle-stand", idleStandAnimation)

	local idleSitAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Dog_IdleSit/Script.lua")
	self:addResource("animation-idle-sit", idleSitAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Dog_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Dog_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Dog_Attack/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	local skin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Nyarlathotep/Nyan.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, skin)
	local hat = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Nyarlathotep/Nyan_Hat.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, 0, hat)

	Creep.ready(self, director, game)
end

function Nyan:update(director, game)
	Creep.update(self, director, game)

	local movement = self:getBehavior(MovementBehavior)
	local isMoving = movement.velocity:getLength() > 0.1
	local actor = self:getBehavior(ActorReferenceBehavior).actor

	if not isMoving then
		self.sittingDuration = self.sittingDuration + game:getDelta()
		if self.sittingDuration >= Nyan.SIT and not self.isSitting then
			local resource = self:getResource(
				"animation-idle-sit",
				"ItsyScape.Graphics.AnimationResource")
			actor:playAnimation('main', 1, resource)
			self.isSitting = true
		end
	else
		self.sittingDuration = 0
		self.isSitting = false
	end
end

function Nyan:onSoldResource(player, resource)
	local selfResource = Utility.Peep.getResource(self)
	if selfResource.id.value ~= resource.id.value then
		Log.warn("%s unlocked %s? How?",
			selfResource.name,
			resource.name)
	end

	SailorsCommon.setActiveFirstMateResource(
		player,
		resource,
		false)
end

return Nyan
