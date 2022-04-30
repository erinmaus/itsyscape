--------------------------------------------------------------------------------
-- ItsyScape/Game/RemoteModel/Game.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Game = require "ItsyScape.Game.Model.Game"

local RemoteGame = Class(Game)

function RemoteGame:new(gameManager, gameDB)
	self.gameManager = gameManager
	self.gameDB = gameDB
end

function RemoteGame:getGameDB()
	return self.gameDB
end

function RemoteGame:getPlayer()
	if not self.player then
		self.player = self.gameManager:getInstance("ItsyScape.Game.Model.Player", 0):getInstance()
	end

	return self.player
end

function RemoteGame:getStage()
	if not self.stage then
		self.stage = self.gameManager:getInstance("ItsyScape.Game.Model.Stage", 0):getInstance()
	end

	return self.stage
end

function RemoteGame:getUI()
	if not self.ui then
		self.ui = self.gameManager:getInstance("ItsyScape.Game.Model.UI", 0):getInstance()
	end

	return self.ui
end

return RemoteGame
