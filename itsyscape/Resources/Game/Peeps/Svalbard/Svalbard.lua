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
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local EquipmentBonusesBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBonusesBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local CreepActorAnimatorCortex = require "ItsyScape.Peep.Cortexes.CreepActorAnimatorCortex"

local Svalbard = Class(Creep)
Svalbard.WEAPONS = {
	{
		weapon = "Svalbard_Attack_Melee",
		animation = "Resources/Game/Animations/Svalbard_Attack_Melee/Script.lua",
		bonuses = "Attack (Melee)",
		specials = {
			{
				weapon = "Svalbard_Special_Melee",
				animation = "Resources/Game/Animations/Svalbard_Special_Melee/Script.lua",
				bonuses = "Special Attack (Melee)"
			}
		}
	},
	{
		weapon = "Svalbard_Attack_Magic",
		animation = "Resources/Game/Animations/Svalbard_Attack_Magic/Script.lua",
		bonuses = "Attack (Magic)",
		specials = {
			{
				weapon = "Svalbard_Special_Dragonfyre",
				animation = "Resources/Game/Animations/Svalbard_Special_Dragonfyre/Script.lua",
				bonuses = "Special Attack (Dragonfyre)"
			},
			{
				weapon = "Svalbard_Special_Magic",
				animation = "Resources/Game/Animations/Svalbard_Special_Magic/Script.lua",
				bonuses = "Special Attack (Magic)"
			}
		}
	},
	{
		weapon = "Svalbard_Attack_Archery",
		animation = "Resources/Game/Animations/Svalbard_Attack_Archery/Script.lua",
		bonuses = "Attack (Archery)",
		specials = {
			{
				weapon = "Svalbard_Special_Archery",
				animation = "Resources/Game/Animations/Svalbard_Special_Archery/Script.lua",
				bonuses = "Special Attack (Archery)"
			}
		}
	}
}

Svalbard.ORGAN_TRANSITION = {
	{
		threshold = 0,
		skins = {
			[Equipment.PLAYER_SLOT_SELF] = "Body",
			[Equipment.PLAYER_SLOT_BODY] = "Flesh",
			[Equipment.PLAYER_SLOT_HEAD] = "Head",
		}
	},
	{
		threshold = 500,
		skins = {
			[Equipment.PLAYER_SLOT_SELF] = "Body_Organless1",
			[Equipment.PLAYER_SLOT_BODY] = "Flesh",
			[Equipment.PLAYER_SLOT_HEAD] = "Head",
		}
	},
	{
		threshold = 1000,
		skins = {
			[Equipment.PLAYER_SLOT_SELF] = "Body_Organless2",
			[Equipment.PLAYER_SLOT_BODY] = false,
			[Equipment.PLAYER_SLOT_HEAD] = "Head",
		}
	},
	{
		threshold = 2000,
		skins = {
			[Equipment.PLAYER_SLOT_SELF] = "Body_Organless2",
			[Equipment.PLAYER_SLOT_BODY] = false,
			[Equipment.PLAYER_SLOT_HEAD] = "Head_Skinless",
		}
	}
}

Svalbard.ROAR_COOLDOWN = 1
Svalbard.LAND_COOLDOWN = 3

Svalbard.ORGAN_DAMAGE = 1000

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
	self:addPoke('equipSpecialWeapon')
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

		local position = self:getBehavior(PositionBehavior).position
		local organs = Utility.spawnActorAtPosition(
			self,
			"Svalbard_Organs",
			position.x, position.y, position.z, 0)

		if organs then
			organs:getPeep():poke('boss', self)
		else
			Log.warn("Couldn't spawn organs!")
		end

		Log.info("Boss fight started.")
		self.fightStarted = true
	end
end

function Svalbard:onVomitAdventurer(attack)
	local target = attack:getAggressor()
	if target then
		local position = Utility.Peep.getPosition(target)

		local actor = Utility.spawnActorAtPosition(
			self,
			"Svalbard_PartiallyDigestedAdventurer",
			position.x, position.y, position.z, 2)
		if actor then
			Utility.Peep.attack(actor:getPeep(), target)
		end
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
	else
		Log.warn("Svalbard has no armor equipped.")
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
	else
		Log.warn("Svalbard has no weapon equipped.")
	end

	Log.info("Svalbard's equipment bonuses updated.")
end

function Svalbard:onEquipArmor(armorName)
	self.armorName = armorName
	self:recalculateEquipmentBonuses()
end

