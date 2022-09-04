--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/PartyBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies the party a peep belongs to.
local PartyBehavior = Behavior("Player")

-- Constructs a PartyBehavior.
--
-- id: Unique ID of party. False if not in a party.
function PartyBehavior:new(id)
	Behavior.Type.new(self)

	self.id = id or false
end

return PartyBehavior
