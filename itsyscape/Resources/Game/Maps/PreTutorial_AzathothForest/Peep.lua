--------------------------------------------------------------------------------
-- Resources/Game/Maps/PreTutorial_AzathothForest/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"


local Forest = Class(Map)
Forest.INVENTORY_STEPS = {
	{
		id = 'Ribbon-PlayerInventory',
		text = "Tap here to access your inventory.",
		callback = function(player)
			return function()
				return Utility.UI.isOpen(player, 'PlayerInventory')
			end
		end
	},
	{
		id = 'PlayerInventory',
		text = "Click on items to use them.\nRight-click to see more options.\nClick on the inventory button to close this tab.",
		callback = function(player)
			return function()
				return not Utility.UI.isOpen(player, 'PlayerInventory')
			end
		end
	},
	{
		id = 'Ribbon-PlayerEquipment',
		text = "Tap here to access your equipment.",
		callback = function(player)
			return function()
				return Utility.UI.isOpen(player, 'PlayerEquipment')
			end
		end
	},
	{
		id = 'PlayerEquipment',
		text = "Click on items to dequip them.\nRight-click to see more options.\nClick on the equipment button to close this tab.",
		callback = function(player)
			return function()
				return not Utility.UI.isOpen(player, 'PlayerEquipment')
			end
		end
	}
}

function Forest:new(resource, name, ...)
	Map.new(self, resource, name or 'PreTutorial_AzathothForest', ...)
end

function Forest:step(steps)
	self.index = self.index + 1

	local step = steps[self.index]
	if step then
		Utility.UI.openInterface(
			self.player,
			"TutorialHint",
			false,
			step.id,
			step.text,
			step.callback(self.player),
			{ position = 'up', style = 'rectangle' },
			function() self:step(steps) end)
	else
		self.player:removeBehavior(DisabledBehavior)
	end
end

function Forest:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	self.player = self:getDirector():getGameInstance():getPlayer():getActor():getPeep()
	self.player:addBehavior(DisabledBehavior)
	
	self.index = 0
	self:step(Forest.INVENTORY_STEPS)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'PreTutorial_AzathothForest_Fungus', 'Fungal', {
		gravity = { 0, -1, 0 },
		wind = { -1, 0, 0 },
		colors = {
			{ 0.43, 0.54, 0.56, 1.0 },
			{ 0.63, 0.74, 0.76, 1.0 }
		},
		minHeight = 12,
		maxHeight = 20,
		heaviness = 0.25
	})
end

return Forest
