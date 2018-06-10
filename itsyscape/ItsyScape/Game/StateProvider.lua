--------------------------------------------------------------------------------
-- ItsyScape/Game/StateProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local StateProvider = Class()

function StateProvider:new()
	-- Nothing.
end

function StateProvider:has(name, count, flags)
	return Class.ABSTRACT()
end

return StateProvider
