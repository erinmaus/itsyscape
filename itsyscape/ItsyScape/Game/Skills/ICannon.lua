--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/ICannon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local ICannon = Class()

function ICannon:getCannonPosition()
	return Class.ABSTRACT()
end

function ICannon:getCannonRotation()
	return Class.ABSTRACT()
end

return ICannon
