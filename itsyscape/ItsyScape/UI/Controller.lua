--------------------------------------------------------------------------------
-- ItsyScape/UI/Controller.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Controller = Class()

-- Constructs a new UI controller for the peep and director.
function Controller:new(peep, director)
	self.peep = peep
	self.director = director
end

-- Gets the peep this controller belongs to.
function Controller:getPeep()
	return self.peep
end

-- Gets the director this controller belongs to.
function Controller:getDirector()
	return self.director
end

-- Gets the game this controller belongs to.
function Controller:getGame()
	return self.director:getGameInstance()
end

-- Called when the Controller is first opened.
function Controller:open()
	-- Nothing.
end

-- Called when the Controller is closed.
function Controller:close()
	-- Nothing.
end

-- Updates the Controller.
function Controller:update(delta)
	-- Nothing.
end

-- Pokes (actionID, actionIndex) with argument 'e'.
function Controller:poke(actionID, actionIndex, e)
	-- Nothing.
end

-- Pulls the current state of the interface.
function Controller:pull()
	return {}
end

return Controller
