--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/StopAnimation.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local CacheRef = require "ItsyScape.Game.CacheRef"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

local StopAnimation = B.Node("StopAnimation")
StopAnimation.SLOT = B.Reference()

function StopAnimation:update(mashina, state, executor)
	local actor = mashina:getBehavior(ActorReferenceBehavior)
	if not actor or not actor.actor then
		return B.Status.Failure
	else
		actor = actor.actor
	end

	local slot = state[self.SLOT] or 'mashina'
	actor:stopAnimation(slot)

	return B.Status.Success
end

return StopAnimation
