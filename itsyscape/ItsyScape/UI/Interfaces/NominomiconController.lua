--------------------------------------------------------------------------------
-- ItsyScape/UI/NominomiconController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Controller = require "ItsyScape.UI.Controller"

local NominomiconController = Class(Controller)

NominomiconController.TUTORIAL = {
	["en-US"] = {
		title = "ItsyRealm Guidebook",
		{
			{
				t = 'header',
				"Welcome to ItsyRealm!"
			},
			"In ItsyRealm, exploration is key. To help you on your journey, keep in mind some useful controls:",
			{
				t = 'list',
				"Left-click to perform the default action in the game world and in the UI.",
				"Right-click to view all available actions.",
				"Use the middle mouse button to move the camera and the mouse wheel to zoom.",
			},
			{
				t = 'text',
				"For an in-depth look at gameplay and a FAQ, check out the",
				{
					t = 'link',
					destination = 'http://itsyrealm.com/nominomicon',
					text = "ItsyRealm website"
				},
				". Otherwise, keep reading for a quick guide to ItsyRealm!"
			},
			{
				t = 'header',
				"Combat"
			},
			"Fighting through the army of creeps that awaits you is critical to success.",
			"To fight a creep (and sometimes a friendly peep), select the 'Attack' option. " ..
			"This is usually the default action for creeps, and a hidden option for friendly peeps.",
			"The creep's combat level is shown if you hover over it or right-click it. " ..
			"The stronger the creep, the higher level its combat level will be.",
			{
				t = 'text',
				"When fighting a creep, you have the option to quit fighting. " ..
				"Click the 'flee' button on the combat status HUD (in the lower left hand corner of the screen).",
				"",
				"It looks like this:",
				{ t = 'image', resource ="Resources/Game/UI/Icons/Concepts/Flee.png" }
			},
			"When using magic and archery, you can run around creep with smaller attack ranges. " ..
			"This allows you to take less damage and forces the creep to chase you.",
			"If you get out of range of an enemy, your peep will try to get back in range. " ..
			"Failing that, they give up.",
			"The downside is you need ammunition or runes to fight from a distance. " ..
			"For archery, you'll either need a boomerang (a weaker weapon with infinite ammo) or arrows, bolts, etc (depending on the weapon). " ..
			"For magic, you'll need runes (dropped by monsters and made by using unfocused runes on obelisks scattered around the world) and an active combat spell. ",
			"Spells can be set in the spells tab. From there, you can hover over a spell to see the requirements and a description. " ..
			"To stop using a spell, go to the stance tab and deselect 'Use Spell.' " ..
			"You must be using a magic weapon (such as a wand, cane, or staff) to use combat spells.",
			"You can change the way you gain XP in the stance tab. " ..
			"This also allows you to better utilize your skills.",
			{
				t = 'list',
				"When using an aggressive stance, you gain XP in the damage-increasing skill (Wisdom, Strength, or Dexterity). " ..
				"You also deal slightly more damage.",

				"A controlled stance gives you XP in the accuracy-increasing skill (Magic, Attack, or Archery). " ..
				"Your hits will be slightly more accurate as well.",

				"Lastly, when using a defensive stance, you gain XP in Defense. " ..
				"You'll better dodge attacks, too."
			},
			{
				t = 'header',
				"Skills"
			},
			"You can use gathering skills (such as mining, fishing, and woodcutting) or combat to obtain resources. " ..
			"These resources can then be refined by artisan skills (like smithing, cooking, crafting, and engineering) to make weapons, armor, and other useful items.",
			"To see all of what you can gather and make, check out the skill guides on the stats tab. " ..
			"Simply click on the corresponding tab to view a list of nearly all things possible with that skill."
		}
	}
}

