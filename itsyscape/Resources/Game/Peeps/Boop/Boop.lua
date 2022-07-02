--------------------------------------------------------------------------------
-- Resources/Peeps/Boop/Boop.lua
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

local Boop = Class(Creep)

function Boop:new(resource, name, ...)
	Creep.new(self, resource, name or 'Boop_Base', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2, 3.5, 2)

	self:addBehavior(RotationBehavior)
end

function Boop:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Boop.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Boop_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Boop_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	local defendAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Boop_Defend/Script.lua")
	self:addResource("animation-defend", defendAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Boop_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Boop_Attack/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	local defendAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Boop_Defend/Script.lua")
	self:addResource("animation-defend", defendAnimation)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Boop/Boop.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

	Creep.ready(self, director, game)

	Utility.Peep.equipXWeapon(self, "BoopSmash")
end

function Boop:update(...)
	Creep.update(self, ...)
	Utility.Peep.face3D(self)
end

return Boop
