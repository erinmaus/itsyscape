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
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"
local ShiptBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"

local CutsceneMap = Class()

function CutsceneMap:new(peep)
	self.peep = peep
	self.director = peep:getDirector()
	self.game = peep:getDirector():getGameInstance()
end

function CutsceneMap:getPeep()
	return self.peep
end

function CutsceneMap:playMusic(music, slot)
	return function()
		local stage = self.game:getStage()
		stage:playMusic(self.peep:getLayer(), slot or "main", music)
	end
end

function CutsceneMap:getPosition(anchor)
	local mapResource = Utility.Peep.getMapResourceFromLayer(Utility.Peep.getInstance(self.peep):getBaseMapScript())
	return Vector(Utility.Map.getAnchorPosition(self.game, mapResource, anchors))
end

function CutsceneMap:getScale(anchor)
	local mapResource = Utility.Peep.getMapResourceFromLayer(Utility.Peep.getInstance(self.peep):getBaseMapScript())
	return Quaternion(Utility.Map.getAnchorScale(self.game, mapResource, anchors))
end

function CutsceneMap:getRotation(anchor)
	local mapResource = Utility.Peep.getMapResourceFromLayer(Utility.Peep.getInstance(self.peep):getBaseMapScript())
	return Vector(Utility.Map.getAnchorRotation(self.game, mapResource, anchors))
end

function CutsceneMap:sail(anchors, duration, tween)
	return function()
		tween = Tween[tween or 'linear'] or Tween.linear

		local mapResource = Utility.Peep.getMapResourceFromLayer(Utility.Peep.getInstance(self.peep):getBaseMapScript())
		local anchorPositions = {}

		for i = 1, #anchors do
			table.insert(anchorPositions, Vector(Utility.Map.getAnchorPosition(self.game, mapResource, anchors[i])))
		end

		local curve
		do
			local c = {}
			if anchors.current then
				local currentPosition = Utility.Peep.getPosition(self.peep)
				table.insert(c, currentPosition.x)
				table.insert(c, currentPosition.z)
			end

			for i = 1, #anchorPositions do
				table.insert(c, anchorPositions[i].x)
				table.insert(c, anchorPositions[i].z)
			end

			curve = love.math.newBezierCurve(unpack(c))
		end

		self.peep:addBehavior(MapOffsetBehavior)
		self.peep:addBehavior(RotationBehavior)

		local currentTime = 0
		repeat
			currentTime = currentTime + self.game:getDelta()
			local mu = math.min(math.max(currentTime / duration, 0), duration)
			local delta = math.min(math.max(tween(mu), 0), 1)
			local currentPosition = Utility.Peep.getPosition(self.peep) * Vector.PLANE_XZ

			local x, z = curve:evaluate(delta)
			local position = Vector(x, 0, z)
			local rotation = Quaternion.lookAt(position, currentPosition)

			Utility.Peep.setPosition(self.peep, position)
			Utility.Peep.setRotation(self.peep, rotation * Quaternion.Y_90)

			coroutine.yield()
		until currentTime > duration
	end
end

function CutsceneMap:hide()
	return function()
		self.peep:addBehavior(DisabledBehavior)
	end
end

function CutsceneMap:show()
	return function()
		self.peep:removeBehavior(DisabledBehavior)
	end
end

function CutsceneMap:teleport(anchor)
	return function()
		local position = self.peep:getBehavior(PositionBehavior)
		local instance = Utility.Peep.getInstance(self.peep)
		local mapScript = instance:getMapScriptByLayer(position.layer or instance:getBaseLayer())
		local mapResource = Utility.Peep.getResource(mapScript)
		local anchorPosition = Vector(Utility.Map.getAnchorPosition(self.game, mapResource, anchor))

		Utility.Peep.setPosition(self.peep, anchorPosition)

		local movement = self.peep:getBehavior(MovementBehavior)
		if movement then
			movement.velocity = Vector(0)
			movement.acceleration = Vector(0)
		end
	end
end

function CutsceneMap:lookAt(anchor)
	return function()
		local position = self.peep:getBehavior(PositionBehavior)
		local instance = Utility.Peep.getInstance(self.peep)
		local mapScript = instance:getMapScriptByLayer(position.layer or instance:getBaseLayer())
		local mapResource = Utility.Peep.getResource(mapScript)
		local anchorPosition = Vector(Utility.Map.getAnchorPosition(self.game, mapResource, anchor))

		local currentPosition = Utility.Peep.getPosition(self.peep)
		local rotation = Quaternion.lookAt(currentPosition * Vector.PLANE_XZ, anchorPosition * Vector.PLANE_XZ)

		local shipMovement = self.peep:getBehavior(ShipMovementBehavior)
		if shipMovement then
			shipMovement.rotation = rotation * Quaternion.lookAt(shipMovement.steerDirectionNormal, Vector.ZERO)
		else
			local _, r = peep:addBehavior(RotationBehavior)
			r.rotation = rotation
		end
	end
end

function CutsceneMap:lerpPosition(anchor, duration, tween)
	return function()
		local E = 0.1
		tween = Tween[tween or 'linear'] or Tween.linear

		local position = self.peep:getBehavior(PositionBehavior)
		local instance = Utility.Peep.getInstance(self.peep)
		local mapScript = instance:getMapScriptByLayer(position.layer or instance:getBaseLayer())
		local mapResource = Utility.Peep.getResource(mapScript)
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

		local position = self.peep:getBehavior(PositionBehavior)
		local instance = Utility.Peep.getInstance(self.peep)
		local mapScript = instance:getMapScriptByLayer(position.layer or instance:getBaseLayer())
		local mapResource = Utility.Peep.getResource(mapScript)
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

		local position = self.peep:getBehavior(PositionBehavior)
		local instance = Utility.Peep.getInstance(self.peep)
		local mapScript = instance:getMapScriptByLayer(position.layer or instance:getBaseLayer())
		local mapResource = Utility.Peep.getResource(mapScript)
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

function CutsceneMap:pushPoke(...)
	local args = { n = select('#', ...), ... }

	return function()
		self.peep:pushPoke(unpack(args, 1, args.n))
	end
end

function CutsceneMap:fireProjectile(source, destination, projectile)
	return function()
		if type(destination) == 'string' then
			local mapResource = Utility.Peep.getMapResource(self.peep)
			destination = Vector(Utility.Map.getAnchorPosition(self.game, mapResource, destination))
		elseif Class.isCompatibleType(destination, CutsceneMap) then
			destination = Utility.Peep.getPosition(destination.peep)
		elseif Class.isCompatibleType(destination, CutsceneEntity) then
			destination = destination:getPeep()
		end

		if type(source) == 'string' then
			local mapResource = Utility.Peep.getMapResource(self.peep)
			source = Vector(Utility.Map.getAnchorPosition(self.game, mapResource, source))
		elseif Class.isCompatibleType(source, CutsceneMap) then
			source = Utility.Peep.getPosition(source.peep)
		elseif Class.isCompatibleType(source, CutsceneEntity) then
			source = source:getPeep()
		end

		local stage = self.peep:getDirector():getGameInstance():getStage()
		stage:fireProjectile(projectile, source, destination, self.peep:getLayer())
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
