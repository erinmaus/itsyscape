--------------------------------------------------------------------------------
-- Resources/Peeps/Svalbard/Svalbard.lua
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
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local Svalbard = Class(Creep)

function Svalbard:new(resource, name, ...)
	Creep.new(self, resource, name or 'Svalbard', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2.5, 1.5, 7)

	self:addBehavior(RotationBehavior)
	local _, scale = self:addBehavior(ScaleBehavior)
	scale.scale = Vector(1.5, 1.5, 1.5)

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = 5000
	status.maximumHitpoints = 5000
end

function Svalbard:ready(director, game)
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
		"Resources/Game/Bodies/Svalbard.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Svalbard_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Svalbard/Body.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_SELF, 0, body)

	local flesh = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Svalbard/Flesh.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, flesh)

	local head = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Svalbard/Head.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, 0, head)

	local wings = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Svalbard/Wings.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BACK, 0, wings)

	Creep.ready(self, director, game)
end

function Svalbard:update(...)
	Creep.update(self, ...)
	Utility.Peep.face3D(self)
end

return Svalbard
