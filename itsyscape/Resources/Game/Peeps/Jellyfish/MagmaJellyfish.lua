--------------------------------------------------------------------------------
-- Resources/Peeps/MagmaJellyfish/MagmaJellyfish.lua
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
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local MagmaJellyfish = Class(Creep)

function MagmaJellyfish:new(resource, name, ...)
	Creep.new(self, resource, name or 'MagmaJellyfish_Base', ...)

	self:addBehavior(RotationBehavior)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2.5, 2.5, 2.5)
	size.offset = Vector(0, 5.5, 0)

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = math.huge	
end

function MagmaJellyfish:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Jellyfish.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Jellyfish_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Jellyfish_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Jellyfish_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Jellyfish_Attack/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Jellyfish/MagmaJellyfish.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

	Utility.Peep.equipXWeapon(self, "MagmaJellyfishAttack")

	Creep.ready(self, director, game)
end

function MagmaJellyfish:update(...)
	Creep.update(self, ...)
	Utility.Peep.face3D(self)
end

function MagmaJellyfish:onExplode(target)
	local stage = self:getDirector():getGameInstance():getStage()
	stage:fireProjectile("MagmaJellyfishSplosion", self, target)

	local weapon = Utility.Peep.getEquippedWeapon(self, true)
	Weapon.perform(weapon, self, target)
end

return MagmaJellyfish
