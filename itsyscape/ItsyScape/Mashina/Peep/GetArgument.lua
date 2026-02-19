--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/GetArgument.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"

local GetArgument = B.Node("GetArgument")
GetArgument.KEY = B.Reference()
GetArgument.DEFAULT = B.Reference()
GetArgument.TRANSFORM = B.Reference()
GetArgument.RESULT = B.Reference()

function GetArgument:update(mashina, state, executor)
	local key = state[self.KEY]
	local argument = Utility.Peep.getMashinaArgument(mashina, key) or state[self.DEFAULT]

	if argument == nil then
		return B.Status.Failure
	end

	local transform = state[self.TRANSFORM]
	if Class.isCallable(transform) then
		argument = transform(argument, mashina, state, executor)
	end

	state[self.RESULT] = argument

	return B.Status.Success
end

return GetArgument
