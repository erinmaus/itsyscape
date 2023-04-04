--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Arachnid/ShadowMite.lua
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
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local Mite = require "Resources.Game.Peeps.Arachnid.Mite"

local ShadowMite = Class(Mite)

ShadowMite.DESPAWN_DISTANCE = 0.05
ShadowMite.DESPAWN_TIME = 0.25

function ShadowMite:new(resource, name, ...)
	Mite.new(self, resource, name or 'ShadowMite_Base', ...)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 14
	movement.noClip = true

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = math.huge
end

function ShadowMite:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior).actor

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/ShadowMite/ShadowMite.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

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

	Mite.ready(self, director, game)
end

function ShadowMite:onInitiateAttack()
	self:removeBehavior(CombatStatusBehavior)
end

function ShadowMite:update(director, game)
	Mite.update(self, director, game)

	local target = self:getBehavior(CombatTargetBehavior)
	target = target and target.actor and target.actor:getPeep()

	local distance = 0
	if target then
		local selfPosition = Utility.Peep.getPosition(self)
		local targetPosition = Utility.Peep.getPosition(target)
		distance = (selfPosition - targetPosition):getLength()

		Utility.Peep.setPosition(self, selfPosition:lerp(targetPosition, game:getDelta()))
	end

	if distance < ShadowMite.DESPAWN_DISTANCE then
		if not self.despawnTime then
			self.despawnTime = ShadowMite.DESPAWN_TIME

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

	self:removeBehavior(TargetTileBehavior)
end

return ShadowMite
