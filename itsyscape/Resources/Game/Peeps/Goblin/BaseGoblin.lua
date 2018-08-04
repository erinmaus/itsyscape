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
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
local PlayerInventoryProvider = require "ItsyScape.Game.PlayerInventoryProvider"
local Stats = require "ItsyScape.Game.Stats"
local Peep = require "ItsyScape.Peep.Peep"
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local BaseGoblin = Class(Player)

function BaseGoblin:new(resource, name, ...)
	Player.new(self, resource, name or 'Goblin_Base', ...)

	self:addBehavior(HumanoidBehavior)
	self:addBehavior(CombatStatusBehavior)

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

	Player.ready(self, director, game)

	local combat = self:getBehavior(CombatStatusBehavior)
	combat.maximumHitpoints = stats.stats:getSkill("Constitution"):getBaseLevel()
	combat.currentHitpoints = stats.stats:getSkill("Constitution"):getBaseLevel()
end

function BaseGoblin:onHit(p)
	Player.onHit(self, p)

	print(string.format("Ow! The goblin took %d damage.", p:getDamage()))
end

function BaseGoblin:onDie(p)
	Player.onDie(self, p)

	print("RIP, Goblin.")
end

return BaseGoblin
