--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Game.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Game = require "ItsyScape.Game.Model.Game"
local LocalStage = require "ItsyScape.Game.LocalModel.Stage"
local ItsyScapeDirector = require "ItsyScape.Game.ItsyScapeDirector"

local LocalGame = Class(Game)
LocalGame.TICKS_PER_SECOND = 10

function LocalGame:new()
	Game.new(self)

	self.director = ItsyScapeDirector(self)
	self.stage = LocalStage(self)
	self.ticks = 0
end

function LocalGame:getStage()
	return self.stage
end

function LocalGame:getDirector()
	return self.director
end

function LocalGame:getTicks()
	return LocalGame.TICKS_PER_SECOND
end

function LocalGame:getCurrentTick()
	return self.ticks
end

function LocalGame:tick()
	self.ticks = self.ticks + 1
	self.director:update()
end

return LocalGame
