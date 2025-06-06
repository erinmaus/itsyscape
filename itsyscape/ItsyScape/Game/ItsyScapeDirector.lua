--------------------------------------------------------------------------------
-- ItsyScape/Game/ItsyScapeDirector.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ItemBroker = require "ItsyScape.Game.ItemBroker"
local ItemManager = require "ItsyScape.Game.ItemManager"
local PlayerStorage = require "ItsyScape.Game.PlayerStorage"
local Director = require "ItsyScape.Peep.Director"
local Peep = require "ItsyScape.Peep.Peep"
local MovementCortex = require "ItsyScape.Peep.Cortexes.MovementCortex"
local MoveToTileCortex = require "ItsyScape.Peep.Cortexes.MoveToTileCortex"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"

local ItsyScapeDirector = Class(Director)

function ItsyScapeDirector:new(game, gameDB)
	Director.new(self, gameDB)

	self:addCortex(require "ItsyScape.Peep.Cortexes.ShipMovementCortex")
	self:addCortex(MoveToTileCortex)
	self:addCortex(MovementCortex)
	self:addCortex(require "ItsyScape.Peep.Cortexes.MashinaCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.MirrorCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.CombatCortex2")
	self:addCortex(require "ItsyScape.Peep.Cortexes.CombatXPCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.DeathCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.PrayerDrainCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.StatDrainCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.LootDropperCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.HumanoidActorAnimatorCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.CreepActorAnimatorCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.ActorPositionUpdateCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.ActorDirectionUpdateCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.FollowerCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.CloudCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.SkyCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.OceanUpdateCortex")

	self.game = game
	self.gameDB = gameDB

	self.itemManager = ItemManager(gameDB)
	self.itemBroker = ItemBroker(self.itemManager)

	self.playerStorage = {}

	self:setPlayerStorage(0, PlayerStorage())
end

function ItsyScapeDirector:setPlayerStorage(index, value)
	if value and (not value or Class.isType(value, PlayerStorage)) then
		self.playerStorage[index] = value or PlayerStorage()
	end
end

function ItsyScapeDirector:getPlayerStorage(peep)
	if peep then
		local index
		if type(peep) == 'number' then
			index = peep
		elseif Class.isCompatibleType(peep, Peep) then
			local player = peep:getBehavior(PlayerBehavior)
			if player and player.playerID then
				index = player.playerID
			end
		end

		if index then
			local storage = self.playerStorage[index]
			if not storage then
				storage = PlayerStorage()
				self.playerStorage[index] = storage
			end

			return storage
		end

		if Class.isCompatibleType(peep, Peep) then
			local instance = self.game:getStage():getPeepInstance(peep)
			if instance then
				return instance:getPlayerStorage()
			end
		end
	end

	return self.playerStorage[0]
end

function ItsyScapeDirector:getGameInstance()
	return self.game
end

function ItsyScapeDirector:getGameDB()
	return self.gameDB
end

function ItsyScapeDirector:getItemManager()
	return self.itemManager
end

function ItsyScapeDirector:getItemBroker()
	return self.itemBroker
end

return ItsyScapeDirector
