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
local KeyItemStateProvider = require "ItsyScape.Game.KeyItemStateProvider"
local PlayerEquipmentStateProvider = require "ItsyScape.Game.PlayerEquipmentStateProvider"
local PlayerInventoryStateProvider = require "ItsyScape.Game.PlayerInventoryStateProvider"
local BankInventoryStateProvider = require "ItsyScape.Game.BankInventoryStateProvider"
local PlayerStatsStateProvider = require "ItsyScape.Game.PlayerStatsStateProvider"
local Equipment = require "ItsyScape.Game.Equipment"
local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
local PlayerInventoryProvider = require "ItsyScape.Game.PlayerInventoryProvider"
local Stats = require "ItsyScape.Game.Stats"
local Color = require "ItsyScape.Graphics.Color"
local Peep = require "ItsyScape.Peep.Peep"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local GenderBehavior = require "ItsyScape.Peep.Behaviors.GenderBehavior"
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
	self:addBehavior(GenderBehavior)
	self:addBehavior(HumanoidBehavior)
	self:addBehavior(HumanPlayerBehavior)
	self:addBehavior(MovementBehavior)
	self:addBehavior(InventoryBehavior)
	self:addBehavior(PositionBehavior)
	self:addBehavior(SizeBehavior)
	self:addBehavior(StanceBehavior)
	self:addBehavior(StatsBehavior)
	self:addBehavior(CombatStatusBehavior)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 2, 1)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 18
	movement.maxAcceleration = 18
	movement.decay = 0.7
	movement.velocityMultiplier = 1.05
	movement.accelerationMultiplier = 1.05
	movement.stoppingForce = 0.2

	local inventory = self:getBehavior(InventoryBehavior)
	inventory.inventory = PlayerInventoryProvider(self)
	inventory.bank = BankInventoryProvider(self)

	local equipment = self:getBehavior(EquipmentBehavior)
	equipment.equipment = EquipmentInventoryProvider(self)

	Utility.Peep.makeHuman(self)
	Utility.Peep.makeAttackable(self, false)

	self:addPoke('actionFailed')
	self:addPoke('initiateAttack')
	self:addPoke('receiveAttack')
	self:addPoke('resourceHit')
	self:addPoke('changeWardrobe')
	self:addPoke('transferItemTo')
	self:addPoke('transferItemFrom')
	self:addPoke('travel')
end

function One:onChangeWardrobe(e)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	else
		return
	end

	local skins = { actor:getSkin(e.slot) }
	for i = 1, #skins do
		if skins[i].priority == e.priority then
			actor:setSkin(e.slot, false, skins[i].skin)
		end
	end

	do
		if e.type and e.filename then
			local ref = CacheRef(e.type, e.filename)
			actor:setSkin(e.slot, e.priority, ref)
		end

		local storage = self:getDirector():getPlayerStorage(self)
		storage = storage:getRoot():getSection("Player"):getSection("Skin")

		storage:getSection(e.slotName):set(e)
	end
end

function One:onRename(e)
	local storage = self:getDirector():getPlayerStorage(self)
	storage = storage:getRoot():getSection("Player"):getSection("Info")
	storage:set("name", e.name)

	self:setName(e.name)
end

