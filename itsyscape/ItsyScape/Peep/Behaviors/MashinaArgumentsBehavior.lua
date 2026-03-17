--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/MashinaArgumentsBehavior.lua
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
local MashinaArgumentsBehavior = Behavior("MashinaArgumentsBehavior")

-- Constructs a MashinaArgumentsBehavior.
function MashinaArgumentsBehavior:new()
	Behavior.Type.new(self)

	-- Key-value-pairs of arguments
	self.arguments = {}
end

return MashinaArgumentsBehavior
