--------------------------------------------------------------------------------
-- ItsyScape/Analytics/Client.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local serpent = require "serpent"
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Events = require "ItsyScape.Analytics.Events"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local Client = Class()
Client.NUM_ID_BYTES = 16

function Client:new(game, device)
	device = device or {}

	self.game = game
	self.gameDB = game:getGameDB()

	self:_startThread()

	self.channel = love.thread.getChannel("ItsyScape.Analytics::input")

	self:_loadID(device)

	self.onQuit = Callback()
end

function Client:_startThread()
	self.sentQuitMessage = false
	self.serviceThread = love.thread.newThread("ItsyScape/Analytics/Threads/AnalyticsService.lua")
	self.serviceThread:start()
end

function Client.getConfig()
	local config = {}
	do
		local file = love.filesystem.read("Player/Common.dat") or "{}"
		local r, e = loadstring("return " .. file)
		if r then
			r, e = pcall(setfenv(r, {}))
		end

		if not r then
			Log.warn("Failed to parse 'Player/Common.dat': %s", e)
		elseif type(e) ~= 'table' then
			Log.warn("Bad file; expected key-value pairs, got '%s' (value = %s)", type(e), Log.stringify(e))
		else
			config = e
		end
	end

	if config.enabled ~= false then
		config.enabled = true
	end

	return config
end

function Client.saveConfig(config)
	love.filesystem.createDirectory("Player")

	local serializedConfig = serpent.block(config, { comment = false })
	local s, e = love.filesystem.write("Player/Common.dat", serializedConfig)
	if not s then
		Log.warn("Couldn't write config to 'Player/Common.dat': %s", e)
	end
end

function Client:_loadID(device)
	local config = Client.getConfig()

	if config.enabled == false then
		Log.info("Analytics disabled.")
		return
	end

	if not config.id then
		local id = {}
		for i = 1, Client.NUM_ID_BYTES do
			local byte = love.math.random(1, 255)
			table.insert(id, string.format("%02x", byte))
		end

		config.id = table.concat(id)
		Client.saveConfig(config)
	end

	Log.info("Got analytics ID '%s'.", config.id)
	self.id = config.id

	self.channel:push({
		type = 'id',
		id = self.id,
		brand = device.brand,
		model = device.model
	})
end

function Client:startGame(peep)
	self:submit(Events.START_GAME, {
		["Player Name"] = peep:getName(),
		["Player Pronouns"] = table.concat(Utility.Text.getPronouns(peep), "/"),
		["Local Time"] = os.date()
	})
end

function Client:endGame(peep)
	self:submit(Events.END_GAME, {
		["Player Name"] = peep:getName(),
		["Player Pronouns"] = table.concat(Utility.Text.getPronouns(peep), "/"),
		["Local Time"] = os.date()
	}, true)

	self:newSession()
end

function Client:gotKeyItem(peep, keyItem, quest)
	keyItem = self.gameDB:getResource(keyItem, "KeyItem")
	if not keyItem then
		return
	end

	quest = self.gameDB:getResource(quest, "Quest")

	self:submit(Events.GOT_KEY_ITEM, {
		["Player Name"] = peep:getName(),
		["Resource"] = keyItem.name,
		["Resource Name"] = Utility.getName(keyItem, self.gameDB) or Utility.getName(quest, self.gameDB) or nil,
		["Resource Description"] = Utility.getDescription(keyItem, self.gameDB, nil, 2)
	})
end

function Client:startedQuest(peep, quest)
	quest = self.gameDB:getResource(quest, "Quest")
	if not quest then
		return
	end

	self:submit(Events.STARTED_QUEST, {
		["Player Name"] = peep:getName(),
		["Resource"] = quest.name,
		["Resource Name"] = Utility.getName(quest, self.gameDB),
		["Resource Description"] = Utility.getDescription(quest, self.gameDB)
	})
end

function Client:completedQuest(peep, quest)
	quest = self.gameDB:getResource(quest, "Quest")
	if not quest then
		return
	end

	self:submit(Events.COMPLETED_QUEST, {
		["Player Name"] = peep:getName(),
		["Resource"] = quest.name,
		["Resource Name"] = Utility.getName(quest, self.gameDB),
		["Resource Description"] = Utility.getDescription(quest, self.gameDB)
	})
end

