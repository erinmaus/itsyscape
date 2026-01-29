--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/DodgeCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Config = require "ItsyScape.Game.Config"
local MagicWeapon = require "ItsyScape.Game.MagicWeapon"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"
local RangedWeapon = require "ItsyScape.Game.RangedWeapon"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Color = require "ItsyScape.Graphics.Color"
local Peep = require "ItsyScape.Peep.Peep"
local Cortex = require "ItsyScape.Peep.Cortex"
local CombatDodgeBehavior = require "ItsyScape.Peep.Behaviors.CombatDodgeBehavior"
local DodgeCooldownBehavior = require "ItsyScape.Peep.Behaviors.DodgeCooldownBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TargetPositionBehavior = require "ItsyScape.Peep.Behaviors.TargetPositionBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local MovementCortex = require "ItsyScape.Peep.Cortexes.MovementCortex"
local Tile = require "ItsyScape.World.Tile"

local DodgeCortex = Class(Cortex)
DodgeCortex.OFFSET = Vector(0, 1.5, 0)

function DodgeCortex:new()
	Cortex.new(self)

	self:require(MovementBehavior)
	self:require(PositionBehavior)

	self.aura = {}

	self._filter = Callback.bind(self.filter, self)
end

function DodgeCortex:matchPeep(peep)
 	return Cortex.matchPeep(self, peep) and (peep:hasBehavior(DodgeCooldownBehavior) or peep:hasBehavior(CombatDodgeBehavior))
end

function DodgeCortex:showDodgeAura(peep)
	local dodge = peep:getBehavior(CombatDodgeBehavior)
	if not dodge then
		return
	end

	local position = Utility.Peep.getPosition(peep)
	local targetPosition = position + dodge.direction * dodge.maximumDistance

	local aura = Utility.spawnPropAtPosition(peep, "Dodge", position:get())
	if not aura then
		return
	end

	local auraPeep = aura:getPeep()
	Utility.Peep.setRotation(auraPeep, Quaternion.lookAt(position, targetPosition, Vector.UNIT_Y))

	local weapon = Utility.Peep.getEquippedWeapon(peep, true)
	local innerColor, outerColor
	if not weapon or Class.isCompatibleType(weapon, MeleeWeapon) then
		innerColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.dodgeAura.melee.inner"))
		outerColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.dodgeAura.melee.outer"))
	elseif Class.isCompatibleType(weapon, MagicWeapon) then
		innerColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.dodgeAura.magic.inner"))
		outerColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.dodgeAura.magic.outer"))
	elseif Class.isCompatibleType(weapon, RangedWeapon) then
		innerColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.dodgeAura.archery.inner"))
		outerColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.dodgeAura.archery.outer"))
	else
		innerColor = Color(1, 1, 0)
		outerColor = Color(1, 0, 0)
	end
	auraPeep:pushPoke("color", innerColor, outerColor)

	self.aura[peep] = auraPeep
end

function DodgeCortex:hideDodgeAura(peep)
	local aura = self.aura[peep]
	if aura then
		self.aura[peep] = nil
		aura:pushPoke("fade")
	end
end

function DodgeCortex:addPeep(peep)
	if peep:hasBehavior(HumanoidBehavior) and peep:hasBehavior(CombatDodgeBehavior) then
		self:showDodgeAura(peep)
	end

	Cortex.addPeep(self, peep)
end

function DodgeCortex:removePeep(peep)
	self:hideDodgeAura(peep)
	Cortex.removePeep(self, peep)
end

function DodgeCortex:filter(item, other)
	if Class.isCompatibleType(other, Tile) then
		if other:hasStaticFlag("impassable") then
			return "slide"
		end
	elseif Class.isCompatibleType(other, Peep) then
		local static = other:getBehavior(StaticBehavior)
		if static and static.type == StaticBehavior.IMPASSABLE then
			return "slide"
		end
	end

	return false
end

function DodgeCortex:accumulateVelocity(peep, value)
	for effect in peep:getEffects(require "ItsyScape.Peep.Effects.MovementEffect") do
		value = effect:applyToVelocity(value)
	end

	return value
end

function DodgeCortex:updatePeepCooldown(peep, delta)
	local cooldown = peep:getBehavior(DodgeCooldownBehavior)
	if not cooldown then
		return
	end

	cooldown.cooldown = math.max((cooldown.cooldown or 0) - delta, 0)
	if cooldown.cooldown <= 0 then
		peep:removeBehavior(DodgeCooldownBehavior)
	end
end

function DodgeCortex:updateDodge(peep, delta)
	local dodge = peep:getBehavior(CombatDodgeBehavior)
	local movement = peep:getBehavior(MovementBehavior)
	if not (dodge and movement) then
		return
	end

	if dodge.speed <= 0 or dodge.direction:getLengthSquared() == 0 then
		peep:removeBehavior(CombatDodgeBehavior)
		return
	end

	if dodge.currentDistance >= dodge.maximumDistance then
		peep:removeBehavior(CombatDodgeBehavior)
		return
	end

	local layer = Utility.Peep.getLayer(peep)
	local world = self:getDirector():getCortex(MovementCortex):getWorld(layer)
	if not world and world:has(peep) then
		peep:removeBehavior(CombatDodgeBehavior)
		return
	end

	local velocity = dodge.direction * dodge.speed
	velocity = self:accumulateVelocity(peep, velocity)

	local velocitySlice = velocity * delta
	local distance = velocitySlice:getLength()
	if distance <= 0 then
		peep:removeBehavior(CombatDodgeBehavior)
		return
	end

	local position = Utility.Peep.getPosition(peep)
	local goalX, goalZ = position.x + velocitySlice.x, position.z + velocitySlice.z
	local nextX, nextZ, collisions = world:move(peep, goalX, goalZ, self._filter)

	local map = Utility.Peep.getMap(peep)
	local finalPosition = Vector(nextX, map:getInterpolatedHeight(nextX, nextZ) + movement.float, nextZ)
	local finalDistance = Vector(position.x, 0, position.z):distance(Vector(nextX, 0, nextZ))

	Utility.Peep.setPosition(peep, finalPosition)
	dodge.currentDistance = dodge.currentDistance + finalDistance

	if #collisions > 0 or finalDistance == 0 then
		peep:removeBehavior(CombatDodgeBehavior)
		return
	end

	peep:removeBehavior(TargetTileBehavior)
	peep:removeBehavior(TargetPositionBehavior)
end

function DodgeCortex:updateAura(peep)
	if not peep:hasBehavior(CombatDodgeBehavior) then
		self:hideDodgeAura(peep)
		return
	end

	local aura = self.aura[peep]
	if aura then
		Utility.Peep.setPosition(aura, Utility.Peep.getPosition(peep) + self.OFFSET)
	elseif peep:hasBehavior(CombatDodgeBehavior) then
		self:showDodgeAura(peep)
	end
end

function DodgeCortex:update(delta)
	local game = self:getDirector():getGameInstance()

	for peep in self:iterate() do
		self:updatePeepCooldown(peep, delta)
		self:updateDodge(peep, delta)

		if peep:hasBehavior(HumanoidBehavior) then
			self:updateAura(peep)
		end
	end
end

return DodgeCortex