function One:assign(director, key, ...)
	Peep.assign(self, director, key, ...)

	local inventory = self:getBehavior(InventoryBehavior)
	director:getItemBroker():addProvider(inventory.inventory)
	director:getItemBroker():addProvider(inventory.bank)

	local equipment = self:getBehavior(EquipmentBehavior)
	director:getItemBroker():addProvider(equipment.equipment)

	local stats = self:getBehavior(StatsBehavior)
	stats.stats = Stats("Player.One", director:getGameDB())

	local storage = director:getPlayerStorage(self):getRoot()
	if storage:get("filename") then
		local name = storage:getSection("Player"):getSection("Info"):get("name")
		self:setName(name or self:getName())

		local gender = self:getBehavior(GenderBehavior)
		if storage:getSection("Player"):getSection("Info"):hasSection("Gender") then
			local g = storage:getSection("Player"):getSection("Info"):getSection("Gender")
			gender.gender = g:get("gender")
			gender.pronouns[GenderBehavior.PRONOUN_SUBJECT] = g:get("subject")
			gender.pronouns[GenderBehavior.PRONOUN_OBJECT] = g:get("object")
			gender.pronouns[GenderBehavior.PRONOUN_POSSESSIVE] = g:get("possessive")
			gender.pronouns[GenderBehavior.FORMAL_ADDRESS] = g:get("formal")
		end

		stats.stats:load(Utility.Peep.getStorage(self))

		local combat = self:getBehavior(CombatStatusBehavior)
		combat.currentHitpoints = stats.stats:getSkill("Constitution"):getWorkingLevel()
		combat.maximumHitpoints = stats.stats:getSkill("Constitution"):getBaseLevel()
		combat.currentPrayer = stats.stats:getSkill("Faith"):getWorkingLevel()
		combat.maximumPrayer = stats.stats:getSkill("Faith"):getBaseLevel()
	else
		stats.stats = Stats("Player.One", director:getGameDB())
		stats.stats:getSkill("Constitution"):setXP(Curve.XP_CURVE:compute(10))

		local combat = self:getBehavior(CombatStatusBehavior)
		combat.currentHitpoints = 10
		combat.maximumHitpoints = 10
		combat.currentPrayer = 1
		combat.maximumPrayer = 1
	end

	stats.stats:getSkill("Constitution").onLevelUp:register(function(skill, oldLevel)
		local difference = math.max(skill:getBaseLevel() - oldLevel, 0)

		local combat = self:getBehavior(CombatStatusBehavior)
		combat.maximumHitpoints = combat.maximumHitpoints + difference
		combat.currentHitpoints = combat.currentHitpoints + difference
	end)
	stats.stats:getSkill("Faith").onLevelUp:register(function(skill, oldLevel)
		local difference = math.max(skill:getBaseLevel() - oldLevel, 0)

		local combat = self:getBehavior(CombatStatusBehavior)
		combat.maximumPrayer = combat.maximumPrayer + difference
		combat.currentPrayer = combat.currentPrayer + difference
	end)

	do
		local combat = self:getBehavior(CombatStatusBehavior)
		combat.maxChaseDistance = math.huge
	end
end

