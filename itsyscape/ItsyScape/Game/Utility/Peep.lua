--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local CommonMath = require "ItsyScape.Common.Math.Common"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local AttackCommand = require "ItsyScape.Game.AttackCommand"
local Config = require "ItsyScape.Game.Config"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
local Shield = require "ItsyScape.Game.Shield"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Probe = require "ItsyScape.Peep.Probe"
local Instance = require "ItsyScape.Game.LocalModel.Instance"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"
local AggressiveBehavior = require "ItsyScape.Peep.Behaviors.AggressiveBehavior"
local CharacterBehavior = require "ItsyScape.Peep.Behaviors.CharacterBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local EquipmentBonusesBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBonusesBehavior"
local Face3DBehavior = require "ItsyScape.Peep.Behaviors.Face3DBehavior"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"
local InstancedInventoryBehavior = require "ItsyScape.Peep.Behaviors.InstancedInventoryBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local MapObjectBehavior = require "ItsyScape.Peep.Behaviors.MapObjectBehavior"
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"
local MappResourceBehavior = require "ItsyScape.Peep.Behaviors.MappResourceBehavior"
local MapResourceReferenceBehavior = require "ItsyScape.Peep.Behaviors.MapResourceReferenceBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local OriginBehavior = require "ItsyScape.Peep.Behaviors.OriginBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local PowerRechargeBehavior = require "ItsyScape.Peep.Behaviors.PowerRechargeBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local ShieldBehavior = require "ItsyScape.Peep.Behaviors.ShieldBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local TeamBehavior = require "ItsyScape.Peep.Behaviors.TeamBehavior"
local TeamsBehavior = require "ItsyScape.Peep.Behaviors.TeamsBehavior"
local TransformBehavior = require "ItsyScape.Peep.Behaviors.TransformBehavior"
local WeaponBehavior = require "ItsyScape.Peep.Behaviors.WeaponBehavior"
local CombatCortex = require "ItsyScape.Peep.Cortexes.CombatCortex2"
local ExecutePathCommand = require "ItsyScape.World.ExecutePathCommand"
local Map = require "ItsyScape.World.Map"
local SmartPathFinder = require "ItsyScape.World.SmartPathFinder"

local Peep = {}

Peep.Attackable = require "ItsyScape.Game.Utility.Peep.Attackable"
Peep.Boss = require "ItsyScape.Game.Utility.Peep.Boss"
Peep.Character = require "ItsyScape.Game.Utility.Peep.Character"
Peep.Creep = require "ItsyScape.Game.Utility.Peep.Creep"
Peep.Dummy = require "ItsyScape.Game.Utility.Peep.Dummy"
Peep.Equipment = require "ItsyScape.Game.Utility.Peep.Equipment"
Peep.Gatherable = require "ItsyScape.Game.Utility.Peep.Gatherable"
Peep.Human = require "ItsyScape.Game.Utility.Peep.Human"
Peep.Inventory = require "ItsyScape.Game.Utility.Peep.Inventory"
Peep.Mashina = require "ItsyScape.Game.Utility.Peep.Mashina"
Peep.Stats = require "ItsyScape.Game.Utility.Peep.Stats"

function Peep.isEnabled(peep)
	return not peep:hasBehavior(DisabledBehavior)
end

function Peep.isDisabled(peep)
	return peep:hasBehavior(DisabledBehavior)
end

function Peep.disable(peep)
	local disabled = peep:getBehavior(DisabledBehavior)
	if not disabled then
		peep:removeBehavior(TargetTileBehavior)
		peep:addBehavior(DisabledBehavior)
		return true
	end


	disabled.index = disabled.index + 1
	return false
end

function Peep.enable(peep)
	local disabled = peep:getBehavior(DisabledBehavior)
	if not disabled then
		return true
	end

	disabled.index = disabled.index - 1

	if disabled.index <= 0 then
		peep:removeBehavior(DisabledBehavior)
		return true
	end

	return false
end

function Peep.dialog(peep, obj, target, overrideEntryPoint)
	local map = Peep.getMapResource(peep)

	if type(target) == "string" then
		local hit = peep:getDirector():probe(
			peep:getLayerName(),
			Probe.namedMapObject(target),
			Probe.instance(Peep.getPlayerModel(peep)))[1]

		if not hit then
			hit = peep:getDirector():probe(
				peep:getLayerName(),
				Probe.namedMapObject(target))[1]
		end

		target = hit
	end

	local namedAction
	if type(obj) == "string" then
		local gameDB = peep:getDirector():getGameDB()

		local namedMapAction = gameDB:getRecord("NamedMapAction", {
			Name = obj,
			Map = map
		})

		local mapObject = target and Peep.getMapObject(target)
		local namedMapObjectAction = mapObject and gameDB:getRecord("NamedPeepAction", {
			Name = obj,
			Peep = mapObject
		})

		local resource = target and Peep.getResource(target)
		local namedResourceAction = resource and gameDB:getRecord("NamedPeepAction", {
			Name = obj,
			Peep = resource
		})

		namedAction = namedMapObjectAction or namedResourceAction or namedMapAction
		if not namedAction then
			Log.warn("Couldn't get named action '%s' from map, resource, or map object for peep '%s'!", name, peep:getName())
			return false
		end

		namedAction = namedAction:get("Action")
	elseif Class.isCompatibleType(obj, require "ItsyScape.Peep.Action") then
		namedAction = obj:getAction()
	else
		namedAction = obj
	end

	local action = Utility.getAction(peep:getDirector():getGameInstance(), namedAction, false, false)
	if not action then
		Log.warn("Couldn't get named action '%s' for peep '%s' on map '%s'!", name, peep:getName(), map and map.name or "???")
		return false
	end

	local success, _, dialog = Utility.UI.openInterface(peep, "DialogBox", true, action.instance, target or peep, overrideEntryPoint)
	return success, dialog
end

function Peep.talk(peep, message, ...)
	Peep.message(peep, "Message", message, ...)
end

function Peep.yell(peep, message, ...)
	Peep.message(peep, "Yell", message, ...)
end

function Peep.notify(peep, message, suppressGenericNotification)
	if Class.isCompatibleType(peep, Instance) then
		for _, player in peep:iteratePlayers() do
			local playerPeep = player:getActor() and player:getActor():getPeep()
			if playerPeep then
				local ui = playerPeep:getDirector():getGameInstance():getUI()

				if not suppressGenericNotification then
					local didUpdate = false
					for _, interface in ui:getInterfacesForPeep(playerPeep, "GenericNotification") do
						interface:updateMessage(message)
						didUpdate = true
						break
					end

					if not didUpdate then
						Utility.UI.openInterface(playerPeep, "GenericNotification", false, message)
					end
				else
					player:addExclusiveChatMessage(message)
				end
			end
		end
	else
		local ui = peep:getDirector():getGameInstance():getUI()

		local didUpdate = false
		if not suppressGenericNotification then
			for _, interface in ui:getInterfacesForPeep(peep, "GenericNotification") do
				interface:updateMessage(message)
				didUpdate = true
				break
			end
		end

		if not didUpdate then
			if not suppressGenericNotification then
				Utility.UI.openInterface(peep, "GenericNotification", false, message)
			else
				local player = Peep.getPlayerModel(peep)
				if player then
					player:addExclusiveChatMessage(message)
				end
			end
		end
	end
end

function Peep.message(peep, sprite, message, ...)
	local instance = Peep.getInstance(peep)
	if instance then
		for _, player in instance:iteratePlayers() do
			player:pushMessage(peep, message)
		end
	end

	local size = Peep.getSize(peep)
	y = (size and size.y and (math.max(size.y - 1, 1))) or 1

	local actor = peep:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor.actor:flash(sprite, y, message, ...)
	end
end