NominomiconController.CREDITS = {
	["en-US"] = {
		title = "Credits",
		{
			{
				t = "header",
				"ItsyRealm Credits",
			},
			"Thank you for playing! Here's a list of credits.",
			{
				t = "header",
				"Coding / Writing / Graphics / Animations",
			},
			"Erin Maus",
			{
				t = "header",
				"Special Thanks",
			},
			"Leif",
			"Thatcher",
			{
				t = "header",
				"Music",
			},
			{
				t = 'text',
				{
					t = 'link',
					destination = 'https://speakmusic.bandcamp.com',
					text = "speak (speakmusic.bandcamp.com)"
				}
			},
			"Elaine Williams"
		}
	}
}

function NominomiconController:new(peep, director)
	Controller.new(self, peep, director)

	local game = director:getGameInstance()
	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()

	self.quests = {}
	self.questInfo = {}

	local quests = gameDB:getResources("Quest")
	for q in gameDB:getResources("Quest") do
		local quest = {
			id = q.name,
			name = Utility.getName(q, gameDB),
			description = Utility.getDescription(q, gameDB),
			didComplete = Utility.Quest.didComplete(q, peep),
			inProgress = Utility.Quest.didStart(q, peep),
			canStart = Utility.Quest.canStart(q, peep),
			isQuest = true
		}

		local steps = Utility.Quest.build(q, gameDB)
		local questInfo = Utility.Quest.buildWorkingQuestLog(steps, gameDB)

		table.insert(self.quests, quest)
		table.insert(self.questInfo, questInfo)
	end

	table.insert(self.quests, 1, {
		id = "X_Introduction",
		name = "Introduction",
		description = "Learn about the world of ItsyRealm.",
		isQuest = false
	})

	table.insert(self.questInfo, 1, NominomiconController.TUTORIAL["en-US"][1])

	table.insert(self.quests, {
		id = "X_Credits",
		name = "Credits",
		description = "See who made the magic.",
		isQuest = false
	})

	table.insert(self.questInfo, NominomiconController.CREDITS["en-US"][1])

	self.state = {
		quests = self.quests,
		hideQuestProgress = self:getDirector():getPlayerStorage(self:getPeep()):getRoot():getSection("Nominomicon"):get("hideQuestProgress") == true
	}

	self:buildBosses()
end

function NominomiconController:buildBosses()
	local bosses = {}

	local gameDB = self:getDirector():getGameDB()
	local areas = gameDB:getRecords("BossCategory", { Language = "en-US" })
	for _, area in ipairs(areas) do
		local a = {
			name = area:get("Name"),
			description = area:get("Description"),
			bosses = {}
		}

		local areaName = area:get("Category")
		local bossRecords = gameDB:getRecords("Boss", {
			Category = area:get("Category")
		})


		local hit = {}

		for _, boss in ipairs(bossRecords) do
			local bossResource = boss:get("Boss")
			if not hit[bossResource.id.value] then
				local killCount = Utility.Boss.getKillCount(self:getPeep(), bossResource)
				local b = {
					name = Utility.getName(bossResource, gameDB),
					description = Utility.getDescription(bossResource, gameDB),
					count = killCount,
					isSpecial = boss:get("RequireKill") ~= 0,
					items = self:buildBossDrops(bossResource)
				}

				table.insert(a.bosses, b)

				hit[bossResource.id.value] = true
			end
		end


		table.insert(bosses, a)
	end

	table.insert(self.quests, 2, {
		id = "X_BossLog",
		name = "Boss Log",
		description = "See the slain bosses and drops you've gotten from them.",
		isQuest = false
	})

	table.insert(self.questInfo, 2, { bosses = bosses })
end