function Client:dreamed(peep, dream)
	dream = self.gameDB:getResource(dream, "Dream")
	if not dream then
		return
	end

	local map = Utility.Peep.getMapResource(peep)
	self:submit(Events.DREAMED, {
		["Player Name"] = peep:getName(),
		["Resource"] = dream.name,
		["Resource Name"] = Utility.getName(dream, self.gameDB),
		["Resource Description"] = Utility.getDescription(dream, self.gameDB),
		["Map Resource"] = map and map.name or "???",
		["Map Name"] = map and Utility.getName(map, self.gameDB)
	})
end

function Client:gainedXP(peep, skills)
	skills = skills or {}
	if next(skills) == nil then
		return
	end

	local event = {
		["Player Name"] = peep:getName()
	}

	for skill, xp in pairs(skills) do
		local skillName = Utility.getName(self.gameDB:getResource(skill, "Skill"), self.gameDB) or skill
		event[string.format("Player Gained %s XP", skillName)] = xp
	end

	self:submit(Events.GAINED_XP, event)
end

function Client:gotLevelUp(peep, skills)
	skills = skills or {}
	if next(skills) == nil then
		return
	end

	local event = {
		["Player Name"] = peep:getName()
	}

	for skill, level in pairs(skills) do
		local skillName = Utility.getName(self.gameDB:getResource(skill, "Skill"), self.gameDB) or skill
		event[string.format("Player Gained %s Level", skillName)] = level
	end

	self:submit(Events.GOT_LEVEL_UP, event)
end

function Client:performedAction(peep, action)
	local resource
	do
		local brochure = self.gameDB:getBrochure()
		for r in brochure:findResourcesByAction(action:getAction()) do
			resource = r
			break
		end

		if resource then
			local resourceType = brochure:getResourceTypeFromResource(resource)
			if resourceType.name == "MapObject" then
				local hit = peep:getDirector():probe(
					peep:getLayerName(),
					Probe.mapObject(resource),
					Probe.instance(Utility.Peep.getPlayerModel(peep), true))[1]

				if hit then
					resource = Utility.Peep.getResource(hit) or resource
				else
					local peepMapObject = self.gameDB:getRecord("PeepMapObject", { MapObject = resource })
					local propMapObject = self.gameDB:getRecord("PropMapObject", { MapObject = resource })

					resource = (peepMapObject and peepMapObject:get("Peep")) or (propMapObject and propMapObject:get("Prop")) or resource
				end
			end
		end
	end

	self:submit(Events.PERFORMED_ACTION, {
		["Player Name"] = peep:getName(),
		["Action Verb"] = action:getVerb() or action:getName(),
		["Action Progressive Verb"] = action:getXProgressiveVerb(),
		["Resource"] = resource and resource.name or "???",
		["Resource Name"] = Utility.getName(resource, self.gameDB),
		["Resource Description"] = Utility.getDescription(resource, self.gameDB, nil, 1)
	})
end

function Client:failedAction(peep, action)
	local resource
	do
		local brochure = self.gameDB:getBrochure()
		for r in brochure:findResourcesByAction(action:getAction()) do
			resource = r
			break
		end

		if resource then
			local resourceType = brochure:getResourceTypeFromResource(resource)
			if resourceType.name == "MapObject" then
				local hit = peep:getDirector():probe(
					peep:getLayerName(),
					Probe.mapObject(resource),
					Probe.instance(Utility.Peep.getPlayerModel(peep), true))[1]

				if hit then
					resource = Utility.Peep.getResource(hit) or resource
				else
					local peepMapObject = self.gameDB:getRecord("PeepMapObject", { MapObject = resource })
					local propMapObject = self.gameDB:getRecord("PropMapObject", { MapObject = resource })

					resource = (peepMapObject and peepMapObject:get("Peep")) or (propMapObject and propMapObject:get("Prop")) or resource
				end
			end
		end
	end

	self:submit(Events.FAILED_ACTION, {
		["Player Name"] = peep:getName(),
		["Action Verb"] = action:getVerb() or action:getName(),
		["Action Progressive Verb"] = action:getXProgressiveVerb(),
		["Resource"] = resource and resource.name or "???",
		["Resource Name"] = Utility.getName(resource, self.gameDB),
		["Resource Description"] = Utility.getDescription(resource, self.gameDB, nil, 1)
	})
end

function Client:cookedRecipe(peep, item)
	self:submit(Events.COOKED_RECIPE, {
		["Player Name"] = peep:getName(),
		["Item Resource"] = item:getID(),
		["Item Count"] = item:getCount(),
		["Item Name"] = Utility.Item.getInstanceName(item),
		["Item Description"] = Utility.Item.getInstanceDescription(item),
		["Item Userdata Hints"] = Utility.Item.getUserdataHints(item:getID(), self.gameDB)
	})