function Peep.getPlayerModel(peep)
	local game = peep:getDirector():getGameInstance()

	local follower = peep:getBehavior(FollowerBehavior)
	if follower and follower.playerID ~= FollowerBehavior.NIL_ID then
		return game:getPlayerByID(follower.playerID)
	end

	local instance = peep:getBehavior(InstancedBehavior)
	if instance and instance.playerID ~= InstancedBehavior.NIL_ID then
		return game:getPlayerByID(instance.playerID)
	end

	local player = peep:getBehavior(PlayerBehavior)
	if player then
		return game:getPlayerByID(player.playerID)
	end

	local stage = peep:getDirector():getGameInstance():getStage()
	local instance = stage:getPeepInstance(peep)
	local leader = instance and instance:getPartyLeader()
	return leader
end

function Peep.getPlayerActor(peep)
	local model = Peep.getPlayerModel(peep)
	return model and model:getActor()
end

function Peep.getPlayer(peep)
	local actor = Peep.getPlayerActor(peep)
	return actor and actor:getPeep()
end

function Peep.isInstancedToPlayer(peep, player)
	local instance = peep:getBehavior(InstancedBehavior)
	if instance and instance.playerID == player:getID() then
		return true
	end

	return false
end

function Peep.dismiss(peep)
	local name = peep:getName()

	Log.info("Dismissing '%s'...", name)

	local follower = peep:getBehavior(FollowerBehavior)
	if follower and follower.followerID ~= FollowerBehavior.NIL_ID then
		local director = peep:getDirector()
		local worldStorage = director:getPlayerStorage(Peep.getPlayer(peep)):getRoot()
		local scopedStorage = worldStorage:getSection("Follower"):getSection(follower.scope)
		local followerID = follower.followerID

		peep:listen('poof', function()
			for i = 1, scopedStorage:length() do
				if scopedStorage:getSection(i):get("id") == followerID then
					scopedStorage:removeSection(i)
					Log.info("Removed storage for '%s'.")
					break
				end
			end
		end)

		Peep.poof(peep)
		Log.info("Dismissed '%s'.", name)
	else
		Log.warn("Can't dismiss '%s': not a follower.")
	end
end

function Peep.getTransform(peep)
	local transform = love.math.newTransform()
	do
		local position = peep:getBehavior(PositionBehavior)
		if position then
			position = position.position
		else
			position = Vector.ZERO
		end

		local rotation = peep:getBehavior(RotationBehavior)
		if rotation then
			rotation = rotation.rotation
		else
			rotation = Quaternion.IDENTITY
		end

		local scale = peep:getBehavior(ScaleBehavior)
		if scale then
			scale = scale.scale
		else
			scale = Vector.ONE
		end

		local origin = peep:getBehavior(OriginBehavior)
		if origin then
			origin = origin.origin
		else
			origin = Vector.ZERO
		end

		transform:translate(origin:get())
		transform:translate(position:get())
		transform:scale(scale:get())
		transform:applyQuaternion(rotation:get())
		transform:translate((-origin):get())
	end

	return transform
end

function Peep.getAbsoluteTransform(peep)
	local transform = love.math.newTransform()
	do
		local mapScript = Peep.getMapScript(peep)
		if mapScript then
			local parentTransform = Peep.getMapTransform(mapScript)
			transform:apply(parentTransform)
		end


		local peepTransform = Peep.getTransform(peep)
		transform:apply(peepTransform)
	end

	return transform
end

function Peep.getDecomposedMapTransform(peep)
	local position = peep:getBehavior(PositionBehavior)
	if position then
		position = position.position
	else
		position = Vector.ZERO
	end

	local rotation = peep:getBehavior(RotationBehavior)
	if rotation then
		rotation = rotation.rotation
	else
		rotation = Quaternion.IDENTITY
	end

	local scale = peep:getBehavior(ScaleBehavior)
	if scale then
		scale = scale.scale
	else
		scale = Vector.ONE
	end

	local origin = peep:getBehavior(OriginBehavior)
	if origin then
		origin = origin.origin
	else
		origin = Vector.ZERO
	end

	local parent
	do
		local mapOffset = peep:getBehavior(MapOffsetBehavior)
		if mapOffset then
			origin = origin + mapOffset.origin
			position = position + mapOffset.offset
			rotation = rotation * mapOffset.rotation
			scale = scale * mapOffset.scale
		end

		if mapOffset.parentLayer then
			parent = Peep.getInstance(peep):getMapScriptByLayer(mapOffset.parentLayer)
		end
	end

	return position, rotation, scale, origin, parent
end

function Peep.getMapTransform(peep, transform)
	transform = transform or love.math.newTransform()

	do
		local transformOverride = peep:getBehavior(TransformBehavior)
		if transformOverride then
			transform:apply(transformOverride.transform)
			return transform
		end
	end

	do
		local position, rotation, scale, origin, parent = Peep.getDecomposedMapTransform(peep)

		if parent then
			Peep.getMapTransform(parent, transform)
		end

		transform:translate(origin:get())
		transform:translate(position:get())
		transform:scale(scale:get())
		transform:applyQuaternion(rotation:get())
		transform:translate((-origin):get())
	end

	return transform
end

function Peep.getParentTransform(peep)
	local director = peep:getDirector()
	local stage = director:getGameInstance():getStage()
	local position = peep:getBehavior(PositionBehavior)
	if not position or not position.layer then
		return love.math.newTransform()
	end

	local layer = position.layer

	local instance = stage:getInstanceByLayer(layer)
	if not instance then
		return love.math.newTransform()
	end

	local mapScript = instance:getMapScriptByLayer(layer)
	if not mapScript then
		return love.math.newTransform()
	end

	return Peep.getMapTransform(mapScript)
end

function Peep.getLayer(peep)
	if not peep then
		return nil
	end

	if peep:isCompatibleType(require "ItsyScape.Peep.Peeps.Map") then
		return peep:getLayer()
	end

	local position = peep:getBehavior(PositionBehavior)
	if position then
		return position.layer
	end

	return nil
end

function Peep.setLayer(peep, layer)
	local position = peep:getBehavior(PositionBehavior)
	if position then
		position.layer = layer
	end
end

function Peep.setLocalLayer(peep, localLayer, mapScript)
	mapScript = mapScript or Peep.getMapScript(peep)
	if not mapScript then
		return
	end

	local mapScriptLayer = Peep.getLayer(mapScript)
	local instance = peep:getDirector():getGameInstance():getStage():getInstanceByLayer(mapScriptLayer)
	if not instance then
		return
	end

	local mapGroup = instance:getMapGroup(mapScriptLayer)
	if not mapGroup then
		return
	end

	local globalLayer = instance:getGlobalLayerFromLocalLayer(mapGroup, localLayer)
	if not globalLayer then
		return
	end

	Peep.setLayer(peep, globalLayer)
end

function Peep.getPosition(peep)
	local position = peep:getBehavior(PositionBehavior)
	if position then
		return position.position
	else
		return Vector.ZERO
	end
end

function Peep.setPosition(peep, position, lerp)
	local p = peep:getBehavior(PositionBehavior)
	if p then
		p.position = position
	else
		Log.error("Peep '%s' doesn't have a position; can't set new position.", peep:getName())
	end

	if not lerp then
		local actor = peep:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor
		if actor then
			actor:onTeleport(position, p.layer)
		end
	end
end

function Peep.makeInstanced(peep, playerPeep)
	local _, instance = peep:addBehavior(InstancedBehavior)
	instance.playerID = Peep.getPlayerModel(playerPeep):getID()
end

