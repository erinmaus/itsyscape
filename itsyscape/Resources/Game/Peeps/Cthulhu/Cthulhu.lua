--------------------------------------------------------------------------------
-- Resources/Peeps/Cthulhu/Cthulhu.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local FishBehavior = require "ItsyScape.Peep.Behaviors.FishBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local Cthulhu = Class(Creep)

function Cthulhu:new(resource, name, ...)
	Creep.new(self, resource, name or 'Cthulhu', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(12, 16, 4)
	size.zoom = 0.75
	size.pan = Vector(0, 12, 0)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 18
	movement.maxAcceleration = 16
	movement.noClip = true

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = 20000
	status.maximumHitpoints = 20000

	self:addBehavior(RotationBehavior)
	self:addBehavior(FishBehavior)
end

function Cthulhu:onReceiveAttack()
	Utility.Peep.setMashinaState(self, "attack")
end

function Cthulhu:ready(director, game)
	Utility.Peep.Creep.setBody(self, "Cthulhu")

	Utility.Peep.Creep.applySkin(
		self,
		"head",
		Equipment.SKIN_PRIORITY_BASE,
		"Cthulhu/Head.lua")

	Utility.Peep.Creep.applySkin(
		self,
		"beak",
		Equipment.SKIN_PRIORITY_BASE,
		"Cthulhu/Beak.lua")

	Utility.Peep.Creep.applySkin(
		self,
		"eyes",
		Equipment.SKIN_PRIORITY_BASE,
		"Cthulhu/Eyes.lua")

	Utility.Peep.Creep.applySkin(
		self,
		"tentacles",
		Equipment.SKIN_PRIORITY_BASE,
		"Cthulhu/Tentacles.lua")

	Utility.Peep.Creep.applySkin(
		self,
		"body",
		Equipment.SKIN_PRIORITY_BASE,
		"Cthulhu/Body.lua")

	Utility.Peep.Creep.applySkin(
		self,
		"wings",
		Equipment.SKIN_PRIORITY_BASE,
		"Cthulhu/Wings.lua")

	Utility.Peep.Creep.applySkin(
		self,
		"hands",
		Equipment.SKIN_PRIORITY_BASE,
		"Cthulhu/Hands.lua")

	Utility.Peep.Creep.applySkin(
		self,
		"nails",
		Equipment.SKIN_PRIORITY_BASE,
		"Cthulhu/Nails.lua")

	Utility.Peep.Creep.applySkin(
		self,
		"feet",
		Equipment.SKIN_PRIORITY_BASE,
		"Cthulhu/Feet.lua")

	Utility.Peep.Creep.addAnimation(
		self,
		"animation-idle",
		"Cthulhu_Idle")

	Utility.Peep.Creep.addAnimation(
		self,
		"animation-attack",
		"Cthulhu_Attack")

	Utility.Peep.Creep.addAnimation(
		self,
		"animation-defend",
		"Cthulhu_Defend")

	Utility.Peep.Creep.addAnimation(
		self,
		"animation-walk",
		"Cthulhu_Swim")

	Creep.ready(self, director, game)
end

function Cthulhu:update(...)
	Creep.update(self, ...)

	Utility.Peep.face3D(self)
end

return Cthulhu
