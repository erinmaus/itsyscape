--------------------------------------------------------------------------------
-- Resources/Game/Actions/Smelt.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Action = require "ItsyScape.Peep.Action"

local Smelt = Class(Action)
Smelt.SCOPES = { ['craft'] = true }

function Smelt:perform(state, player, prop)
	if not self:canPerform(state) then
		return false
	end

	-- Nothing.
end

return Smelt