function Peep.teleportCompanion(peep, targetPeep)
	local i, j, k = Peep.getTile(targetPeep)
	local map = Peep.getMap(targetPeep)

	local offsetX = (love.math.random() - 0.5) * 2 * (map:getCellSize() / 2)
	local offsetZ = (love.math.random() - 0.5) * 2 * (map:getCellSize() / 2)
	local offset = Vector(offsetX, 0, offsetZ)

	if map:canMove(i, j, 1, 0) then
		Peep.setPosition(peep, map:getTileCenter(i + 1, j) + offset)
		return true
	elseif map:canMove(i, j, -1, 0) then
		Peep.setPosition(peep, map:getTileCenter(i - 1, j) + offset)
		return true
	elseif map:canMove(i, j, 0, -1) then
		Peep.setPosition(peep, map:getTileCenter(i, j - 1) + offset)
		return true
	elseif map:canMove(i, j, 0, 1) then
		Peep.setPosition(peep, map:getTileCenter(i, j + 1) + offset)
		return true
	end

	return false
end

function Peep.getScale(peep)
	local scale = peep:getBehavior(ScaleBehavior)
	if scale then
		return scale.scale
	else
		return Vector.ONE
	end
end

function Peep.setScale(peep, scale)
	local p = peep:getBehavior(ScaleBehavior)
	if p then
		p.scale = scale
	else
		Log.warn("Peep '%s' doesn't have a scale; can't set new scale.", peep:getName())
	end
end

function Peep.getRotation(peep)
	local rotation = peep:getBehavior(RotationBehavior)
	if rotation then
		return rotation.rotation
	else
		return Quaternion.IDENTITY
	end
end

function Peep.setRotation(peep, rotation)
	local p = peep:getBehavior(RotationBehavior)
	if p then
		p.rotation = rotation
	else
		Log.warn("Peep '%s' doesn't have a rotation; can't set new rotation.", peep:getName())
	end
end

function Peep.setOrigin(peep, origin)
	local p = peep:getBehavior(OriginBehavior)
	if p then
		p.origin = origin
	else
		Log.warn("Peep '%s' doesn't have an origin; can't set new origin.", peep:getName())
	end
end

function Peep.getAbsolutePosition(peep)
	local position = Peep.getPosition(peep)
	local transform = Peep.getParentTransform(peep)
	if transform then
		local tx, ty, tz = transform:transformPoint(position:get())
		return Vector(tx, ty, tz)
	else
		return position
	end
end

function Peep.getAbsoluteDistance(sourcePeep, targetPeep)
	local sourcePeepPosition = Peep.getAbsolutePosition(sourcePeep)
	local sourcePeepSize = Peep.getSize(sourcePeep)
	local sourcePeepHalfSize = sourcePeepSize / 2
	local sourcePeepMin, sourcePeepMax = sourcePeepPosition - sourcePeepHalfSize, sourcePeepPosition + sourcePeepHalfSize

	local targetPeepPosition = Peep.getAbsolutePosition(targetPeep)
	local targetPeepSize = Peep.getSize(targetPeep)
	local targetPeepHalfSize = targetPeepSize / 2
	local targetPeepMin, targetPeepMax = targetPeepPosition - targetPeepHalfSize, targetPeepPosition + targetPeepHalfSize

	local u = (sourcePeepMin - targetPeepMax):max(Vector.ZERO)
	local v = (targetPeepMin - sourcePeepMax):max(Vector.ZERO)
	local squaredDistance = u:getLengthSquared() + v:getLengthSquared()

	if squaredDistance > 0 then
		return math.sqrt(squaredDistance)
	end

	-- Overlapping.
	return 0
end

function Peep.getSize(peep)
	local size = peep:getBehavior(SizeBehavior)
	if size then
		return size.size
	else
		return Vector.ZERO
	end
end

function Peep.setSize(peep, size)
	local s = peep:getBehavior(SizeBehavior)
	if s then
		s.size = size
	else
		Log.warn("Peep '%s' doesn't have a size; can't set new size.", peep:getName())
	end
end

function Peep.getBounds(peep)
	local position = Peep.getPosition(peep)
	local size = Peep.getSize(peep)

	return position - Vector(size.x / 2, 0, size.z / 2), position + Vector(size.x / 2, size.y, size.z / 2)
end

function Peep.getTargetLineOfSight(peep, target, offset)
	offset = offset or Vector.UNIT_Y

	local peepPosition = Peep.getAbsolutePosition(peep)
	local targetPosition = Peep.getAbsolutePosition(target)
	local difference = peepPosition - targetPosition
	local range = difference:getLength()
	local direction = difference / range

	return Ray(peepPosition + offset, -direction), range
end

function Peep.getPeepsAlongRay(peep, ray, range)
	local peepsDistance = {}
	local hits = peep:getDirector():probe(peep:getLayerName(), function(p)
		local position = Peep.getAbsolutePosition(p)
		local size = p:getBehavior(SizeBehavior)
		if not size then
			return false
		else
			size = size.size
		end

		local min = position - Vector(size.x / 2, 0, size.z / 2)
		local max = position + Vector(size.x / 2, size.y, size.z / 2)

		local s, hitPosition = ray:hitBounds(min, max)
		local peepDistance = s and (hitPosition - ray.origin):getLength()
		peepsDistance[p] = peepDistance

		return s and peepDistance <= range
	end)

	table.sort(hits, function(a, b)
		return peepsDistance[a] < peepsDistance[b]
	end)

	return hits
end

function Peep.getPeepsInRadius(peep, range, ...)
	local selfPosition = Peep.getAbsolutePosition(peep)

	local peepsDistance = {}
	local hits = peep:getDirector():probe(peep:getLayerName(), function(p)
		local otherPosition = Peep.getAbsolutePosition(p)
		local distance = (otherPosition - selfPosition):getLength()

		peepsDistance[p] = distance

		return distance <= range
	end, ...)

	table.sort(hits, function(a, b)
		return peepsDistance[a] < peepsDistance[b]
	end)

	return hits
end

function Peep.getDescription(peep, lang)
	lang = lang or "en-US"

	local director = peep:getDirector()
	if director then
		local gameDB = director:getGameDB()

		local mapObject = Peep.getMapObject(peep)
		if mapObject then
			local description = gameDB:getRecord("ResourceDescription", {
				Language = lang,
				Resource = mapObject
			})

			if description and description:get("Value") then
				return description:get("Value")
			end
		end

		local resource = Peep.getResource(peep)
		if resource then
			return Utility.getDescription(resource, gameDB, lang)
		end

		local player = peep:getBehavior(PlayerBehavior)
		if player then
			return "Hey, you!"
		end
	end

	return string.format("It's a %s.", peep:getName())
end

function Peep.getTemporaryStorage(peep)
	return Peep.getPlayerModel(peep):getTemporaryStorage()
end

function Peep.getStorage(peep, instancedPlayer)
	local director = peep:getDirector()
	local gameDB = director:getGameDB()

	local player = peep:getBehavior(PlayerBehavior)
	if player then
		local root = director:getPlayerStorage(peep):getRoot()
		return root:getSection("Peep")
	else
		local resource = Peep.getResource(peep)
		if resource then
			local singleton = gameDB:getRecord("Peep", {
				Resource = resource
			})

			if singleton and singleton:get("Singleton") ~= 0 then
				local name = singleton:get("SingletonID")
				if name and name ~= "" then
					Log.engine(
						"Trying to get singleton peep storage for player '%s' (%d).",
						(instancedPlayer and instancedPlayer:getName()) or "<invalid>",
						(instancedPlayer and Peep.getPlayerModel(instancedPlayer) and Peep.getPlayerModel(instancedPlayer):getID()) or -1)

					local worldStorage = director:getPlayerStorage(instancedPlayer or Peep.getPlayer(peep)):getRoot():getSection("World")
					local mapStorage = worldStorage:getSection("Singleton")
					local peepStorage = mapStorage:getSection("Peeps"):getSection(name)

					return peepStorage
				end
			end
		end

		local follower = peep:getBehavior(FollowerBehavior)
		if follower and follower.followerID ~= FollowerBehavior.NIL_ID then
			local worldStorage = director:getPlayerStorage(Peep.getPlayer(peep)):getRoot()
			local scopedStorage = worldStorage:getSection("Follower"):getSection(follower.scope)

			local length = scopedStorage:length()
			for i = 1, length do
				local peepStorage = scopedStorage:getSection(i)
				if peepStorage:get("id") == follower.followerID then
					return peepStorage
				end
			end

			local storage = scopedStorage:getSection(scopedStorage:length() + 1)
			storage:set("id", follower.followerID)

			return storage
		end

		local mapObject = Peep.getMapObject(peep)
		if mapObject then
			local location = gameDB:getRecord("MapObjectLocation", {
				Resource = mapObject
			})

			if location then
				local name = location:get("Name")
				local map = location:get("Map")
				if name and name ~= "" and map then
					local worldStorage = director:getPlayerStorage(peep):getRoot():getSection("World")
					local mapStorage = worldStorage:getSection(map.name)
					local peepStorage = mapStorage:getSection("Peeps"):getSection(name)

					return peepStorage
				else
					Log.warn("Incomplete map object location.")
				end
			end
		else
			Log.warn("No map object or singleton resource.")
		end
	end

	Log.warn("Failed to get storage for Peep '%s' (%d).", peep:getName(), peep:getTally())

	return nil
