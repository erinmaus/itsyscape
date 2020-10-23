--------------------------------------------------------------------------------
-- Resources/Game/Actions/QuestStart.lua
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

local QuestStart = Class(Action)
QuestStart.SCOPES = { ['quest'] = true }
QuestStart.FLAGS = { ['x-ignore-quest'] = true }

function QuestStart:perform(state, peep)
	return self:transfer(state)
end

return QuestStart
