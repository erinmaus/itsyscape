--------------------------------------------------------------------------------
-- ItsyScape/Peep/Peeps/Creep.lua
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
local Mapp = require "ItsyScape.GameDB.Mapp"
local AttackCommand = require "ItsyScape.Game.AttackCommand"
local PlayerStatsStateProvider = require "ItsyScape.Game.PlayerStatsStateProvider"
local Stats = require "ItsyScape.Game.Stats"
local Peep = require "ItsyScape.Peep.Peep"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local CreepBehavior = require "ItsyScape.Peep.Behaviors.CreepBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local LootDropperBehavior = require "ItsyScape.Peep.Behaviors.LootDropperBehavior"
local MapObjectBehavior = require "ItsyScape.Peep.Behaviors.MapObjectBehavior"
local MappResourceBehavior = require "ItsyScape.Peep.Behaviors.MappResourceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local Creep = Class(Peep)

function Creep:new(resource, ...)
	Peep.new(self, ...)

	self:addBehavior(ActorReferenceBehavior)
	self:addBehavior(CreepBehavior)
	self:addBehavior(LootDropperBehavior)
	self:addBehavior(MovementBehavior)
	self:addBehavior(SizeBehavior)
	self:addBehavior(PositionBehavior)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 1, 1)

	Utility.Peep.makeAttackable(self)
	Utility.Peep.makeMashina(self)
	Utility.Peep.addStats(self)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 12
	movement.maxAcceleration = 8
	movement.decay = 0.7
	movement.velocityMultiplier = 1
	movement.accelerationMultiplier = 1
	movement.stoppingForce = 4

	Utility.Peep.setResource(self, resource)
end

function Creep:ready(director, game)
	Peep.ready(self, director, game)

	Utility.Peep.setNameMagically(self)
end

return Creep
