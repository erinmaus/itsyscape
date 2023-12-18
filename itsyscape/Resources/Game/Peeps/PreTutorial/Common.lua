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

Common.COMMON_HINT_DURATION = 4

Common.DEQUIP_HINT = {
	{
		position = 'up',
		id = "Ribbon-PlayerEquipment",
		message = _MOBILE and "Tap here to access your equipment." or "Click here to access your equipment.",
		open = function(target)
			return function()
				return Utility.UI.isOpen(target, "PlayerEquipment")
			end
		end
	},
	{
		position = 'up',
		id = "Equipment-PLAYER_SLOT_NECK",
		message = _MOBILE and "Tap the copper amulet spell to dequip it.\nIt will return to your inventory." or "Click the copper amulet spell to dequip it.\nIt will return to your inventory.",
		open = function(target)
			return function()
				return not target:getState():has("Item", "CopperAmulet", 1, { ['item-equipment'] = true })
			end
		end
	},
	{
		position = 'up',
		id = "Ribbon-PlayerSpells",
		message = _MOBILE and "Tap here to access your spells." or "Click here to access your spells.",
		open = function(target)
			return function()
				return Utility.UI.isOpen(target, "PlayerSpells")
			end
		end
	},
	{
		position = 'up',
		id = "Spell-Enchant",
		message = _MOBILE and "Tap the Enchant spell to activate it." or "Click the Enchant spell to activate it.",
		open = function(target)
			return function()
				return Utility.UI.isOpen(target, "CraftWindow")
			end
		end
	},
	{
		position = 'down',
		id = "Craft-GhostspeakAmulet",
		message = _MOBILE and "This is the craft window.\nTap on the copper amulet and then enter a quantity.\nAfter you're happy, click 'Make it!'" or "This is the craft window.\nClick on the copper amulet and then enter a quantity.\nAfter you're happy, click 'Make it!'",
		open = function(target)
			return function()
				return not target:getState():has('Item', "CopperAmulet", 1, { ['item-inventory'] = true }) or
				       not Utility.UI.isOpen(target, "CraftWindow")
			end
		end
	}
}

Common.CRAFT_HINT = {
	{
		position = 'up',
		id = "Ribbon-PlayerInventory",
		message = _MOBILE and "Tap here to access your inventory." or "Click here to access your inventory.",
		open = function(target)
			return function()
				return Utility.UI.isOpen(target, "PlayerInventory")
			end
		end
	},
	{
		position = 'up',
		id = "Inventory-ShadowLogs",
		message = _MOBILE and "Tap the shadow logs to see what you can craft or fletch.\nRemember, you will need a knife to craft or fletch.\nIf you lost your knife, go back to the shed and search the crate." or "Click the shadow logs to see what you can craft or fletch.\nRemember, you will need a knife to craft or fletch.\nIf you lost your knife, go back to the shed and search the crate.",
		open = function(target)
			return function()
				return not target:getState():has("Item", "ShadowLogs", 1, { ['item-inventory'] = true }) or Utility.UI.isOpen(target, "CraftWindow")
			end
		end
	},
	{
		position = 'down',
		id = "Craft-ToyLongsword",
		message = _MOBILE and "Tap on the wooden sword and then enter a quantity.\nAfter you're happy, click 'Make it!'" or "Click on the wooden sword and then enter a quantity.\nAfter you're happy, click 'Make it!'",
		open = function(target)
			return function()
				return not Utility.UI.isOpen(target, "CraftWindow")
			end
		end
	}
}

Common.ENCHANT_HINT = {
	{
		position = 'up',
		id = "Ribbon-PlayerSpells",
		message = _MOBILE and "Tap here to access your spells." or "Click here to access your spells.",
		open = function(target)
			return function()
				return Utility.UI.isOpen(target, "PlayerSpells")
			end
		end
	},
	{
		position = 'up',
		id = "Spell-Enchant",
		message = _MOBILE and "Tap the Enchant spell to activate it." or "Click the Enchant spell to activate it.",
		open = function(target)
			return function()
				return Utility.UI.isOpen(target, "CraftWindow")
			end
		end
	},
	{
		position = 'down',
		id = "Craft-GhostspeakAmulet",
		message = _MOBILE and "This is the craft window.\nTap on the copper amulet and then enter a quantity.\nAfter you're happy, click 'Make it!'" or "This is the craft window.\nClick on the copper amulet and then enter a quantity.\nAfter you're happy, click 'Make it!'",
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
		message = _MOBILE and "Tap here to access the Nominomicon.\nThe Nominomicon let's you see quest progress." or "Click here to access the Nominomicon.\nThe Nominomicon let's you see quest progress.",
		open = function(target)
			return function()
				return Utility.UI.isOpen(target, "Nominomicon")
			end
		end
	},
	{
		position = 'up',
		id = "Quest-PreTutorial",
		message = _MOBILE and "Tap here to view the tutorial progress." or "Click here to view the tutorial progress.",
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

function Common.showTip(tips, target, done)
	target:addBehavior(DisabledBehavior)

	local time = love.timer.getTime()
	Utility.UI.openInterface(
		target,
		"TutorialHint",
		false,
		"root",
		_MOBILE and "Look at the bottom right corner.\nTap on the flashing icon to continue." or "Look at the bottom right corner.\nClick on the flashing icon to continue.",
		function()
			return love.timer.getTime() > time + Common.COMMON_HINT_DURATION
		end,
		{ position = 'center' })

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
			if done then
				done()
			end
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

function Common.showDequipTip(target)
	Common.showTip(Common.DEQUIP_HINT, target)
end

function Common.showCraftTip(target)
	Common.showTip(Common.CRAFT_HINT, target, function()
		Utility.Quest.listenForItem(target, "ShadowLogs", function()
			if not target:getState():has("KeyItem", "PreTutorial_CraftedToyWeapon") then
				Common.showCraftTip(target)
			end
		end)
	end)
end

function Common.showKeyItemHint(target)
	local targetTime = love.timer.getTime() + 2.5

	Utility.UI.openInterface(
		target,
		"TutorialHint",
		false,
		"QuestProgressNotification",
		nil,
		function()
			return love.timer.getTime() > targetTime
		end)
end

function Common.listenForKeyItemHint(target)
	Utility.Quest.listenForKeyItem(target, "PreTutorial_(.+)", function()
		Common.showKeyItemHint(target)
	end)
end

return Common
