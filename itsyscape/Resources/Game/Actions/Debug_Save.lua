--------------------------------------------------------------------------------
-- Resources/Game/Actions/Debug_Save.lua
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
local Color = require "ItsyScape.Graphics.Color"

local Save = Class(Action)
Save.SCOPES = { ['inventory'] = true, ['equipment'] = true }
Save.FLAGS = { ['item-inventory'] = true, ['item-equipment'] = true }

function Save:perform(state, player, item)
	Utility.save(player, true, false)
	return true
end

return Save