end

function Peep.getInventory(peep)
	local inventory = peep:getBehavior(InventoryBehavior)
	inventory = inventory and inventory.inventory

	if not inventory then
		return nil
	end

	local broker = inventory:getBroker()
	if not broker then
		return nil
	end

	local result = {}
	for key in broker:keys(inventory) do
		for item in broker:iterateItemsByKey(inventory, key) do
			table.insert(result, item)
		end
	end

	return result
end

function Peep.getEquippedItem(peep, slot)
	local equipment = peep:getBehavior(EquipmentBehavior)
	if equipment and equipment.equipment then
		equipment = equipment.equipment
		return equipment:getEquipped(slot)
	end
end

function Peep.canEquipItem(peep, itemResource)
	local director = peep:getDirector()

	if type(itemResource) == 'string' then
		itemResource = director:getGameDB():getResource(itemResource, "Item")
	end

	local actions = Utility.getActions(director:getGameInstance(), itemResource, 'inventory')

	for i = 1, #actions do
		if actions[i].instance:is("equip") then
			return actions[i].instance:canPerform(peep:getState())
		end
	end

	return false
end

function Peep.getToolsFromInventory(peep, toolType)
	local inventory = peep:getBehavior(InventoryBehavior)
	if inventory and inventory.inventory then
		inventory = inventory.inventory
	else
		return {}
	end

	local itemBroker = peep:getDirector():getItemBroker()
	local itemManager = peep:getDirector():getItemManager()

	local tools = {}
	for item in itemBroker:iterateItems(inventory) do
		local logic = itemManager:getLogic(item:getID())
		local isLogicWeapon = Class.isCompatibleType(logic, Weapon)
		local isToolOfType = isLogicWeapon and logic:getWeaponType() == toolType
		local canEquipTool = Peep.canEquipItem(peep, item:getID())

		if isToolOfType and canEquipTool then
			table.insert(tools, {
				item = item,
				logic = logic
			})
		end
	end

	return tools
end

function Peep.getEquippedTool(peep, toolType)
	local logic, item = Peep.getEquippedWeapon(peep, true)
	local isLogicWeapon = Class.isCompatibleType(logic, Weapon)
	local isToolOfType = isLogicWeapon and logic:getWeaponType() == toolType

	if isToolOfType then
		return item, logic
	end

	return nil, nil
end

function Peep.getBestTool(peep, toolType)
	local tools
	do
		tools = Peep.getToolsFromInventory(peep, toolType)
		local equippedItem, equippedLogic = Peep.getEquippedTool(peep, toolType)
		if equippedItem and equippedLogic then
			table.insert(tools, {
				item = equippedItem,
				logic = equippedLogic
			})
		end
	end

	if #tools < 1 then
		return nil
	end

	for i = 1, #tools do
		local roll = tools[i].logic:rollDamage(peep, Weapon.PURPOSE_TOOL)
		tools[i].maxHit = roll:getMaxHit()
	end

	table.sort(tools, function(a, b) return a.maxHit > b.maxHit end)
	return tools[1].logic
end

function Peep.getEquippedWeapon(peep, includeXWeapon)
	if includeXWeapon then
		local xWeapon = peep:getBehavior(WeaponBehavior)
		if xWeapon and xWeapon.weapon then
			return xWeapon.weapon
		end
	end

	local weapon = Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_RIGHT_HAND) or
		Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_TWO_HANDED)
	if weapon then
		local logic = peep:getDirector():getItemManager():getLogic(weapon:getID())
		if logic then
			return logic, weapon
		end
	end

	return nil
end

function Peep.getEquippedShield(peep, includeXShield)
	local rightHandItem = Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_LEFT_HAND)
	if rightHandItem then
		local shieldLogic = peep:getDirector():getItemManager():getLogic(rightHandItem:getID())
		if shieldLogic:isCompatibleType(Shield) then
			return shieldLogic, rightHandItem
		end
	end

	if includeXShield then
		
		local xShield = peep:getBehavior(ShieldBehavior)
		if xShield and xShield.shield and xShield.shield:isCompatibleType(Shield) then
			return xShield.shield
		end
	end

	return nil, nil
end

function Peep.getEquipmentBonuses(peep)
	local result = {}
	for i = 1, #EquipmentInventoryProvider.STATS do
		local stat = EquipmentInventoryProvider.STATS[i]
		result[stat] = 0
	end

	do
		local equipment = peep:getBehavior(EquipmentBehavior)
		if equipment and equipment.equipment then
			equipment = equipment.equipment
			for bonus, value in equipment:getStats() do
				result[bonus] = result[bonus] + value
			end
		end
	end

	do
		local equipment = peep:getBehavior(EquipmentBonusesBehavior)
		if equipment then
			equipment = equipment.bonuses
			for i = 1, #EquipmentInventoryProvider.STATS do
				local stat = EquipmentInventoryProvider.STATS[i]
				result[stat] = result[stat] + equipment[stat]
			end
		end
	end

	return result
end

function Peep.getXWeaponType(id)
	local XName = string.format("Resources.Game.Items.X_%s.Logic", id)
	local XType = require(XName)

	return XType
end

function Peep.getXWeapon(game, id, proxyID, ...)
	local XName = string.format("Resources.Game.Items.X_%s.Logic", id)
	local XType = require(XName)

	return XType(proxyID or id, game:getDirector():getItemManager(), ...)
end

function Peep.equipXWeapon(peep, id)
	local xWeapon = Peep.getXWeapon(peep:getDirector():getGameInstance(), id)
	local s, weapon = peep:addBehavior(WeaponBehavior)
	if s then
		weapon.weapon = xWeapon
		if Class.isDerived(xWeapon:getType(), Equipment) then
			xWeapon:onEquip(peep)
		end
	end
end

function Peep.equipXShield(peep, id)
	local xShield = Peep.getXWeapon(peep:getDirector():getGameInstance(), id)
	local s, shield = peep:addBehavior(ShieldBehavior)
	if s then
		shield.shield = xShield
		if Class.isDerived(xShield:getType(), Equipment) then
			xShield:onEquip(peep)
		end
	end
end

function Peep.getEffectType(resource, gameDB)
	if type(resource) == 'string' then
		resource = gameDB:getResource(resource, "Effect")
	end

	if not resource then
		return nil
	end

	local EffectTypeName = string.format("Resources.Game.Effects.%s.Effect", resource.name)
	local s, r = pcall(require, EffectTypeName)
	if s then
		return r
	else
		Log.error("Couldn't load effect '%s': %s", Utility.getName(resource, gameDB), r)
	end

	return nil
end

