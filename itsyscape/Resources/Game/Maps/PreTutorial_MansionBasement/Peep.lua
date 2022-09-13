--------------------------------------------------------------------------------
-- Resources/Game/Maps/PreTutorial_MansionBasement/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"

local Mansion = Class(Map)
Mansion.MIN_LIGHTNING_PERIOD = 3
Mansion.MAX_LIGHTNING_PERIOD = 6
Mansion.LIGHTNING_TIME = 0.5
Mansion.MAX_AMBIENCE = 2

function Mansion:new(resource, name, ...)
	Map.new(self, resource, name or 'PreTutorial_MansionBasement', ...)
end

function Mansion:onPlayerEnter(player)
	player = player:getActor():getPeep()

	if self.zombiButler:getCurrentTarget() then
		self.zombiButler:giveHint("Oh dear me, looks like someone else needs help!")
	end

	self.zombiButler:poke('followPlayer', player)
	self.zombiButler:poke('floorChange', 2)

	Utility.Quest.listenForAction(player, "Prop", "CopperRock_Default", "Mine", function()
		player:getState():give("KeyItem", "PreTutorial_MineCopper")
	end)

	Utility.Quest.listenForAction(player, "Item", "GhostspeakAmulet", "Enchant", function()
		player:getState():give("KeyItem", "PreTutorial_MineCopper")
		player:getState():give("KeyItem", "PreTutorial_SmeltCopperBar")
		player:getState():give("KeyItem", "PreTutorial_SmithCopperAmulet")
		player:getState():give("KeyItem", "PreTutorial_EnchantedCopperAmulet")
		player:getState():give("KeyItem", "PreTutorial_MadeGhostspeakAmulet")
	end)

	Utility.Quest.listenForItem(player, "GhostspeakAmulet", function()
		player:getState():give("KeyItem", "PreTutorial_MineCopper")
		player:getState():give("KeyItem", "PreTutorial_SmeltCopperBar")
		player:getState():give("KeyItem", "PreTutorial_SmithCopperAmulet")
		player:getState():give("KeyItem", "PreTutorial_EnchantedCopperAmulet")
		player:getState():give("KeyItem", "PreTutorial_MadeGhostspeakAmulet")
	end)
end

return Mansion
