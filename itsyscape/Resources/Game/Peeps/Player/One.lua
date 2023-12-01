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
local BossStateProvider = require "ItsyScape.Game.BossStateProvider"
local DreamStateProvider = require "ItsyScape.Game.DreamStateProvider"
local KeyItemStateProvider = require "ItsyScape.Game.KeyItemStateProvider"
local PlayerEquipmentStateProvider = require "ItsyScape.Game.PlayerEquipmentStateProvider"
local PlayerInventoryStateProvider = require "ItsyScape.Game.PlayerInventoryStateProvider"
local BankInventoryStateProvider = require "ItsyScape.Game.BankInventoryStateProvider"
local PlayerStatsStateProvider = require "ItsyScape.Game.PlayerStatsStateProvider"
local QuestStateProvider = require "ItsyScape.Game.QuestStateProvider"
local SailingItemStateProvider = require "ItsyScape.Game.SailingItemStateProvider"
local Equipment = require "ItsyScape.Game.Equipment"
local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
local PlayerInventoryProvider = require "ItsyScape.Game.PlayerInventoryProvider"
local PlayerShipInventoryProvider = require "ItsyScape.Game.PlayerShipInventoryProvider"
local Stats = require "ItsyScape.Game.Stats"
local Color = require "ItsyScape.Graphics.Color"
local Peep = require "ItsyScape.Peep.Peep"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local GenderBehavior = require "ItsyScape.Peep.Behaviors.GenderBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local HumanPlayerBehavior = require "ItsyScape.Peep.Behaviors.HumanPlayerBehavior"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local One = Class(Peep)
One.PENDING_ANALYTIC_LEVEL_UP_PERIOD_SECONDS = 5
One.PENDING_ANALYTIC_XP_GAIN_PERIOD_SECONDS = 30

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
	movement.maxSpeed = 12
	movement.maxAcceleration = 12
	movement.decay = 0.5
	movement.velocityMultiplier = 1
	movement.accelerationMultiplier = 1
	movement.stoppingForce = 3

	local inventory = self:getBehavior(InventoryBehavior)
	inventory.inventory = PlayerInventoryProvider(self)
	inventory.bank = BankInventoryProvider(self)
	inventory.ship = PlayerShipInventoryProvider(self)

	local equipment = self:getBehavior(EquipmentBehavior)
	equipment.equipment = EquipmentInventoryProvider(self)

	Utility.Peep.makeHuman(self)
	Utility.Peep.makeAttackable(self, false)

	self:addPoke('actionFailed')
	self:addPoke('initiateAttack')
	self:addPoke('receiveAttack')
	self:addPoke('resourceHit')
	self:addPoke('resourceObtained')
	self:addPoke('changeWardrobe')
	self:addPoke('transferItemTo')
	self:addPoke('transferItemFrom')
	self:addPoke('equipItem')
	self:addPoke('dequipItem')
	self:addPoke('travel')
	self:addPoke('walk')
	self:addPoke('bootstrapComplete')
	self:addPoke('endGame')
	self:addPoke('moveInstance')
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
			actor:unsetSkin(e.slot, skins[i].priority, skins[i].skin)
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

	local stats = self:getBehavior(StatsBehavior)
	stats.stats = Stats("Player.One", director:getGameDB(), 99)

	local inventory = self:getBehavior(InventoryBehavior)
	director:getItemBroker():addProvider(inventory.inventory)
	director:getItemBroker():addProvider(inventory.bank)

	local equipment = self:getBehavior(EquipmentBehavior)
	director:getItemBroker():addProvider(equipment.equipment)

	local storage = director:getPlayerStorage(self):getRoot()
	if storage:get("filename") and storage:hasSection("Location") then
		local name = storage:getSection("Player"):getSection("Info"):get("name")
		self:setName(name or self:getName())

		local gender = self:getBehavior(GenderBehavior)
		if storage:getSection("Player"):getSection("Info"):hasSection("Gender") then
			local g = storage:getSection("Player"):getSection("Info"):getSection("Gender")
			gender.gender = g:get("gender")
			gender.description = g:get("description") or "Non-Binary"
			gender.pronounsPlural = g:get("plural")
			gender.pronouns[GenderBehavior.PRONOUN_SUBJECT] = g:get("subject")
			gender.pronouns[GenderBehavior.PRONOUN_OBJECT] = g:get("object")
			gender.pronouns[GenderBehavior.PRONOUN_POSSESSIVE] = g:get("possessive")
			gender.pronouns[GenderBehavior.FORMAL_ADDRESS] = g:get("formal")
		end

		stats.stats:load(Utility.Peep.getStorage(self))

		-- Ensure player always has at least 10 HP.
		if stats.stats:getSkill("Constitution"):getBaseLevel() < 10 then
			stats.stats:getSkill("Constitution"):setXP(Curve.XP_CURVE:compute(10))
		end

		local combat = self:getBehavior(CombatStatusBehavior)
		combat.currentHitpoints = stats.stats:getSkill("Constitution"):getWorkingLevel()
		combat.maximumHitpoints = stats.stats:getSkill("Constitution"):getWorkingLevel()
		combat.currentPrayer = stats.stats:getSkill("Faith"):getWorkingLevel()
		combat.maximumPrayer = stats.stats:getSkill("Faith"):getWorkingLevel()
	else
		stats.stats = Stats("Player.One", director:getGameDB())
		stats.stats:getSkill("Constitution"):setXP(Curve.XP_CURVE:compute(10))

		local combat = self:getBehavior(CombatStatusBehavior)
		combat.currentHitpoints = 10
		combat.maximumHitpoints = 10
		combat.currentPrayer = 1
		combat.maximumPrayer = 1
	end

	self.pendingLevelUps = {}
	self.pendingXP = {}
	self.pendingXPTime = love.timer.getTime()
	self.pendingLevelTime = love.timer.getTime()

	stats.stats.onLevelUp:register(function(_, skill)
		self.pendingLevelUps[skill:getName()] = skill:getBaseLevel()
		self.pendingLevelUpTime = love.timer.getTime()

		Utility.UI.openInterface(self, "LevelUpNotification", false, skill)
	end)
	stats.stats.onXPGain:register(function(_, skill, xp)
		if xp > 0 then
			self.pendingXP[skill:getName()] = (self.pendingXP[skill:getName()] or 0) + xp
			self.pendingXPTime = love.timer.getTime()
		end
	end)

	stats.stats:getSkill("Constitution").onLevelUp:register(function(skill, oldLevel)
		local difference = math.max(skill:getBaseLevel() - oldLevel, 0)

		local combat = self:getBehavior(CombatStatusBehavior)
		combat.maximumHitpoints = combat.maximumHitpoints + difference
		combat.currentHitpoints = combat.currentHitpoints + difference
	end)
	stats.stats:getSkill("Constitution").onBoost:register(function(skill)
		local combat = self:getBehavior(CombatStatusBehavior)
		combat.maximumHitpoints = skill:getWorkingLevel()
	end)
	stats.stats:getSkill("Faith").onLevelUp:register(function(skill, oldLevel)
		local difference = math.max(skill:getBaseLevel() - oldLevel, 0)

		local combat = self:getBehavior(CombatStatusBehavior)
		combat.maximumPrayer = combat.maximumPrayer + difference
		combat.currentPrayer = combat.currentPrayer + difference
	end)
	stats.stats:getSkill("Faith").onBoost:register(function(skill)
		local combat = self:getBehavior(CombatStatusBehavior)
		combat.maximumPrayer = skill:getWorkingLevel()
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
		local index = love.math.random(1, #t)
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

	local skin = director:getPlayerStorage(self):getRoot():getSection("Player"):getSection("Skin")
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
	self:getState():addProvider("Boss", BossStateProvider(self))
	self:getState():addProvider("Dream", DreamStateProvider(self))
	self:getState():addProvider("Quest", QuestStateProvider(self))
	self:getState():addProvider("SailingItem", SailingItemStateProvider(self))
	self:getState():addProvider("Skill", PlayerStatsStateProvider(self))
	self:getState():addProvider("Item", PlayerEquipmentStateProvider(self))
	self:getState():addProvider("Item", PlayerInventoryStateProvider(self))
	self:getState():addProvider("Item", BankInventoryStateProvider(self))

	self.deadTimer = math.huge
	self.rezzTimer = math.huge

	Peep.ready(self, director, game)

	self.oldCombatLevel = Utility.Combat.getCombatLevel(self)
end

function One:onTransferItemTo(e)
	if e.purpose ~= 'bank-withdraw' and e.purpose ~= self then
		self:interruptUI()
	end
end

function One:onTransferItemFrom(e)
	if e.purpose ~= 'bank-deposit' and e.purpose ~= 'uninterrupted-drop' then
		self:interruptUI()
	end
end

function One:onInterrupt()
	self:removeBehavior(TargetTileBehavior)
end

function One:onTravel(e)
	self:interruptUI()

	self:interrupt(true)
end

function One:onWalk(e)
	self:interruptUI()
end

function One:onHeal(p)
	self:interruptUI()
end

function One:onHit(p)
	self:interruptUI()
end

function One:onMiss(p)
	self:interruptUI()
end

function One:onDie(p)
	self:interrupt(true)

	local movement = self:getBehavior(MovementBehavior)
	movement.velocity = Vector.ZERO
	movement.acceleration = Vector.ZERO

	self:interruptUI()

	Utility.Peep.notify(self, "Oh no, you died! You'll respawn at the last place you slept.")
	Utility.save(self, false, true, "Aaah!")

	self.deadTimer = 5
	self:addBehavior(DisabledBehavior)

	Analytics:died(self, p and p:getAggressor())
end

function One:onResurrect()
	Analytics:rezzed(self)

	self.rezzTimer = 2

	-- Keep them dead until we rezz ourselves
	local combatStatus = self:getBehavior(CombatStatusBehavior)
	combatStatus.dead = true
end

function One:updatePendingAnalytics(force)
	if self.pendingLevelTime + One.PENDING_ANALYTIC_LEVEL_UP_PERIOD_SECONDS < love.timer.getTime() or force then
		if next(self.pendingLevelUps) ~= nil then
			Analytics:gotLevelUp(self, self.pendingLevelUps)
			table.clear(self.pendingLevelUps)
		end
	end

	if self.pendingXPTime + One.PENDING_ANALYTIC_XP_GAIN_PERIOD_SECONDS < love.timer.getTime() or force then
		if next(self.pendingXP) ~= nil then
			Analytics:gainedXP(self, self.pendingXP)
			table.clear(self.pendingXP)
		end
	end

	if self.lastActionPerformed then
		if not self.previousActionPerformed or self.previousActionPerformed:getID() ~= self.lastActionPerformed:getID() then
			Analytics:performedAction(self, self.lastActionPerformed)

			self.previousActionPerformed = self.lastActionPerformed
			self.lastActionPerformed = nil
		end
	end

	if self.lastActionFailed then
		if not self.previousActionFailed or self.previousActionFailed:getID() ~= self.lastActionFailed:getID() then
			Analytics:failedAction(self, self.lastActionFailed)

			self.previousActionFailed = self.lastActionFailed
			self.lastActionFailed = nil
		end
	end

	local combatLevel = Utility.Combat.getCombatLevel(self)
	if self.oldCombatLevel and self.oldCombatLevel < combatLevel then
		self.oldCombatLevel = combatLevel
		Analytics:gainedCombatLevel(self)
	end
end

function One:update(...)
	Peep.update(self, ...)

	local delta = self:getDirector():getGameInstance():getDelta()

	do
		local combatStatus = self:getBehavior(CombatStatusBehavior)
		if combatStatus.dead or
		   (self.rezzTimer > 0 and self.rezzTimer ~= math.huge)
		then
			self:interrupt(true)
		end

		if self.rezzTimer > 0 then
			self.rezzTimer = self.rezzTimer - delta
			if self.rezzTimer < 0 then
				self:removeBehavior(DisabledBehavior)
				self.rezzTimer = math.huge
				combatStatus.dead = false
			end
		end
	end

	self:updatePendingAnalytics()

	self.deadTimer = self.deadTimer - delta
	if self.deadTimer < 0 then
		self.deadTimer = math.huge

		local combatStatus = self:getBehavior(CombatStatusBehavior)
		combatStatus.currentHitpoints = combatStatus.maximumHitpoints
		combatStatus.currentPrayer = combatStatus.maximumPrayer

		local director = self:getDirector()
		local stage = director:getGameInstance():getStage()
		local storage = director:getPlayerStorage(self):getRoot()
		local spawn = storage:getSection("Spawn")
		if spawn and spawn:get("name") then
			stage:movePeep(
				self,
				spawn:get("name"),
				Vector(spawn:get("x"), spawn:get("y"), spawn:get("z")),
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

	if _DEBUG and love.keyboard.isDown('f9') then
		local i, j, k = Utility.Peep.getTile(self)
		Log.info("Peep: tile = (%d, %d; %d)", i, j, k)

		local position = Utility.Peep.getAbsolutePosition(self)
		Log.info("Peep: position = (%0.2f, %0.2f; %0.2f)", position.x, position.y, position.z)
	end
end

function One:onEndGame()
	self:updatePendingAnalytics(true)
end

function One:onPoof()
	Log.info('Player poofed.')
end

function One:onActionFailed(e)
	Utility.UI.openInterface(self, "Notification", false, e)
	self.lastActionFailed = e.action
end

function One:onActionPerformed(e)
	local combatStatus = self:getBehavior(CombatStatusBehavior)
	if (self.deadTimer > 0 and self.deadTimer ~= math.huge) or
	   (self.rezzTimer > 0 and self.rezzTimer ~= math.huge) or
	   (combatStatus and combatStatus.dead) or
	   self:hasBehavior(DisabledBehavior)
	then
		self:interrupt(true)
	end

	self.lastActionPerformed = e.action
end

function One:interruptUI()
	if self:getIsReady() and not self:hasBehavior(DisabledBehavior) then
		local game = self:getDirector():getGameInstance()
		game:getUI():interrupt(self)
	end
end

function One:onBootstrapComplete()
	self.didCompleteBootstrap = true
	Utility.UI.openGroup(self, Utility.UI.Groups.WORLD)
end

function One:onMoveInstance(previousInstance, currentInstance)
	local player = Utility.Peep.getPlayerModel(self)
	if not player then
		Log.error("Player '%s' does not have a player behavior.", self:getName())
		return
	end

	if self.didCompleteBootstrap then
		Analytics:traveled(self, (previousInstance and previousInstance:getFilename()), (currentInstance and currentInstance:getFilename()))
	end

	if not previousInstance or not currentInstance then
		return
	end

	local stage = self:getDirector()
	stage = stage and stage:getGameInstance():getStage()
	if not stage then
		Log.error("Player '%s' (%d) could not get stage.", self:getName(), player:getID())
		return
	end

	for _, actor in previousInstance:iterateActors() do
		local peep = actor:getPeep()
		local follower = peep:getBehavior(FollowerBehavior)
		if follower and follower.followAcrossMaps and follower.playerID == player:getID() then
			stage:movePeep(peep, currentInstance, Utility.Peep.getPosition(self))

			Log.info(
				"Moved player '%s' (%d) follower actor '%s' (id = %d) from instance %s (%d) to instance %s (%d).",
				self:getName(), player:getID(),
				actor:getName(), actor:getID(),
				previousInstance:getFilename(), previousInstance:getID(),
				currentInstance:getFilename(), currentInstance:getID())
		end
	end
end

return One
