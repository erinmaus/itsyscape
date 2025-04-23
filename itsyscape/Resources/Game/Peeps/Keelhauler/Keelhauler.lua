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
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"

local Keelhauler = Class(Creep)

function Keelhauler:new(resource, name, ...)
	Creep.new(self, resource, name or 'Keelhauler', ...)

	self:addBehavior(RotationBehavior)

	Utility.Peep.setSize(self, Vector(8, 10, 12.5))
end

function Keelhauler:ready(director, game)
	Utility.Peep.Creep.setBody(self, "Keelhauler")
	Utility.Peep.Creep.addAnimation(self, "animation-idle", "Keelhauler_Idle")
	Utility.Peep.Creep.addAnimation(self, "animation-walk", "Keelhauler_Idle")
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

function Keelhauler:update(...)
	Creep.update(self, ...)

	Utility.Peep.face3D(self)
end

return Keelhauler