end

local COMBAT_SKILLS = {
	"Attack",
	"Strength",
	"Magic",
	"Wisdom",
	"Archery",
	"Dexterity",
	"Constitution",
	"Defense",
	"Faith"
}

function Client:gainedCombatLevel(peep)
	local event = {
		["Player Name"] = peep:getName(),
		["Player Combat Level"] = Utility.Combat.getCombatLevel(peep)
	}

	local stats = peep:getBehavior(StatsBehavior)
	stats = stats and stats.stats
	if stats then
		for _, skill in pairs(COMBAT_SKILLS) do
			local skillName = Utility.getName(self.gameDB:getResource(skill, "Skill"), self.gameDB) or skill
			event[string.format("Player %s Level", skillName)] = stats:hasSkill(skill) and stats:getSkill(skill):getBaseLevel() or 1
		end
	end

	self:submit(Events.GAINED_COMBAT_LEVEL, event)
end

local SLOT_NAMES = {
	[Equipment.PLAYER_SLOT_HEAD] = "Head",
	[Equipment.PLAYER_SLOT_NECK] = "Neck",
	[Equipment.PLAYER_SLOT_BODY] = "Body",
	[Equipment.PLAYER_SLOT_LEGS] = "Legs",
	[Equipment.PLAYER_SLOT_FEET] = "Boots",
	[Equipment.PLAYER_SLOT_HANDS] = "Glove",
	[Equipment.PLAYER_SLOT_BACK] = "Cape",
	[Equipment.PLAYER_SLOT_FINGER] = "Ring",
	[Equipment.PLAYER_SLOT_POCKET] = "Pocket",
	[Equipment.PLAYER_SLOT_QUIVER] = "Quiver",
	[Equipment.PLAYER_SLOT_EFFECT] = "Effect",
	[Equipment.PLAYER_SLOT_RIGHT_HAND] = "Shield"
}

function Client:killedNPC(peep, target, xp)
	local peepCombatStatus = peep:getBehavior(CombatStatusBehavior)
	local targetCombatStatus = target:getBehavior(CombatStatusBehavior)
	local resource = Utility.Peep.getResource(target)

	local event = {
		["Player Name"] = peep:getName(),
		["Player Combat Level"] = Utility.Combat.getCombatLevel(peep),
		["Target Name"] = target:getName(),
		["Target Description"] = Utility.getDescription(resource, self.gameDB, nil, 1),
		["Target Resource"] = resource and resource.name or "???",
		["Target Combat Level"] = Utility.Combat.getCombatLevel(target),
		["Player Current Health"] = peepCombatStatus and peepCombatStatus.currentHitpoints,
		["Player Maximum Health"] = peepCombatStatus and peepCombatStatus.maximumHitpoints,
		["Player Current Prayer"] = peepCombatStatus and peepCombatStatus.currentPrayer,
		["Player Maximum Prayer"] = peepCombatStatus and peepCombatStatus.maximumPrayer,
		["Target Current Health"] = targetCombatStatus and targetCombatStatus.currentHitpoints,
		["Target Maximum Health"] = targetCombatStatus and targetCombatStatus.maximumHitpoints,
		["Target Current Prayer"] = targetCombatStatus and targetCombatStatus.currentPrayer,
		["Target Maximum Prayer"] = targetCombatStatus and targetCombatStatus.maximumPrayer,
		["Target Total XP"] = Utility.Combat.getCombatXP(target),
		["Target Is Boss"] = Utility.Boss.isBoss(target),
		["Player Partial XP"] = xp
	}

	local peepStats = peep:getBehavior(StatsBehavior)
	peepStats = peepStats and peepStats.stats
	if peepStats then
		for _, skill in pairs(COMBAT_SKILLS) do
			local skillName = Utility.getName(self.gameDB:getResource(skill, "Skill"), self.gameDB) or skill
			event[string.format("Player %s Level", skillName)] = peepStats:hasSkill(skill) and peepStats:getSkill(skill):getBaseLevel() or 1
		end
	end

	for _, slot in ipairs(Equipment.SLOTS) do
		local slotName = SLOT_NAMES[slot]
		if slotName then
			slotName = string.format("Player %s Slot", slotName)
			local item = Utility.Peep.getEquippedItem(peep, slot)
			if item then
				event[slotName] = Utility.Item.getInstanceName(item)
			end
		end
	end

	local _, playerWeapon = Utility.Peep.getEquippedWeapon(peep)
	if playerWeapon then
		event["Player Weapon Slot"] = Utility.Item.getInstanceName(playerWeapon)
	else
		event["Player Weapon Slot"] = "Unarmed"
	end

	local targetStats = target:getBehavior(StatsBehavior)
	targetStats = targetStats and targetStats.stats
	if targetStats then
		for _, skill in pairs(COMBAT_SKILLS) do
			local skillName = Utility.getName(self.gameDB:getResource(skill, "Skill"), self.gameDB) or skill
			event[string.format("Target %s Level", skillName)] = targetStats:hasSkill(skill) and targetStats:getSkill(skill):getBaseLevel() or 1
		end
	end

	local targetWeapon = Utility.Peep.getEquippedWeapon(target, true)
	if targetWeapon then
		event["Target Weapon Slot Resource"] = targetWeapon:getID()
	else
		event["Target Weapon Slot Resource"] = "Unarmed"
	end

	self:submit(Events.KILLED_NPC, event)
