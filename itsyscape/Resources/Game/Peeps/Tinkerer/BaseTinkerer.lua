--------------------------------------------------------------------------------
-- Resources/Peeps/Tinkerer/BaseTinkerer.lua
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
local FlyingBehavior = require "ItsyScape.Peep.Behaviors.FlyingBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local BaseTinkerer = Class(Creep)

function BaseTinkerer:new(resource, name, ...)
	Creep.new(self, resource, name or 'Tinkerer_Base', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2.5, 5, 2.5)
end

function BaseTinkerer:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = math.huge

	local _, flying = self:addBehavior(FlyingBehavior)
	flying.range = 2.5
	flying.maxElevation = 5

	Utility.Peep.Creep.setBody(self, "Tinkerer")

	Utility.Peep.Creep.addAnimation(self, "animation-idle", "Tinkerer_Idle")
	Utility.Peep.Creep.addAnimation(self, "animation-walk", "Tinkerer_Walk")
	Utility.Peep.Creep.addAnimation(self, "animation-die", "Tinkerer_Die")
	Utility.Peep.Creep.addAnimation(self, "animation-attack", "Tinkerer_Attack")
	Utility.Peep.Creep.addAnimation(self, "animation-fly", "Tinkerer_Fly")

	Utility.Peep.Creep.applySkin(
		self,
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"Tinkerer/Tinkerer.lua")

	Utility.Peep.equipXWeapon(self, "Tinkerer_Attack_MedicalSaw")

	Creep.ready(self, director, game)
end

return BaseTinkerer
