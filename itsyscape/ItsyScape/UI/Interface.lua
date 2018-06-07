--------------------------------------------------------------------------------
-- ItsyScape/UI/Interface.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Widget = require "ItsyScape.UI.Widget"

local Interface = Class(Widget)

-- Constructs a new interface, (id, index), belonging to the UI model, 'ui'.
function Interface:new(id, index, view)
	Widget.new(self)

	self.id = id
	self.index = index
	self.view = view
end

-- Gets the UI model this interface belongs to.
function Interface:getUI()
	return self.view:getUI()
end

-- Gets the UI view this interface belongs to.
function Interface:getView()
	return self.view
end

-- Gets the interface ID.
function Interface:getID()
	return self.id
end

-- Gets the index of the interface.
function Interface:getIndex()
	return self.index
end

-- Called when the interface is poked.
function Interface:poke(actionID, actionIndex, e)
	if actionIndex == nil then
		local func = self[actionID]
		if func then
			local s, r = pcall(func, self, unpack(e, e.n))
			if not s then
				io.stderr:write("error: ", r, "\n")
				self:sendPoke("$error", 1, { actionID = actionID, message = r })

				return false
			end

			return true
		end
	end

	return false
end

-- Utility to poke the correct Interface via the UI model.
function Interface:sendPoke(actionID, actionIndex, e)
	return self:getUI():poke(
		self:getID(),
		self:getIndex(),
		actionID,
		actionIndex,
		e)
end

-- Gets the state this Interface holds.
--
-- State is a table of values referenced by children widgets. For example, an
-- inventory widget may expect there to be an array called 'items' with fields
-- { id, count, noted }.
--
-- Returns the state. This state overrides the current state, if any.
--
-- By default, it requests the state from the UI model.
function Interface:getState()
	return self:getUI():pull(self:getID(), self:getIndex()) or {}
end

return Interface
