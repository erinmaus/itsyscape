--------------------------------------------------------------------------------
-- Resources/Peeps/FungalDemogorgon/FungalDemogorgon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local FungalDemogorgon = Class(Creep)

function FungalDemogorgon:new(resource, name, ...)
	Creep.new(self, resource, name or 'FungalDemogorgon_Base', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2, 2, 2)

	self:addBehavior(RotationBehavior)
end

function FungalDemogorgon:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local movement = self:getBehavior(MovementBehavior)
	movement.stoppingForce = 0.5
	movement.maxSpeed = 22
	movement.maxAcceleration = 18
	movement.stoppingForce = 4

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/FungalDemogorgon.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/FungalDemogorgon_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/FungalDemogorgon_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	--local dieAnimation = CacheRef(
	--	"ItsyScape.Graphics.AnimationResource",
	--	"Resources/Game/Animations/FungalDemogorgon_Die/Script.lua")
	--self:addResource("animation-die", dieAnimation)

	--local attackAnimation = CacheRef(
	--	"ItsyScape.Graphics.AnimationResource",
	--	"Resources/Game/Animations/FungalDemogorgon_Attack/Script.lua")
	--self:addResource("animation-attack", attackAnimation)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/FungalDemogorgon/FungalDemogorgon.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

	self.isOpen = false
	self:playOpenOrCloseAnimation()

	Creep.ready(self, director, game)
end

function FungalDemogorgon:onFinalize()
	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = 4000
	status.maximumHitpoints = 4000
end

function FungalDemogorgon:playOpenOrCloseAnimation()
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor

		local animation
		if self.isOpen then
			animation = CacheRef(
				"ItsyScape.Graphics.AnimationResource",
				"Resources/Game/Animations/FungalDemogorgon_Open/Script.lua")
		else
			animation = CacheRef(
				"ItsyScape.Graphics.AnimationResource",
				"Resources/Game/Animations/FungalDemogorgon_Close/Script.lua")
		end

		actor:playAnimation(
			'x-mouth', math.huge, animation)
	end
end

function FungalDemogorgon:onWander()
	local _, _, layer = Utility.Peep.getTile(self)
	local map = self:getDirector():getMap(layer)

	if map then
		local foundTile = false
		repeat
			local i, j = math.random(map:getWidth()), math.random(map:getHeight())

			local tile = map:getTile(i, j)
			if not tile:hasFlag('impassable') then
				if Utility.Peep.walk(self, i, j, layer, 0) then
					foundTile = true
				end
			end
		until foundTile
	end
end

function FungalDemogorgon:update(...)
	Creep.update(self, ...)

	local rotation = self:getBehavior(RotationBehavior)
	local combatTarget = self:getBehavior(CombatTargetBehavior)
	if combatTarget and combatTarget.actor then
		local actor = combatTarget.actor
		local peep = actor:getPeep()

		if peep then
			local selfPosition = Utility.Peep.getAbsolutePosition(self)
			local peepPosition = Utility.Peep.getAbsolutePosition(peep)

			rotation.rotation = (Quaternion.lookAt(peepPosition, selfPosition):getNormal())
		end

		if not self.isOpen then
			self.isOpen = true
			self:playOpenOrCloseAnimation()
		end
	else
		local targetTile = self:getBehavior(TargetTileBehavior)
		if targetTile and targetTile.pathNode then
			local position = self:getBehavior(PositionBehavior)
			local map = self:getDirector():getMap(position.layer)

			local selfPosition = Utility.Peep.getAbsolutePosition(self)
			local tilePosition = map:getTileCenter(targetTile.pathNode.i, targetTile.pathNode.j)

			rotation.rotation = Quaternion.lookAt(tilePosition, selfPosition):getNormal()
		else
			rotation.rotation = Quaternion.IDENTITY
		end

		if self.isOpen then
			self.isOpen = false
			self:playOpenOrCloseAnimation()
		end
	end

	local movement = self:getBehavior(MovementBehavior)
	movement.facing = MovementBehavior.FACING_RIGHT
	movement.targetFacing = MovementBehavior.FACING_LEFT
end

return FungalDemogorgon
