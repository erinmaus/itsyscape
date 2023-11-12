--------------------------------------------------------------------------------
-- Resources/Peeps/MagmaSnail/MagmaSnail.lua
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
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local MagmaSnail = Class(Creep)

function MagmaSnail.hasIronItemInInventory(peep, inventory)
	local gameDB = peep:getDirector():getGameDB()

	local broker = peep:getDirector():getItemBroker()
	for item in broker:iterateItems(inventory) do
		local resource = gameDB:getResource(item:getID(), "Item")
		local metal = gameDB:getRecord("ResourceCategory", { Key = "Metal", Resource = resource })
		if metal then
			metal = metal:get("Value")

			if metal and metal:lower() == "iron" then
				return true
			end
		end
	end
end

function MagmaSnail.probeForIronItem(peep)
	local hasIronItem = false

	local equipment = peep:getBehavior(EquipmentBehavior)
	if equipment and equipment.equipment then
		equipment = equipment.equipment
		hasIronItem = hasIronItem or MagmaSnail.hasIronItemInInventory(peep, equipment)
	end

	local inventory = peep:getBehavior(InventoryBehavior)
	if inventory and inventory.inventory then
		inventory = inventory.inventory
		hasIronItem = hasIronItem or MagmaSnail.hasIronItemInInventory(peep, inventory)
	end

	return hasIronItem
end

function MagmaSnail:new(resource, name, ...)
	Creep.new(self, resource, name or 'MagmaSnail_Base', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1.5, 1.5, 1.5)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 1
	movement.maxAcceleration = 1

	local status = self:getBehavior(CombatStatusBehavior)
	status.deathPoofTime = 30
end

function MagmaSnail:onDie()
	self:poke('resurrect')

	local gameDB = self:getDirector():getGameDB()
	local resource = gameDB:getResource("MagmaSnail_Dead", "Peep")
	Utility.Peep.setResource(self, resource)

	self:silence('receiveAttack', Utility.Peep.Attackable.aggressiveOnReceiveAttack)
end

function MagmaSnail:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Snail.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/MagmaSnail_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/MagmaSnail_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/MagmaSnail_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/MagmaSnail_Attack/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	local defendAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/MagmaSnail_Defend/Script.lua")
	self:addResource("animation-defend", defendAnimation)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/MagmaSnail/MagmaSnail.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

	Creep.ready(self, director, game)

	Utility.Peep.equipXWeapon(self, "MagmaSnailRock")
end

return MagmaSnail