function Peep.applyEffect(peep, resource, singular, ...)
	local gameDB = peep:getDirector():getGameDB()

	if type(resource) == 'string' then
		resource = gameDB:getResource(resource, "Effect")
	end

	if not resource then
		return false, nil
	end

	local EffectType = Peep.getEffectType(resource, gameDB)

	if not EffectType then
		Log.warn("Effect '%s' does not exist.", Utility.getName(resource, gameDB))
		return false, nil
	end

	if singular and peep:getEffect(EffectType) then
		Log.info("Effect '%s' already applied.", Utility.getName(resource, gameDB))
		return false, nil
	end

	local effectInstance = EffectType(...)
	effectInstance:setResource(resource)
	peep:addEffect(effectInstance)

	return true, effectInstance
end

function Peep.toggleEffect(peep, resource, onOrOff, ...)
	local gameDB = peep:getDirector():getGameDB()

	local EffectType = Peep.getEffectType(resource, gameDB)

	if not EffectType then
		Log.warn("Effect '%s' does not exist.", Utility.getName(resource, gameDB))
		return false
	end

	local e = peep:getEffect(EffectType)
	if e and onOrOff ~= true then
		peep:removeEffect(e)
		return true, e
	elseif not e and onOrOff ~= false then
		local effectInstance = EffectType(...)
		effectInstance:setResource(resource)
		peep:addEffect(effectInstance)
		return true, effectInstance
	end

	if e and onOrOff or (not e and not onOrOff) then
		return true, e
	end

	return false
end

function Peep.getPowerType(resource, gameDB)
	local PowerTypeName = string.format("Resources.Game.Powers.%s.Power", resource.name)
	local s, r = pcall(require, PowerTypeName)
	if s then
		return r
	else
		Log.error("Couldn't load power '%s': %s", Utility.getName(resource, gameDB) or resource.name, r)
	end

	return nil
end

function Peep.canAttack(peep)
	local status = peep:getBehavior(require "ItsyScape.Peep.Behaviors.CombatStatusBehavior")
	if not status then
		return false
	end

	return status.currentHitpoints > 0 and not status.dead
end

function _canPeepAttack(peep, target, teams, otherTeams, matchup)
	local targetCharacter = Peep.getCharacter(target)
	if not targetCharacter then
		return true
	end

	local override = teams.override[targetCharacter.name]
	if override then
		if override == TeamsBehavior.ENEMY then
			-- Forced enemy.
			return true, true
		elseif override == TeamsBehavior.ALLY and otherTeams.override[targetCharacter.name] ~= TeamsBehavior.ENEMY then
			-- Forced ally.
			return false, true
		end
	end

	if #teams.teams == 0 or #otherTeams.teams == 0 then
		return true, false
	end

	for _, team in ipairs(teams.teams) do
		for _, otherTeam in ipairs(otherTeams.teams) do
			local status = matchup[team] and matchup[team][otherTeam]
			if status == TeamsBehavior.ENEMY then
				return true, false
			end
		end
	end

	return false, false
end

function Peep.canPeepAttackTarget(peep, target)
	if not (Peep.isAttackable(peep) and Peep.canAttack(peep)) then
		return false
	end

	if not (Peep.isAttackable(target) and Peep.canAttack(target)) then
		return false
	end

	local player = Peep.getPlayer(peep)
	if not player then
		return true
	end

	local teams = player:getBehavior(TeamsBehavior)
	if not teams then
		return true
	end

	local peepTeams = peep:getBehavior(TeamBehavior)
	local targetTeams = target:getBehavior(TeamBehavior)

	local peepCharacter = Peep.getCharacter(peep)
	local targetCharacter = Peep.getCharacter(target)

	if not (peepCharacter and targetCharacter) then
		return true
	end

	local peepVsTarget = teams.characters[peepCharacter] and teams.characters[peepCharacter][targetCharacter]
	local targetVsPeep = teams.characters[targetCharacter] and teams.characters[targetCharacter][peepCharacter]

	if peepVsTarget == TeamsBehavior.ENEMY or targetVsPeep == TeamsBehavior.ENEMY then
		return true
	end

	local canAttack, isForced = _canPeepAttack(peep, target, peepTeams, targetTeams, teams.teams)
	if isForced then
		return canAttack
	end

	return canAttack or _canPeepAttack(target, peep, targetTeams, peepTeams, teams.teams)
end

local function _isAttackable(peep, r)
	if not r then
		return false
	end

	local actions = Utility.getActions(peep:getDirector():getGameInstance(), r)
	for i = 1, #actions do
		if actions[i].instance:is("Attack") or actions[i].instance:is("InvisibleAttack") then
			return true
		end
	end

	return false
end

function Peep.isAttackable(peep)
	if peep:hasBehavior(PlayerBehavior) then
		return true
	end

	local resource = Peep.getResource(peep)
	local mapObject = Peep.getMapObject(peep)

	return _isAttackable(peep, resource) or _isAttackable(peep, mapObject) or peep:hasBehavior(PlayerBehavior)
end

function Peep.playAnimation(peep, animationSlot, animationPriority, animationName, animationForced, animationTime)
	local actor = peep:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor
	if not actor then
		return false
	end

	local filename = string.format("%s", animationName)
	if not love.filesystem.getInfo(filename) then
		if love.filesystem.getInfo(animationName) then
			filename = animationName
		else
			return false
		end
	end

	actor:playAnimation(
		animationSlot,
		animationPriority,
		CacheRef("ItsyScape.Graphics.AnimationResource", filename),
		animationForced,
		animationTime)

	return true
end

-- Makes the peep walk to the tile (i, j, k).
--
-- Returns true on success, false on failure.
function Peep.walk(peep, i, j, k, distance, t, ...)
	local command, r = Peep.getWalk(peep, i, j, k, distance, t, ...)
	if command then
		local queue = peep:getCommandQueue()
		local success = queue:interrupt(command)

		-- In the event the peep was walking, we don't want to interrupt the animator cortexes.
		-- Animator cortexes use velocity and/or the target tile behavior as indicators a peep
		-- is walking. So pre-emptively signal the peep is walking, so a walking animation isn't
		-- interrupted.
		if r:getNumNodes() > 1 then
			peep:addBehavior(TargetTileBehavior)
		end

		return success
	end

	return false, r
end

Peep.WALK_QUEUE = { n = 0, pending = {} }

function Peep.cancelWalk(n)
	for i = #Peep.WALK_QUEUE.pending, 1, -1 do
		local pending = Peep.WALK_QUEUE.pending[i]

		if (type(n) == "number" and pending.n == n) or pending.peep == n then
			table.remove(Peep.WALK_QUEUE.pending, i)
		end
	end
end

function Peep.updateWalks(time)
	local walkQueueTimeMS = Config.get("Config", "ENGINE", "var", "walkQueueTimeMS", "_", 10)
	local targetTime = love.timer.getTime() + (time or (walkQueueTimeMS / 1000))

	local queue = Peep.WALK_QUEUE.pending
	while love.timer.getTime() < targetTime and #queue > 0 do
		for i = #queue, 1, -1 do
			local pending = queue[i]

			if pending.s == nil then
				pending.s = pending.update()
			end

			if pending.s ~= nil then
				pending.callback(pending.s)
				table.remove(queue, i)
			end
		end
	end
end

function Peep.queueWalk(peep, i, j, k, distance, t, ...)
	local callback = Callback(false)

	t = t or { asCloseAsPossible = true }
	local y = {}
	do
		for k, v in pairs(t) do
			y[k] = v
		end

		y.yield = true
	end

	if t.isPosition then
		local map = peep:getDirector():getGameInstance():getStage():getMap(k or Peep.getLayer(peep))
		local _, s, t = map:getTileAt(i, j)

		i = s
		j = t
	end

	Peep.WALK_QUEUE.n = Peep.WALK_QUEUE.n + 1
	local walkCoroutine = coroutine.wrap(Peep.walk)
	local pending = {
		n = Peep.WALK_QUEUE.n,
		callback = callback,
		update = walkCoroutine,
		peep = peep
	}

	pending.s = walkCoroutine(peep, i, j, k, distance, y, ...)

	table.insert(Peep.WALK_QUEUE.pending, pending)
	return callback, pending.n
