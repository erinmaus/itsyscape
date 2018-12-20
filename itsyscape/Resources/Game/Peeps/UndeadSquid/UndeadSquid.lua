--------------------------------------------------------------------------------
-- Resources/Peeps/UndeadSquid/UndeadSquid.lua
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
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local UndeadSquid = Class(Creep)

function UndeadSquid:new(resource, name, ...)
	Creep.new(self, resource, name or 'UndeadSquid', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(8, 9, 8)
	size.offset = Vector(0, 1, 0)

	local movement = self:getBehavior(MovementBehavior)
	movement.velocityMultiplier = 1.5
	movement.accelerationMultiplier = 1.5

	self:silence('receiveAttack', Utility.Peep.Attackable.aggressiveOnReceiveAttack)
	self:listen('receiveAttack', Utility.Peep.Attackable.onReceiveAttack)
end

function UndeadSquid:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/UndeadSquid.lskel")
	actor:setBody(body)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/UndeadSquid/UndeadSquid.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/UndeadSquid_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)
	local swimAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/UndeadSquid_Swim/Script.lua")
	self:addResource("animation-walk", swimAnimation)
	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/UndeadSquid_Attack/Script.lua")
	self:addResource("animation-attack", attackAnimation)
	local defendAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/UndeadSquid_Defend/Script.lua")
	self:addResource("animation-defend", defendAnimation)
	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/UndeadSquid_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	Creep.ready(self, director, game)
end

return UndeadSquid