end

function Client:talkedToNPC(peep, target, action)
	local talkDialog = self.gameDB:getRecord("TalkDialog", { Action = action:getAction(), Language = "en-US" })

	self:submit(Events.TALKED_TO_NPC, {
		["Player Name"] = peep:getName(),
		["Target Name"] = target and target:getName(),
		["Dialogue Script"] = talkDialog and talkDialog:get("Script")
	})
end

function Client:selectedDialogueOption(peep, target, action, option)
	local talkDialog = self.gameDB:getRecord("TalkDialog", { Action = action:getAction(), Language = "en-US" })

	self:submit(Events.SELECTED_DIALOGUE_OPTION, {
		["Player Name"] = peep:getName(),
		["Target Name"] = target:getName(),
		["Dialogue Script"] = talkDialog and talkDialog:get("Script"),
		["Dialogue Option"] = option
	})
end

function Client:npcDroppedItem(peep, target, item, count, isLegendary)
	local resource = Utility.Peep.getResource(target)

	self:submit(Events.NPC_DROPPED_ITEM, {
		["Player Name"] = peep:getName(),
		["Player Combat Level"] = Utility.Combat.getCombatLevel(peep),
		["Target Name"] = target:getName(),
		["Target Description"] = Utility.getDescription(resource, self.gameDB, nil, 1),
		["Target Resource"] = resource and resource.name or "???",
		["Target Combat Level"] = Utility.Combat.getCombatLevel(target),
		["Item Resource"] = item:getID(),
		["Item Count"] = count or item:getCount(),
		["Item Is Note"] = item:isNoted(),
		["Item Name"] = Utility.Item.getInstanceName(item),
		["Item Description"] = Utility.Item.getInstanceDescription(item),
		["Item Userdata Hints"] = Utility.Item.getUserdataHints(item:getID(), self.gameDB),
		["Item Is Legendary"] = isLegendary == true
	})
end

function Client:lootedItem(peep, lootBag, item, count, isLegendary)
	self:submit(Events.LOOTED_ITEM, {
		["Player Name"] = peep:getName(),
		["Player Combat Level"] = Utility.Combat.getCombatLevel(peep),
		["Loot Bag Resource"] = lootBag:getID(),
		["Loot Bag Name"] = Utility.Item.getInstanceName(lootBag),
		["Item Resource"] = item:getID(),
		["Item Count"] = count or item:getCount(),
		["Item Is Note"] = item:isNoted(),
		["Item Name"] = Utility.Item.getInstanceName(item),
		["Item Description"] = Utility.Item.getInstanceDescription(item),
		["Item Userdata Hints"] = Utility.Item.getUserdataHints(item:getID(), self.gameDB),
		["Item Is Legendary"] = isLegendary == true
	})
end

