--------------------------------------------------------------------------------
-- Resources/Peeps/Emily/BaseEmily.lua
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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local BaseEmily = Class(Creep)

function BaseEmily:new(resource, name, ...)
	Creep.new(self, resource, name or 'Emily_Base', ...)

	self:addBehavior(RotationBehavior)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(4.5, 4, 4.5)
	size.zoom = 2
	size.pan = Vector(0, 4, 0)

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = 1000
	status.maximumHitpoints = 1000
end

function BaseEmily:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local movement = self:getBehavior(MovementBehavior)
	movement.stoppingForce = 0.1
	movement.maxSpeed = 5
	movement.maxAcceleration = 5

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Emily.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Emily_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Emily_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Emily_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Emily_Attack/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Emily/Emily.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

	Creep.ready(self, director, game)
end

function BaseEmily:update(...)
	Creep.update(self, ...)
	Utility.Peep.face3D(self)
end

return BaseEmily
