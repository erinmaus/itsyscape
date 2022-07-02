--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/UI.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"

-- User interface. Pretty self-explanatory.
local UI = Class()

function UI:new()
	-- Called when a top-level interface is opened.
	--
	-- Arguments are (interfaceID, index).
	self.onOpen = Callback()

	-- Called when a top-level interface pushes new state.
	-- Arguments are (interfaceID, index, state).
	self.onPush = Callback()

	-- Called when a top-level interface is closed.
	--
	-- Arguments are (interfaceID, index).
	self.onClose = Callback()

	-- Called when an interface is poked (server-to-client).
	--
	-- Arguments are (interfaceID, interfaceIndex, actionID, actionIndex, e).
	self.onPoke = Callback()
end

-- Pokes the specified interface (client-to-server).
--
-- 'actionID' and 'actionIndex' are a tuple representing the action/widget being
-- acted upon.
--
-- 'e' is a table of event data. It should be a simple table; no userdata. The
-- specified values of 'e' depend on the interface.
function UI:poke(interface, index, actionID, actionIndex, e)
	Class.ABSTRACT()
end

-- Pulls data from the interface.
function UI:pull(interface, index)
	return Class.ABSTRACT()
end

-- Returns true if the interface is open, false otherwise.
--
-- If index is nil, then returns true if any interface 'interface' is open.
function UI:isOpen(interface, index)
	return Class.ABSTRACT()
end

-- Returns true if the interface is closed, false otherwise.
--
-- This is already implemented as 'not self:isOpen(interface, index)'.
function UI:isClosed(interface, index)
	return not self:isOpen(interface, index)
end

return UI
