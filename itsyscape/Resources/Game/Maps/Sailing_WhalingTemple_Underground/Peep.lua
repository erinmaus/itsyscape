-------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_WhalingTemple_Underground/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local PreTutorialCommon = require "Resources.Game.Peeps.PreTutorial.V2Common"

local WhalingTempleUnderground = Class(Map)

function WhalingTempleUnderground:new(resource, name, ...)
	Map.new(self, resource, name or 'WhalingTempleUnderground', ...)
end

function WhalingTempleUnderground:onPlayerEnter(player)
	local playerPeep = player:getActor():getPeep()

	self:prepareQuest(playerPeep)
	self:pushPoke("preparePlayer", playerPeep)
end

function WhalingTempleUnderground:onPreparePlayer(playerPeep)
	if not playerPeep:getState():has("KeyItem", "PreTutorial_FoundYenderling") then
		Utility.UI.closeAll(playerPeep)

		playerPeep:addBehavior(DisabledBehavior)
		local cutscene = Utility.Map.playCutscene(self, "Sailing_WhalingTemple_Underground_Yenderling", "StandardCutscene", playerPeep)
		cutscene:listen("done", self.onFinishCutscene, self, playerPeep)
	end
end

function WhalingTempleUnderground:onFinishCutscene(playerPeep)
	playerPeep:removeBehavior(DisabledBehavior)
	Utility.UI.openGroup(playerPeep, Utility.UI.Groups.WORLD)
end

function WhalingTempleUnderground:prepareQuest(playerPeep)
	do
		local yenderlings = self:getDirector():probe(
			self:getLayerName(),
			Probe.resource("Prop", "PreTutorial_Yenderling"))

		for _, yenderling in ipairs(yenderlings) do
			yenderling:listen("die", function()
				playerPeep:getState():give("PreTutorial_SlayedYenderling")
			end)
		end
	end

	do
		local stage = self:getDirector():getGameInstance():getStage()
		local ground = stage:getGround(self:getLayer())
		local inventory = ground and ground:hasBehavior(InventoryBehavior) and ground:getBehavior(InventoryBehavior).inventory
		if inventory then
			local targets = {}

			local function listenForShardDrop(item, _, _, _, peep)
				local position = stage:getMap(self:getLayer()):getTileCenter(Utility.Peep.getTile(peep))

				if playerPeep:getState():has("KeyItem", "PreTutorial_MadeArmor") then
					return
				end

				if item:getID() ~= "AzatiteShard" then
					return
				end

				if peep and not peep:hasBehavior(PlayerBehavior) then
					local target = Utility.spawnPropAtPosition(self, "Target_Default", position.x, position.y, position.z)
					target = target and target:getPeep()

					if target then
						target:setTarget("Azatite shards", not _MOBILE and "Click on the loot bag to pick up the azatite shards!" or "Tap on the loot bag to pick up the azatite shards!")
						targets[item:getRef()] = target
					end
				end
			end

			local function listenForShardTake(item)
				if targets[item:getRef()] then
					Utility.Peep.poof(targets[item:getRef()])
					targets[item:getRef()] = nil
				end
			end

			inventory.onDropItem:register(listenForShardDrop)
			inventory.onTakeItem:register(listenForShardTake)
		end
	end
end

return WhalingTempleUnderground