function Svalbard:onEquipRandomSpecialWeapon()
	local specials
	for i = 1, #Svalbard.WEAPONS do
		local weapon = Svalbard.WEAPONS[i]
		if weapon.weapon == self.weaponID then
			specials = weapon.specials
			break
		end
	end

	if not specials then
		Log.warn("Can't equip random special weapon; current weapon '%s' not in weapon list.", self.weaponID)
		return
	elseif #specials == 0 then
		Log.warn("Can't equip random special weapon; current weapon '%s' has no specials.", self.weaponID)
		return
	end

	local weaponIndex = math.random(1, #specials)
	local weapon = specials[weaponIndex].weapon

	Utility.Peep.equipXWeapon(self, weapon)
	Log.info("Equipped special weapon '%s'.", weapon)

	self:applyCooldown(Svalbard.ROAR_COOLDOWN)
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
			self.weaponID = xWeapon:getID()
			return
		end
	end

	if Class.isCompatibleType(xWeapon, Weapon) then
		Log.warn("Couldn't update Svalbard's weapon bonuses; XWeapon '%s' not found.", xWeapon:getID())
	else
		Log.error("XWeapon not provided.")
	end
end

function Svalbard:equip(xWeapon, weapons)
	self:setXWeapon(xWeapon, weapons)
	self:setXWeaponAnimation(xWeapon, weapons)
	self:recalculateEquipmentBonuses()
end

function Svalbard:onEquipXWeapon(xWeapon)
	self:equip(xWeapon, Svalbard.WEAPONS)
end

function Svalbard:onEquipSpecialWeapon(xWeapon)
	local specials
	if Class.isCompatibleType(xWeapon, Weapon) then
		for i = 1, #Svalbard.WEAPONS do
			local weapon = Svalbard.WEAPONS[i]
			for j = 1, #weapon.specials do
				if weapon.specials[j].weapon == xWeapon:getID() then
					specials = weapon.specials
					break
				end
			end
		end

		if not specials then
			Log.warn("Special XWeapon '%s' not found.", xWeapon:getID())
		else
			self:equip(xWeapon, specials)
		end
	else
		Log.error("XWeapon not provided.")
	end

end

function Svalbard:damageSkin(damage, skins)
	for i = #skins, 1, -1 do
		local skin = skins[i]
		if damage >= skin.threshold then
			self:applyDamagedSkin(skin.skins)
			break
		end
	end
end

function Svalbard:applyDamagedSkin(skins)
	local actor = self:getBehavior(ActorReferenceBehavior).actor

	for slot, skin in pairs(skins) do
		if skin == false then
			local existingSkin = actor:getSkin(slot)
			if existingSkin then
				actor:setSkin(slot, false, existingSkin.skin)
				Log.info("Cleared skin slot %d ('%s').", slot, existingSkin.skin:getFilename())
			end
		else
			local filename = string.format("Resources/Game/Skins/Svalbard/%s.lua", skin)
			local cacheRef = CacheRef("ItsyScape.Game.Skin.ModelSkin", filename)
			actor:setSkin(slot, 0, cacheRef)
			Log.info("Set skin slot %d to %s.", slot, skin)
		end
	end
end

function Svalbard:onOrgansHit(damage)
	self:damageSkin(damage, Svalbard.ORGAN_TRANSITION)
end

function Svalbard:onOrgansDie()
	self:poke('hit', AttackPoke {
		damage = Svalbard.ORGAN_DAMAGE
	})
end

function Svalbard:onFly()
	local animation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Svalbard_Fly/Script.lua")

	local actor = self:getBehavior(ActorReferenceBehavior).actor
	actor:playAnimation(
		'x-svalbard-fly',
		CreepActorAnimatorCortex.WALK_PRIORITY + 1,
		animation)
end

function Svalbard:onLand()
	local animation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Svalbard_Idle/Script.lua")

	local actor = self:getBehavior(ActorReferenceBehavior).actor
	actor:playAnimation(
		'x-svalbard-fly',
		0,
		animation,
		true)

	self:applyCooldown(Svalbard.LAND_COOLDOWN)
end

function Svalbard:onSummonStorm()
	local _, _, layer = Utility.Peep.getTile(self)
	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Trailer_Svalbard_Storm', 'Fungal', {
		gravity = { 0, -10, 0 },
		wind = { -10, 0, 0 },
		colors = {
			{ 1, 1, 1, 1 }
		},
		minHeight = 20,
		maxHeight = 25,
		heaviness = 2,
		init = false
	})

	self:applyStormDebuffToAggressors()
end

function Svalbard:applyStormDebuffToAggressors()
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local actor = self:getBehavior(ActorReferenceBehavior).actor
	local hits = director:probe(self:getLayerName(), function(p)
		local target = self:getBehavior(CombatTargetBehavior)
		return target.actor == actor or p:hasBehavior(PlayerBehavior)
	end)

	local resource = gameDB:getResource("SvalbardSnowArmor", "Effect")
	for i = 1, #hits do
		Utility.Peep.applyEffect(hits[i], resource, false)
	end
end

function Svalbard:onClearStorm()
	local _, _, layer = Utility.Peep.getTile(self)
	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Trailer_Svalbard_Storm', nil)
end


function Svalbard:update(...)
	Creep.update(self, ...)
	Utility.Peep.face3D(self)
end

return Svalbard
