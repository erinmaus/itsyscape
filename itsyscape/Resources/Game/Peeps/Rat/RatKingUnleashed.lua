--------------------------------------------------------------------------------
-- Resources/Peeps/Rat/RatKingUnleashed.lua
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
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local RatKingUnleashed = Class(Creep)

function RatKingUnleashed:new(resource, name, ...)
	Creep.new(self, resource, name or 'RatKingUnleashed', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(4.5, 12, 4.5)

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = 1000
	status.maximumHitpoints = 1000

	self:addBehavior(RotationBehavior)
end

function RatKingUnleashed:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/RatKing.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/RatKing_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	-- local walkAnimation = CacheRef(
	-- 	"ItsyScape.Graphics.AnimationResource",
	-- 	"Resources/Game/Animations/RatKing_Walk/Script.lua")
	-- self:addResource("animation-walk", walkAnimation)

	-- local dieAnimation = CacheRef(
	-- 	"ItsyScape.Graphics.AnimationResource",
	-- 	"Resources/Game/Animations/RatKing_Die/Script.lua")
	-- self:addResource("animation-die", dieAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/RatKing_Attack/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	local spawnAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/RatKing_Spawn/Script.lua")
	self:addResource("animation-spawn", spawnAnimation)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/RatKing/RatKing.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

	Creep.ready(self, director, game)
end

function RatKingUnleashed:update(...)
	Creep.update(self, ...)
	Utility.Peep.face3D(self)
end

return RatKingUnleashed