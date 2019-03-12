--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Weather.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Weather = Class()
function Weather:new(gameView, map, ...)
	self.gameView = gameView
	self.map = map
end

function Weather:getGameView()
	return self.gameView
end

function Weather:getMap()
	return self.map
end

function Weather:update(delta)
	-- Nothing.
end

function Weather:draw()
	-- Nothing.
end

return Weather
