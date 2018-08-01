--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/MashinaBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local BTreeBuilder = require "B.TreeBuilder"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies AI.
local MashinaBehavior = Behavior("MashinaBehavior")

-- Constructs a MashinaBehavior.
--
-- Contains a map of states and a currentState.
function MashinaBehavior:new(spell)
	Behavior.Type.new(self)
	self.states = {}
	self.currentState = false

	self.Node = function(name)
		local n = self.states[name]
		if not n then
			n = BTreeBuilder.Root()
			self.states[name] = n
		end

		return n
	end
end

return MashinaBehavior
