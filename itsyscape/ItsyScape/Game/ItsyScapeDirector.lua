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
local MovementCortex = require "ItsyScape.Peep.Cortexes.MovementCortex"
local MoveToTileCortex = require "ItsyScape.Peep.Cortexes.MoveToTileCortex"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"

local ItsyScapeDirector = Class(Director)

function ItsyScapeDirector:new(game, gameDB)
	Director.new(self, gameDB)

	self:addCortex(MovementCortex)
	self:addCortex(MoveToTileCortex)
	self:addCortex(require "ItsyScape.Peep.Cortexes.MirrorCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.CombatCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.CombatXPCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.PrayerDrainCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.LootDropperCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.HumanoidActorAnimatorCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.CreepActorAnimatorCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.ActorPositionUpdateCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.ActorDirectionUpdateCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.MashinaCortex")

	self.game = game
	self.gameDB = gameDB

	self.itemManager = ItemManager(gameDB)
	self.itemBroker = ItemBroker(self.itemManager)

	self.playerStorage = {}
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
		else
			local player = peep:getBehavior(PlayerBehavior)
			if player and player.id then
				index = player.id
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
	else
		local player = self.game:getPlayer():getActor():getPeep()
		if player then
			return self:getPlayerStorage(player)
		end
	end

	return nil
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
