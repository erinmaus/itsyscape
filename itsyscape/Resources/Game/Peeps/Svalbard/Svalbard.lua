--------------------------------------------------------------------------------
-- Resources/Peeps/Svalbard/Svalbard.lua
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
local Weapon = require "ItsyScape.Game.Weapon"
local Equipment = require "ItsyScape.Game.Equipment"
local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local EquipmentBonusesBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBonusesBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local Svalbard = Class(Creep)
Svalbard.WEAPONS = {
	{
		weapon = "Svalbard_Attack_Melee",
		animation = "Resources/Game/Animations/Svalbard_Attack_Melee/Script.lua",
		bonuses = "Attack (Melee)"
	},
	{
		weapon = "Svalbard_Attack_Magic",
		animation = "Resources/Game/Animations/Svalbard_Attack_Magic/Script.lua",
		bonuses = "Attack (Magic)"
	},
	{
		weapon = "Svalbard_Attack_Archery",
		animation = "Resources/Game/Animations/Svalbard_Attack_Archery/Script.lua",
		bonuses = "Attack (Archery)"
	}
}

Svalbard.SPECIALS = {
	-- {
	-- 	weapon = require("Resources.Game.Items.X_Svalbard_Special_Magic.Logic"),
	-- 	animation = "Resources/Game/Animations/Svalbard_Attack_Archery/Script.lua"
	-- },
	-- {
	-- 	weapon = require("Resources.Game.Items.X_Svalbard_Special_Melee.Logic"),
	-- 	animation = "Resources/Game/Animations/Svalbard_Special_Melee/Script.lua"
	-- }
}

Svalbard.ROAR_COOLDOWN = 3
Svalbard.FLY_COOLDOWN  = 3

function Svalbard:new(resource, name, ...)
	Creep.new(self, resource, name or 'Svalbard', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2.5, 1.5, 7)

	self:addBehavior(RotationBehavior)
	local _, scale = self:addBehavior(ScaleBehavior)
	scale.scale = Vector(1.5, 1.5, 1.5)

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = 10000
	status.maximumHitpoints = 10000
	status.maxChaseDistance = math.huge

	self:addPoke('equipXWeapon')
end

function Svalbard:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local movement = self:getBehavior(MovementBehavior)
	movement.stoppingForce = 0.5
	movement.maxSpeed = 8
	movement.maxAcceleration = 6

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Svalbard.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Svalbard_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Svalbard_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Svalbard_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Svalbard/Body.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_SELF, 0, body)

	local flesh = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Svalbard/Flesh.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, flesh)

	local head = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Svalbard/Head.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, 0, head)

	local wings = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Svalbard/Wings.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BACK, 0, wings)

	Creep.ready(self, director, game)

	self:onEquipArmor("Base")
	self:onEquipRandomWeapon()
end

function Svalbard:onBoss()
	if not self.fightStarted then
		Utility.UI.openInterface(
			Utility.Peep.getPlayer(self),
			"BossHUD",
			false,
			self)
		self.fightStarted = true
	end
end

function Svalbard:onDie()
	self.fightStarted = false
end

function Svalbard:onPreSpecial()
	local animation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Svalbard_PreSpecial/Script.lua")

	local actor = self:getBehavior(ActorReferenceBehavior).actor
	actor:playAnimation('x-svalbard-pre-special', 0, animation)
end

function Svalbard:onSpecial()
	local mashina = self:getBehavior(MashinaBehavior)
	mashina.currentState = 'special'

	Log.info("SPECIAL ATTACK uwu! >:3")
end

