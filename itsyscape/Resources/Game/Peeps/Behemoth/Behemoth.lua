--------------------------------------------------------------------------------
-- Resources/Peeps/Behemoth/Behemoth.lua
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
local Face3DBehavior = require "ItsyScape.Peep.Behaviors.Face3DBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local TeleportalBehavior = require "ItsyScape.Peep.Behaviors.TeleportalBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local Behemoth = Class(Creep)

function Behemoth:new(resource, name, ...)
	Creep.new(self, resource, name or 'Behemoth', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1.5, 1.5, 1.5)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 2.5

	self:addBehavior(RotationBehavior)
	self:addBehavior(Face3DBehavior)
end

function Behemoth:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local status = self:getBehavior(CombatStatusBehavior)
	status.maximumHitpoints = math.huge
	status.currentHitpoints = math.huge
	status.maxChaseDistance = math.huge

	local face3D = self:getBehavior(Face3DBehavior)
	face3D.duration = 1.5

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Behemoth.lskel")
	actor:setBody(body)

	local bodySkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Behemoth/Behemoth.lua")
	actor:setSkin("skin", Equipment.SKIN_PRIORITY_BASE, bodySkin)

	local vinesSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Behemoth/Vines.lua")
	actor:setSkin("vines", Equipment.SKIN_PRIORITY_BASE, vinesSkin)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Behemoth_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	Utility.spawnPropAtPosition(
		self,
		"BehemothSkin",
		0, 0, 0, 0)

	local backLayer = Utility.Map.spawnMap(self, "Behemoth_Back", Vector(-1000, -1000, 0))
	local back = Utility.spawnPropAtPosition(self, "BehemothMap", 0, 0, 0, 0)
	do
		local _, portal = back:getPeep():addBehavior(TeleportalBehavior)
		portal.layer = backLayer
		portal.i = 4
		portal.j = 8
		portal.k = 12
		portal.x = -4
		portal.z = -20
		portal.bone = "body"
	end

	Creep.ready(self, director, game)
end

function Behemoth:update(...)
	Creep.update(self, ...)
	Utility.Peep.face3D(self)
end

return Behemoth
