--------------------------------------------------------------------------------
-- Resources/Peeps/TheEmptyKing/CutsceneEmptyKing_FullyRealized.lua
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
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local TheEmptyKing = Class(Creep)

function TheEmptyKing:new(resource, name, ...)
	Creep.new(self, resource, name or 'TheEmptyKing_FullyRealized', ...)

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = math.huge
	status.maximumHitpoints = math.huge
	status.currentPrayer = math.huge
	status.maximumPrayer = math.huge
	status.maxChaseDistance = math.huge

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2, 6, 2)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxAcceleration = 16
	movement.maxSpeed = 32
end

function TheEmptyKing:ready(director, game)
	Creep.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/TheEmptyKing.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/TheEmptyKing_FullyRealized_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/TheEmptyKing_FullyRealized_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	local skin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/TheEmptyKing_FullyRealized/TheEmptyKing_FullyRealized.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_SELF, Equipment.SKIN_PRIORITY_BASE, skin)
end

function TheEmptyKing:onSummonAxe(axe)
	local stage = self:getDirector():getGameInstance():getStage()
	stage:fireProjectile("TheEmptyKingsExecutionerAxe", Utility.Peep.getAbsolutePosition(axe), self)

	Utility.Peep.poof(axe)
end

function TheEmptyKing:onEquipAxe(axe)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/TheEmptyKing_FullyRealized_Idle_Axe/Script.lua")
	self:addResource("animation-idle", idleAnimation)
	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Axe/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	local skin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/TheEmptyKing_FullyRealized/TheEmptyKing_FullyRealized_Axe.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_RIGHT_HAND, Equipment.SKIN_PRIORITY_BASE, skin)
end

return TheEmptyKing
