--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/FollowerBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

local FollowerBehavior = Behavior("Follower")
FollowerBehavior.NIL_ID = 0

-- Constructs a FollowerBehavior.
--
-- * scope: Scope of the follower. Defaults to 'General'. Scope is used to create storage
--          for the peep, if necessary.
-- * id: Index of the follower in the scope. An ID of 0 is invalid.
-- * playerID: The player ID this follower belongs to.
-- * followAcrossMaps: Follow the player across maps.
function FollowerBehavior:new()
	Behavior.Type.new(self)

	self.scope = "General"
	self.followerID = FollowerBehavior.NIL_ID
	self.playerID = FollowerBehavior.NIL_ID
	self.followAcrossMaps = false
end

return FollowerBehavior
