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
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local MapPathFinder = require "ItsyScape.World.MapPathFinder"
local ExecutePathCommand = require "ItsyScape.World.ExecutePathCommand"

local BaseGoblin = Class(Peep)

function BaseGoblin:new(...)
	Peep.new(self, 'Goblin', ...)

	self:addBehavior(ActorReferenceBehavior)
	self:addBehavior(HumanoidBehavior)
	self:addBehavior(MovementBehavior)
	self:addBehavior(PositionBehavior)
	self:addBehavior(SizeBehavior)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 16
	movement.maxAcceleration = 16
	movement.decay = 0.6
	movement.velocityMultiplier = 1
	movement.accelerationMultiplier = 1
	movement.stoppingForce = 3

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

	self:addPoke('initiateAttack')
	self:addPoke('receiveAttack')

	self:listen('receiveAttack', function(_, p)
		print("The Goblin says ow!")
	end)
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
end

function BaseGoblin:walk(i, j, k)
	local position = self:getBehavior(PositionBehavior).position
	local map = self:getDirector():getGameInstance():getStage():getMap(k)
	local _, playerI, playerJ = map:getTileAt(position.x, position.z)
	local pathFinder = MapPathFinder(map)
	local path = pathFinder:find(
		{ i = playerI, j = playerJ },
		{ i = i, j = j })
	if path then
		local queue = self:getCommandQueue()
		queue:interrupt(ExecutePathCommand(path))
	end
end

function BaseGoblin:update(director, game)
	Peep.update(self, director, game)

	if math.random() < 0.1 and not self:hasBehavior(TargetTileBehavior) then
		local map = self:getDirector():getGameInstance():getStage():getMap(1)
		local i = math.floor(math.random(1, map:getWidth()))
		local j = math.floor(math.random(1, map:getHeight()))
		self:walk(i, j, 1)
	end
end

return BaseGoblin
