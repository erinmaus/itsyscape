--------------------------------------------------------------------------------
-- ItsyScape/GameDB/Commands/ActionCategory.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Action = require "ItsyScape.GameDB.Commands.Action"

-- Category for Actions.
--
-- This is the backing logic for Game.Action.
--
-- Similar to ResourceCategory, except the Action instances are not kept. (They
-- should be connected to Resources).
local ActionCategory = Class()

function ActionCategory:new(game)
	self._game = game
end

-- Internal method. Adds a new field 'name' that constructs Actions of type
-- 'name'.
--
-- It is an error to create a field with an existing name.
function ActionCategory:add(name)
	assert(self[name] == nil, string.format("'%s' already exists", name))

	self[name] = function(actionName)
		local actionType = self._game:getActionType(name)
		return Action(actionType, actionName)
	end
end

return ActionCategory