function Client:died(peep, target)
	local peepCombatStatus = peep:getBehavior(CombatStatusBehavior)
	local targetCombatStatus = target and target:getBehavior(CombatStatusBehavior)
	local map = Utility.Peep.getMapResource(peep)
	local resource = Utility.Peep.getResource(target)

	local event = {
		["Player Name"] = peep:getName(),
		["Player Combat Level"] = Utility.Combat.getCombatLevel(peep),
		["Map Resource"] = map and map.name or "???",
		["Map Name"] = map and Utility.getName(map, self.gameDB),
		["Target Name"] = target and target:getName(),
		["Target Description"] = target and Utility.getDescription(Utility.Peep.getResource(target), self.gameDB, nil, 1),
		["Target Resource"] = resource and resource.name or nil,
		["Target Combat Level"] = target and Utility.Combat.getCombatLevel(target) or nil,
		["Player Current Health"] = peepCombatStatus and peepCombatStatus.currentHitpoints,
		["Player Maximum Health"] = peepCombatStatus and peepCombatStatus.maximumHitpoints,
		["Player Current Prayer"] = peepCombatStatus and peepCombatStatus.currentPrayer,
		["Player Maximum Prayer"] = peepCombatStatus and peepCombatStatus.maximumPrayer,
		["Target Current Health"] = targetCombatStatus and targetCombatStatus.currentHitpoints or nil,
		["Target Maximum Health"] = targetCombatStatus and targetCombatStatus.maximumHitpoints or nil,
		["Target Current Prayer"] = targetCombatStatus and targetCombatStatus.currentPrayer or nil,
		["Target Maximum Prayer"] = targetCombatStatus and targetCombatStatus.maximumPrayer or nil
	}

	local peepCombatStatus = peep:getBehavior(CombatStatusBehavior)
	local targetCombatStatus = target:getBehavior(CombatStatusBehavior)

	local peepStats = peep:getBehavior(StatsBehavior)
	peepStats = peepStats and peepStats.stats
	if peepStats then
		for _, skill in pairs(COMBAT_SKILLS) do
			local skillName = Utility.getName(self.gameDB:getResource(skill, "Skill"), self.gameDB) or skill
			event[string.format("Player %s Level", skillName)] = peepStats:hasSkill(skill) and peepStats:getSkill(skill):getBaseLevel() or 1
		end
	end

	local _, playerWeapon = Utility.Peep.getEquippedWeapon(peep)
	if playerWeapon then
		event["Player Weapon Slot"] = Utility.Item.getInstanceName(playerWeapon)
	else
		event["Player Weapon Slot"] = "Unarmed"
	end

	local targetStats = target:getBehavior(StatsBehavior)
	targetStats = targetStats and targetStats.stats
	if targetStats then
		for _, skill in pairs(COMBAT_SKILLS) do
			local skillName = Utility.getName(self.gameDB:getResource(skill, "Skill"), self.gameDB) or skill
			event[string.format("Target %s Level", skillName)] = targetStats:hasSkill(skill) and targetStats:getSkill(skill):getBaseLevel() or 1
		end
	end

	local targetWeapon = Utility.Peep.getEquippedWeapon(target, true)
	if targetWeapon then
		event["Target Weapon Slot Resource"] = targetWeapon:getID()
	else
		event["Target Weapon Slot Resource"] = "Unarmed"
	end

	self:submit(Events.DIED, event)
end

function Client:rezzed(peep, dream)
	local map = Utility.Peep.getMapResource(peep)

	self:submit(Events.REZZED, {
		["Player Name"] = peep:getName(),
		["Map Resource"] = map and map.name or "???",
		["Map Name"] = map and Utility.getName(map, self.gameDB)
	})
end

function Client:gotSailingItem(peep, item)
	local item = self.gameDB:getResource(item, "SailingItem")
	local map = Utility.Peep.getMapResource(peep)

	self:submit(Events.GOT_SAILING_ITEM, {
		["Player Name"] = peep:getName(),
		["Resource"] = item and item.name or "???",
		["Resource Name"] = item and Utility.getName(item, self.gameDB),
		["Resource Description"] = item and Utility.getDescription(map, self.gameDB),
		["Map Resource"] = map and map.name or "???",
		["Map Name"] = map and Utility.getName(map, self.gameDB)
	})
end

local INTERFACE_BLACKLIST = {
	"Ribbon",
	"Chat",
	"ProCombatStatusHUD",
	"QuestProgressNotification",
	"Notification",
	"GenericNotification",
	"LevelUpNotification",
	"QuestCompleteNotification",
	"BossHUD",
	"Countdown",
	"KeyboardAction",
	"MapInfo",
	"ScoreHUD",
	"TutorialHint",
	"ConfigWindow",
	"DialogBox",
	"PlayerStance",
	"PlayerInventory",
	"PlayerEquipment",
	"PlayerStats",
	"PlayerSpells",
	"PlayerPrayers",
	"PlayerPowers",
	"DramaticText",
	"CutsceneTransition"
}

