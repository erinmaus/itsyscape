
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
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"

local CutsceneEntity = Class()

function CutsceneEntity:new(peep)
	self.peep = peep
	self.director = peep:getDirector()
	self.game = peep:getDirector():getGameInstance()
end

function CutsceneEntity:move(map, anchor, minDuration)
	local DELAY_SECONDS = 0.5
	if self.peep:hasBehavior(PlayerBehavior) then
		return function()
			Utility.UI.openInterface(self.peep, "CutsceneTransition", false, minDuration)

			local time = love.timer.getTime()
			while love.timer.getTime() < time + DELAY_SECONDS do
				coroutine.yield()
			end

			if map and anchor then
				local stage = self.game:getStage()
				stage:movePeep(self.peep, map, anchor)
			end
		end
	else
		Log.warn("Cannot move peep '%s'; not a player!", self.peep:getName())
		return function() end
	end
end

function CutsceneEntity:narrate(narration, caption, duration)
	if self.peep:hasBehavior(PlayerBehavior) then
		return function()
			Utility.UI.openInterface(
				self.peep,
				"DramaticText",
				false,
				{ caption }, duration)
		end
	else
		Log.warn("Cannot narrate for peep '%s'; not a player!", self.peep:getName())
		return function() end
	end
end

function CutsceneEntity:getPeep()
	return self.peep
end

function CutsceneEntity:castSpell(target, spell)
	return function()
		local spell = Utility.Magic.newSpell(spell, self.peep:getDirector():getGameInstance())
		spell:cast(self.peep, target:getPeep())
	end
end

function CutsceneEntity:fireProjectile(target, projectile)
	return function()
		if type(target) == 'string' then
			local mapResource = Utility.Peep.getMapResource(self.peep)
			target = Vector(Utility.Map.getAnchorPosition(self.game, mapResource, target))
		elseif Class.isCompatibleType(target, CutsceneEntity) then
			target = target:getPeep()
		end

		local stage = self.peep:getDirector():getGameInstance():getStage()
		stage:fireProjectile(projectile, self.peep, target)
	end
end

function CutsceneEntity:attack(target)
	return function()
		if Class.isCompatibleType(target, CutsceneEntity) then
			Utility.Peep.attack(self.peep, target:getPeep())
		end
	end
end

function CutsceneEntity:playAttackAnimation(target, wait)
	return function()
		local animation, projectile
		do
			Utility.Peep.face(self.peep, target:getPeep())

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

			if projectile and target then
				local stage = self.peep:getDirector():getGameInstance():getStage()
				stage:fireProjectile(projectile, self.peep, target:getPeep())
			end

			if wait then
				local duration = (weapon and weapon:getCooldown(self.peep)) or 2.4

				while duration > 0 do
					duration = duration - self.game:getDelta()
					coroutine.yield()
				end
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
			elseif Class.isCompatibleType(target, Quaternion) then
				Utility.Peep.setRotation(self.peep, target)
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

function CutsceneEntity:walkTo(anchor, distance, ghost, wait)
	distance = distance or 0

	return function()
		local mapResource = Utility.Peep.getMapResource(self.peep)
		local anchorX, _, anchorZ = Utility.Map.getAnchorPosition(self.game, mapResource, anchor)
		local map = Utility.Peep.getMap(self.peep)
		local _, anchorI, anchorJ = map:getTileAt(anchorX, anchorZ)

		local movement = self.peep:getBehavior(MovementBehavior)
		local oldGhost = movement and movement.ghost
		if movement and ghost then
			movement.ghost = true
		end

		local callback = Utility.Peep.queueWalk(self.peep, anchorI, anchorJ, Utility.Peep.getLayer(self.peep), distance, { isCutscene = true })

		local isDone = false
		local success
		callback:register(function(s)
			isDone = true
			success = s
		end)

		repeat
			coroutine.yield()
		until isDone

		if success and (wait or wait == nil) then
			local peepI, peepJ, peepDistance
			repeat
				peepI, peepJ = Utility.Peep.getTile(self.peep)
				coroutine.yield()

				peepDistance = (Utility.Peep.getPosition(self.peep) * Vector.PLANE_XZ - Vector(anchorX, 0, anchorZ)):getLength()
			until (peepI == anchorI and peepJ == anchorJ) or (distance and peepDistance <= distance)
		end

		if movement and ghost then
			movement.ghost = oldGhost
		end
	end
end

function CutsceneEntity:follow(entity, distance)
	distance = distance or 0

	return function()
		local isRunning
		local oldI, oldJ, oldK
		repeat
			local i, j, k  = Utility.Peep.getTile(entity:getPeep())
			if oldI ~= i or oldJ ~= j or oldK ~= k then
				isRunning = Utility.Peep.walk(self.peep, i, j, k, distance, { isCutscene = true })
				oldI, oldJ, oldK = i, j, k
			else
				isRunning = self.peep:getCommandQueue():getIsPending()
			end

			coroutine.yield()
		until not isRunning
	end