end

function Peep.getMakeOffset(peep)
	local offsetY
	do
		local mapObject = Peep.getMapObject(peep)
		local resource = Peep.getResource(peep)
		if mapObject then
			local gameDB = peep:getDirector():getGameDB()

			local record = gameDB:getRecord("MakeOffset", {
				Resource = mapObject
			})

			if record then
				offsetY = record:get("OffsetY")
			end
		end

		if not offsetY and resource then
			local gameDB = peep:getDirector():getGameDB()

			local record = gameDB:getRecord("MakeOffset", {
				Resource = resource
			})

			if record then
				offsetY = record:get("OffsetY")
			end
		end
	end

	if not offsetY then
		local size = Peep.getSize(peep)
		offsetY = size.y
	end

	return offsetY or 0
end

function Peep.getTileAnchor(peep, offsetI, offsetJ)
	local rotation = Peep.getRotation(peep)
	local size = Peep.getSize(peep)

	if not (offsetI and offsetJ) then
		local mapObject = Peep.getMapObject(peep)
		local resource = Peep.getResource(peep)
		if mapObject then
			local gameDB = peep:getDirector():getGameDB()

			local record = gameDB:getRecord("PropAnchor", {
				Resource = mapObject
			})

			if record then
				offsetI = record:get("OffsetI")
				offsetJ = record:get("OffsetJ")
			end
		end

		if not (offsetI and offsetJ) and resource then
			local gameDB = peep:getDirector():getGameDB()

			local record = gameDB:getRecord("PropAnchor", {
				Resource = resource
			})

			if record then
				offsetI = record:get("OffsetI")
				offsetJ = record:get("OffsetJ")
			end
		end
	end

	if peep:hasBehavior(ActorReferenceBehavior) then
		local i, j, k = Peep.getTile(peep)
		i = i + (offsetI or 0)
		j = j + (offsetJ or 0)

		return i, j, k
	end

	if not (offsetI and offsetJ) then
		local map = Peep.getMap(peep)

		offsetI = 0
		offsetJ = math.max(math.floor(size.z / map:getCellSize()), 1)
	end

	local i, j = Peep.getTile(peep)
	local v = rotation:transformVector(Vector(offsetI, 0, offsetJ))

	i = i + math.floor(v.x)
	j = j + math.floor(v.z)

	return i, j, Peep.getLayer(peep)
end

function Peep.getTile(peep)
	if not peep:hasBehavior(PositionBehavior) then
		return 0, 0
	end

	local position = peep:getBehavior(PositionBehavior)
	local k
	if not position then
		return 0, 0, 0
	else
		k = position.layer or 1
		position = position.position
	end

	local map = peep:getDirector():getMap(k)
	if not map then
		return 0, 0, 0
	end

	local tile, i, j = map:getTileAt(position.x, position.z)

	return i, j, k, tile
end

function Peep.getPassages(peep)
	local position = Peep.getPosition(peep)
	local mapResource = Peep.getMapResource(peep)

	local gameDB = peep:getDirector():getGameDB()
	local passages = gameDB:getRecords("MapObjectRectanglePassage", {
		Map = mapResource
	})

	local result = {}
	for _, passage in ipairs(passages) do
		local x1, z1 = passage:get("X1"), passage:get("Z1")
		local x2, z2 = passage:get("X2"), passage:get("Z2")
		if position.x >= x1 and position.x <= x2 and
		   position.z >= z1 and position.z <= z2
		then
			local mapObject = gameDB:getRecord("MapObjectReference", {
				Map = mapResource,
				Resource = passage:get("Resource")
			})

			local currentPassageName = mapObject and mapObject:get("Name")
			if currentPassageName then
				table.insert(result, currentPassageName)
			end
		end
	end

	return result
end

function Peep.isInPassage(peep, passage)
	local passages = Peep.getPassages(peep)
	for _, p in ipairs(passages) do
		if p == passage then
			return true
		end
	end
	return false
end

function Peep.getTileRotation(peep)
	local i, j = Peep.getTile(peep)
	local map = Peep.getMap(peep)

	return Utility.Map.getTileRotation(map, i, j)
end

function Peep.getWalk(peep, i, j, k, distance, t, ...)
	t = t or { asCloseAsPossible = true }

	do
		local status = peep:getBehavior(require "ItsyScape.Peep.Behaviors.CombatStatusBehavior")
		if status.dead and not t.isCutscene then
			Log.info("Peep %s is dead; can't walk!", peep:getName())
			return false, "dead"
		end

		local isDisabled = peep:hasBehavior(require "ItsyScape.Peep.Behaviors.DisabledBehavior")
		if isDisabled and not t.isCutscene then
			Log.info("Peep %s is disabled; can't walk!", peep:getName())
			return false, "disabled"
		end
	end

	local distance = distance or 0

	if not peep:hasBehavior(PositionBehavior) or
	   not peep:hasBehavior(MovementBehavior)
	then
		Log.info("Peep '%s' can't walk because they don't have a position or movement behavior.", peep:getName())
		return nil, "missing walking behaviors"
	end

	local position = peep:getBehavior(PositionBehavior)
	if position.layer ~= k then
		Log.info(
			"Peep '%s' is on a different map (on layer %d, can't move to layer %d).",
			peep:getName(), position.layer, k)
		return nil, "different map"
	else
		position = position.position
	end

	local map = peep:getDirector():getMap(k)
	if not map then
		Log.info("Peep '%s' doesn't have a map.", peep:getName())
		return false, "no map"
	end

	local _, playerI, playerJ = map:getTileAt(position.x, position.z)
	local pathFinder = SmartPathFinder(map, peep, t)
	local path = pathFinder:find(
		{ i = playerI, j = playerJ },
		{ i = i, j = j },
		distance, ...)
	if path then
		local n = path:getNodeAtIndex(-1)
		if n then
			local d = math.abs(n.i - i) + math.abs(n.j - j)
			if d > distance then
				return nil, "distance to goal exceeds maximum distance to goal"
			end
		end

		if t.asCloseAsPossible then
			return ExecutePathCommand(path, 0), path
		else
			return ExecutePathCommand(path, distance), path
		end
	end

	return false, "path not found"
end

function Peep.setFacing(peep, direction)
	local movement = peep:getBehavior(MovementBehavior)
	if movement then
		if direction < 0 then
			movement.targetFacing = MovementBehavior.FACING_LEFT
		elseif direction > 0 then
			movement.targetFacing = MovementBehavior.FACING_RIGHT
		end
	end
end

function Peep.face(peep, target)
	local peepPosition = Peep.getAbsolutePosition(peep)
	local targetPosition = Peep.getAbsolutePosition(target)

	local dx = targetPosition.x - peepPosition.x

	local movement = peep:getBehavior(MovementBehavior)
	if movement then
		if dx < 0 then
			movement.targetFacing = MovementBehavior.FACING_LEFT
		elseif dx > 0 then
			movement.targetFacing = MovementBehavior.FACING_RIGHT
		end
	end
end

function Peep.faceAway(peep, target)
	local peepPosition = Peep.getAbsolutePosition(peep)
	local targetPosition = Peep.getAbsolutePosition(target)

	local dx = targetPosition.x - peepPosition.x

	local movement = peep:getBehavior(MovementBehavior)
	if movement then
		if dx > 0 then
			movement.targetFacing = MovementBehavior.FACING_LEFT
		elseif dx < 0 then
			movement.targetFacing = MovementBehavior.FACING_RIGHT
		end
	end
end

