--------------------------------------------------------------------------------
-- Resources/Peeps/Zombi/ExperimentX.lua
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
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"

local ExperimentX = Class(Creep)

function ExperimentX:new(resource, name, ...)
	Creep.new(self, resource, name or 'ExperimentX', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(3.5, 5.5, 3.5)

	self:addBehavior(RotationBehavior)
end

function ExperimentX:ready(director, game)
	Creep.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	if not actor then
		return
	end

	actor:setBody(
		CacheRef(
			"ItsyScape.Game.Body",
			"Resources/Game/Bodies/ExperimentX.lskel"))

	local bodySkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/ExperimentX/ExperimentX.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, bodySkin)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/ExperimentX_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	-- local walkAnimation = CacheRef(
	-- 	"ItsyScape.Graphics.AnimationResource",
	-- 	"Resources/Game/Animations/ExperimentX_Walk/Script.lua")
	-- self:addResource("animation-walk", walkAnimation)

	-- local dieAnimation = CacheRef(
	-- 	"ItsyScape.Graphics.AnimationResource",
	-- 	"Resources/Game/Animations/ExperimentX_Die/Script.lua")
	-- self:addResource("animation-die", dieAnimation)

	-- local attackAnimation = CacheRef(
	-- 	"ItsyScape.Graphics.AnimationResource",
	-- 	"Resources/Game/Animations/ExperimentX_Attack/Script.lua")
	-- self:addResource("animation-attack", attackAnimation)

	Utility.Peep.equipXWeapon(self, "DisemboweledSmash")
end

function ExperimentX:update(...)
	Creep.update(self, ...)
	Utility.Peep.face3D(self)
end

return ExperimentX
