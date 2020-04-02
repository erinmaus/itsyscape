--------------------------------------------------------------------------------
-- Resources/Game/Actions/Sail.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Action = require "ItsyScape.Peep.Action"

local Sail = Class(Action)
Sail.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function Sail:perform(state, peep, prop)
	-- Time traveling into the past is impossible, even for the Old Ones...
	-- ...or so we think...
	return false
end

return Sail
