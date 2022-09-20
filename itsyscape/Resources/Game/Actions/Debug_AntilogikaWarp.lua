--------------------------------------------------------------------------------
-- Resources/Game/Actions/Debug_AntilogikaWarp.lua
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

local DebugAntilogikaWarp = Class(Action)
DebugAntilogikaWarp.SCOPES = { ['inventory'] = true, ['equipment'] = true }

function DebugAntilogikaWarp:perform(state, peep, item)
	Utility.UI.openInterface(peep, "DebugAntilogikaWarp")
	Action.perform(self, state, peep)

	return true
end

return DebugAntilogikaWarp
