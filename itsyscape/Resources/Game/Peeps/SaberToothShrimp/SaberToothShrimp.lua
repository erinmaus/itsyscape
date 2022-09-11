--------------------------------------------------------------------------------
-- Resources/Peeps/SaberToothShrimp/SaberToothShrimp.lua
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
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local SaberToothShrimp = Class(Creep)

function SaberToothShrimp:new(resource, name, ...)
	Creep.new(self, resource, name or 'SaberToothShrimp_Base', ...)

	self:addBehavior(RotationBehavior)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(4, 4, 4)
end

function SaberToothShrimp:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/SaberToothShrimp.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/SaberToothShrimp_Idle_Lava/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/SaberToothShrimp_Idle_Lava/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	-- local walkAnimation = CacheRef(
	-- 	"ItsyScape.Graphics.AnimationResource",
	-- 	"Resources/Game/Animations/SaberToothShrimp_Walk/Script.lua")
	-- self:addResource("animation-walk", walkAnimation)

	-- local dieAnimation = CacheRef(
	-- 	"ItsyScape.Graphics.AnimationResource",
	-- 	"Resources/Game/Animations/SaberToothShrimp_Die/Script.lua")
	-- self:addResource("animation-die", dieAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/SaberToothShrimp_Attack_Lava/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/SaberToothShrimp/SaberToothShrimp.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:fireProjectile("SaberToothShrimpSmoke", Vector.ZERO, self)

	Creep.ready(self, director, game)

	Utility.Peep.equipXWeapon(self, "SaberToothShrimp_Attack")
end

function SaberToothShrimp:update(...)
	Creep.update(self, ...)

	local player = Utility.Peep.getPlayer(self)
	if player then
		Utility.Peep.lookAt(self, player)
	end
end

return SaberToothShrimp
