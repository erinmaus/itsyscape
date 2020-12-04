--------------------------------------------------------------------------------
-- Resources/Game/Actions/Gather.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Action = require "ItsyScape.Peep.Action"

local Gather = Class(Action)
Gather.SCOPES = { ['x-shake'] = true }
Gather.FLAGS = { ['item-inventory'] = true, ['item-drop-excess'] = true }

function Gather:perform(state, player, target)
	local success = self:transfer(state, player)
	Action.perform(self, state, player)

	return success
end

return Gather
