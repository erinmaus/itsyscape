--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/Flash.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"

local Flash = B.Node("Flash")
Flash.PEEP = B.Reference()
Flash.SPRITE = B.Reference()
Flash.Y_OFFSET = B.Reference()
Flash.ARGUMENTS = B.Reference()

function Flash:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	local arguments = state[self.ARGUMENTS] or {}

	local sprite = state[self.SPRITE]
	if not sprite then
		return B.Status.Failure
	end

	local yOffset = state[self.Y_OFFSET] or 0.5
	Utility.Peep.flash(peep, sprite, yOffset, unpack(arguments, 1, table.maxn(arguments)))

	return B.Status.Success
end

return Flash
