--------------------------------------------------------------------------------
-- Resources/Game/Makes/Mine_Secondary.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local Make = require "Resources.Game.Actions.Make"

local MineSecondary = Class(Make)
MineSecondary.SCOPES = { ['mine-secondary'] = true }
MineSecondary.FLAGS = { ['item-inventory'] = true, ['item-equipment'] = true }

function MineSecondary:perform(state, player)
	if self:canPerform(state) and self:canTransfer(state) then
		self:transfer(state, player)
		return true
	end

	return false, "can't perform"
end

return MineSecondary
