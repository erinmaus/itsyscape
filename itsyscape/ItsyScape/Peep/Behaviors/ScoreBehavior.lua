--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/ScoreBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies a score.
local ScoreBehavior = Behavior("Score")

-- Constructs a ScoreBehavior.
--
-- 'scores' should be a table of scores.
function ScoreBehavior:new()
	Behavior.Type.new(self)

	self.scores = {}
end

return ScoreBehavior
