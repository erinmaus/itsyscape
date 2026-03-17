--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Peep/Dummy.lua
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
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local Player = require "ItsyScape.Peep.Peeps.Player"

local Dummy = {}
Dummy.TIERS = {
	{
		base = "Staff",
		"Dinky",
		"Feeble",
		"Moldy",
		"Springy",
		"Tense",
		"Scary"
	},
	{
		base = "Longbow",
		"Puny",
		"Bendy",
		"Petty",
		"Shaky",
		"Spindly",
		"Terrifying"
	},
	{
		base = "Zweihander",
		"Bronze",
		"Iron",
		"BlackenedIron",
		"Mithril",
		"Adamant",
		"Itsy"
	}
}

Dummy.ANIMATIONS = {
	"Human_AttackStaffMagic_1",
	"Human_AttackBowRanged_1",
	"Human_AttackZweihanderSlash_1"
}

Dummy.WEAPONS = {
	"Dummy_Staff",
	"Dummy_Bow",
	"Dummy_Sword"
}

function Dummy.getAttackCooldown(peep)
	local gameDB = peep:getDirector():getGameDB()
	local resource = Utility.Peep.getResource(peep)

	local dummy = gameDB:getRecord("Dummy", { Resource = resource })
	local cooldown = dummy and dummy:get("AttackCooldown")
	return ((not cooldown or cooldown == 0) and nil) or cooldown
end

function Dummy.getAttackRange(peep)
	local gameDB = peep:getDirector():getGameDB()
	local resource = Utility.Peep.getResource(peep)

	local dummy = gameDB:getRecord("Dummy", { Resource = resource })
	local distance = dummy and dummy:get("AttackDistance")
	return ((not distance or distance == 0) and nil) or distance
end

function Dummy.getProjectile(peep)
	local gameDB = peep:getDirector():getGameDB()
	local resource = Utility.Peep.getResource(peep)

	local dummy = gameDB:getRecord("Dummy", { Resource = resource })
	local projectile = dummy and dummy:get("AttackProjectile")
	
	return projectile
end