function NominomiconController:buildBossDrops(boss)
	local gameDB = self:getDirector():getGameDB()
	local items = {}

	local tables = gameDB:getRecords("BossDropTable", {
		Boss = boss
	})

	for _, bossDropTable in ipairs(tables) do
		local dropTableResource = bossDropTable:get("DropTable")

		local lootRecords = gameDB:getRecords("DropTableEntry", { Resource = dropTableResource })
		for _, loot in ipairs(lootRecords) do
			local item = loot:get("Item")
			items[item.name] = true
		end

		local rewardActions = Utility.getActions(self:getGame(), dropTableResource, 'loot')
		for _, reward in ipairs(rewardActions) do
			local constraints = Utility.getActionConstraints(self:getGame(), reward.instance:getAction())
			for _, output in ipairs(constraints.outputs) do
				if output.type:lower() == "item" then
					items[output.resource] = true
				end
			end
		end
	end

	local drops = Utility.Boss.getDrops(self:getPeep(), boss)
	local result = {}
	for item in pairs(items) do
		local itemResource = gameDB:getResource(item, "Item")
		table.insert(result, {
			id = item,
			name = Utility.getName(itemResource, gameDB) or ("*" .. item),
			description = Utility.getDescription(itemResource, gameDB),
			count = drops[item] and drops[item].count or 0
		})
	end

	table.sort(result, function(a, b)
		local isLegendaryA = Utility.Boss.isLegendary(gameDB, a.id)
		local isLegendaryB = Utility.Boss.isLegendary(gameDB, b.id)
		local isSpecialA = Utility.Boss.isSpecial(gameDB, a.id)
		local isSpecialB = Utility.Boss.isSpecial(gameDB, b.id)

		if isLegendaryA == isLegendaryB then
			if isSpecialA == isSpecialB then
				return a.name < b.name
			elseif isSpecialA and not isSpecialB then
				return true
			elseif not isSpecialA and isSpecialB then
				return false
			end
		elseif isLegendaryA and not isLegendaryB then
			return true
		elseif not isLegendaryA and isLegendaryB then
			return false
		end

		return false
	end)

	return result
end

function NominomiconController:poke(actionID, actionIndex, e)
	if actionID == "select" then
		self:select(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	elseif actionID == "openQuestProgress" then
		self:openQuestProgress(e)
	elseif actionID == "toggleShowQuestProgress" then
		self:toggleShowQuestProgress(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function NominomiconController:openQuestProgress(e)
	assert(type(e.index) == 'number', "index must be number")
	assert(e.index >= 1, "index must be >= 1")
	assert(e.index <= #self.quests, "index must be less than number of quests")

	local gameDB = self:getDirector():getGameDB()
	local quest = gameDB:getResource(self.quests[e.index].id, "Quest")

	if not quest then
		return
	end

	local isOpen, index = Utility.UI.isOpen(self:getPeep(), "QuestProgressNotification")
	if not isOpen then
		local _, n = Utility.UI.openInterface(self:getPeep(), "QuestProgressNotification", false)
		index = n
	end

	if index then
		local controller = Utility.UI.getOpenInterface(self:getPeep(), "QuestProgressNotification", index)
		controller:updateQuest(quest)
	end
end

function NominomiconController:select(e)
	assert(type(e.index) == 'number', "index must be number")
	assert(e.index >= 1, "index must be >= 1")
	assert(e.index <= #self.quests, "index must be less than number of quests")

	local currentQuest = self.questInfo[e.index]

	local result
	if not self.quests[e.index].isQuest then
		result = currentQuest
	else
		result = Utility.Quest.buildRichTextLabelFromQuestLog(currentQuest, self:getPeep())

		table.insert(result, 1, {
			t = 'header',
			self.quests[e.index].name
		})
	end

	if #result == 0 then
		table.insert(result, "You haven't started this quest.")
	end

	self.state.currentQuest = result
	self.state.currentQuestID = self.quests[e.index].id

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateGuide",
		nil,
		{})
end

function NominomiconController:toggleShowQuestProgress()
	local storage = self:getDirector():getPlayerStorage(self:getPeep())
	local hideQuestProgress = not storage:getRoot():getSection("Nominomicon"):get("hideQuestProgress")
	storage:getRoot():getSection("Nominomicon"):set("hideQuestProgress", hideQuestProgress)

	self.state.hideQuestProgress = hideQuestProgress
end

function NominomiconController:pull()
	return self.state
end

return NominomiconController
