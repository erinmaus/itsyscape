--------------------------------------------------------------------------------
-- ItsyScape/World/OpenInterfaceCommand.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Command = require "ItsyScape.Peep.Command"

local OpenInterfaceCommand = Class(Command)

function OpenInterfaceCommand:new(interfaceID, blocking, ...)
	Command.new(self)

	self.interfaceID = interfaceID
	self.blocking = blocking or false
	self.index = false
	self.arguments = { n = select('#', ...), ... }
end

function OpenInterfaceCommand:getIsFinished()
	return self.index ~= false
end

function OpenInterfaceCommand:onBegin(peep)
	local ui = peep:getDirector():getGameInstance():getUI()

	if self.blocking then
		local _, n = ui:openBlockingInterface(
			peep,
			self.interfaceID,
			unpack(self.arguments, 1, self.arguments.n))
		self.index = n
	else
		local _, n = ui:open(
			peep,
			self.interfaceID,
			unpack(self.arguments, 1, self.arguments.n))
		self.index = n
	end
end

return OpenInterfaceCommand
