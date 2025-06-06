--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/BaseCombatHUDController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local sort = require "batteries.sort"
local Class = require "ItsyScape.Common.Class"
local CombatPower = require "ItsyScape.Game.CombatPower"
local CombatSpell = require "ItsyScape.Game.CombatSpell"
local Config = require "ItsyScape.Game.Config"
local Curve = require "ItsyScape.Game.Curve"
local Equipment = require "ItsyScape.Game.Equipment"
local ItemInstance = require "ItsyScape.Game.ItemInstance"
local Spell = require "ItsyScape.Game.Spell"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Variables = require "ItsyScape.Game.Variables"
local RPCState = require "ItsyScape.Game.RPC.State"
local Mapp = require "ItsyScape.GameDB.Mapp"
local DebugStats = require "ItsyScape.Graphics.DebugStats"
local Controller = require "ItsyScape.UI.Controller"
local Effect = require "ItsyScape.Peep.Effect"
local ActiveSpellBehavior = require "ItsyScape.Peep.Behaviors.ActiveSpellBehavior"
local AggressiveBehavior = require "ItsyScape.Peep.Behaviors.AggressiveBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"
local PowerRechargeBehavior = require "ItsyScape.Peep.Behaviors.PowerRechargeBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local ZealEffect = require "ItsyScape.Peep.Effects.ZealEffect"

local BaseCombatHUDController = Class(Controller)

local UpdateDebugStats = Class(DebugStats)

function UpdateDebugStats:process(func, node, ...)
	return node[func](node, ...)
end

BaseCombatHUDController.MAX_TURN_ORDER = 10

BaseCombatHUDController.COMBAT_SKILLS = {
	"Constitution",
	"Attack",
	"Strength",
	"Magic",
	"Wisdom",
	"Archery",
	"Dexterity",
	"Defense",
	"Faith"
}

local CONFIG = Variables.load("Resources/Game/Variables/Combat.json")
local BASE_COST_PATH = Variables.Path("zealCost", Variables.PathParameter("tier"), "baseCost")

function BaseCombatHUDController:new(peep, director)
	Controller.new(self, peep, director)

	self:bindToPlayer(peep)
	self.isDirty = true
	self.needsRefresh = false
	self.isOpen = false

	self.spells = {}
	self.castableSpells = {}
	self.offensiveSpells = {}

	self.prayers = {}
	self.prayerEffects = {}
	self.offensivePrayers = {}
	self.usablePrayers = {}
	self.turns = {}
	self.food = {}

	self.powers = {}
	self:_pullPowers()

	self.currentOpenedThingies = {}

	self.updateDebugStats = UpdateDebugStats()
end

function BaseCombatHUDController:bindToPlayer(peep)
	local stats = peep:getBehavior(StatsBehavior)
	if stats and stats.stats then
		stats = stats.stats

		self._onLevelUp = function(stats, skill, oldLevel)
			self.isDirty = true
		end
		stats.onLevelUp:register(self._onLevelUp)
	else
		Log.error("Could not bind to stats of '%s'.", peep:getName())
	end
end

function BaseCombatHUDController:unbindToPlayer(peep)
	local stats = peep:getBehavior(StatsBehavior)
	if stats and stats.stats then
		stats = stats.stats

		stats.onLevelUp:unregister(self._onLevelUp)
	end
end

function BaseCombatHUDController:close()
	Controller.close(self)
	self:unbindToPlayer(self:getPeep())
end

function BaseCombatHUDController:getStorage(section)
	local storage = self:getDirector():getPlayerStorage(self:getPeep())
	return storage:getRoot():getSection("CombatHUD"):getSection(section)
end

