--------------------------------------------------------------------------------
-- Resources/Peeps/Rat/BaseRatKing.lua
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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local BaseRatKing = Class(Creep)

function BaseRatKing:new(resource, name, ...)
	Creep.new(self, resource, name or 'RatKing_Base', ...)

	self:silence('receiveAttack', Utility.Peep.Attackable.aggressiveOnReceiveAttack)
	self:listen('receiveAttack', Utility.Peep.Attackable.onReceiveAttack)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2, 4, 2)
end

function BaseRatKing:onEat(p)
	local target = p.target

	if target then
		target:poke('die')

		local targetStatus = target:getBehavior(CombatStatusBehavior)
		if targetStatus then
			self:poke('heal', {
				hitPoints = targetStatus.maximumHitpoints * 2
			})
		end
	end
end

function BaseRatKing:onBoss()
	Utility.UI.openInterface(
		self:getDirector():getGameInstance():getPlayer():getActor():getPeep(),
		"BossHUD",
		false,
		self)
end

function BaseRatKing:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Rat.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Rat_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Rat_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Rat_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Rat_Attack/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Rat/RatKing.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)
	local crown = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Rat/RatKingCrown.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, 0, crown)

	Creep.ready(self, director, game)
end

return BaseRatKing
