--------------------------------------------------------------------------------
-- Resources/Peeps/GhostlyMinerForeman/GhostlyMinerForeman.lua
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
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"

local GhostlyMinerForeman = Class(Creep)

function GhostlyMinerForeman:new(resource, name, ...)
	Creep.new(self, resource, name or 'GhostlyMinerForeman', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2, 4, 2)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 4

	local combat = self:getBehavior(CombatStatusBehavior)
	combat.maxChaseDistance = math.huge

	self:addPoke('pillarMined')
end

function GhostlyMinerForeman:onPillarMined(e)
	local combat = self:getBehavior(CombatStatusBehavior)
	if combat.currentHitpoints > 0 then
		self:poke('hit', AttackPoke({
			damage = 9,
			aggressor = e.pillar
		}))
	end
end

function GhostlyMinerForeman:onDie(e)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
		actor:flash('Message', 1, "I have failed the Empty King!")
	end
end

function GhostlyMinerForeman:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/GhostlyMinerForeman.lskel")
	actor:setBody(body)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/GhostlyMinerForeman_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)
	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/GhostlyMinerForeman_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)
	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/GhostlyMinerForeman_Attack/Script.lua")
	self:addResource("animation-attack", attackAnimation)
	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/GhostlyMinerForeman_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	local bodySkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/GhostlyMinerForeman/GhostlyMinerForeman.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, bodySkin)

	Creep.ready(self, director, game)
end

return GhostlyMinerForeman
