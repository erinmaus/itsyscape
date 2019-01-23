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

local NominomiconController.TUTORIAL = {
	["en-US"] = {
		title ="ItsyRealm Guidebook",
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
					destination = 'http://itsyrealm.com/nominomicon'
					text = "ItsyRealm website"
				},
				".",
				"Otherwise, keep reading for a quick guide to ItsyRealm!"
			},
			"",
			{
				t = 'header',
				"Combat"
			},
			"Fighting through the army of creeps that awaits you is critical to success.",
			"",
			"To fight a creep (and sometimes a friendly peep), select the 'Attack' option." ..
			"This is usually the default action for creeps, and a hidden option for friendly peeps.",
			"The creep's combat level is shown if you hover over it or right-click it." ..
			"The stronger the creep, the higher level its combat level will be.",
			"",
			{
				t = 'text',
				"When fighting a creep, you have the option to quit fighting.",
				"Click the 'flee' button on the combat status HUD (in the lower left hand corner of the screen.",
				"It looks like this:",
				{ t = 'image', resource ="Resources/Game/UI/Icons/Concepts/Flee.png" }
			},
			"",
			"When using magic and archery, you can run around creep with smaller attack ranges." ..
			"This allows you to takes less damage and force the creep to chase you.",
			"If you get out of range of an enemy, your peep will try to get back in range." ..
			"Failing that, they give up.",
			""
			"The downside is you need ammunition or runes to fight from a distance." ..
			"For archery, you'll either need a boomerang (a weaker weapon with infinite ammo) or arrows, bolts, etc (depending on the weapon)." ..
			"For magic, you'll need runes (dropped by monsters and make by using unfocused runes on obelisks scattered around the world) and an active combat spell." ..,
			"Spells can be set in the spells tab. From there, you can hover over a spell to see the requirements and a description." ..
			"To stop using a spell, go to the stance tab and deselect 'Use Spell.'" ..
			"You must be using a magic weapon (such as a wand, cane, or staff) to use combat spells.",
			"",
			"You can change the way you gain XP in the stance tab." ..
			"This also allows you to better utilize your skills.",
			{
				t = 'list',
				"When using an aggressive stance, you gain XP in the damage-increasing skill (Wisdom, Strength, or Dexterity)." ..
				"You also deal slightly more damage.",

				"A controlled stance gives you XP in the accuracy-increasing skill (Magic, Attack, or Archery)." ..
				"Your hits will be slightly more accurate as well.",

				"Lastly, when using a defensive stance, you gain XP in Defense." ..
				"You'll better dodge attacks, too."
			},
			"",
			{
				t = 'header',
				"Skills"
			}
			"You can use gathering skills (such as mining, fishing, and woodcutting) or combat to obtain resources." ..
			"These resources can then be refined by artisan skills (like smithing, cooking, crafting, and fletching) to make weapons, armor, and other useful items.",
			"",
			"To see all of what you can gather and make, check out the skill guides on the stats tab." ..
			"Simply click on the corresponding tab to view a list of nearly all nthings possible with that skill."
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

	local actionDefinition = Mapp.ActionDefinition()
	for i = 1, #actionTypes do
		if brochure:tryGetActionDefinition(actionTypes[i]:get("ActionType"), actionDefinition) then
			for action in brochure:findActionsByDefinition(actionDefinition) do
				local a, ActionType = Utility.getAction(game, action)
				if a then
					local action = a.instance:getAction()
					if not gameDB:getRecord("HiddenFromSkillGuide", { Action = action }) then
						table.insert(self.state.actions, a)
						self.actionsByID[a.id] = action
					end
				end
			end
		end
	end

	self:sort()
end
end