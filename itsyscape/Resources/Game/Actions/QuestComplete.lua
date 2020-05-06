--------------------------------------------------------------------------------
-- Resources/Game/Actions/QuestComplete.lua
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

local QuestComplete = Class(Action)
QuestComplete.SCOPES = { ['quest'] = true }
QuestComplete.FLAGS = { ['x-ignore-quest'] = true }

function QuestComplete:perform(state, peep)
	return false
end

return QuestComplete
