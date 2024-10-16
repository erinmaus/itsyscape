--------------------------------------------------------------------------------
-- Resources/Game/Actions/InvisibleAttack.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Action = require "ItsyScape.Peep.Action"

local InvisibleAttack = Class(Action)
InvisibleAttack.SCOPES = {}

function InvisibleAttack:perform(state, player, target)
	return false
end

return InvisibleAttack