end

function CutsceneEntity:teleport(anchor)
	return function()
		local mapResource = Utility.Peep.getMapResource(self.peep)

		local anchorPosition, layer
		if Class.isCompatibleType(anchor, Vector) then
			anchorPosition = anchor
		elseif Class.isCompatibleType(anchor, CutsceneEntity) then
			anchorPosition = Utility.Peep.getPosition(anchor:getPeep())
			layer = Utility.Peep.getLayer(anchor:getPeep())
		else
			anchorPosition = Vector(Utility.Map.getAnchorPosition(self.game, mapResource, anchor))
		end

		Utility.Peep.setPosition(self.peep, anchorPosition)
		if layer then
			Utility.Peep.setLayer(self.peep, layer)
		end
	end
end

function CutsceneEntity:setState(state)
	return function()
		local mashinaBehavior = self.peep:getBehavior(MashinaBehavior)
		if mashinaBehavior then
			mashinaBehavior.currentState = state
		end
	end
end

function CutsceneEntity:waitForState(state)
	return function()
		local currentState
		repeat
			local mashinaBehavior = self.peep:getBehavior(MashinaBehavior)
			currentState = mashinaBehavior and mashinaBehavior.currentState or nil
			coroutine.yield()
		until currentState == nil or currentState == state
	end
end

function CutsceneEntity:face(direction)
	return function()
		if Class.isCompatibleType(direction, CutsceneEntity) then
			Utility.Peep.face(self.peep, direction:getPeep())
		else
			local movement = self.peep:getBehavior(MovementBehavior)
			movement.facing = direction
		end
	end
end

function CutsceneEntity:lerpPosition(anchor, duration, tween)
	return function()
		local E = 0.1
		tween = Tween[tween or 'linear'] or Tween.linear

		local mapResource = Utility.Peep.getMapResource(self.peep)
		local anchorPosition
		if Class.isCompatibleType(anchor, Vector) then
			anchorPosition = anchor + Utility.Peep.getPosition(self.peep)
		elseif Class.isCompatibleType(anchor, CutsceneEntity) then
			anchorPosition = Utility.Peep.getPosition(anchor:getPeep())
		else
			anchorPosition = Vector(Utility.Map.getAnchorPosition(self.game, mapResource, anchor))
		end

		local peepPosition = Utility.Peep.getPosition(self.peep)

		local movement = self.peep:getBehavior(MovementBehavior)
		local previousNoClipValue
		if movement then
			previousNoClipValue = movement.noClip
			movement.noClip = true

			if anchorPosition.x < peepPosition.x then
				movement.facing = MovementBehavior.FACING_LEFT
			else
				movement.facing = MovementBehavior.FACING_RIGHT
			end
		end

		local currentTime
		if duration then
			repeat
				currentTime = (currentTime or 0) + self.game:getDelta()

				local delta = currentTime / duration
				local newPosition = peepPosition:lerp(anchorPosition, tween(delta))
				Utility.Peep.setPosition(self.peep, newPosition, true)

				coroutine.yield()
			until currentTime > duration
		else
			local distance
			repeat
				local newPosition = Utility.Peep.getPosition(self.peep):lerp(anchorPosition, self.game:getDelta())
				Utility.Peep.setPosition(self.peep, newPosition, true)
				distance = (anchorPosition - newPosition):getLength()
				coroutine.yield()
			until distance <= E
		end

		if movement then
			movement.noClip = previousNoClipValue
		end
	end
end

function CutsceneEntity:curvePositions(anchors, duration, tween)
	return function()
		tween = Tween[tween or 'linear'] or Tween.linear

		local mapResource = Utility.Peep.getMapResourceFromLayer(Utility.Peep.getInstance(self.peep):getBaseMapScript())
		local anchorPositions = {}

		for i = 1, #anchors do
			table.insert(anchorPositions, Vector(Utility.Map.getAnchorPosition(self.game, mapResource, anchors[i])))
		end

		local curves
		do
			local currentPosition = Utility.Peep.getPosition(self.peep)

			local x = { currentPosition.x, 0 }
			local y = { currentPosition.y, 0 }
			local z = { currentPosition.z, 0 }

			for i = 1, #anchorPositions do
				table.insert(x, anchorPositions[i].x)
				table.insert(x, 0)

				table.insert(y, anchorPositions[i].y)
				table.insert(y, 0)

				table.insert(z, anchorPositions[i].z)
				table.insert(z, 0)
			end

			curves = {
				love.math.newBezierCurve(unpack(x)),
				love.math.newBezierCurve(unpack(y)),
				love.math.newBezierCurve(unpack(z))
			}
		end

		local currentTime
		repeat
			currentTime = (currentTime or 0) + self.game:getDelta()
			local mu = math.clamp(currentTime / duration)
			local delta = math.clamp(tween(mu))

			local x = curves[1]:evaluate(delta)
			local y = curves[2]:evaluate(delta)
			local z = curves[3]:evaluate(delta)

			Utility.Peep.setPosition(self.peep, Vector(x, y, z))

			coroutine.yield()
		until currentTime > duration
	end
