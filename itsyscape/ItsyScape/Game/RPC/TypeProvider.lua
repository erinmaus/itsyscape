--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/TypeProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local TypeProvider = Class()

function TypeProvider:serialize(obj, result, state, exceptions)
	Class.ABSTRACT()
end

function TypeProvider:deserialize(obj, state)
	return Class.ABSTRACT()
end

return TypeProvider
