--------------------------------------------------------------------------------
-- Resources/Peeps/YeastBeast/YeastBeast.lua
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
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local YeastBeast = Class(Creep)

function YeastBeast:new(resource, name, ...)
	Creep.new(self, resource, name or 'YeastBeast', ...)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 3

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = 16

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1.5)

	self:addBehavior(ScaleBehavior)
	self:addBehavior(RotationBehavior)
end

function YeastBeast:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local scale = self:getBehavior(ScaleBehavior)
	scale.scale = Vector(1.5)

	local status = self:getBehavior(CombatStatusBehavior)
	status.maximumHitpoints = 5000
	status.currentHitpoints = 5000	

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/YeastBeast.lskel")
	actor:setBody(body)

	local bodySkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/YeastBeast/YeastBeast_Body.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, bodySkin)

	local jarSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/YeastBeast/YeastBeast_Jar.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BACK, Equipment.SKIN_PRIORITY_BASE, jarSkin)

	local yeastSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/YeastBeast/YeastBeast_Yeast.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BACK, Equipment.SKIN_PRIORITY_ACCENT, yeastSkin)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/YeastBeast_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/YeastBeast_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	Utility.Peep.equipXWeapon(self, "ChocoroachVomit")

	Creep.ready(self, director, game)
end

function YeastBeast:update(...)
	Creep.update(self, ...)

	Utility.Peep.face3D(self)
end

return YeastBeast
