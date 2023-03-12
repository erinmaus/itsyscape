--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Cooking/init.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Cooking = setmetatable({}, {
	__index = function(self, key)
		local module = require(string.format("ItsyScape.Game.Skills.Cooking.%s", key))
		rawset(self, key, module)

		return module
	end
})

return Cooking
