--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Get.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local Get = B.Node("Get")
Get.VALUE = B.Reference()
Get.RESULT = B.Reference()

function Get:update(mashina, state, executor)
	local value = state[self.VALUE]

	if value then
		state[self.RESULT] = value(mashina, state, executor)
	end

	return B.Status.Success
end

return Get
