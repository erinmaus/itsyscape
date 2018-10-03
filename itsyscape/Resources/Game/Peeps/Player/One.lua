--------------------------------------------------------------------------------
-- Resources/Peeps/Player/One.lua
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
local Curve = require "ItsyScape.Game.Curve"
local BankInventoryProvider = require "ItsyScape.Game.BankInventoryProvider"
local PlayerEquipmentStateProvider = require "ItsyScape.Game.PlayerEquipmentStateProvider"
local PlayerInventoryStateProvider = require "ItsyScape.Game.PlayerInventoryStateProvider"
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
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local HumanPlayerBehavior = require "ItsyScape.Peep.Behaviors.HumanPlayerBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local One = Class(Peep)

function One:new(...)
	Peep.new(self, 'Player', ...)

	self:addBehavior(ActorReferenceBehavior)
	self:addBehavior(EquipmentBehavior)
	self:addBehavior(HumanoidBehavior)
	self:addBehavior(HumanPlayerBehavior)
	self:addBehavior(MovementBehavior)
	self:addBehavior(InventoryBehavior)
	self:addBehavior(PositionBehavior)
	self:addBehavior(SizeBehavior)
	self:addBehavior(StanceBehavior)
	self:addBehavior(StatsBehavior)
	self:addBehavior(CombatStatusBehavior)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 16
	movement.maxAcceleration = 16
	movement.decay = 0.6
	movement.velocityMultiplier = 1
	movement.accelerationMultiplier = 1
	movement.stoppingForce = 3

	local inventory = self:getBehavior(InventoryBehavior)
	inventory.inventory = PlayerInventoryProvider(self)
	inventory.bank = BankInventoryProvider(self)

	local equipment = self:getBehavior(EquipmentBehavior)
	equipment.equipment = EquipmentInventoryProvider(self)

	Utility.Peep.makeHuman(self)
	Utility.Peep.makeAttackable(self, false)
end

function One:assign(director, key, ...)
	Peep.assign(self, director, key)

	local inventory = self:getBehavior(InventoryBehavior)
	director:getItemBroker():addProvider(inventory.inventory)
	director:getItemBroker():addProvider(inventory.bank)

	local equipment = self:getBehavior(EquipmentBehavior)
	director:getItemBroker():addProvider(equipment.equipment)

	local stats = self:getBehavior(StatsBehavior)
	stats.stats = Stats("Player.One", director:getGameDB())
	stats.stats:getSkill("Constitution"):setXP(Curve.XP_CURVE:compute(10))
	stats.stats:getSkill("Constitution").onLevelUp:register(function(skill, oldLevel)
		local difference = math.max(skill:getBaseLevel() - oldLevel, 0)

		local combat = self:getBehavior(CombatStatusBehavior)
		combat.maximumHitpoints = combat.maximumHitpoints + difference
		combat.currentHitpoints = combat.currentHitpoints + difference
	end)

	stats.stats.onXPGain:register(function(_, skill, xp)
		local actor = self:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			actor = actor.actor
			actor:flash("XPPopup", 1, skill:getName(), xp)
		end
	end)

	local combat = self:getBehavior(CombatStatusBehavior)
	combat.currentHitpoints = 10
	combat.maximumHitpoints = 10
	combat.maxChaseDistance = math.huge

	-- DEBUG
	do
		local t = director:getItemBroker():createTransaction()
		t:addParty(inventory.inventory)
		t:spawn(inventory.inventory, "BronzePickaxe", 1)
		t:spawn(inventory.inventory, "IsabelleIsland_AbandonedMine_WroughtBronzeKey", 1)
		t:commit()
	end

	do
		local t = director:getItemBroker():createTransaction()
		t:addParty(inventory.bank)
		t:spawn(inventory.bank, "BronzePlatebody", 100, true)
		t:spawn(inventory.bank, "BronzeGloves", 100, true)
		t:spawn(inventory.bank, "BronzeBoots", 100, true)
		t:spawn(inventory.bank, "BronzeHelmet", 100, true)
		t:spawn(inventory.bank, "AmuletOfYendor", 100, true)
		t:spawn(inventory.bank, "ErrinTheHeathensHat", 10, true)
		t:spawn(inventory.bank, "ErrinTheHeathensBoots", 10, true)
		t:spawn(inventory.bank, "ErrinTheHeathensGloves", 10, true)
		t:spawn(inventory.bank, "ErrinTheHeathensCoat", 10, true)
		t:spawn(inventory.bank, "ErrinTheHeathensStaff", 10, true)
		t:spawn(inventory.bank, "AirRune", 2000000)
		t:spawn(inventory.bank, "TinCan", 100, true)
		t:spawn(inventory.bank, "CopperBadge", 100, true)
		t:commit()
	end

	self:addPoke('initiateAttack')
	self:addPoke('receiveAttack')
	self:addPoke('resourceHit')

	self:getState():addProvider("Skill", PlayerStatsStateProvider(self))
	self:getState():addProvider("Item", PlayerEquipmentStateProvider(self))
	self:getState():addProvider("Item", PlayerInventoryStateProvider(self))
