--------------------------------------------------------------------------------
-- Resources/Peeps/MiasmaSkeleton/MiasmaSkeleton.lua
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
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"

local MiasmaSkeleton = Class(Player)

MiasmaSkeleton.DESPAWN_DISTANCE = 0.5
MiasmaSkeleton.DESPAWN_TIME = 0.25
MiasmaSkeleton.SCALE = 2

function MiasmaSkeleton:new(resource, name, ...)
	Player.new(self, resource, name or 'MiasmaSkeleton', ...)

	local movement = self:getBehavior(MovementBehavior)
	movement.noClip = true

	self:removeBehavior(CombatStatusBehavior)

	self:addBehavior(ScaleBehavior)
	local scale = self:getBehavior(ScaleBehavior)
	scale.scale = Vector(MiasmaSkeleton.SCALE)
end

function MiasmaSkeleton:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Human.lskel")
	actor:setBody(body)

	local head = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/MiasmaSkeleton/MiasmaSkeleton.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, head)

	local animation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Walk_Glide_1/Script.lua")
	self:addResource("animation-walk", animation)
	self:addResource("animation-idle", animation)

	local spawnAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/FX_Spawn/Script.lua")
	self:addResource("animation-spawn", spawnAnimation)

	local despawnAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/FX_Despawn/Script.lua")
	self:addResource("animation-despawn", despawnAnimation)

	actor:playAnimation(
		'x-spawn',
		0,
		self:getResource("animation-spawn", "ItsyScape.Graphics.AnimationResource"))

	Player.ready(self, director, game)
end

function MiasmaSkeleton:update(director, game)
	Player.update(self, director, game)

	local target = self:getBehavior(CombatTargetBehavior)
	target = target and target.actor and target.actor:getPeep()

	local distance = 0
	if target then
		local selfPosition = Utility.Peep.getPosition(self)
		local targetPosition = Utility.Peep.getPosition(target)
		distance = (selfPosition - targetPosition):getLength()

		Utility.Peep.setPosition(self, selfPosition:lerp(targetPosition, game:getDelta()))

		local movement = self:getBehavior(MovementBehavior)
		if selfPosition.x > targetPosition.x then
			movement.facing = MovementBehavior.FACING_LEFT
		else
			movement.facing = MovementBehavior.FACING_RIGHT
		end
	end

	if distance < MiasmaSkeleton.DESPAWN_DISTANCE then
		if not self.despawnTime then
			self.despawnTime = MiasmaSkeleton.DESPAWN_TIME

			local actor = self:getBehavior(ActorReferenceBehavior).actor
			actor:playAnimation(
				'x-spawn',
				0,
				self:getResource("animation-despawn", "ItsyScape.Graphics.AnimationResource"))
		end
	end

	if self.despawnTime then
		if self.despawnTime < 0 then
			Utility.Peep.poof(self)
		end

		self.despawnTime = self.despawnTime - game:getDelta()
	end
end

return MiasmaSkeleton
