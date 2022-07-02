--------------------------------------------------------------------------------
-- Resources/Game/Makes/ObtainSecondary.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Action = require "ItsyScape.Peep.Action"

local ObtainSecondary = Class(Action)
ObtainSecondary.SCOPES = { ['make-action'] = true }
ObtainSecondary.FLAGS = {
	['item-inventory'] = true,
	['item-equipment'] = true ,
	['item-drop-excess'] = true
}

function ObtainSecondary:perform(state, player, count)
	local f = {}
	for key, value in pairs(self.FLAGS) do
		f[key] = value
	end

	f['action-count'] = count or 1

	if self:canPerform(state) and self:canTransfer(state) then
		self:transfer(state, player, f)
		return true
	end

	return false, "can't perform"
end

return ObtainSecondary