function Svalbard:recalculateEquipmentBonuses()
	local gameDB = self:getDirector():getGameDB()
	
	self:addBehavior(EquipmentBonusesBehavior)

	local bonuses = self:getBehavior(EquipmentBonusesBehavior).bonuses

	if self.armorName then
		local record = gameDB:getRecord("Equipment", {
			Resource = Utility.Peep.getResource(self),
			Name = self.armorName
		})

		if not record then
			Log.warn("Can't find '%s' armor for Svalbard.", self.armorName)
		else
			for i = 1, #EquipmentInventoryProvider.STATS do
				local stat = EquipmentInventoryProvider.STATS[i]
				bonuses[stat] = record:get(stat) or 0
			end
		end
	end

	if self.weaponName then
		local record = gameDB:getRecord("Equipment", {
			Resource = Utility.Peep.getResource(self),
			Name = self.weaponName
		})

		if not record then
			Log.warn("Can't find '%s' weapon for Svalbard.", self.weaponName)
		else
			for i = 1, #EquipmentInventoryProvider.STATS do
				local stat = EquipmentInventoryProvider.STATS[i]
				bonuses[stat] = bonuses[stat] + (record:get(stat) or 0)
			end
		end
	end

	Log.info("Svalbard's equipment bonuses updated.")
end

function Svalbard:onEquipArmor(armorName)
	self.armorName = armorName
	self:recalculateEquipmentBonuses()
end

function Svalbard:onEquipRandomWeapon()
	local weaponIndex = math.random(1, #Svalbard.WEAPONS)
	local weapon = Svalbard.WEAPONS[weaponIndex].weapon

	Utility.Peep.equipXWeapon(self, weapon)
	Log.info("Equipped weapon '%s'.", weapon)

	self:playRoarAnimation()
	self:applyCooldown(Svalbard.ROAR_COOLDOWN)
end

function Svalbard:playRoarAnimation()
	local animation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Svalbard_Roar/Script.lua")

	local actor = self:getBehavior(ActorReferenceBehavior).actor
	actor:playAnimation('combat', math.huge, animation, true)
end

function Svalbard:applyCooldown(duration)
	local _, cooldown = self:addBehavior(AttackCooldownBehavior)

	cooldown.cooldown = duration
	cooldown.ticks = self:getDirector():getGameInstance():getCurrentTick()
end

function Svalbard:setXWeaponAnimation(xWeapon, weapons)
	local xWeaponType = Class.getType(xWeapon)
	for i = 1, #weapons do
		local weapon = weapons[i]
		local weaponID = weapon.weapon
		local weaponType = Utility.Peep.getXWeapon(self:getDirector():getGameInstance(), weaponID)
		if Class.isType(weaponType, xWeaponType) then
			local attackAnimation = CacheRef("ItsyScape.Graphics.AnimationResource", weapon.animation)
			self:addResource("animation-attack", attackAnimation)

			Log.info("Set attack animation to '%s'.", weapon.animation)
			return
		end
	end

	if Class.isCompatibleType(xWeapon, Weapon) then
		Log.warn("Couldn't switch Svalbard's attack animation; XWeapon '%s' not found.", xWeapon:getID())
	else
		Log.error("XWeapon not provided.")
	end
end

function Svalbard:setXWeapon(xWeapon, weapons)
	local xWeaponType = Class.getType(xWeapon)
	for i = 1, #weapons do
		local weaponID = weapons[i].weapon
		local weaponType = Utility.Peep.getXWeapon(self:getDirector():getGameInstance(), weaponID)
		if Class.isType(weaponType, xWeaponType) then
			self.weaponName = weapons[i].bonuses
			return
		end
	end

	if Class.isCompatibleType(xWeapon, Weapon) then
		Log.warn("Couldn't update Svalbard's weapon bonuses; XWeapon '%s' not found.", xWeapon:getID())
	else
		Log.error("XWeapon not provided.")
	end
end

function Svalbard:onEquipXWeapon(xWeapon)
	self:setXWeapon(xWeapon, Svalbard.WEAPONS)
	self:setXWeaponAnimation(xWeapon, Svalbard.WEAPONS)
	self:recalculateEquipmentBonuses()
end

function Svalbard:update(...)
	Creep.update(self, ...)
	Utility.Peep.face3D(self)
end

return Svalbard
