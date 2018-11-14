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
	self:addCortex(require "ItsyScape.Peep.Cortexes.CombatCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.LootDropperCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.HumanoidActorAnimatorCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.CreepActorAnimatorCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.ActorPositionUpdateCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.ActorDirectionUpdateCortex")
	--self:addCortex(require "ItsyScape.Peep.Cortexes.MashinaCortex")

	self.game = game
	self.gameDB = gameDB

	self.itemManager = ItemManager(gameDB)
	self.itemBroker = ItemBroker(self.itemManager)

	self.playerStorage = {}
end

function ItsyScapeDirector:getPlayerStorage(peep)
	local player = peep:getBehavior(PlayerBehavior)
	if player and player.id then
		local storage = self.playerStorage[player.id]
		if not storage then
			storage = PlayerStorage()
			self.playerStorage[player.id] = storage
		end

		return storage
	else
		print(player, player.id)
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
