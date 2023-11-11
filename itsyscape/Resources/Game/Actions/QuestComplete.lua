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
QuestComplete.FLAGS = { ['x-ignore-quest'] = true, ['item-bank'] = true }

function QuestComplete:perform(state, peep)
	if self:canPerform(state) and self:canTransfer(state) then
		return self:transfer(state, peep)
	end
end

return QuestComplete