function Client:openedInterface(peep, interface, blocking)
	for _, ignoredInterface in ipairs(INTERFACE_BLACKLIST) do
		if interface == ignoredInterface then
			return
		end
	end

	self:submit(Events.OPENED_INTERFACE, {
		["Player Name"] = peep:getName(),
		["Interface ID"] = interface,
		["Interface Is Blocking"] = blocking or false
	})
end

function Client:closedInterface(peep, interface, blocking)
	for _, ignoredInterface in ipairs(INTERFACE_BLACKLIST) do
		if interface == ignoredInterface then
			return
		end
	end

	self:submit(Events.CLOSED_INTERFACE, {
		["Player Name"] = peep:getName(),
		["Interface ID"] = interface,
		["Interface Is Blocking"] = blocking or false
	})
end

function Client:startedRaid(peep, raid)
	local raid = self.gameDB:getResource(raid, "Raid")
	local map = Utility.Peep.getMapResource(peep)

	self:submit(Events.STARTED_RAID, {
		["Player Name"] = peep:getName(),
		["Resource"] = raid.name,
		["Resource Name"] = Utility.getName(raid, self.gameDB),
		["Resource Description"] = Utility.getDescription(raid, self.gameDB),
		["Map Resource"] = map and map.name or "???",
		["Map Name"] = map and Utility.getName(map, self.gameDB)
	})
end

function Client:traveled(peep, oldMap, newMap)
	oldMap = oldMap and self.gameDB:getResource(oldMap, "Map")
	newMap = newMap and self.gameDB:getResource(newMap, "Map")

	self:submit(Events.TRAVELED, {
		["Player Name"] = peep:getName(),
		["Map Resource"] = newMap and newMap.name or "???",
		["Map Name"] = newMap and Utility.getName(newMap, self.gameDB),
		["Old Map Resource"] = oldMap and oldMap.name or "???",
		["Old Map Name"] = oldMap and Utility.getName(oldMap, self.gameDB)
	})
end

function Client:playedCutscene(peep, cutscene)
	self:submit(Events.PLAYED_CUTSCENE, {
		["Player Name"] = peep:getName(),
		["Resource"] = cutscene
	})
end

local function sanitize(properties, e)
	e = e or {}

	for key, value in pairs(properties) do
		local k = type(key)
		local v = type(value)

		if not (k == 'number' or k == 'string' or k == 'boolean') then
			Log.error("Analytics property key '%s' is type %s (value = '%s'); not allowed!", tostring(key), k, tostring(value))
			return false
		elseif not (v == 'number' or v =='string' or v == 'boolean' or v == 'table') then
			Log.error("Analytics property key '%s' value is type %s (value = '%s'); not allowed!", tostring(key), v, tostring(value))
			return false
		end

		if v == 'table' then
			if e[v] then
				Log.error("Analytics property key '%s' is recursive table.", tostring(k))
				return false
			else
				e[v] = true
				if not sanitize(value, e) then
					return false
				end
				e[v] = nil
			end
		end
	end

	return true
end

function Client:submit(event, properties, flush)
	if not self.serviceThread:isRunning() then
		Log.engine("Not submitting analytic event '%s' (%s): analytics disabled.", event, Log.stringify(properties))
		return
	end

	if not sanitize(properties) then
		Log.error("Properties not valid for analytic event '%s'!", event)
		return
	end

	Log.engine("Submitting analytic event '%s'...", event)

	self.channel:push({
		type = 'submit',
		flush = flush or nil,
		data = {
			event = event,
			properties = properties
		}
	})
end

function Client:getIsEnabled()
	local enable = Client.getConfig().enable
	return enable == nil or enable
end

function Client:enable(device)
	local config = Client.getConfig()
	config.enable = true

	Client.saveConfig(config)
	self:_loadID(device)

	if not self.serviceThread:isRunning() then
		self:_startThread()
	end
end

function Client:disable()
	local config = Client.getConfig()
	config.pending = nil
	config.enable = false

	Client.saveConfig(config)

	if self.serviceThread:isRunning() then
		self:_quit(true)
	end
end

function Client:newSession()
	Log.engine("Creating new analytics session...")

	self.channel:push({ type = "session" })
end

function Client:update()
	if not self.serviceThread:isRunning() then
		if not self.sentQuitMessage then
			self:onQuit()
			self.sentQuitMessage = true
		end
	end
end

function Client:_quit(disable)
	if self.serviceThread:isRunning() then
		self.channel:push({ type = 'quit', disable = disable })
		self.serviceThread:wait()
	end

	if not self.sentQuitMessage then
		self:onQuit()
	end
end

function Client:quit()
	self:_quit()
end

return Client
