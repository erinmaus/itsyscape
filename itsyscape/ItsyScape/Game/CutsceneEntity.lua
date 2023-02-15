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
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local CutsceneEntity = Class()

function CutsceneEntity:new(peep)
	self.peep = peep
	self.director = peep:getDirector()
	self.game = peep:getDirector():getGameInstance()
end

function CutsceneEntity:getPeep()
	return self.peep
end

function CutsceneEntity:fireProjectile(target, projectile)
	return function()
		if type(target) == 'string' then
			local mapResource = Utility.Peep.getMapResource(self.peep)
			target = Vector(Utility.Map.getAnchorPosition(self.game, mapResource, target))
		elseif Class.isCompatibleType(target, CutsceneEntity) then
			target = target:getPeep()
		else
			-- Bail out early and don't do anything.
			return
		end

		local stage = self.peep:getDirector():getGameInstance():getStage()
		stage:fireProjectile(projectile, self.peep, target)
	end
end

function CutsceneEntity:playAttackAnimation(target)
	return function()
		local animation, projectile
		do
			local weapon = Utility.Peep.getEquippedWeapon(self.peep, true)
			if weapon then
				local animations = {
					string.format("animation-attack-%s-%s", weapon:getBonusForStance(self.peep):lower(), weapon:getWeaponType()),
					string.format("animation-attack-%s", weapon:getBonusForStance(self.peep):lower()),
					string.format("animation-attack-%s", weapon:getWeaponType()),
					"animation-attack"
				}

				for i = 1, #animations do
					local resource = self.peep:getResource(
						animations[i],
						"ItsyScape.Graphics.AnimationResource")
					if not animation then
						animation = resource
					end
				end

				projectile = weapon:getProjectile(self.peep)
			else
				animation = self.peep:getResource("animation-attack", "ItsyScape.Graphics.AnimationResource")
			end

			if animation then
				local actor = self.peep:getBehavior(ActorReferenceBehavior)
				if actor and actor.actor then
					actor.actor:playAnimation('x-cutscene', math.huge, animation, true, 0)
				end
			end

			if projectile then
				local stage = self.peep:getDirector():getGameInstance():getStage()
				stage:fireProjectile(projectile, self.peep, target:getPeep())
			end
		end
	end
end

function CutsceneEntity:lookAt(target, duration)
	return function()
		local currentDuration = duration
		repeat
			local delta
			if currentDuration then
				delta = 1 - math.max(currentDuration / duration, 0)
			end

			if Class.isCompatibleType(target, CutsceneEntity) then
				Utility.Peep.lookAt(self.peep, target:getPeep(), delta)
			elseif type(target) == 'string' then
				local mapResource = Utility.Peep.getMapResource(self.peep)
				local anchorX, anchorY, anchorZ = Utility.Map.getAnchorPosition(self.game, mapResource, anchor)
				local rotation = self.peep:getBehavior(RotationBehavior)
				if rotation then
					local selfPosition = Utility.Peep.getPosition(self)
					local anchorPosition = Vector(anchorX, anchorY, anchorZ)
					local xzSelfPosition = selfPosition * Vector.PLANE_XZ
					local xzAnchorPosition = peepPosition * Vector.PLANE_XZ
					rotation.rotation = (Quaternion.lookAt(xzAnchorPosition, xzSelfPosition):getNormal())

					if delta then
						rotation.rotation = Quaternion.IDENTITY:slerp(rotation.rotation, delta)
					end
				end
			end

			if currentDuration then
				currentDuration = currentDuration - self.game:getDelta()
				coroutine.yield()
			end
		until not currentDuration or currentDuration <= 0
	end
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

function CutsceneEntity:teleport(anchor)
	return function()
		local mapResource = Utility.Peep.getMapResource(self.peep)
		local anchorPosition = Vector(Utility.Map.getAnchorPosition(self.game, mapResource, anchor))
		Utility.Peep.setPosition(self.peep, anchorPosition)

		local actor = self.peep:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor

		if actor then
			actor:onTeleport(anchorPosition)
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
		priority = priority or 10000
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

function CutsceneEntity:yell(message, duration)
	duration = duration or #message / 8
	return function()
		local actor = self.peep:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			actor.actor:flash('Yell', 1, message, nil, duration)
		end
	end
end

function CutsceneEntity:usePower(power)
	local gameDB = self.director:getGameDB()
	local resource = gameDB:getResource(power, "Power")
	local powerName
	if resource then
		powerName = Utility.getName(resource, gameDB) or power
	end

	return function()
		if not powerName then
			return
		end

		local actor = self.peep:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			actor.actor:flash('Power', 0.5, power, powerName)
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
