--------------------------------------------------------------------------------
-- Resources/Peeps/Yenderling/ExtraterrestrialYenderling.lua
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
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local Yenderling = Class(Creep)

function Yenderling:new(resource, name, ...)
	Creep.new(self, resource, name or 'ExtraterrestrialYenderling', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(4, 6, 4)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 0
	movement.maxAcceleration = 0
	movement.noClip = true

	self:addBehavior(RotationBehavior)
end

function Yenderling:ready(director, game)
	Utility.Peep.Creep.setBody(self, "ExtraterrestrialYenderling")

	Utility.Peep.Creep.applySkin(
		self,
		"head",
		Equipment.SKIN_PRIORITY_BASE,
		"Yenderling/ExtraterrestrialYenderling.lua")

	Utility.Peep.Creep.addAnimation(
		self,
		"animation-spawn",
		"ExtraterrestrialYenderling_Spawn")

	Utility.Peep.Creep.addAnimation(
		self,
		"animation-idle",
		"ExtraterrestrialYenderling_Idle")

	Utility.Peep.Creep.addAnimation(
		self,
		"animation-attack",
		"ExtraterrestrialYenderling_Attack")

	Utility.Peep.Creep.addAnimation(
		self,
		"animation-die",
		"ExtraterrestrialYenderling_Die")

	Utility.Peep.Creep.addAnimation(
		self,
		"animation-walk",
		"ExtraterrestrialYenderling_Idle")

	Utility.Peep.playAnimation(
		self,
		"main",
		10000,
		"ExtraterrestrialYenderling_Spawn")

	Creep.ready(self, director, game)

	Utility.Peep.equipXWeapon(self, "ExtraterrestrialYenderling_Smash")
end

function Yenderling:update(...)
	Creep.update(self, ...)

	Utility.Peep.face3D(self)
end

return Yenderling
