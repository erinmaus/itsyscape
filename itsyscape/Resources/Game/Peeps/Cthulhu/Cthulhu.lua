--------------------------------------------------------------------------------
-- Resources/Peeps/Cthulhu/Cthulhu.lua
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
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local FishBehavior = require "ItsyScape.Peep.Behaviors.FishBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local Cthulhu = Class(Creep)

function Cthulhu:new(resource, name, ...)
	Creep.new(self, resource, name or 'Cthulhu', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(12, 32, 4)
	size.zoom = 0.75
	size.pan = Vector(0, 12, 0)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 18
	movement.maxAcceleration = 16
	movement.noClip = true

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = 20000
	status.maximumHitpoints = 20000

	self:addBehavior(RotationBehavior)
	self:addBehavior(FishBehavior)
end

function Cthulhu:onReceiveAttack()
	Utility.Peep.setMashinaState(self, "attack")
end

function Cthulhu:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Cthulhu.lskel")
	actor:setBody(body)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Cthulhu/Cthulhu.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Cthulhu_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local swimAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Cthulhu_Swim/Script.lua")
	self:addResource("animation-walk", swimAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Cthulhu_Attack/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	Creep.ready(self, director, game)
end

function Cthulhu:update()
	Utility.Peep.face3D(self)
end

return Cthulhu
