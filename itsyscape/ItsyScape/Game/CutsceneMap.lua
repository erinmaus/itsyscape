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
	return function()
		local E = 0.1
		tween = Tween[tween or 'linear'] or Tween.linear

		local mapResource = Utility.Peep.getMapResourceFromLayer(self.peep)
		local anchorPosition = Vector(
			Utility.Map.getAnchorPosition(self.game, mapResource, anchor))

		self.peep:addBehavior(MapOffsetBehavior)
		local peepPosition = self.peep:getBehavior(MapOffsetBehavior).offset

		local currentTime
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

function CutsceneMap:lerpScale(anchor, duration, tween)
	return function()
		local E = 0.1
		tween = Tween[tween or 'linear'] or Tween.linear

		local mapResource = Utility.Peep.getMapResourceFromLayer(self.peep)
		local anchorScale = Vector(
			Utility.Map.getAnchorScale(self.game, mapResource, anchor))

		self.peep:addBehavior(MapOffsetBehavior)
		local peepScale = self.peep:getBehavior(MapOffsetBehavior).scale

		local currentTime
		if duration then
			repeat
				currentTime = (currentTime or 0) + self.game:getDelta()

				local delta = currentTime / duration
				local newScale = peepScale:lerp(anchorScale, tween(delta))
				self.peep:getBehavior(MapOffsetBehavior).scale = newScale

				coroutine.yield()
			until currentTime > duration
		else
			local distance
			repeat
				local newScale = Utility.Peep.getScale(self.peep):lerp(anchorScale, self.game:getDelta())
				self.peep:getBehavior(MapOffsetBehavior).scale = newScale
				distance = (anchorScale - newScale):getLength()
				coroutine.yield()
			until distance <= E
		end
	end
end

function CutsceneMap:slerpRotation(anchor, duration, tween)
	return function()
		local E = 0.01
		tween = Tween[tween or 'linear'] or Tween.linear

		local mapResource = Utility.Peep.getMapResourceFromLayer(self.peep)
		local anchorRotation = Quaternion(
			Utility.Map.getAnchorRotation(self.game, mapResource, anchor))

		self.peep:addBehavior(MapOffsetBehavior)
		local peepRotation = self.peep:getBehavior(MapOffsetBehavior).rotation


		local currentTime
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
	return function()
		local currentTime = duration
		while currentTime > 0 do
			currentTime = currentTime - self.game:getDelta()
			coroutine.yield()
		end
	end
end

function CutsceneMap:poke(...)
	local args = { n = select('#', ...), ... }

	return function()
		self.peep:poke(unpack(args, 1, args.n))
	end
end

function CutsceneMap:performNamedAction(name, target)
	return function()
		local game = self.peep:getDirector():getGameInstance()
		local gameDB = self.peep:getDirector():getGameDB()
		local action = gameDB:getRecord("NamedMapAction", {
			Name = name,
			Map = Utility.Peep.getResource(self.peep)
		})

		if action then
			local action = Utility.getAction(game, action:get("Action"))
			action.instance:perform(target:getPeep():getState(), target:getPeep())
		end
	end
end

return CutsceneMap