function Dummy:onFinalize()
	local gameDB = self:getDirector():getGameDB()
	local resource = Utility.Peep.getResource(self)

	if not resource then
		return
	end

	local dummy = gameDB:getRecord("Dummy", {
		Resource = resource
	})

	if not dummy then
		return
	end

	local hitpoints = dummy:get("Hitpoints")
	if hitpoints > 0 then
		local _, c = self:addBehavior(CombatStatusBehavior)
		c.currentHitpoints = hitpoints
		c.maximumHitpoints = hitpoints
	end

	local chaseDistance = dummy:get("ChaseDistance")
	if chaseDistance > 0 then
		local _, c = self:addBehavior(CombatStatusBehavior)
		c.maxChaseDistance = chaseDistance
	end

	local size = dummy:get("Size")
	if size > 0 then
		local _, s = self:addBehavior(ScaleBehavior)
		s.scale = Vector(size)
	end

	local style = dummy:get("CombatStyle")
	local tier = math.max(math.floor(dummy:get("Tier") / 10), 1)

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor
	if not actor then
		return
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Human.lskel")
	actor:setBody(body)

	Utility.Peep.Human.applySkin(
		self,
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Head/Dummy.lua",
		{ Utility.Peep.Human.Palette.SKIN_MEDIUM })
	Utility.Peep.Human.applySkin(
		self,
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shirts/Dummy.lua",
		{ Utility.Peep.Human.Palette.SKIN_MEDIUM })
	Utility.Peep.Human.applySkin(
		self,
		Equipment.PLAYER_SLOT_HEAD,
		math.huge,
		"PlayerKit2/Eyes/Eyes.lua",
		{ Utility.Peep.Human.Palette.ACCENT_PINK, Utility.Peep.Human.Palette.EYE_BLACK, Utility.Peep.Human.Palette.EYE_WHITE })
	Utility.Peep.Human.applySkin(
		self,
		Equipment.PLAYER_SLOT_HANDS,
		Equipment.SKIN_PRIORITY_BASE, 
		"PlayerKit2/Hands/Dummy.lua",
		{ Utility.Peep.Human.Palette.SKIN_MEDIUM })
	Utility.Peep.Human.applySkin(
		self,
		Equipment.PLAYER_SLOT_FEET,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shoes/Dummy.lua",
		{ Utility.Peep.Human.Palette.SKIN_MEDIUM })

	if dummy:get("Shield") ~= "" and not Class.isCompatibleType(self, require "ItsyScape.Peep.Peeps.Player") then
		local shieldSkin = CacheRef(
			"ItsyScape.Game.Skin.ModelSkin",
			"Resources/Game/Skins/Wooden/Shield.lua")
		actor:setSkin(Equipment.PLAYER_SLOT_RIGHT_HAND, Equipment.SKIN_PRIORITY_EQUIPMENT, shieldSkin)
	end

	if Class.isCompatibleType(self, Player) then
		local broker = self:getDirector():getItemBroker()
		local equipment = self:getBehavior(EquipmentBehavior)

		local shield = dummy:get("Shield")
		if shield ~= "" then
			local transaction = broker:createTransaction()
			transaction:addParty(equipment.equipment)
			transaction:spawn(equipment.equipment, shield, 1, false)
			transaction:commit()
		end

		local weapon = dummy:get("Weapon")
		if weapon ~= "" then
			local transaction = broker:createTransaction()
			transaction:addParty(equipment.equipment)
			transaction:spawn(equipment.equipment, weapon, 1, false)
			transaction:commit()
		end
	else
		local walkAnimation = CacheRef(
			"ItsyScape.Graphics.AnimationResource",
			"Resources/Game/Animations/Human_Walk_1/Script.lua")
		self:addResource("animation-walk", walkAnimation)
		local idleAnimation = CacheRef(
			"ItsyScape.Graphics.AnimationResource",
			"Resources/Game/Animations/Human_Idle_1/Script.lua")
		self:addResource("animation-idle", idleAnimation)
		local dieAnimation = CacheRef(
			"ItsyScape.Graphics.AnimationResource",
			"Resources/Game/Animations/Human_Die_1/Script.lua")
		self:addResource("animation-die", dieAnimation)

		local animation = Dummy.ANIMATIONS[style]
		if animation then
			local attackAnimation = CacheRef(
				"ItsyScape.Graphics.AnimationResource",
				string.format("Resources/Game/Animations/%s/Script.lua", animation))
			self:addResource("animation-attack", attackAnimation)
		end

		local skins = Dummy.TIERS[style]
		local skin = skins and skins[tier]

		if skins and skin then
			local weaponSkin = CacheRef(
				"ItsyScape.Game.Skin.ModelSkin",
				string.format("Resources/Game/Skins/%s/%s.lua", skin, skins.base))
			actor:setSkin(Equipment.PLAYER_SLOT_RIGHT_HAND, Equipment.SKIN_PRIORITY_EQUIPMENT, weaponSkin)
		end

		local shield = dummy:get("Shield")
		if shield ~= "" then
			local shieldSkin = CacheRef(
				"ItsyScape.Game.Skin.ModelSkin",
				"Resources/Game/Skins/Wooden/Shield.lua")
			actor:setSkin(Equipment.PLAYER_SLOT_RIGHT_HAND, Equipment.SKIN_PRIORITY_EQUIPMENT, shieldSkin)

			Utility.Peep.equipXShield(self, shield)
		end

		local weapon = dummy:get("Weapon")
		if weapon ~= "" then
			Utility.Peep.equipXWeapon(self, weapon)
		else
			weapon = Dummy.WEAPONS[style]
			if weapon then
				Utility.Peep.equipXWeapon(self, weapon)
			end
		end
	end
end

return Dummy