end

One.HEADS = {
	"Resources/Game/Skins/PlayerKit1/Head/Light.lua",
	"Resources/Game/Skins/PlayerKit1/Head/Medium.lua",
	"Resources/Game/Skins/PlayerKit1/Head/Dark.lua",
	"Resources/Game/Skins/PlayerKit1/Head/Minifig.lua"
}

One.EYES = {
	"Resources/Game/Skins/PlayerKit1/Eyes/Eyes.lua"
}

One.SHOES = {
	"Resources/Game/Skins/PlayerKit1/Shoes/Boots1.lua"
}

One.SHIRTS = {
	"Resources/Game/Skins/PlayerKit1/Shirts/Red.lua",
	"Resources/Game/Skins/PlayerKit1/Shirts/Green.lua",
	"Resources/Game/Skins/PlayerKit1/Shirts/Blue.lua",
	"Resources/Game/Skins/PlayerKit1/Shirts/Yellow.lua"
}

One.HAIR = {
	"Resources/Game/Skins/PlayerKit1/Hair/Afro.lua",
	"Resources/Game/Skins/PlayerKit1/Hair/Enby.lua",
	"Resources/Game/Skins/PlayerKit1/Hair/Emo.lua",
	"Resources/Game/Skins/PlayerKit1/Hair/Fade.lua"
}

function One:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local function roll(t)
		local index = math.random(1, #t)
		return t[index]
	end

	actor:setBody(CacheRef("ItsyScape.Game.Body", "Resources/Game/Bodies/Human.lskel"))
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, math.huge, CacheRef("ItsyScape.Game.Skin.ModelSkin", roll(One.EYES)))

	local head = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		roll(One.HEADS))
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, 0, head)
	local hair = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		roll(One.HAIR))
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, 0, hair)
	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		roll(One.SHIRTS))
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)
	local hands = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Bronze/Gloves.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HANDS, 0, hands)
	local feet = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		roll(One.SHOES))
	actor:setSkin(Equipment.PLAYER_SLOT_FEET, 0, feet)
end

function One:onDropItem(e)
	local game = self:getDirector():getGameInstance()
	game:getUI():interrupt()
end

function One:onTransferItemTo(e)
	local game = self:getDirector():getGameInstance()
	game:getUI():interrupt()
end

function One:onTransferItemFrom(e)
	local game = self:getDirector():getGameInstance()
	game:getUI():interrupt()
end

function One:onWalk(e)
	local game = self:getDirector():getGameInstance()
	game:getUI():interrupt()
end

function One:onHeal(p)
	local game = self:getDirector():getGameInstance()
	game:getUI():interrupt()
end

function One:onHit(p)
	local game = self:getDirector():getGameInstance()
	game:getUI():interrupt()
end

function One:onMiss(p)
	local game = self:getDirector():getGameInstance()
	game:getUI():interrupt()
end

function One:onDie(p)
	self:getCommandQueue():clear()

	local movement = self:getBehavior(MovementBehavior)
	movement.velocity = Vector.ZERO
	movement.acceleration = Vector.ZERO

	local game = self:getDirector():getGameInstance()
	game:getUI():interrupt()
end

function One:update(...)
	Peep.update(self, ...)

	local c = 0
	for k, v in pairs(self.commandQueues) do
		c = c + 1
	end
end

return One
