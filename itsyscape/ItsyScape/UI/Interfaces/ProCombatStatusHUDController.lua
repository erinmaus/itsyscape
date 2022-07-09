--------------------------------------------------------------------------------
-- ItsyScape/UI/ProCombatStatusHUDController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CombatSpell = require "ItsyScape.Game.CombatSpell"
local Curve = require "ItsyScape.Game.Curve"
local Equipment = require "ItsyScape.Game.Equipment"
local Spell = require "ItsyScape.Game.Spell"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Controller = require "ItsyScape.UI.Controller"
local Effect = require "ItsyScape.Peep.Effect"
local ActiveSpellBehavior = require "ItsyScape.Peep.Behaviors.ActiveSpellBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"
local PowerCoolDownBehavior = require "ItsyScape.Peep.Behaviors.PowerCoolDownBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

local ProCombatStatusHUDController = Class(Controller)

function ProCombatStatusHUDController:new(peep, director)
	Controller.new(self, peep, director)

	self:bindToPlayer(peep)
	self.isDirty = true

	self.spells = {}
	self.castableSpells = {}
	self.offensiveSpells = {}

	self.prayers = {}
	self.prayerEffects = {}
	self.offensivePrayers = {}
	self.usablePrayers = {}

	self:update(0)
end

function ProCombatStatusHUDController:bindToPlayer(peep)
	local stats = peep:getBehavior(StatsBehavior)
	if stats and stats.stats then
		stats = stats.stats

		self._onLevelUp = function(stats, skill, oldLevel)
			self.isDirty = true
		end
		stats.onLevelUp:register(self._onLevelUp)
	end
end

function ProCombatStatusHUDController:unbindToPlayer(peep)
	local stats = peep:getBehavior(StatsBehavior)
	if stats and stats.stats then
		stats = stats.stats

		stats.onLevelUp:unregister(self._onLevelUp)
	end
end

function ProCombatStatusHUDController:close()
	Controller.close(self)
	self:unbindToPlayer(self:getPeep())
end

function ProCombatStatusHUDController:getStorage(section)
	local storage = self:getDirector():getPlayerStorage(self:getPeep())
	return storage:getRoot():getSection("ProCombatStatusHUD"):getSection(section)
end

function ProCombatStatusHUDController:poke(actionID, actionIndex, e)
	if actionID == "activateOffensivePower" then
		self:activate(self.state.powers.offensive, e)
	elseif actionID == "activateDefensivePower" then
		self:activate(self.state.powers.defensive, e)
	elseif actionID == "castSpell" then
		self:castSpell(e)
	elseif actionID == "pray" then
		self:pray(e)
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
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function ProCombatStatusHUDController:activate(powers, e)
	local power = powers[e.index]
	if power then
		local peep = self:getPeep()
		local gameDB = self:getDirector():getGameDB()

		if power.id == self.state.powers.pendingID then
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

function ProCombatStatusHUDController:castSpell(e)
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
end

function ProCombatStatusHUDController:pray(e)
	local prayer = self.prayers[e.id]
	local peep = self:getPeep()
	if prayer then
		prayer:perform(peep:getState(), peep)
	end
end

function ProCombatStatusHUDController:saveEquipment(e)
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
		slotStorage:set(index, {
			id = item:getID(),
			slot = broker:getItemKey(item)
		})

		index = index + 1
	end

	if index == 1 then
		-- No items were added. Undo changes.
		slotsStorage:removeSection(slotsStorage:length())
	else
		self.isDirty = true
	end
end

function ProCombatStatusHUDController:addEquipmentSlot(e)
	local equipmentStorage = self:getStorage("Equipment")
	local slotsStorage = equipmentStorage:getSection(equipmentStorage:length() + 1)
	slotsStorage:set({
		name = "Unammed"
	})

	self.isDirty = true
end

function ProCombatStatusHUDController:renameEquipmentSlot(e)
	local equipmentStorage = self:getStorage("Equipment")
	local slotsStorage = equipmentStorage:getSection(e.index)
	slotsStorage:set({
		name = e.name
	})

	self.isDirty = true
end

function ProCombatStatusHUDController:deleteEquipmentSlot(e)
	local equipmentStorage = self:getStorage("Equipment")
	equipmentStorage:removeSection(e.index)

	self.isDirty = true
end

function ProCombatStatusHUDController:equip(e)
	local equipmentStorage = self:getStorage("Equipment")
	local slotStorage = equipmentStorage:getSection(e.index):getSection(e.slot)

	local peep = self:getPeep()
	local gameDB = self:getDirector():getGameDB()

	for _, item in slotStorage:iterateSections() do
		local itemID = item:get("id")
		local itemInstance = Utility.Item.getItemInPeepInventory(peep, itemID)
		local itemResource = gameDB:getResource(itemID, "Item")

		print(itemInstance and itemInstance:getID(), itemResource and itemResource.name)

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
				end
			end
		end
	end
end

function ProCombatStatusHUDController:pull(e)
	return self.state
end

function ProCombatStatusHUDController:pullStateForPeep(peep)
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
		effects = {},
		stats = {}
	}

	do
		for effect in peep:getEffects() do
			local resource = effect:getResource()
			local e = {
				id = resource.name,
				z = resource.id.value,
				name = Utility.getName(resource, gameDB),
				description = Utility.getDescription(resource, gameDB),
				duration = effect:getDuration(),
				debuff = effect:getBuffType() == Effect.BUFF_TYPE_NEGATIVE,
				buff = effect:getBuffType() == Effect.BUFF_TYPE_POSITIVE
			}

			table.insert(result.effects, e)
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
		else
			result.stats = {
				prayer = { current = 0, max = 0 },
				hitpoints = { current = 0, max = 0 }
			}
		end
	end

	return result
