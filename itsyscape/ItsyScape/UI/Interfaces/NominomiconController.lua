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
				t = "text",
				{
					t = "link",
					destination = "https://incompetech.com/",
					text = "'Inner Sanctum' - Kevin Macleod",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://incompetech.com/",
					text = "'Netherworld Shanty' - Kevin Macleod",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://incompetech.com/",
					text = "'Night Cave' - Kevin Macleod",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://incompetech.com/",
					text = "'Unholy Knight' - Kevin Macleod",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://incompetech.com/",
					text = "'Sneaky Snitch' - Kevin Macleod",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://incompetech.com/",
					text = "'Whiskey on the Mississippi' - Kevin Macleod",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://www.silvermansound.com/",
					text = "'The Buccaneer's Haul' - Silverman Sound Studios",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://www.bensound.com/royalty-free-music/track/ofelias-dream",
					text = "'Ofelia's Dream' - Bensound",
				},
			},
			{
				t = "header",
				"Sound Effects",
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/429178/",
					text = "'THUNDERSTORM - 1' - SamuelGremaud",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/446450/",
					text = "'52-Boomerang.wav' - UsuarioLeal",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/7720/",
					text = "'Bone Cracking 2.wav' - DalomarGrimm",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/341918/",
					text = "'bone snap 8.mp3' - ShockwaveFIlms",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/288941/",
					text = "'rat-squeak.wav' - toefur",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/233093/",
					text = "'Chicken - Buck - 96kHz.wav' - JarredGibb",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/58277/",
					text = "'Cow.wav' - Benboncan",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/155235/",
					text = "'Bomb - Small' - Zangrutz",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/399617/",
					text = "'Knife/sword stab #2.MP3' - SoundsForHim",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/216089/",
					text = "'Magic' - RICHERlandTV",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/221683/",
					text = "'another magic wand spell tinkle.flac' - Timbre",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/155235/",
					text = "'Bomb - Small' - Zangrutz",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/195568/",
					text = "'Creature Roar 1' - jacobalcook",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/249686/",
					text = "'Cthulhu growl.wav' - cylon8472",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/406458/",
					text = "'Punching-003.wav' - kretopi",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/178318/",
					text = "'04099 magic string spell.wav' - Robinhood76",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/221683/",
					text = "'another magic wand spell tinkle.flac' - Timbre",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/216089/",
					text = "'Magic' - RICHERlandTV",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/349206/",
					text = "'Paper Smack' - Natty23",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/471156/",
					text = "'chair smack.wav' - Worldmaxter",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/203075/",
					text = "'Ruler Smack.wav' - deleted_user_3737200",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/384915/",
					text = "'Bow Release (Bow and Arrow)' - Ali_6868",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/398808/",
					text = "'Bubbling, Large, A.wav' - InspectorJ",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/99964/",
					text = "'Pounding a metal stake with hammer.wav' - CGEffex",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/399617/",
					text = "'Knife/sword stab #2.MP3' - SoundsForHim",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/180820/",
					text = "'SwordClash01' - 32cheeseman32",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/240801/",
					text = "'Pickaxe mining stone' - ryanconway",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/23700/",
					text = "'chop.wav' - hazure",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/475094/",
					text = "'thunder3.ogg' - Josh74000MC",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/s/398765/",
					text = "'noodles - stir 01.wav' - Anthousai",
				},
			},
			{
				t = "text",
				{
					t = "link",
					destination = "https://freesound.org/people/BranndyBottle/sounds/464693/",
					text = "'treeshake.wav' - BranndyBottle",
				},
			},
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
			description = Utility.getDescription(q, gameDB)
		}

		local questInfo = {}
		do
			local steps = Utility.Quest.build(q, gameDB)
			for i = 1, #steps do
				local step = steps[i]
				if #step > 1 then
					local block = {
						t = 'list'
					}

					for i = 1, #step do
						local description1 = Utility.getDescription(step[i], gameDB, nil, 1)
						local description2 = Utility.getDescription(step[i], gameDB, nil, 2)
						table.insert(block, { description1, description2 })
					end

					table.insert(questInfo, { block = block, resources = step })
				else
					table.insert(questInfo, {
						block = {
							{ Utility.getDescription(step[1], gameDB, nil, 1),
							  Utility.getDescription(step[1], gameDB, nil, 2) }
						},
						resources = step
					})
				end
			end

			table.insert(questInfo, 1, {
				t = 'header',
				quest.name
			})
		end

		table.insert(self.quests, quest)
		table.insert(self.questInfo, questInfo)
	end

	table.insert(self.quests, 1, {
		id = "X_Introduction",
		name = "Introduction",
		description = "Learn about the world of ItsyRealm."
	})

	table.insert(self.questInfo, 1, NominomiconController.TUTORIAL["en-US"][1])

	table.insert(self.quests, {
		id = "X_Credits",
		name = "Credits",
		description = "See who made the magic."
	})

	table.insert(self.questInfo, NominomiconController.CREDITS["en-US"][1])

	self.state = {
		quests = self.quests
	}
end

function NominomiconController:poke(actionID, actionIndex, e)
	if actionID == "select" then
		self:select(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function NominomiconController:select(e)
	assert(type(e.index) == 'number', "index must be number")
	assert(e.index >= 1, "index must be >= 1")
	assert(e.index <= #self.quests, "index must be less than number of quests")

	local currentQuest = self.questInfo[e.index]

	local result
	if e.index == 1 or e.index == #self.questInfo then
		result = currentQuest
	else
		result = { currentQuest[1] }
		do
			local peep = self:getPeep()

			local max
			for i = 2, #currentQuest do
				local block = {}
				local hasAny = false
				for j = 1, #currentQuest[i].resources do
					if peep:getState():has("KeyItem", currentQuest[i].resources[j].name) then
						table.insert(block, currentQuest[i].block[j][2])
						hasAny = true
					else
						table.insert(block, currentQuest[i].block[j][1])
					end
				end

				if #block == 1 then
					block.t = 'text'
				else
					block.t = 'list'
				end

				table.insert(result, block)

				if not hasAny then
					max = i

					if not _DEBUG then
						break
					end
				end
			end

			if max then
				table.insert(result, currentQuest[max].block[1])
			end
		end
	end

	if #result == 1 then
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

function NominomiconController:pull()
	return self.state
end

return NominomiconController