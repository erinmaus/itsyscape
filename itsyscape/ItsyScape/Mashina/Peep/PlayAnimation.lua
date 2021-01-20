--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/PlayAnimation.lua
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

local PlayAnimation = B.Node("PlayAnimation")
PlayAnimation.TYPE = B.Reference()
PlayAnimation.FILENAME = B.Reference()
PlayAnimation.SLOT = B.Reference()
PlayAnimation.PRIORITY = B.Reference()
PlayAnimation.FORCE = B.Reference()

function PlayAnimation:update(mashina, state, executor)
	local actor = mashina:getBehavior(ActorReferenceBehavior)
	if not actor or not actor.actor then
		return B.Status.Failure
	else
		actor = actor.actor
	end

	local fileType = state[self.TYPE] or "ItsyScape.Graphics.AnimationResource"
	local filename = state[self.FILENAME]
	local slot = state[self.SLOT] or 'mashina'
	local priority = state[self.PRIORITY] or 0
	local force = state[self.FORCE] or false

	if not filename then
		Log.error("Filename not provided.")
		return B.Status.Error
	else
		local animation = CacheRef(fileType, filename)
		actor:playAnimation(slot, priority, animation, force)
	end

	return B.Status.Success
end

return PlayAnimation