end

function ProCombatStatusHUDController:isAttacking()
	return function(peep)
		local status = peep:getBehavior(CombatStatusBehavior)
		local target = peep:getBehavior(CombatTargetBehavior)

		local hasTarget = target and target.actor
		local isAlive = status and not status.dead

		return hasTarget and isAlive
	end
end

function ProCombatStatusHUDController:isBeingAttacked()
	return function(peep)
		local actor = peep:getBehavior(ActorReferenceBehavior)
		if not actor or not actor.actor then
			return false
		end

		if self.targetsByID[actor.actor:getID()] then
			return true
		end
	end
end

function ProCombatStatusHUDController:getPendingPowerID()
	local peep = self:getPeep()
	local pending = peep:getBehavior(PendingPowerBehavior)
	if pending and pending.power then
		return pending.power:getResource().name
	end

	return nil
end

function ProCombatStatusHUDController:updatePowersState(powers)
	local peep = self:getPeep()
	local gameDB = self:getDirector():getGameDB()

	local b = peep:getBehavior(PowerCoolDownBehavior)
	if not b then
		peep:addBehavior(PowerCoolDownBehavior)
		b = peep:getBehavior(PowerCoolDownBehavior)
	end

	if b then
		local time = self:getGame():getCurrentTick() * self:getGame():getDelta()
		for i = 1, #powers do
			local p = powers[i]

			local resource = gameDB:getResource(p.id, "Power")
			if b.powers[resource.id.value] then
				local coolDown = b.powers[resource.id.value] - time
				if coolDown > 0 then
					p.coolDown = math.floor(coolDown)
				end
			end
		end
	end
end

function ProCombatStatusHUDController:updateActiveSpell()
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
end

function ProCombatStatusHUDController:updateSpells()
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

function ProCombatStatusHUDController:updateCastableSpells()
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

function ProCombatStatusHUDController:updatePrayers()
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

function ProCombatStatusHUDController:updateUsablePrayers()
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
			local isCorrectStyle = prayer.style == self.style or prayer.style == "All"
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

function ProCombatStatusHUDController:updateState()
	local director = self:getDirector()

	local result = {
		combatants = {},
		powers = {
			offensive = self.currentOffensivePowers,
			defensive = self.currentDefensivePowers,
			pendingID = self:getPendingPowerID()
		},
		spells = self.castableSpells,
		prayers = self.usablePrayers,
		equipment = self:getStorage("Equipment"):get(),
		style = self.style
	}

	self.combatantsByID = {}
	self.targetsByID = {}

	local attackers = director:probe(
		self:getPeep():getLayerName(),
		self:isAttacking())

	for i = 1, #attackers do
		local r = self:pullStateForPeep(attackers[i])
		self.targetsByID[r.targetID] = true
		self.combatantsByID[r.actorID] = true

		table.insert(result.combatants, r)

		if r.actorID == director:getGameInstance():getPlayer():getActor():getID() then
			result.player = r
		end
	end

	local victims = director:probe(
		self:getPeep():getLayerName(),
		self:isBeingAttacked())

	for i = 1, #victims do
		local r = self:pullStateForPeep(victims[i])
		table.insert(result.combatants, r)

		if r.actorID == director:getGameInstance():getPlayer():getActor():getID() then
			result.player = r
		end
	end

	self:updatePowersState(result.powers.offensive)
	self:updatePowersState(result.powers.defensive)

	self.state = result
end

function ProCombatStatusHUDController:getAvailablePowers()
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
					if resource.name == self.style then
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
			local coolDownDescription
			do
				local PowerType = Utility.Peep.getPowerType(power, gameDB)
				local instance = PowerType(self:getGame(), power)
				coolDownDescription = string.format("Cooldown: %d seconds", instance:getCoolDown(self:getPeep()))
			end

			local result = {
				index = power.id.value,
				id = power.name,
				name = Utility.getName(power, gameDB) or "*" .. power.name,
				description = {
					Utility.getDescription(power, gameDB),
					coolDownDescription
				},
				level = Curve.XP_CURVE:getLevel(xp)
			}

			local skill, powers
			if isSameStyle then
				skill = self.style
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

function ProCombatStatusHUDController:updateStyle()
	local peep = self:getPeep()

	local oldStyle = self.style
	self.style = nil

	local weapon = Utility.Peep.getEquippedWeapon(peep, true)
	if weapon then
		weapon = self:getDirector():getItemManager():getLogic(weapon:getID())

		if weapon and weapon:isCompatibleType(Weapon) then
			local style = weapon:getStyle()
			if style == Weapon.STYLE_MAGIC then
				self.style = "Magic"
			elseif style == Weapon.STYLE_ARCHERY then
				self.style = "Archery"
			elseif style == Weapon.STYLE_MELEE then
				self.style = "Attack"
			end
		end
	end

	self.style = self.style or "Attack"

	if self.style ~= oldStyle then
		self.isDirty = true
	end
end

function ProCombatStatusHUDController:updatePowers()
	local offensivePowers, defensivePowers = self:getAvailablePowers()

	self.currentOffensivePowers = offensivePowers
	self.currentDefensivePowers = defensivePowers
end

function ProCombatStatusHUDController:sendRefresh()
	local ui = self:getDirector():getGameInstance():getUI()
	ui:sendPoke(self, "refresh", nil, {})
end

function ProCombatStatusHUDController:update(delta)
	Controller.update(self, delta)

	self:updateStyle()
	self:updateCastableSpells()
	self:updateUsablePrayers()
	self:updateActiveSpell()

	if self.isDirty then
		self:updatePowers()
		self:updateSpells()
		self:updatePrayers()
		self.isDirty = false

		self:sendRefresh()
	end

	self:updateState()
end

return ProCombatStatusHUDController