end

function CutsceneEntity:lerpScale(anchor, duration, tween)
	return function()
		local E = 0.1
		tween = Tween[tween or 'linear'] or Tween.linear

		local mapResource = Utility.Peep.getMapResource(self.peep)
		local anchorScale
		if Class.isCompatibleType(anchor, Vector) then
			anchorScale = anchor
		else
			anchorScale = Vector(
				Utility.Map.getAnchorScale(self.game, mapResource, anchor))
		end

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

function CutsceneEntity:slerpRotation(anchor, duration, tween)
	return function()
		local E = 0.01
		tween = Tween[tween or 'linear'] or Tween.linear

		local mapResource = Utility.Peep.getMapResourceFromLayer(Utility.Peep.getInstance(self.peep):getBaseMapScript())
		local anchorRotation
		if type(anchor) == "table" and Class.isCompatibleType(anchor, Quaternion) then
			anchorRotation = anchor
		else
			anchorRotation = Quaternion(
				Utility.Map.getAnchorRotation(self.game, mapResource, anchor))
		end

		local peepRotation = Utility.Peep.getRotation(self.peep)

		local currentTime
		if duration then
			repeat
				currentTime = (currentTime or 0) + self.game:getDelta()

				local delta = currentTime / duration
				local newRotation = peepRotation:slerp(anchorRotation, tween(delta)):getNormal()
				Utility.Peep.setRotation(self.peep, newRotation)

				coroutine.yield()
			until currentTime > duration
		else
			local distance
			repeat
				local newRotation = Utility.Peep.getRotation(self.peep):slerp(anchorRotation, self.game:getDelta())
				Utility.Peep.setRotation(self.peep, newRotation)
				distance = (anchorRotation - newRotation):getLength()

				coroutine.yield()
			until distance <= E
		end
	end
end

function CutsceneEntity:playAnimation(animation, slot, priority, force, time, resourceType)
	return function()
		local slot = slot or 'x-cutscene'
		local priority = priority or 10000
		local resourceType = resourceType or "ItsyScape.Graphics.AnimationResource"
		local time = time or 0
		local animation = string.format("Resources/Game/Animations/%s/Script.lua", animation)

		local actor = self.peep:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			actor.actor:playAnimation(slot, priority, CacheRef(resourceType, animation), force, time)
		end
	end
end

function CutsceneEntity:stopAnimation(slot)
	return function()
		local actor = self.peep:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			actor.actor:stopAnimation(slot)
		end
	end
end


function CutsceneEntity:talk(message, duration)
	duration = duration or #message / 8
	return function()
		Utility.Peep.talk(self.peep, message, nil, duration)
	end
end

function CutsceneEntity:yell(message, duration)
	duration = duration or #message / 8
	return function()
		Utility.Peep.yell(self.peep, message, nil, duration)
	end
end

function CutsceneEntity:damage(min, max, damageType)
	if max == nil and min == 0 then
		min = 0
		max = 0
	else
		min, max = math.min(min or 1, max or 1), math.max(min or 1, max or 1)
	end

	return function()
		local damage
		if min == math.huge or max == math.huge then
			damage = math.huge
		else
			damage = love.math.random(min, max)
		end

		local actor = self.peep:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			if not damageType then
				if damage == 0 then
					damageType = "block"
				else
					damageType = "none"
				end
			end

			actor.actor:flash("Damage", 1, damageType, damage)
		end		
	end
end

function CutsceneEntity:flash(...)
	local args = { n = select('#', ...), ... }

	return function()
		local actor = self.peep:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			actor.actor:flash(unpack(args, 1, args.n))
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
		local b = love.timer.getTime()
		local currentTime = duration or 0
		while currentTime > 0 do
			currentTime = currentTime - self.game:getDelta()
			coroutine.yield()
		end
		local a = love.timer.getTime()
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

function CutsceneEntity:dialog(name, target, overrideEntryPoint)
	return function()
		Utility.Peep.dialog(self.peep, name, target and target:getPeep(), overrideEntryPoint)

		while Utility.UI.isOpen(self.peep, "DialogBox") do
			coroutine.yield()
		end
	end
end

return CutsceneEntity
