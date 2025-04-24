--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Keelhauler/Keelhauler.lua
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
local Probe = require "ItsyScape.Peep.Probe"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"

local Keelhauler = Class(Creep)
Keelhauler.WALK_SPEED = 2
Keelhauler.RUN_SPEED = 16
Keelhauler.MAX_ACCELERATION = 24

function Keelhauler:new(resource, name, ...)
	Creep.new(self, resource, name or 'Keelhauler', ...)

	self:addBehavior(RotationBehavior)

	Utility.Peep.setSize(self, Vector(8, 10, 12.5))

	self:addPoke("dashStart")
	self:addPoke("dashEnd")
	self:addPoke("dashHit")

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = self.WALK_SPEED
	movement.maxAcceleration = self.MAX_ACCELERATION

	self.isDashing = false
	self.hits = {}
end

function Keelhauler:ready(director, game)
	Utility.Peep.Creep.setBody(self, "Keelhauler")
	Utility.Peep.Creep.addAnimation(self, "animation-idle", "Keelhauler_Idle")
	Utility.Peep.Creep.addAnimation(self, "animation-walk", "Keelhauler_Walk")
	Utility.Peep.Creep.applySkin(
		self,
		"x-accents",
		Equipment.SKIN_PRIORITY_BASE,
		"Keelhauler/Accents.lua")
	Utility.Peep.Creep.applySkin(
		self,
		"x-body",
		Equipment.SKIN_PRIORITY_BASE,
		"Keelhauler/Body.lua")
	Utility.Peep.Creep.applySkin(
		self,
		"x-head",
		Equipment.SKIN_PRIORITY_BASE,
		"Keelhauler/Head.lua")
	Utility.Peep.Creep.applySkin(
		self,
		"x-accents-reflective",
		Equipment.SKIN_PRIORITY_BASE,
		"Keelhauler/Accents_Reflective.lua")
	Utility.Peep.Creep.applySkin(
		self,
		"x-feathers-windy",
		Equipment.SKIN_PRIORITY_BASE,
		"Keelhauler/Feathers_Windy.lua")
	Utility.Peep.Creep.applySkin(
		self,
		"x-feathers-bendy",
		Equipment.SKIN_PRIORITY_BASE,
		"Keelhauler/Feathers_Bendy.lua")

	Utility.Peep.equipXWeapon(self, "Keelhauler_MudSplash")

	Creep.ready(self, director, game)
end

function Keelhauler:onDashStart()
	self.isDashing = true
	self.hits = {}

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = self.RUN_SPEED

	Utility.Peep.Creep.addAnimation(self, "animation-walk", "Keelhauler_Run")
end

function Keelhauler:onDashEnd()
	self.isDashing = false

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = self.WALK_SPEED

	Utility.Peep.Creep.addAnimation(self, "animation-walk", "Keelhauler_Run")
end

function Keelhauler:updateDash()
	local hits = self:getDirector():probe(
		self:getLayerName(),
		self:hasBehavior(InstancedBehavior) and Probe.instance(Utility.Peep.getPlayerModel(self)) or Probe.any(),
		Probe.attackable(self),
		Probe.except(self),
		function(p)
			local distance = Utility.Peep.getAbsoluteDistance(self, p)
			return distance <= 0
		end)

	for _, hit in ipairs(hits) do
		if not self.hits[hit] then
			print(">>> hit", hit:getName())
			self:poke("dashHit", hit)
			self.hits[hit] = true
		end
	end
end

function Keelhauler:update(...)
	Creep.update(self, ...)

	Utility.Peep.face3D(self)

	if self.isDashing then
		self:updateDash()
	end
end

return Keelhauler
