--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/Channel.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Command = require "ItsyScape.Game.Animation.Commands.Command"

local Channel = Class()
function Channel:new(t)
	t = t or {}

	self.commands = {}
	for i = 1, #t do
		if Class.isCompatibleType(t[i], Command) then
			table.insert(self.commands, t[i])
		end
	end
end

function Channel:merge(other)
	for i = 1, #other.commands do
		table.insert(self.commands, other.commands[i])
	end
end

function Channel:getNumCommands()
	return #self.commands
end

function Channel:getCommand(index)
	return self.commands[index]
end

function Channel:iterate()
	return ipairs(self.commands)
end

return Channel
