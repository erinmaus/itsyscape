--------------------------------------------------------------------------------
-- Resources/Peeps/Skelemental/BaseSkelemental.lua
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
local Curve = require "ItsyScape.Game.Curve"
local Equipment = require "ItsyScape.Game.Equipment"
local Stats = require "ItsyScape.Game.Stats"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local BaseSkelemental = Class(Creep)

function BaseSkelemental:new(resource, name, ...)
	Creep.new(self, resource, name or 'Skelemental_Base', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2, 3, 2)
end

function BaseSkelemental:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Skelemental.lskel")
	actor:setBody(body)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Skelemental_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)
	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Skelemental_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)
	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Skelemental_Attack/Script.lua")
	self:addResource("animation-attack", attackAnimation)
	local defendAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Skelemental_Defend/Script.lua")
	self:addResource("animation-defend", defendAnimation)
	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Skelemental_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	Creep.ready(self, director, game)
end

return BaseSkelemental
