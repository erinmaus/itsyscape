--------------------------------------------------------------------------------
-- ItsyScape/Game/CutsceneEntity.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local CutsceneEntity = Class()

function CutsceneEntity:new(peep)
	self.peep = peep
	self.director = peep:getDirector()
	self.game = peep:getDirector():getGameInstance()
end

function CutsceneEntity:walkTo(anchor)
	return function()
		local mapResource = Utility.Peep.getMapResource(self.peep)
		local anchorX, _, anchorZ = Utility.Map.getAnchorPosition(self.game, mapResource, anchor)
		local map = Utility.Peep.getMap(self.peep)
		local _, anchorI, anchorJ = map:getTileAt(anchorX, anchorZ)

		local success = Utility.Peep.walk(self.peep, anchorI, anchorJ, Utility.Peep.getLayer(self.peep))
		if success then
			local peepI, peepJ
			repeat
				peepI, peepJ = Utility.Peep.getTile(self.peep)
				coroutine.yield()
			until peepI == anchorI and peepJ == anchorJ
		end
	end
end

function CutsceneEntity:lerpPosition(anchor, duration, tween)
	return function()
		local E = 0.1
		tween = Tween[tween or 'linear'] or Tween.linear

		local mapResource = Utility.Peep.getMapResource(self.peep)
		local anchorPosition = Vector(
			Utility.Map.getAnchorPosition(self.game, mapResource, anchor))

		local movement = self.peep:getBehavior(MovementBehavior)
		local peepPosition = Utility.Peep.getPosition(self.peep)

		if anchorPosition.x < peepPosition.x then
			movement.facing = MovementBehavior.FACING_LEFT
		else
			movement.facing = MovementBehavior.FACING_RIGHT
		end

		local currentTime
		if duration then
			repeat
				currentTime = (currentTime or 0) + self.game:getDelta()

				local delta = currentTime / duration
				local newPosition = peepPosition:lerp(anchorPosition, tween(delta))
				Utility.Peep.setPosition(self.peep, newPosition)

				coroutine.yield()
			until currentTime > duration
		else
			local distance
			repeat
				local newPosition = Utility.Peep.getPosition(self.peep):lerp(anchorPosition, self.game:getDelta())
				Utility.Peep.setPosition(self.peep, newPosition)
				distance = (anchorPosition - newPosition):getLength()
				coroutine.yield()
			until distance <= E
		end
	end
end

function CutsceneEntity:lerpScale(anchor, duration, tween)
	return function()
		local E = 0.1
		tween = Tween[tween or 'linear'] or Tween.linear

		local mapResource = Utility.Peep.getMapResource(self.peep)
		local anchorScale = Vector(
			Utility.Map.getAnchorScale(self.game, mapResource, anchor))
		local peepScale = Utility.Peep.getScale(self.peep)

		local currentTime
		if duration then
			repeat
				currentTime = (currentTime or 0) + self.game:getDelta()

				local delta = currentTime / duration
				local newScale = peepScale:lerp(anchorScale, tween(delta))
				Utility.Peep.setScale(self.peep, newScale)

				coroutine.yield()
			until currentTime > duration
		else
			local distance
			repeat
				local newScale = Utility.Peep.getScale(self.peep):lerp(anchorScale, self.game:getDelta())
				Utility.Peep.setScale(self.peep, newScale)
				distance = (anchorScale - newScale):getLength()
				coroutine.yield()
			until distance <= E
		end
	end
end

function CutsceneEntity:playAnimation(animation, slot, priority, force, time, resourceType)
	return function()
		slot = slot or 'x-cutscene'
		priority = priority or 1
		resourceType = resourceType or "ItsyScape.Graphics.AnimationResource"
		time = time or 0
		animation = string.format("Resources/Game/Animations/%s/Script.lua", animation)

		local actor = self.peep:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			actor.actor:playAnimation(slot, priority, CacheRef(resourceType, animation), force, time)
		end
	end
end

function CutsceneEntity:talk(message, duration)
	duration = duration or #message / 8
	return function()
		local actor = self.peep:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			actor.actor:flash('Message', 1, message, nil, duration)
		end
	end
end

function CutsceneEntity:wait(duration)
	return function()
		local currentTime = duration
		while currentTime > 0 do
			currentTime = currentTime - self.game:getDelta()
			coroutine.yield()
		end
	end
end

function CutsceneEntity:addBehavior(behavior)
	return function()
		self.peep:addBehavior(behavior)
	end
end

function CutsceneEntity:removeBehavior(behavior)
	return function()
		self.peep:removeBehavior(behavior)
	end
end

function CutsceneEntity:poke(...)
	local args = { n = select('#', ...), ... }

	return function()
		self.peep:poke(unpack(args, 1, args.n))
	end
end

return CutsceneEntity
