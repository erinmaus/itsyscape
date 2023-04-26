--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Pretutorial/Common.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"

local Common = {}
Common.ENCHANT_HINT = {
	{
		position = 'up',
		id = "Ribbon-PlayerSpells",
		message = "Click here to access your spells.",
		open = function(target)
			return function()
				return Utility.UI.isOpen(target, "PlayerSpells")
			end
		end
	},
	{
		position = 'up',
		id = "Spell-Enchant",
		message = "Click the Enchant spell to activate it.",
		open = function(target)
			return function()
				return Utility.UI.isOpen(target, "CraftWindow")
			end
		end
	},
	{
		position = 'up',
		id = "CraftWindow",
		message = "This is the craft window.\nClick on the copper amulet then enter a quantity.\nAfter you're happy, click 'Make it!'",
		open = function(target)
			return function()
				return not target:getState():has('Item', "CopperAmulet", 1, { ['item-inventory'] = true }) or
				       not Utility.UI.isOpen(target, "CraftWindow")
			end
		end
	}
}

Common.QUEST_HINT = {
	{
		position = 'up',
		id = "Ribbon-Nominomicon",
		message = "Click here to access the Nominomicon.\nThe Nominomicon let's you see quest progress.",
		open = function(target)
			return function()
				return Utility.UI.isOpen(target, "Nominomicon")
			end
		end
	},
	{
		position = 'up',
		id = "Quest-PreTutorial",
		message = "Click here to view the tutorial progress.",
		open = function(target)
			return function()
				local open, index = Utility.UI.isOpen(target, "Nominomicon")
				if open then
					local interface = Utility.UI.getOpenInterface(target, "Nominomicon", index)
					return interface.state.currentQuestID == "PreTutorial"
				end

				return true
			end
		end
	}
}

function Common.showTip(tips, target)
	target:addBehavior(DisabledBehavior)

	local index = 0
	local function after()
		index = index + 1
		if index <= #tips then
			Utility.UI.openInterface(
				target,
				"TutorialHint",
				false,
				tips[index].id,
				tips[index].message,
				tips[index].open(target),
				{ position = tips[index].position },
				after)
		else
			target:removeBehavior(DisabledBehavior)
		end
	end

	after()
end

function Common.showEnchantTip(target)
	Common.showTip(Common.ENCHANT_HINT, target)
end

function Common.showQuestTip(target)
	Common.showTip(Common.QUEST_HINT, target)
end

return Common
