--------------------------------------------------------------------------------
-- Resources/Peeps/Goblin/BaseGoblin.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Curve = require "ItsyScape.Game.Curve"
local Equipment = require "ItsyScape.Game.Equipment"
local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
local PlayerInventoryProvider = require "ItsyScape.Game.PlayerInventoryProvider"
local Stats = require "ItsyScape.Game.Stats"
local Peep = require "ItsyScape.Peep.Peep"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local BaseGoblin = Class(Creep)

function BaseGoblin:new(t, ...)
	Creep.new(self, t or 'Goblin_Base', ...)

	self:addBehavior(HumanoidBehavior)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Goblin_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)
	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Goblin_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)
	local punchAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Goblin_AttackUnarmed/Script.lua")
	self:addResource("animation-attack-unarmed", punchAnimation)
	self:addResource("animation-attack", punchAnimation)
	local defendAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Goblin_Defend/Script.lua")
	self:addResource("animation-defend", defendAnimation)
	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Goblin_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)
end

function BaseGoblin:ready(director, game)
	Creep.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Goblin.lskel")
	actor:setBody(body)

	local skin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Goblin/Base.lua")
	actor:setSkin('npc', 1, skin)

	local stats = self:getBehavior(StatsBehavior)
	stats.stats = Stats("Goblin", game:getGameDB())
	stats.stats:getSkill("Constitution"):setXP(Curve.XP_CURVE:compute(15))

	local combat = self:getBehavior(CombatStatusBehavior)
	combat.maximumHitpoints = 15
	combat.currentHitpoints = 15
end

function BaseGoblin:update(director, game)
	Creep.update(self, director, game)

	local isAlive
	do
		local combat = self:getBehavior(CombatStatusBehavior)
		isAlive = combat.currentHitpoints > 0
	end

	if math.random() < 0.1 and not self:hasBehavior(TargetTileBehavior) then
		if isAlive then
			local map = self:getDirector():getGameInstance():getStage():getMap(1)
			local i = math.floor(math.random(1, map:getWidth()))
			local j = math.floor(math.random(1, map:getHeight()))
			self:walk(i, j, 1)
		end
	end
end

function BaseGoblin:onHit(p)
	Creep.onHit(self, p)

	print(string.format("Ow! The goblin took %d damage.", p:getDamage()))
end

function BaseGoblin:onDie(p)
	Creep.onDie(self, p)

	print("RIP, Goblin.")
end

return BaseGoblin
