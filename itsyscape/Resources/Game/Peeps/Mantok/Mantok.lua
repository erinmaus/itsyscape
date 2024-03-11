--------------------------------------------------------------------------------
-- Resources/Peeps/Mantok/Mantok.lua
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
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local Mantok = Class(Creep)

function Mantok:new(resource, name, ...)
	Creep.new(self, resource, name or 'Mantok', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(9.5, 9.5, 9.5)

	self:addBehavior(RotationBehavior)

	local _, scale = self:addBehavior(ScaleBehavior)
	scale.scale = Vector(0.25)
end

function Mantok:ready(director, game)
	Creep.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	if not actor then
		return
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Mantok.lskel")
	actor:setBody(body)

	local bodySkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Mantok/Mantok_Body.lua")
	actor:setSkin("body", Equipment.SKIN_PRIORITY_BASE, bodySkin)

	local eyeSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Mantok/Mantok_Eye.lua")
	actor:setSkin("head", Equipment.SKIN_PRIORITY_BASE, eyeSkin)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Mantok_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Mantok_Idle/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	Utility.spawnPropAtPosition(
		self,
		"Mantok_Head",
		Utility.Peep.getPosition(self):get())
end

function Mantok:update(...)
	Creep.update(self, ...)

	if not Utility.Peep.face3D(self) then
		local player = Utility.Peep.getPlayer(self)
		if player then
			Utility.Peep.lookAt(self, player)
		end
	end
end

return Mantok