function BaseCombatHUDController:poke(actionID, actionIndex, e)
	if actionID == "activateOffensivePower" then
		self:activate(self.currentState.powers.offensive, e)
	elseif actionID == "activateDefensivePower" then
		self:activate(self.currentState.powers.defensive, e)
	elseif actionID == "castSpell" then
		self:castSpell(e)
	elseif actionID == "pray" then
		self:pray(e)
	elseif actionID == "deleteEquipment" then
		self:deleteEquipment(e)
	elseif actionID == "saveEquipment" then
		self:saveEquipment(e)
	elseif actionID == "addEquipmentSlot" then
		self:addEquipmentSlot(e)
	elseif actionID == "renameEquipmentSlot" then
		self:renameEquipmentSlot(e)
	elseif actionID == "deleteEquipmentSlot" then
		self:deleteEquipmentSlot(e)
	elseif actionID == "equip" then
		self:equip(e)
	elseif actionID == "eat" then
		self:eat(e)
	elseif actionID == "changeStance" then
		self:changeStance(e)
	elseif actionID == "show"then
		self:show(e)
	elseif actionID == "hide" then
		self:hide(e)
	elseif actionID == "openThingies"then
		self:openThingies(e)
	elseif actionID == "closeThingies"then
		self:closeThingies(e)
	elseif actionID == "open" then
		self:toggle(e, true)
	elseif actionID == "close" then
		self:toggle(e, false)
	elseif actionID == "setConfig" then
		self:setConfig(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function BaseCombatHUDController:activate(powers, e)
	local power = powers[e.index]
	if power then
		local peep = self:getPeep()
		local gameDB = self:getDirector():getGameDB()

		if power.id == self.currentState.powers.pendingID then
			peep:removeBehavior(PendingPowerBehavior)
		else
			local powerResource = gameDB:getResource(power.id, "Power")
			if powerResource then
				local PowerType = Utility.Peep.getPowerType(powerResource, gameDB)
				if PowerType then
					local power = PowerType(self:getGame(), powerResource)

					local _, b = peep:addBehavior(PendingPowerBehavior)
					b.power = power
				end
			end
		end
	end
end

function BaseCombatHUDController:useSpell()
	local peep = self:getPeep()
	local equippedWeapon = Utility.Peep.getEquippedWeapon(peep, true)
	if equippedWeapon and peep:hasBehavior(ActiveSpellBehavior) then
		local logic = self:getDirector():getItemManager():getLogic(equippedWeapon:getID())
		if logic:isCompatibleType(Weapon) then
			if logic:getStyle() == Weapon.STYLE_MAGIC then
				local s, b = peep:addBehavior(StanceBehavior)
				if s then
					b.useSpell = true
				end
			end
		end
	end
end

function BaseCombatHUDController:castSpell(e)
	local spell = self.spells[e.id]
	local peep = self:getPeep()
	if spell and spell:isCompatibleType(CombatSpell) then
		local s, b = peep:addBehavior(ActiveSpellBehavior)
		if s then
			if b.spell and b.spell:getID() == self.spells[e.id]:getID() then
				peep:removeBehavior(ActiveSpellBehavior)
			else
				b.spell = self.spells[e.id]
			end
		end

		self:useSpell()
	end
end

function BaseCombatHUDController:pray(e)
	local prayer = self.prayers[e.id]
	local peep = self:getPeep()
	if prayer then
		prayer:perform(peep:getState(), peep)
	end
end

function BaseCombatHUDController:changeStance(e)
	if e.stance == Weapon.STANCE_AGGRESSIVE or
	   e.stance == Weapon.STANCE_CONTROLLED or
	   e.stance == Weapon.STANCE_DEFENSIVE
	then
		local stance = self:getPeep():getBehavior(StanceBehavior)
		if stance then
			stance.stance = e.stance
		end
	end
end

function BaseCombatHUDController:eat(e)
	local item
	do
		local inventory = self:getPeep():getBehavior(InventoryBehavior)
		if inventory and inventory.inventory then
			local broker = inventory.inventory:getBroker()

			for i in broker:iterateItemsByKey(inventory.inventory, e.key) do
				item = i
				break
			end
		end
	end

	if not item then
		Log.error("No item at key %d", e.index)
		return
	end

	local itemResource = self:getGame():getGameDB():getResource(item:getID(), "Item")
	if itemResource then
		Utility.performAction(
			self:getGame(),
			itemResource,
			"eat",
			"inventory",
			self:getPeep():getState(), self:getPeep(), item)
	end
end

function BaseCombatHUDController:deleteEquipment(e)
	local equipmentStorage = self:getStorage("Equipment")
	equipmentStorage:getSection(e.index):removeSection(e.slot)

	self.isDirty = true
end

function BaseCombatHUDController:saveEquipment(e)
	local equipmentStorage = self:getStorage("Equipment")
	local slotsStorage = equipmentStorage:getSection(e.index)
	local slotStorage = slotsStorage:getSection(slotsStorage:length() + 1)

	local peep = self:getPeep()
	local equipment = peep:getBehavior(EquipmentBehavior)
	equipment = equipment and equipment.equipment

	if not equipment then
		Log.warn("Peep '%s' does not equipment.", peep:getName())
		return
	end

	local broker = equipment:getBroker()
	if not broker then
		Log.warn("Peep '%s' has equipment, but equipment doesn't have an item broker.", peep:getName())
		return
	end

	local index = 1
	for item in broker:iterateItems(equipment) do
		slotStorage:getSection("items"):set(index, {
			id = item:getID(),
			slot = broker:getItemKey(item)
		})

		index = index + 1
	end

	local stats
	do
		local peep = self:getPeep()
		local equipment = peep:getBehavior(EquipmentBehavior)
		equipment = equipment and equipment.equipment

		if equipment then
			stats = {}
			for name, value in equipment:getStats() do
				stats[name] = value
			end
		end
	end

	if e.icon then
		slotStorage:set("icon", e.icon)
		slotStorage:set("stats", stats)
	end

	if index == 1 then
		-- No items were added. Undo changes.
		slotsStorage:removeSection(slotsStorage:length())
	else
		self.isDirty = true
	end
end

function BaseCombatHUDController:addEquipmentSlot(e)
	local equipmentStorage = self:getStorage("Equipment")
	local slotsStorage = equipmentStorage:getSection(equipmentStorage:length() + 1)
	slotsStorage:set({
		name = string.format("More Gear", equipmentStorage:length())
	})

	self.isDirty = true
end

function BaseCombatHUDController:renameEquipmentSlot(e)
	local equipmentStorage = self:getStorage("Equipment")
	local slotsStorage = equipmentStorage:getSection(e.index)
	slotsStorage:set({
		name = e.name
	})

	self.isDirty = true
end

function BaseCombatHUDController:deleteEquipmentSlot(e)
	local equipmentStorage = self:getStorage("Equipment")
	equipmentStorage:removeSection(e.index)

	self.isDirty = true
end

function BaseCombatHUDController:equip(e)
	local equipmentStorage = self:getStorage("Equipment")
	local slotStorage = equipmentStorage:getSection(e.index):getSection(e.slot):getSection("items")

	local peep = self:getPeep()
	local gameDB = self:getDirector():getGameDB()

	for _, item in slotStorage:iterateSections() do
		local itemID = item:get("id")
		local itemInstance = Utility.Item.getItemInPeepInventory(peep, itemID)
		local itemResource = gameDB:getResource(itemID, "Item")

		if itemInstance and itemResource then
			local actions = Utility.getActions(
				self:getDirector():getGameInstance(),
				itemResource,
				'inventory')
			for i = 1, #actions do
				local actionInstance = actions[i].instance
				if actionInstance:is("equip") then
					actionInstance:perform(
						peep:getState(),
						peep,
						itemInstance)
					break
				end
			end
		end
	end
end

function BaseCombatHUDController:getConfig()
	local config = self:getStorage("Config"):get().config or {}

	local disabled = config.disabled or {}
	disabled["equipment"] = true
	disabled["spells"] = true
	disabled["prayers"] = true
	config.disabled = disabled

	return config
end

function BaseCombatHUDController:setConfig(e)
	local configStorage = self:getStorage("Config")

	configStorage:set({
		config = e.config
	})
end

function BaseCombatHUDController:getIsOpen()
	return self.isShowing
end

function BaseCombatHUDController:show(e)
	self.isShowing = true
end

function BaseCombatHUDController:hide(e)
	self.isShowing = false
end

function BaseCombatHUDController:getIsThingiesOpen(name)
	return not not self.currentOpenedThingies[name]
end

function BaseCombatHUDController:openThingies(e)
	assert(type(e.name) == "string", "thingies name must be string")

	self.currentOpenedThingies[e.name] = true
end

function BaseCombatHUDController:closeThingies(e)
	assert(type(e.name) == "string", "thingies name must be string")

	self.currentOpenedThingies[e.name] = nil
end

function BaseCombatHUDController:toggle(e, open)
	assert(Class.isCompatibleType(e.interface, Controller), "toggle is controller-to-controller and must provide the interface requesting the hide")
	self:send("toggle", open)
end

function BaseCombatHUDController:pullStateForPeep(peep)
	local gameDB = self:getDirector():getGameDB()

	local actor = peep:getBehavior(ActorReferenceBehavior)
	do
		if not actor or not actor.actor then
			return nil
		end

		actor = actor.actor
	end

	local target = peep:getBehavior(CombatTargetBehavior)
	if target then
		target = target.actor
	end

	local result = {
		actorID = actor:getID(),
		targetID = target and target:getID(),
		name = actor:getName(),
		description = actor:getDescription(),
		effects = {},
		stats = {},
		meta = {}
	}

	do
		for effect in peep:getEffects() do
			if effect:getBuffType() ~= Effect.BUFF_TYPE_NONE then
				local resource = effect:getResource()
				local e = {
					id = resource.name,
					z = resource.id.value,
					name = Utility.getName(resource, gameDB),
					description = Utility.getDescription(resource, gameDB),
					tinyDescription = effect:getDescription(),
					duration = effect:getDuration(),
					debuff = effect:getBuffType() == Effect.BUFF_TYPE_NEGATIVE,
					buff = effect:getBuffType() == Effect.BUFF_TYPE_POSITIVE
				}

				table.insert(result.effects, e)
			end
		end

		table.sort(result.effects, function(a, b) return a.z < b.z end)
	end

	do
		local status = peep:getBehavior(CombatStatusBehavior)
		if status then
			result.stats.prayer = {
				current = status.currentPrayer,
				max = status.maximumPrayer
			}

			result.stats.hitpoints = {
				current = status.currentHitpoints,
				max = status.maximumHitpoints
			}

			result.stats.zeal = {
				current = status.currentZeal,
				max = status.maximumZeal,
				tier = 0
			}

			for tier, tierName in ipairs(CombatPower.TIER_NAMES) do
				local cost = CONFIG:get(BASE_COST_PATH, "tier", tierName)

				for effect in peep:getEffects(ZealEffect) do
					cost = effect:modifyTierCost(tier, cost)
				end

				if status.currentZeal >= cost then
					result.stats.zeal.tier = tier
				else
					break
				end
			end
		else
			result.stats = {
				prayer = { current = 0, max = 0 },
				hitpoints = { current = 0, max = 0 },
				zeal = { current = 0, max = 0, tier = 0 }
			}
		end
	end

	if target then
		local weapon, item = Utility.Peep.getEquippedWeapon(peep, true)
		weapon = weapon or Weapon("Unarmed")

		local accuracy = weapon:rollAttack(peep, target:getPeep(), weapon:getBonusForStance(peep))
		local damage = weapon:rollDamage(peep, Weapon.PURPOSE_KILL, target:getPeep())

		result.dps = {
			accuracy = {
				level = accuracy:getAttackLevel(),
				stat = accuracy:getAccuracyBonus(),
				attackRoll = accuracy:getMaxAttackRoll(),
				defenseRoll = accuracy:getMaxDefenseRoll()
			},

			damage = {
				level = damage:getLevel(),
				stat = damage:getBonus(),
				damageMultiplier = damage:getDamageMultiplier(),
				min = damage:getMinHit(),
				max = damage:getMaxHit()
			},

			weapon = {
				id = item and Utility.Item.getInstanceName(item) or weapon:getWeaponType(),
			},

			bonuses = Utility.Peep.getEquipmentBonuses(peep),

			skills = {}
		}

		local stats = peep:getBehavior(StatsBehavior)
		stats = stats and stats.stats
		if stats then
			for _, skillName in ipairs(self.COMBAT_SKILLS) do
				local skill = stats:hasSkill(skillName) and stats:getSkill(skillName)
				table.insert(result.dps.skills, {
					id = skillName,
					level = skill and skill:getBaseLevel() or 1,
					boost = skill and skill:getLevelBoost() or 0
				})
			end
		end

		local stance = peep:getBehavior(StanceBehavior)
		result.stance = stance and stance.stance or Weapon.STANCE_NONE
		result.style = weapon:getStyle()
	end

	return result
end

function BaseCombatHUDController:isAttacking()
	local playerTarget
	do
		local target = self:getPeep():getBehavior(CombatTargetBehavior)
		if target and target.actor then
			playerTarget = target.actor:getPeep()
		end
	end

	return function(peep)
		local status = peep:getBehavior(CombatStatusBehavior)
		local target = peep:getBehavior(CombatTargetBehavior)

		local hasTarget = target and target.actor and target.actor:getPeep() == playerTarget
		local isPlayerTarget = peep == playerTarget
		local hasPlayerTarget = target and target.actor and target.actor:getPeep() == self:getPeep()
		local isAlive = status and not status.dead
		local canEngage = status and status.canEngage
		local isPlayer = peep == self:getPeep()

		return ((hasTarget or isPlayerTarget or hasPlayerTarget) and isAlive and canEngage) or isPlayer
	end
end

function BaseCombatHUDController:getPendingPowerID()
	local peep = self:getPeep()
	local pending = peep:getBehavior(PendingPowerBehavior)
	if pending and pending.power then
		return pending.power:getResource().name
	end

	return nil
end

function BaseCombatHUDController:getPowers()
	local result = {
		offensive = {},
		defensive = {},
		pendingID = self:getPendingPowerID()
	}

	for _, power in ipairs(self.currentOffensivePowers) do
		local p = {}
		for k, v in pairs(power) do
			p[k] = v
		end

		table.insert(result.offensive, p)
	end

	for _, power in ipairs(self.currentDefensivePowers) do
		local p = {}
		for k, v in pairs(power) do
			p[k] = v
		end

		table.insert(result.defensive, p)
	end

	return result
end

function BaseCombatHUDController:updateActiveSpell()
	local activeSpellID
	do
		local activeSpell = self:getPeep():getBehavior(ActiveSpellBehavior)
		if activeSpell and activeSpell.spell then
			activeSpellID = activeSpell.spell:getID()
		end
	end

	for i = 1, #self.offensiveSpells do
		local spell = self.offensiveSpells[i]
		if spell.id == activeSpellID then
			spell.active = true
		else
			spell.active = false
		end
	end

	self.activeSpellID = activeSpellID
end

function BaseCombatHUDController:updateSpells()
	local spells = {}

	do
		local peep = self:getPeep()
		local gameDB = self:getDirector():getGameDB()
		local brochure = gameDB:getBrochure()
		local resourceType = Mapp.ResourceType()
		brochure:tryGetResourceType("Spell", resourceType)

		local activeSpellID
		do
			local activeSpell = self:getPeep():getBehavior(ActiveSpellBehavior)
			if activeSpell and activeSpell.spell then
				activeSpellID = activeSpell.spell:getID()
			end
		end

		local zValues = {}
		for resource in brochure:findResourcesByType(resourceType) do
			local spell = self.spells[resource.name]
			if not spell then
				local TypeName = string.format("Resources.Game.Spells.%s.Spell", resource.name)
				local Type = require(TypeName)
				spell = Type(resource.name, self:getGame())
				self.spells[resource.name] = spell
			end

			if Class.isCompatibleType(spell, CombatSpell) then
				local action = spell:getAction()
				local items = {}
				local z = 0
				if action then
					for requirement in brochure:getRequirements(action) do
						local resource = brochure:getConstraintResource(requirement)
						local resourceType = brochure:getResourceTypeFromResource(resource)
						if resourceType.name == "Skill" and resource.name == "Magic" then
							z = requirement.count
						end
					end

					for input in brochure:getInputs(action) do
						local resource = brochure:getConstraintResource(input)
						local resourceType = brochure:getResourceTypeFromResource(resource)

						if resourceType.name == "Item" then
							local item = {
								count = input.count,
								name = Utility.getName(resource, gameDB)
							}

							table.insert(items, item)
						end
					end

					zValues[resource.name] = z
					table.insert(spells, {
						active = activeSpellID == spell:getID(),
						id = resource.name,
						name = Utility.getName(resource, gameDB),
						description = Utility.getDescription(resource, gameDB),
						level = Curve.XP_CURVE:getLevel(z),
						items = items
					})
				end
			end
		end

		table.sort(spells, function(a, b) return zValues[a.id] < zValues[b.id] end)
	end

	self.offensiveSpells = spells
end

function BaseCombatHUDController:getSpells()
	local result = {}

	for _, spell in ipairs(self.castableSpells) do
		local s = {}
		for k, v in pairs(spell) do
			s[k] = v
		end

		table.insert(result, s)
	end

	return result
end

function BaseCombatHUDController:updateCastableSpells()
	local spells = {}
	for i = 1, #self.offensiveSpells do
		local spell = self.offensiveSpells[i]
		local spellInstance = self.spells[spell.id]
		if spellInstance then
			local canCast = spellInstance:canCast(self:getPeep()):good()

			if canCast then
				table.insert(spells, spell)
			end
		end
	end

	if #spells ~= #self.castableSpells then
		self.isDirty = true
	else
		for i = 1, #self.castableSpells do
			if self.castableSpells[i].id ~= spells[i].id then
				self.isDirty = true
				break
			end
		end
	end

	self.castableSpells = spells
end

function BaseCombatHUDController:updatePrayers()
	local prayers = {}

	do
		local game = self:getDirector():getGameInstance()
		local gameDB = self:getDirector():getGameDB()
		local brochure = gameDB:getBrochure()
		local resourceType = Mapp.ResourceType()
		brochure:tryGetResourceType("Effect", resourceType)

		local zValues = {}
		local index = 1
		for resource in brochure:findResourcesByType(resourceType) do
			local action
			do
				local actions = Utility.getActions(game, resource, 'prayer')
				if #actions >= 1 then
					action = actions[1].instance

					if not self.prayers[resource.name] then
						self.prayers[resource.name] = action
					end
				end
			end

			if action then
				local z = 0
				if action then
					for requirement in brochure:getRequirements(action:getAction()) do
						local resource = brochure:getConstraintResource(requirement)
						local resourceType = brochure:getResourceTypeFromResource(resource)
						if resourceType.name == "Skill" and resource.name == "Faith" then
							z = requirement.count
						end
					end
				end

				local style, isNonCombat
				do
					local record = gameDB:getRecord("Prayer", {
						Resource = resource
					})

					if record then
						style = record:get("Style")
						isNonCombat = record:get("IsNonCombat") ~= 0
					end
				end

				zValues[resource.name] = { z = Curve.XP_CURVE:getLevel(z), i = index }
				table.insert(prayers, {
					id = resource.name,
					name = Utility.getName(resource, gameDB),
					description = Utility.getDescription(resource, gameDB),
					style = style,
					isNonCombat = isNonCombat,
					level = Curve.XP_CURVE:getLevel(z)
				})

				index = index + 1
			end
		end

		table.sort(prayers, function(a, b)
			if math.floor(zValues[a.id].z) < math.floor(zValues[b.id].z) then
				return true
			elseif math.floor(zValues[a.id].z) == math.floor(zValues[b.id].z) then
				return zValues[a.id].i < zValues[b.id].i
			else
				return false
			end
		end)
	end

	self.offensivePrayers = prayers
end

function BaseCombatHUDController:updateUsablePrayers()
	local gameDB = self:getDirector():getGameDB()

	local prayers = {}
	for i = 1, #self.offensivePrayers do
		local prayer = self.offensivePrayers[i]
		local prayerAction = self.prayers[prayer.id]
		if prayerAction then
			local isActive
			do
				local resource = gameDB:getResource(prayer.id, "Effect")
				if resource then
					local type = Utility.Peep.getEffectType(resource, gameDB)
					isActive = self:getPeep():getEffect(type) ~= nil
				end

				isActive = isActive or false
			end

			local usable = prayerAction:canPerform(self:getPeep():getState())
			local isCorrectStyle = prayer.style == self.styleName or prayer.style == "All"
			local isCombatPrayer = not prayer.isNonCombat
			if (usable and isCorrectStyle and isCombatPrayer) or isActive then
				table.insert(prayers, prayer)
			end

			prayer.active = isActive
		end
	end

	if #prayers ~= #self.usablePrayers then
		self.isDirty = true
	else
		for i = 1, #self.usablePrayers do
			if self.usablePrayers[i].id ~= prayers[i].id then
				self.isDirty = true
				break
			end
		end
	end

	self.usablePrayers = prayers
end

function BaseCombatHUDController:getPrayers()
	local result = {}

	for _, prayer in ipairs(self.usablePrayers) do
		local p = {}
		for k, v in pairs(prayer) do
			p[k] = v
		end

		table.insert(result, p)
	end

	return result
end

function BaseCombatHUDController:getCurrentEquipment(e)
	local peep = self:getPeep()
	local equipment = peep:getBehavior(EquipmentBehavior)
	equipment = equipment and equipment.equipment

	if not equipment then
		return {}
	end

	local broker = equipment:getBroker()
	if not broker then
		return {}
	end

	local result = {
		items = {},
		stats = {}
	}

	for item in broker:iterateItems(equipment) do
		local itemState = {
			id = item:getID(),
			count = item:getCount()
		}

		local key = broker:getItemKey(item)
		if key == Equipment.PLAYER_SLOT_TWO_HANDED then
			key = Equipment.PLAYER_SLOT_RIGHT_HAND
		end

		result.items[key] = itemState
	end

	result.items.n = equipment:getMaxInventorySpace()

	for name, value in equipment:getStats() do
		result.stats[name] = value
	end

	return result
end

function BaseCombatHUDController:getEquipment()
	local equipment = self:getStorage("Equipment")
	if equipment:length() <= 1 and not equipment:getSection(1):hasValue("name") then
		equipment:getSection(1):set("name", "Gear")
	end

	local result = self:getStorage("Equipment"):get()
	for _, section in ipairs(result) do
		for i, slot in ipairs(section) do
			local newSlot = {
				icon = slot.icon,
				stats = slot.stats,
				items = {}
			}

			local items = slot.items
			for _, item in ipairs(items or {}) do
				local key = item.slot
				if key == Equipment.PLAYER_SLOT_TWO_HANDED then
					key = Equipment.PLAYER_SLOT_RIGHT_HAND
				end

				newSlot.items[key] = {
					id = item.id,
					count = 1,
					slot = key
				}
			end

			section[i] = newSlot
		end
	end

	result.current = { self:getCurrentEquipment() }

	return result
end

function BaseCombatHUDController:_getTurnOrder(peep, time)
	local actorReference = peep:getBehavior(ActorReferenceBehavior)
	local actorID = actorReference and actorReference.actor and actorReference.actor:getID()

	local cooldown = peep:getBehavior(AttackCooldownBehavior)
	local cooldownTime = cooldown and cooldown.ticks or self:getGame():getCurrentTime()
	local cooldown = cooldown and cooldown.cooldown

	local pendingPower = peep:getBehavior(PendingPowerBehavior)
	local pendingPowerTurns = pendingPower and pendingPower.turns or math.huge
	pendingPower = pendingPower and pendingPower.power

	local canUsePower = false
	if pendingPower then
		local status = peep:getBehavior(CombatStatusBehavior)
		local currentZeal = status and math.floor(status.currentZeal * 100) or 0
		local zealCost = pendingPower and math.floor(pendingPower:getCost(peep) * 100) or 100

		if zealCost <= currentZeal then
			canUsePower = true
		end
	end

	local equippedWeapon = Utility.Peep.getEquippedWeapon(peep, true) or Weapon()

	local baseWeaponCooldown
	do
		local target = peep:getBehavior(CombatTargetBehavior)
		target = target and target.actor and target.actor:getPeep()

		baseWeaponCooldown = equippedWeapon:getCooldown(peep, target)
	end

	local tickDurationSeconds = Config.get("Combat", "TICK_DURATION_SECONDS")

	local result = {}
	local currentTime = self:getGame():getCurrentTime() - cooldownTime
	for i = 1, self.MAX_TURN_ORDER do
		local turn = {
			id = actorID or 0,
			name = peep:getName(),
			time = currentTime,
			tickTime = math.floor(currentTime / tickDurationSeconds) * tickDurationSeconds,
			duration = baseWeaponCooldown
		}

		if pendingPower and canUsePower and i == pendingPowerTurns + 1 then
			turn.power = self:_pullPower(peep, pendingPower:getResource())
		end

		table.insert(result, turn)
		currentTime = currentTime + baseWeaponCooldown
	end

	return result
end

local function _sortTurn(a, b)
	if a.tickTime == b.tickTime then
		return a.id < b.id
	end

	return a.tickTime < b.tickTime
end

function BaseCombatHUDController:updateTurnOrder()
	local playerPeep = self:getPeep()
	local targetPeep = playerPeep:getBehavior(CombatTargetBehavior)
	targetPeep = targetPeep and targetPeep.actor and targetPeep.actor:getPeep()

	self.turns = {}
	if not targetPeep then
		return
	end

	local aggressive = targetPeep:getBehavior(AggressiveBehavior)
	if aggressive and aggressive.pendingResponseTime > 0 then
		return
	end

	local time = love.timer.getTime()
	local playerTurns = self:_getTurnOrder(playerPeep, time)
	local targetTurns = self:_getTurnOrder(targetPeep, time)

	local workingTurns = {}
	do
		for _, turn in ipairs(playerTurns) do
			table.insert(workingTurns, turn)
		end

		for _, turn in ipairs(targetTurns) do
			table.insert(workingTurns, turn)
		end
	end

	table.sort(workingTurns, _sortTurn)

	local currentIndex = 1
	while #self.turns < self.MAX_TURN_ORDER and currentIndex <= #workingTurns do
		local turn = {}

		local currentTime = workingTurns[currentIndex].tickTime
		while currentIndex <= #workingTurns and workingTurns[currentIndex].tickTime == currentTime do
			table.insert(turn, workingTurns[currentIndex])
			currentIndex = currentIndex + 1
		end

		table.insert(self.turns, turn)
	end

	self.turns.time = time
end

function BaseCombatHUDController:updateStateKey(key, current, previous)
	if not RPCState.deepEquals(current, previous) then
		self:send("updateState", key, current)
	end
end

function BaseCombatHUDController:updateState()
	self.previousState = self.currentState or {}
	self.currentState = self:buildCurrentState()

	for key, value in pairs(self.currentState) do
		self:updateStateKey(key, value, self.previousState[key])
	end
end

function BaseCombatHUDController:buildCurrentState()
	local director = self:getDirector()

	local result = {
		combatants = {},
		powers = self:getPowers(),
		spells = self:getSpells(),
		activeSpellID = self.activeSpellID,
		prayers = self:getPrayers(),
		food = self:getFood(),
		equipment = self:getEquipment(),
		config = self:getConfig(),
		style = self.style,
		stance = self.stance,
		turns = self.turns
	}

	self.combatantsByID = {}
	self.targetsByID = {}

	local attackers = director:probe(
		self:getPeep():getLayerName(),
		self:isAttacking())

	for i = 1, #attackers do
		local r = self:pullStateForPeep(attackers[i])

		if r.targetID then
			self.targetsByID[r.targetID] = true
		end

		self.combatantsByID[r.actorID] = true

		table.insert(result.combatants, r)

		if attackers[i] == self:getPeep() then
			result.player = r
		end
	end

	return result
end

function BaseCombatHUDController:_pullPowers()
	local gameDB = self:getDirector():getGameDB()

	for power in gameDB:getResources("Power") do
		local PowerType = Utility.Peep.getPowerType(power, gameDB)
		local instance = PowerType(self:getGame(), power)

		self.powers[power.id.value] = instance
	end
end

function BaseCombatHUDController:_pullPower(peep, powerResource, xp, extraDescription)
	local gameDB = self:getDirector():getGameDB()
	local power = self.powers[powerResource.id.value]

	return {
		index = powerResource.id.value,
		id = powerResource.name,
		name = Utility.getName(powerResource, gameDB) or "*" .. powerResource.name,
		description = {
			Utility.getDescription(powerResource, gameDB),
			extraDescription
		},
		level = xp and Curve.XP_CURVE:getLevel(xp) or 1,
		zeal = Class.isCompatibleType(power, CombatPower) and power:getCost(peep) or 0,
		tier = Class.isCompatibleType(power, CombatPower) and power:getTier() or 1
	}
end

function BaseCombatHUDController:getAvailablePowers()
	local offensivePowers = {}
	local defensivePowers = {}

	local gameDB = self:getDirector():getGameDB()
	local brochure = gameDB:getBrochure()
	for power in gameDB:getResources("Power") do
		local isSameStyle = false
		local isDefensive = false
		local xp
		
		for action in brochure:findActionsByResource(power) do
			local actionType = brochure:getActionDefinitionFromAction(action)
			if actionType.name:lower() == "activate" then
				for requirement in brochure:getRequirements(action) do
					local resource = brochure:getConstraintResource(requirement)
					if resource.name == self.styleName then
						isSameStyle = true
						xp = requirement.count
						break
					elseif resource.name == "Defense" then
						isDefensive = true
						xp = requirement.count
						break
					end
				end
			end

			if isSameStyle or isDefensive then
				break
			end
		end

		if isSameStyle or isDefensive then
			local result = self:_pullPower(self:getPeep(), power, xp)

			local skill, powers
			if isSameStyle then
				skill = self.styleName
				powers = offensivePowers
			elseif isDefensive then
				skill = "Defense"
				powers = defensivePowers
			end

			if self:getPeep():getState():count("Skill", skill) >= xp then
				table.insert(powers, result)
			end
		end
	end

	table.sort(offensivePowers, function(a, b)
			if a.level < b.level then
				return true
			elseif a.level == b.level then
				return a.index < b.index
			else
				return false
			end
		end)

	table.sort(defensivePowers, function(a, b)
			if a.level < b.level then
				return true
			elseif a.level == b.level then
				return a.index < b.index
			else
				return false
			end
		end)

	return offensivePowers, defensivePowers
end

function BaseCombatHUDController:updateStyle()
	local peep = self:getPeep()

	local oldStyle = self.style
	self.style = nil
	self.styleName = nil

	local weapon = Utility.Peep.getEquippedWeapon(peep, true)
	if weapon then
		weapon = self:getDirector():getItemManager():getLogic(weapon:getID())

		if weapon and weapon:isCompatibleType(Weapon) then
			self.style = weapon:getStyle()
			if self.style == Weapon.STYLE_MAGIC then
				self.styleName = "Magic"
			elseif self.style == Weapon.STYLE_ARCHERY then
				self.styleName = "Archery"
			elseif self.style == Weapon.STYLE_MELEE then
				self.styleName = "Attack"
			end
		end
	end

	self.style = self.style or Weapon.STYLE_MELEE
	self.styleName = self.styleName or "Attack"

	if self.style ~= oldStyle then
		self.isDirty = true

		if self.style == Weapon.STYLE_MAGIC then
			self:useSpell()
		end
	end

	local stance = peep:getBehavior(StanceBehavior)
	self.stance = stance and stance.stance or Weapon.STANCE_NONE
end

function BaseCombatHUDController:_updatePowersRecharge(powers)
	local recharge = self:getPeep():getBehavior(PowerRechargeBehavior)
	if not recharge then
		return
	end

	for _, power in ipairs(powers) do
		power.pending = recharge.powers[power.id] or 0
	end
end

function BaseCombatHUDController:updatePowersRecharge()
	self:_updatePowersRecharge(self.currentOffensivePowers)
	self:_updatePowersRecharge(self.currentDefensivePowers)
end

function BaseCombatHUDController:updatePowers()
	local offensivePowers, defensivePowers = self:getAvailablePowers()

	self.currentOffensivePowers = offensivePowers
	self.currentDefensivePowers = defensivePowers
end

function BaseCombatHUDController:tryPullFood(key, item)
	if item:isNoted() then
		return nil
	end

	local gameDB = self:getDirector():getGameDB()
	local itemResource = gameDB:getResource(item:getID(), "Item")
	if not itemResource then
		return nil
	end

	local actions = Utility.getActions(self:getDirector():getGameInstance(), itemResource, 'inventory', false)
	local eatAction
	for _, action in ipairs(actions) do
		if action.instance:is("eat") then
			eatAction = action.instance
			break
		end
	end

	if not eatAction then
		return nil
	end

	local health = 0

	local healingPower = gameDB:getRecord("HealingPower", { Action = eatAction:getAction() })
	if healingPower then
		health = health + healingPower:get("HitPoints")
	end

	local healingUserdata = item:getUserdata("ItemHealingUserdata")
	if healingUserdata then
		health = health + healingUserdata:getHitpoints()
	end

	local result = {}
	result.key = key
	result.health = health
	result.id = item:getID()
	result.count = item:getCount()
	result.name = Utility.Item.getInstanceName(item)
	result.description = Utility.Item.getInstanceDescription(item)
	result.instance = item

	return result
end

function BaseCombatHUDController:tryAddFood(item)
	for _, food in ipairs(self.food) do
		if food.id == item.id and ItemInstance.isSame(food.instances[1].instance, item.instance) then
			table.insert(food.instances, item)
			food.count = food.count + item.count
			return
		end
	end

	local result = {
		id = item.id,
		count = item.count,
		name = item.name,
		description = item.description,
		health = item.health,
		instances = { item }
	}

	table.insert(self.food, result)
end

function BaseCombatHUDController:updateFood()
	local oldFood = self.food
	self.food = {}

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	inventory = inventory and inventory.inventory
	if not inventory then
		return
	end

	local broker = inventory:getBroker()
	if not broker then
		return
	end

	for key in broker:keys(inventory) do
		for item in broker:iterateItemsByKey(inventory, key) do
			local food = self:tryPullFood(key, item)
			if food then
				self:tryAddFood(food)
			end
		end
	end

	self.isDirty = self.isDirty or #oldFood ~= #self.food
end

function BaseCombatHUDController:getFood()
	local foodState = {}

	for _, food in ipairs(self.food) do
		local result = {
			id = food.id,
			count = food.count,
			name = food.name,
			description = food.description,
			health = food.health,
			keys = {}
		}

		for _, item in ipairs(food.instances) do
			table.insert(result.keys, item.key)
		end

		table.insert(foodState, result)
	end

	return foodState
end

function BaseCombatHUDController:sendRefresh()
	self:send("refresh")
end

function BaseCombatHUDController:close()
	if _DEBUG then
		local player = Utility.Peep.getPlayerModel(self:getPeep())
		if player then
			self.updateDebugStats:dumpStatsToCSV(string.format("ProCombatStatusHUD_Player%d", player:getID()))
		end
	end
end

function BaseCombatHUDController:update(delta)
	Controller.update(self, delta)

	self.updateDebugStats:measure("updateStyle", self)
	self.updateDebugStats:measure("updateCastableSpells", self)
	self.updateDebugStats:measure("updateUsablePrayers", self)
	self.updateDebugStats:measure("updateActiveSpell", self)
	self.updateDebugStats:measure("updateTurnOrder", self)
	self.updateDebugStats:measure("updateFood", self)

	local wasDirty = self.isDirty

	if self.isDirty then
		self.updateDebugStats:measure("updatePowers", self)
		self.updateDebugStats:measure("updateSpells", self)
		self.updateDebugStats:measure("updatePrayers", self)
		self.isDirty = false
		self.needsRefresh = true
	end

	self.updateDebugStats:measure("updatePowersRecharge", self)
	self.updateDebugStats:measure("updateState", self)

	if not wasDirty and self.needsRefresh then
		self.needsRefresh = false
		self.updateDebugStats:measure("sendRefresh", self)
	end
end

return BaseCombatHUDController
