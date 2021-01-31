--------------------------------------------------------------------------------
-- ItsyScape/Game/CutsceneMap.lua
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
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"

local CutsceneMap = Class()

function CutsceneMap:new(peep)
	self.peep = peep
	self.director = peep:getDirector()
	self.game = peep:getDirector():getGameInstance()
end

function CutsceneMap:lerpPosition(anchor, duration, tween)
	local E = 0.1
	tween = Tween[tween or 'linear'] or Tween.linear

	local mapResource = Utility.Peep.getMapResourceFromLayer(self.peep)
	local anchorPosition = Vector(
		Utility.Map.getAnchorPosition(self.game, mapResource, anchor))
	local peepPosition
	local currentTime

	return function()
		self.peep:addBehavior(MapOffsetBehavior)

		peepPosition = peepPosition or self.peep:getBehavior(MapOffsetBehavior).offset
		if duration then
			repeat
				currentTime = (currentTime or 0) + self.game:getDelta()

				local delta = currentTime / duration
				local newPosition = peepPosition:lerp(anchorPosition, tween(delta))
				self.peep:getBehavior(MapOffsetBehavior).offset = newPosition

				coroutine.yield()
			until currentTime > duration
		else
			local distance
			repeat
				local newPosition = Utility.Peep.getPosition(self.peep):lerp(anchorPosition, self.game:getDelta())
				self.peep:getBehavior(MapOffsetBehavior).offset = newPosition
				distance = (anchorPosition - newPosition):getLength()
				coroutine.yield()
			until distance <= E
		end
	end
end

function CutsceneMap:slerpRotation(anchor, duration, tween)
	local E = 0.01
	tween = Tween[tween or 'linear'] or Tween.linear

	local mapResource = Utility.Peep.getMapResourceFromLayer(self.peep)
	local anchorRotation = Quaternion(
		Utility.Map.getAnchorRotation(self.game, mapResource, anchor))
	local peepPosition
	local currentTime

	return function()
		self.peep:addBehavior(MapOffsetBehavior)

		peepRotation = peepRotation or self.peep:getBehavior(MapOffsetBehavior).rotation
		if duration then
			repeat
				currentTime = (currentTime or 0) + self.game:getDelta()

				local delta = currentTime / duration
				local newRotation = peepRotation:slerp(anchorRotation, tween(delta)):getNormal()
				self.peep:getBehavior(MapOffsetBehavior).rotation = newRotation

				coroutine.yield()
			until currentTime > duration
		else
			local distance
			repeat
				local newRotation = Utility.Peep.getRotation(self.peep):slerp(anchorRotation, self.game:getDelta())
				self.peep:getBehavior(MapOffsetBehavior).rotation = newRotation
				distance = (anchorRotation - newRotation):getLength()
				coroutine.yield()
			until distance <= E
		end
	end
end

function CutsceneMap:wait(duration)
	local currentTime = duration

	return function()
		while currentTime > 0 do
			currentTime = currentTime - self.game:getDelta()
			coroutine.yield()
		end
	end
end

return CutsceneMap