function Peep.lookAt(self, target, delta)
	local rotation = self:getBehavior(RotationBehavior)
	if rotation then
		local selfPosition = Peep.getAbsolutePosition(self)
		local peepPosition

		if Class.isCompatibleType(target, Vector) then
			peepPosition = target
		elseif Class.isCompatibleType(target, Ray) then
			peepPosition = target.origin
		elseif Class.isCompatibleType(target, require "ItsyScape.Peep.Peep") then
			peepPosition = Peep.getAbsolutePosition(target)
		else
			return
		end

		local selfMapTransform = Peep.getParentTransform(self)
		local _, mapRotation = CommonMath.decomposeTransform(selfMapTransform)

		local xzSelfPosition = selfPosition * Vector.PLANE_XZ
		local xzPeepPosition = peepPosition * Vector.PLANE_XZ

		local r = Quaternion.lookAt(xzPeepPosition, xzSelfPosition):getNormal()
		r = (r * -mapRotation):getNormal()

		if delta then
			rotation.rotation = rotation.rotation:slerp(r, delta):getNormal()
		else
			rotation.rotation = r
		end

		return true
	end

	return false
end

function Peep.face3D(self)
	if not self:hasBehavior(Face3DBehavior) then
		local _, face3D = self:addBehavior(Face3DBehavior)
		face3D.rotation = self:hasBehavior(RotationBehavior) and self:getBehavior(RotationBehavior).rotation or face3D.rotation
	end

	local face3D = self:getBehavior(Face3DBehavior)

	local combatTarget = self:getBehavior(CombatTargetBehavior)
	if combatTarget and combatTarget.actor then
		local actor = combatTarget.actor
		local peep = actor:getPeep()

		if peep then
			return Peep.lookAt(self, peep)
		end
	else
		local rotation = self:getBehavior(RotationBehavior)
		local targetTile = self:getBehavior(TargetTileBehavior)
		local movement = self:getBehavior(MovementBehavior)
		local isWalking = targetTile and targetTile.pathNode
		local isMoving = movement and (movement.velocity * Vector.PLANE_XZ):getLength() > 0
		if rotation and (isWalking or isMoving) then
			local position = self:getBehavior(PositionBehavior)
			local map = self:getDirector():getMap(position.layer)

			local xzSelfPosition = Peep.getPosition(self) * Vector.PLANE_XZ
			local xzTargetPosition, direction
			if isWalking and map then
				local tilePosition = map:getTileCenter(targetTile.pathNode.i, targetTile.pathNode.j)
				xzTargetPosition = tilePosition * Vector.PLANE_XZ
				direction = (xzSelfPosition - xzTargetPosition):getNormal()
			elseif isMoving then
				local velocity = movement.velocity * Vector.PLANE_XZ
				xzTargetPosition = xzSelfPosition + (velocity)
				direction = velocity:getNormal()
			end

			if xzTargetPosition and direction then
				if (direction - face3D.direction):getLength() > 0.01 then
					face3D.rotation = rotation.rotation
					face3D.time = love.timer.getTime()
					face3D.direction = direction
				end

				local delta = math.min((love.timer.getTime() - face3D.time) / face3D.duration, 1)

				local targetRotation = Quaternion.lookAt(xzTargetPosition, xzSelfPosition)
				rotation.rotation = face3D.rotation:slerp(targetRotation, delta):getNormal()

				return true
			end
		end
	end

	return false
end

function Peep.applyCooldown(peep, time)
	if not time then
		local weapon = Peep.getEquippedWeapon(peep, true)
		if weapon and Class.isCompatibleType(weapon, require "ItsyScape.Game.Weapon") then
			time = weapon:getCooldown(peep)
		end
	end

	local _, cooldown = peep:addBehavior(AttackCooldownBehavior)
	cooldown.cooldown = math.max(cooldown.cooldown, time)
	cooldown.ticks = peep:getDirector():getGameInstance():getCurrentTick()
end

function Peep.attack(peep, other, distance)
	do
		local status = peep:getBehavior(CombatStatusBehavior)
		if not status then
			return false
		end

		if status and (status.dead or status.currentHitpoints == 0) then
			return false
		end
	end

	if not Peep.canPeepAttackTarget(peep, other) then
		return false
	end

	local actor = other:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		if peep:getCommandQueue(CombatCortex.QUEUE):interrupt(AttackCommand()) then
			local _, target = peep:addBehavior(CombatTargetBehavior)
			target.actor = actor.actor
		end

		local mashina = peep:getBehavior(MashinaBehavior)
		if mashina then
			if mashina.currentState == 'idle' or not mashina.currentState then
				if mashina.states['begin-attack'] then
					mashina.currentState = 'begin-attack'
				elseif mashina.states['attack'] then
					mashina.currentState = 'attack'
				elseif mashina.currentState == 'idle' then
					mashina.currentState = false
				end
			end
		end

		if distance then
			local status = peep:getBehavior(CombatStatusBehavior)
			status.maxChaseDistance = distance
		end
	end

	return true
end

function Peep.getCharacter(peep)
	local character = peep:getBehavior(CharacterBehavior)
	return character and character.character
end

function Peep.getResource(peep)
	local resource = peep:getBehavior(MappResourceBehavior)
	if resource then
		if resource.resource and peep:getIsReady() then
			local brochure = peep:getDirector():getGameDB():getBrochure()
			local resourceType = brochure:getResourceTypeFromResource(resource.resource)

			return resource.resource, resourceType
		end

		return resource.resource, nil
	else
		return false
	end
end

function Peep.setResource(peep, resource)
	if not resource then
		peep:removeBehavior(MappResourceBehavior)
	else
		local behavior = peep:getBehavior(MappResourceBehavior)
		if not behavior then
			if not peep:addBehavior(MappResourceBehavior) then
				return false
			end

			behavior = peep:getBehavior(MappResourceBehavior)
		end

		assert(behavior, "couldn't add MappResourceBehavior")
		behavior.resource = resource
	end
end

function Peep.getMapObject(peep)
	local mapObject = peep:getBehavior(MapObjectBehavior)
	if mapObject then
		return mapObject.mapObject
	else
		return false
	end
end

function Peep.setMapObject(peep, mapObject)
	if mapObject == false then
		peep:removeBehavior(MapObjectBehavior)
	else
		local behavior = peep:getBehavior(MapObjectBehavior)
		if not behavior then
			if not peep:addBehavior(MapObjectBehavior) then
				return false
			end

			behavior = peep:getBehavior(MapObjectBehavior)
		end

		assert(behavior, "couldn't add MapObjectBehavior")
		behavior.mapObject = mapObject
	end
end

function Peep.getTier(peep)
	local resource = Peep.getResource(peep)
	if resource then
		local gameDB = peep:getDirector():getGameDB()
		local tier = gameDB:getRecord("Tier", {
			Resource = resource
		})

		if tier then
			return tier:get("Tier")
		end
	end

	return 0
end

function Peep.getInstance(peep)
	return peep:getDirector():getGameInstance():getStage():getPeepInstance(peep)
end

function Peep.getRaid(peep)
	local instance = Peep.getInstance(peep)
	return instance and instance:getRaid()
end

function Peep.getMap(peep)
	if not peep:getDirector() then
		return Peep._defaultMap
	end

	local director = peep:getDirector()
	local position = peep:getBehavior(PositionBehavior)

	Peep._defaultMap = Peep._defaultMap or Map(1, 1, 2)

	if peep:isCompatibleType(require "ItsyScape.Peep.Peeps.Map") then
		return director:getMap(peep:getLayer()) or Peep._defaultMap
	end

	if position and position.layer and director then 
		return director:getMap(position.layer) or Peep._defaultMap
	end

	return Peep._defaultMap
end

function Peep.getMapResource(peep)
	local instance = Peep.getInstance(peep)
	local mapGroup = instance:getMapGroup(Peep.getLayer(peep))
	local groupBaseLayer = instance:getGlobalLayerFromLocalLayer(mapGroup)
	local mapScript = instance:getMapScriptByLayer(groupBaseLayer) or instance:getBaseMapScript()
	return Peep.getResource(mapScript)