One.SKINS = {
	head = {
		slot = Equipment.PLAYER_SLOT_HEAD,
		priority = Equipment.SKIN_PRIORITY_BASE,
		"Resources/Game/Skins/PlayerKit1/Head/Light.lua",
		"Resources/Game/Skins/PlayerKit1/Head/Medium.lua",
		"Resources/Game/Skins/PlayerKit1/Head/Dark.lua",
		"Resources/Game/Skins/PlayerKit1/Head/Minifig.lua"
	},
	eyes = {
		slot = Equipment.PLAYER_SLOT_HEAD,
		priority = math.huge,
		"Resources/Game/Skins/PlayerKit1/Eyes/Eyes.lua"
	},
	feet = {
		slot = Equipment.PLAYER_SLOT_FEET,
		priority = Equipment.SKIN_PRIORITY_BASE,
		"Resources/Game/Skins/PlayerKit1/Shoes/Boots1.lua"
	},
	body = {
		slot = Equipment.PLAYER_SLOT_BODY,
		priority = Equipment.SKIN_PRIORITY_BASE,
		"Resources/Game/Skins/PlayerKit1/Shirts/Red.lua",
		"Resources/Game/Skins/PlayerKit1/Shirts/Green.lua",
		"Resources/Game/Skins/PlayerKit1/Shirts/Blue.lua",
		"Resources/Game/Skins/PlayerKit1/Shirts/Yellow.lua"
	},
	hands = {
		slot = Equipment.PLAYER_SLOT_HANDS,
		priority = Equipment.SKIN_PRIORITY_BASE,
		"Resources/Game/Skins/PlayerKit1/Hands/BlackGloves.lua"
	},
	hair = {
		slot = Equipment.PLAYER_SLOT_HEAD,
		priority = Equipment.SKIN_PRIORITY_ACCENT,
		"Resources/Game/Skins/PlayerKit1/Hair/Afro.lua",
		"Resources/Game/Skins/PlayerKit1/Hair/Enby.lua",
		"Resources/Game/Skins/PlayerKit1/Hair/Emo.lua",
		"Resources/Game/Skins/PlayerKit1/Hair/Fade.lua"
	}
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

	local SLOTS = {
		'hair',
		'eyes',
		'head',
		'body',
		'hands',
		'feet'
	}

	local skin = director:getPlayerStorage():getRoot():getSection("Player"):getSection("Skin")
	for i = 1, #SLOTS do
		local slot = SLOTS[i]
		if skin:hasSection(slot) then
			local s = skin:getSection(slot)
			self:onChangeWardrobe({
				slot = s:get('slot'),
				slotName = s:get('slotName'),
				priority = s:get('priority'),
				name = s:get('name'),
				filename = s:get('filename'),
				type = s:get('type')
			})
		else
			self:onChangeWardrobe({
				slot = One.SKINS[slot].slot,
				slotName = slot,
				priority = One.SKINS[slot].priority,
				name = 'Default',
				filename = roll(One.SKINS[slot]),
				type = "ItsyScape.Game.Skin.ModelSkin"
			})
		end
	end

	self:getState():addProvider("KeyItem", KeyItemStateProvider(self))
	self:getState():addProvider("Skill", PlayerStatsStateProvider(self))
	self:getState():addProvider("Item", PlayerEquipmentStateProvider(self))
	self:getState():addProvider("Item", PlayerInventoryStateProvider(self))
	self:getState():addProvider("Item", BankInventoryStateProvider(self))

	self.deadTimer = math.huge

	Peep.ready(self, director, game)
end

function One:onDropItem(e)
	local game = self:getDirector():getGameInstance()
	game:getUI():interrupt(self)
end

function One:onTransferItemTo(e)
	if e.purpose ~= 'bank-withdraw' then
		local game = self:getDirector():getGameInstance()
		game:getUI():interrupt(self)
	end
end

function One:onTransferItemFrom(e)
	if e.purpose ~= 'bank-deposit' then
		local game = self:getDirector():getGameInstance()
		game:getUI():interrupt(self)
	end
end

function One:onWalk(e)
	local game = self:getDirector():getGameInstance()
	game:getUI():interrupt(self)
end

function One:onHeal(p)
	local game = self:getDirector():getGameInstance()
	game:getUI():interrupt(self)
end

function One:onHit(p)
	local game = self:getDirector():getGameInstance()
	game:getUI():interrupt(self)
end

function One:onMiss(p)
	local game = self:getDirector():getGameInstance()
	game:getUI():interrupt(self)
end

function One:onDie(p)
	self:getCommandQueue():clear()

	local movement = self:getBehavior(MovementBehavior)
	movement.velocity = Vector.ZERO
	movement.acceleration = Vector.ZERO

	local game = self:getDirector():getGameInstance()
	game:getUI():interrupt(self)

	Utility.save(self, false, true, "Aaah!")

	self.deadTimer = 5
end

function One:update(...)
	Peep.update(self, ...)

	self.deadTimer = self.deadTimer - self:getDirector():getGameInstance():getDelta()
	if self.deadTimer < 0 then
		self.deadTimer = math.huge

		local combatStatus = self:getBehavior(CombatStatusBehavior)
		combatStatus.currentHitpoints = combatStatus.maximumHitpoints
		combatStatus.currentPrayer = combatStatus.maximumPrayer

		local director = self:getDirector()
		local stage = director:getGameInstance():getStage()
		local storage = director:getPlayerStorage(self):getRoot()
		local location = storage:getSection("Location")
		if location and location:get("name") then
			stage:movePeep(
				self,
				location:get("name"),
				Vector(location:get("x"), location:get("y"), location:get("z")),
				true)
		else
			stage:movePeep(
				self,
				"IsabelleIsland_Tower",
				"Anchor_StartGame",
				true)
		end

		self:poke('resurrect', {})
	end
end

function One:onPoof()
	Log.error('Player poofed.')
end

function One:onActionFailed(e)
	Utility.UI.openInterface(self, "Notification", false, e)
end

return One
