--------------------------------------------------------------------------------
-- Resources/Peeps/Arachnid/Spider.lua
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

local Spider = Class(Creep)

function Spider:new(resource, name, ...)
	Creep.new(self, resource, name or 'Spider', ...)

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = 16

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2.5, 1.5, 1.5)

	self:addBehavior(RotationBehavior)
	self:addBehavior(ScaleBehavior)
end

function Spider:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Spider.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Spider_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Spider_Attack_Magic/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Spider_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Spider_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	Creep.ready(self, director, game)
end

function Spider:update(...)
	Creep.update(self, ...)

	Utility.Peep.face3D(self)
end

return Spider
