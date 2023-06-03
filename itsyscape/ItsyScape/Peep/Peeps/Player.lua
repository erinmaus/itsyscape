--------------------------------------------------------------------------------
-- ItsyScape/Peep/Peeps/Player.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Curve = require "ItsyScape.Game.Curve"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local AttackCommand = require "ItsyScape.Game.AttackCommand"
local PlayerEquipmentStateProvider = require "ItsyScape.Game.PlayerEquipmentStateProvider"
local PlayerInventoryStateProvider = require "ItsyScape.Game.PlayerInventoryStateProvider"
local PlayerStatsStateProvider = require "ItsyScape.Game.PlayerStatsStateProvider"
local Equipment = require "ItsyScape.Game.Equipment"
local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
local PlayerInventoryProvider = require "ItsyScape.Game.PlayerInventoryProvider"
local Stats = require "ItsyScape.Game.Stats"
local Peep = require "ItsyScape.Peep.Peep"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local LootDropperBehavior = require "ItsyScape.Peep.Behaviors.LootDropperBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local MapObjectBehavior = require "ItsyScape.Peep.Behaviors.MapObjectBehavior"
local MappResourceBehavior = require "ItsyScape.Peep.Behaviors.MappResourceBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local Player = Class(Peep)

function Player:new(resource, ...)
	Peep.new(self, ...)

	self:addBehavior(ActorReferenceBehavior)
	self:addBehavior(MovementBehavior)
	self:addBehavior(PositionBehavior)
	self:addBehavior(SizeBehavior)
	self:addBehavior(LootDropperBehavior)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1.5, 2, 1.5)

	Utility.Peep.makeAttackable(self)
	Utility.Peep.makeMashina(self)
	Utility.Peep.makeHuman(self)
	Utility.Peep.makeSkiller(self)
	Utility.Peep.addStats(self, Curve.MAX)
	Utility.Peep.addEquipment(self)
	Utility.Peep.addInventory(self)

	self:addPoke('transferItemTo')
	self:addPoke('transferItemFrom')
	self:addPoke('spawnItem')
	self:addPoke('spawnEquipment')
	self:addPoke('walk')

	Utility.Peep.setResource(self, resource)

	Utility.Peep.makeDummy(self)
end

function Player:ready(director, game)
	Peep.ready(self, director, game)

	Utility.Peep.setNameMagically(self)
end

return Player