end

function Peep.getMapResourceFromLayer(peep)
	local instance = peep:getDirector():getGameInstance():getStage():getPeepInstance(peep)
	if instance then
		local mapScript = instance:getMapScriptByLayer(Peep.getLayer(peep))
		if mapScript then
			return Peep.getResource(mapScript)
		end
	end

	return nil
end

function Peep.setMapResource(peep, map)
	local _, mapResourceReference = peep:addBehavior(MapResourceReferenceBehavior)
	mapResourceReference.map = map
end

function Peep.getMapScript(peep)
	local instance = Peep.getInstance(peep)
	local mapGroup = instance:getMapGroup(Peep.getLayer(peep))
	local groupBaseLayer = instance:getGlobalLayerFromLocalLayer(mapGroup)
	local mapScript = instance:getMapScriptByLayer(groupBaseLayer)

	return mapScript
end

function Peep.setNameMagically(peep)
	local gameDB = peep:getDirector():getGameDB()
	local resource = Peep.getResource(peep)
	local mapObject = Peep.getMapObject(peep)
	local storage = Peep.getStorage(peep)

	local name
	if storage then
		if storage:hasSection("flavor") then
			name = storage:getSection("flavor"):get("name")
		end

		if not name then
			name = storage:get("name")
		end
	end

	if not name and mapObject then
		name = Utility.getName(mapObject, gameDB)
	end

	if not name and resource then
		name = Utility.getName(resource, gameDB)
	end

	if name then
		peep:setName(name)
	elseif resource then
		peep:setName("*" .. resource.name)
	end
end

function Peep.poofInstancedMapGroup(playerPeep, mapObjectGroup)
	local director = playerPeep:getDirector()
	local hits = director:probe(
		playerPeep:getLayerName(),
		Probe.mapObjectGroup(mapObjectGroup),
		Probe.instance(Peep.getPlayerModel(playerPeep)))

	for _, hit in ipairs(hits) do
		Peep.poof(hit)
	end
end

function Peep.poof(peep)
	if peep:wasPoofed() then
		return
	end

	local function performPoof()
		local stage = peep:getDirector():getGameInstance():getStage()

		local actor = peep:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			stage:killActor(actor.actor)
		end

		local prop = peep:getBehavior(PropReferenceBehavior)
		if prop and prop.prop then
			stage:removeProp(prop.prop)
		end

		if not actor and not prop then
			peep:getDirector():removePeep(peep)
		end
	end

	if not peep:getDirector() then
		peep:listen('finalize', performPoof)
	else
		performPoof()
	end
end

function Peep.addStats(peep, max)
	peep:addBehavior(StatsBehavior)

	peep:listen('assign', Utility.Peep.Stats.onAssign, max)
	peep:listen('ready', Utility.Peep.Stats.onReady)
	peep:listen('finalize', Utility.Peep.Stats.onFinalize)
end

function Peep.makeMashina(peep)
	peep:addBehavior(MashinaBehavior)

	peep:listen('ready', Utility.Peep.Mashina.onReady)
end

function Peep.getMashinaState(peep)
	local mashina = peep:getBehavior(MashinaBehavior)
	return mashina and mashina.currentState or false
end

function Peep.setMashinaState(peep, state)
	local mashina = peep:getBehavior(MashinaBehavior)
	if mashina then
		mashina.currentState = state or false
		return not not mashina.states[state] or state == false
	end

	return false
end

function Peep.addInventory(peep, InventoryType)
	InventoryType = InventoryType or require "ItsyScape.Game.PlayerInventoryProvider"

	peep:addBehavior(InventoryBehavior)
	local inventory = peep:getBehavior(InventoryBehavior)
	inventory.inventory = InventoryType(peep)

	peep:listen('assign', Utility.Peep.Inventory.onAssign)
	peep:listen('ready', Utility.Peep.Inventory.onReady)
end

function Peep.prepInstancedInventory(peep, InventoryType, player)
	InventoryType = InventoryType or require "ItsyScape.Game.SimpleInventoryProvider"
	local inventoryBehavior = peep:getBehavior(InstancedInventoryBehavior)

	if not inventoryBehavior then
		return nil
	end

	local playerModel = Utility.Peep.getPlayerModel(player)

	local inventory = inventoryBehavior.inventory[playerModel:getID()]
	if not inventory then
		inventory = InventoryType(peep, player)
		inventoryBehavior.inventory[playerModel:getID()] = inventory

		peep:getDirector():getItemBroker():addProvider(inventory)
	end

	return inventory
end

function Peep.addEquipment(peep, EquipmentType)
	EquipmentType = EquipmentType or EquipmentInventoryProvider

	peep:addBehavior(EquipmentBehavior)
	local equipment = peep:getBehavior(EquipmentBehavior)
	equipment.equipment = EquipmentType(peep)

	peep:listen('assign', Utility.Peep.Equipment.onAssign)
	peep:listen('ready', Utility.Peep.Equipment.onReady)
end

function Peep.makeAttackable(peep, retaliate)
	if retaliate == nil then
		retaliate = true
	end

	peep:addBehavior(CombatStatusBehavior)
	peep:addBehavior(PowerRechargeBehavior)

	peep:addPoke("initiateAttack")
	peep:listen("initiateAttack", Utility.Peep.Attackable.onInitiateAttack)
	peep:addPoke("receiveAttack")
	peep:addPoke("switchStyle")
	peep:addPoke("rollAttack")
	peep:addPoke("rollDamage")

	peep:listen("ready", Utility.Peep.Attackable.onReady)
	peep:listen("postReady", Utility.Peep.Attackable.onPostReady)

	if retaliate then
		peep:addBehavior(AggressiveBehavior)
		peep:listen("receiveAttack", Utility.Peep.Attackable.aggressiveOnReceiveAttack)
	else
		peep:listen("receiveAttack", Utility.Peep.Attackable.onReceiveAttack)
	end

	peep:addPoke("targetFled")
	peep:listen("targetFled", Utility.Peep.Attackable.onTargetFled)
	peep:addPoke("hit")
	peep:listen("hit", Utility.Peep.Attackable.onHit)
	peep:addPoke("miss")
	peep:listen("miss", Utility.Peep.Attackable.onMiss)
	peep:addPoke("die")
	peep:listen("die", Utility.Peep.Attackable.onDie)
	peep:addPoke("heal")
	peep:listen("heal", Utility.Peep.Attackable.onHeal)
	peep:addPoke("resurrect")
	peep:listen("resurrect", Utility.Peep.Attackable.onResurrect)
	peep:addPoke("powerApplied")
	peep:addPoke("powerActivated")
	peep:addPoke("powerDeflected")
	peep:addPoke("zeal")
	peep:listen("zeal", Utility.Peep.Attackable.onZeal)
end

function Peep.makeSkiller(peep)
	peep:addPoke('resourceHit')
	peep:addPoke('resourceObtained')
end

function Peep.makeDummy(peep)
	peep:listen('finalize', Utility.Peep.Dummy.onFinalize)
end

function Peep.makeHuman(peep)
	local movement = peep:getBehavior(MovementBehavior)
	if movement then
		movement.maxSpeed = 6
		movement.maxAcceleration = 8
		movement.velocityMultiplier = 1
		movement.accelerationMultiplier = 1
		movement.stoppingForce = 3
	end

	peep:addPoke('trip')

	peep:addBehavior(HumanoidBehavior)

	for _, a in ipairs(Peep.Human.ANIMATIONS) do
		local name, filename = unpack(a)
		Peep.Human.addAnimation(peep, name, filename)
	end

	peep:listen('finalize', Utility.Peep.Human.onFinalize)
end

function Peep.makeCharacter(peep)
	peep:addBehavior(TeamBehavior)
	peep:listen('finalize', Utility.Peep.Character.onFinalize)
end

return Peep
