--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Common.lua
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
local Curve = require "ItsyScape.Game.Curve"
local CurveConfig = require "ItsyScape.Game.CurveConfig"
local PlayerStatsStateProvider = require "ItsyScape.Game.PlayerStatsStateProvider"
local Stats = require "ItsyScape.Game.Stats"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"
local AggressiveBehavior = require "ItsyScape.Peep.Behaviors.AggressiveBehavior"
local CharacterBehavior = require "ItsyScape.Peep.Behaviors.CharacterBehavior"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local Probe = require "ItsyScape.Peep.Probe"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local CombatChargeBehavior = require "ItsyScape.Peep.Behaviors.CombatChargeBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local Face3DBehavior = require "ItsyScape.Peep.Behaviors.Face3DBehavior"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"
local InstancedInventoryBehavior = require "ItsyScape.Peep.Behaviors.InstancedInventoryBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local GatherableBehavior = require "ItsyScape.Peep.Behaviors.GatherableBehavior"
local GenderBehavior = require "ItsyScape.Peep.Behaviors.GenderBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local ImmortalBehavior = require "ItsyScape.Peep.Behaviors.ImmortalBehavior"
local MapObjectBehavior = require "ItsyScape.Peep.Behaviors.MapObjectBehavior"
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"
local MappResourceBehavior = require "ItsyScape.Peep.Behaviors.MappResourceBehavior"
local MapResourceReferenceBehavior = require "ItsyScape.Peep.Behaviors.MapResourceReferenceBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local OriginBehavior = require "ItsyScape.Peep.Behaviors.OriginBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"
local PowerRechargeBehavior = require "ItsyScape.Peep.Behaviors.PowerRechargeBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local TeamBehavior = require "ItsyScape.Peep.Behaviors.TeamBehavior"
local TeamsBehavior = require "ItsyScape.Peep.Behaviors.TeamsBehavior"
local TransformBehavior = require "ItsyScape.Peep.Behaviors.TransformBehavior"
local FollowerCortex = require "ItsyScape.Peep.Cortexes.FollowerCortex"
local MapPathFinder = require "ItsyScape.World.MapPathFinder"
local socket = require "socket"

-- Contains utility methods for a variety of purposes.
--
-- These methods can be used on both the client and server. They should not load
-- any resources.
local Common = {}

Common.RESOURCE_CURVE = Curve()

function _doMove(stage, player, path, anchor, raid, e, callback)
	if callback then
		callback("waited", player)
	end

	local instance = stage:movePeep(player, path, anchor, e)

	if instance ~= path and raid then
		raid:addInstance(instance)
	end

	if callback then
		callback("move", player, instance)
	end
end

-- callback lifecycle:
--   - "wait"   -> begin waiting before move
--   - "waited" -> finished waiting before move
--   - "move"   -> peep moved
--   - "ready"  -> player can move again
function Common.move(player, path, anchor, raid, e, callback)
	local move = CallbackCommand(_doMove, player:getDirector():getGameInstance():getStage(), player, path, anchor, raid, e, callback)
	local wait = WaitCommand(0.5, false)
	local command = CompositeCommand(true, wait, move)

	if not player:getCommandQueue():interrupt(command) then
		if callback then
			callback("cancel", player)
		end

		Log.info("Couldn't interrupt command queue for player '%s'; cannot move.", player:getName())
		return false
	end

	if callback then
		callback("wait", player)
	end

	Utility.Peep.disable(player)
	player:removeBehavior(TargetTileBehavior)

	local movement = player:getBehavior(MovementBehavior)
	if movement then
		movement.velocity = Vector.ZERO
		movement.acceleration = Vector.ZERO
	end

	Utility.UI.openInterface(player, "CutsceneTransition", false, nil, function()
		Utility.Peep.enable(player)

		if callback then
			callback("ready", player)
		end
	end)

	return true
end

function Common.save(player, saveLocation, talk, ...)
	local director = player:getDirector()
	if not director then
		return
	end

	director:getItemBroker():toStorage()

	local storage = director:getPlayerStorage(player)
	if storage then
		local root = storage:getRoot()
		do
			local stats = player:getBehavior(StatsBehavior)
			if stats and stats.stats then
				stats.stats:save(root:getSection("Peep"))
			end

			if saveLocation then
				local isInstanced = Utility.Peep.getInstance(player):getIsLocal()

				local map = player:getBehavior(MapResourceReferenceBehavior)
				if map and map.map then
					map = map.map

					local location = root:getSection("Location")
					local spawn = root:getSection("Spawn")
					local position = player:getBehavior(PositionBehavior)
					if position then
						location:set({
							name = map.name,
							instance = isInstanced,
							x = position.position.x,
							y = position.position.y,
							z = position.position.z
						})

						spawn:set({
							name = map.name,
							instance = isInstanced,
							x = position.position.x,
							y = position.position.y,
							z = position.position.z
						})
					end
				end
			end
		end

		local playerModel = Utility.Peep.getPlayerModel(player)
		if playerModel then
			playerModel:onSave(storage)
		end

		local actor = player:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor and talk then
			local actor = actor.actor
			actor:flash("Message", 1, ...)
		end

		return true
	end

	return false
end

function Common.moveToAnchor(peep, map, anchor)
	if not peep then
		return nil
	end

	local game = peep:getDirector():getGameInstance()
	local x, y, z, localLayer = Utility.Map.getAnchorPosition(game, map, anchor)
	Utility.Peep.setPosition(peep, Vector(x, y, z))
	Utility.Peep.setLocalLayer(peep, localLayer)

	return peep
end

function Common.orientateToAnchor(peep, map, anchor)
	if peep then
		local game = peep:getDirector():getGameInstance()
		local rotation = Quaternion(Utility.Map.getAnchorRotation(game, map, anchor))
		local scale = Vector(Utility.Map.getAnchorScale(game, map, anchor))
		local direction = Utility.Map.getAnchorDirection(game, map, anchor)
		local _, _, _, localLayer = Utility.Map.getAnchorPosition(game, map, anchor)

		if rotation ~= Quaternion.IDENTITY then
			local shipMovement = peep:getBehavior(ShipMovementBehavior)
			if shipMovement then
				shipMovement.rotation = rotation
			else
				local _, r = peep:addBehavior(RotationBehavior)
				r.rotation = rotation
			end
		end

		if scale ~= Vector.ONE then
			local _, s = peep:addBehavior(ScaleBehavior)
			s.scale = scale
		end

		if direction ~= 0 then
			local movement = peep:getBehavior(MovementBehavior)
			if movement then
				movement.facing = direction
				movement.targetFacing = direction
			end
		end

		Utility.Peep.setLocalLayer(peep, localLayer)
	end

	return peep
end

function Common.spawnActorAtPosition(peep, resource, x, y, z, radius)
	radius = radius or 0

	if type(resource) == 'string' then
		local gameDB = peep:getDirector():getGameDB()
		resource = gameDB:getResource(resource, "Peep")
	end

	if resource then
		local name = "resource://" .. resource.name
		local stage = peep:getDirector():getGameInstance():getStage(peep)
		local s, a = stage:spawnActor(name, Utility.Peep.getLayer(peep), peep:getLayerName())
		if s then
			local actorPeep = a:getPeep()

			local position = actorPeep:getBehavior(PositionBehavior)
			if position then
				position.position = Vector(
					x + ((math.random() * 2) - 1) * radius,
					y, 
					z + ((math.random() * 2) - 1) * radius)
			end

			actorPeep:poke('spawnedByPeep', { peep = peep })

			return a
		end
	end

	return nil
end

function Common.spawnActorAtAnchor(peep, resource, anchor, radius)
	local map = Utility.Peep.getMapResource(peep)
	local x, y, z = Utility.Map.getAnchorPosition(
		peep:getDirector():getGameInstance(),
		map,
		anchor)

	if x and y and z then
		local actor = Common.spawnActorAtPosition(peep, resource, x, y, z, radius)
		if actor then
			actor:getPeep():listen('finalize',
				Common.orientateToAnchor,
				actor:getPeep(),
				map,
				anchor)
		end

		return actor
	else
		Log.warn("Anchor '%s' for map '%s' not found.", anchor, map.name)
		return nil
	end
end

function Common.spawnInstancedMapObjectAtAnchor(peep, playerPeep, mapObject, anchor, radius)
	radius = radius or 0

	local gameDB = peep:getDirector():getGameDB()
	local mapResource = Utility.Peep.getMapResource(peep)

	if type(mapObject) == 'string' then
		local m = mapObject

		local reference = gameDB:getRecord("MapObjectReference", {
			Name = mapObject,
			Map = mapResource
		})

		if not reference then
			Log.warn("Map object reference '%s' not found.", m)
			return nil, nil
		end

		mapObject = reference:get("Resource")
		if not mapObject then
			Log.info("Map object '%s' not found.", m)
			return nil, nil
		end
	end

	local mapObjectResource
	do
		local peepMapObject = gameDB:getRecord("PeepMapObject", {
			MapObject = mapObject
		})

		local propMapObject = gameDB:getRecord("PropMapObject", {
			MapObject = mapObject
		})

		mapObjectResource = (peepMapObject and peepMapObject:get("Peep")) or (propMapObject and propMapObject:get("Prop"))
	end

	if not mapObjectResource then
		return nil, nil
	end

	local followerCortex = peep:getDirector():getCortex(FollowerCortex)
	local currentPeep
	for peep in followerCortex:iterateFollowers(Utility.Peep.getPlayerModel(playerPeep)) do
		local resource = Utility.Peep.getResource(peep)
		if resource then
			if resource.id.value == mapObjectResource.id.value then
				currentPeep = peep
				break
			end
		end
	end

	if currentPeep then
		local actorReference = currentPeep:getBehavior(ActorReferenceBehavior)
		local propReference = currentPeep:getBehavior(PropReferenceBehavior)

		return actorReference and actorReference.actor, propReference and propReference.prop
	end

	local actor, prop = Common.spawnMapObjectAtAnchor(peep, mapObject, anchor, radius)
	local playerID = Utility.Peep.getPlayerModel(playerPeep):getID()

	if actor then
		local _, follower = actor:getPeep():addBehavior(FollowerBehavior)
		follower.playerID = playerID

		local _, instance = actor:getPeep():addBehavior(InstancedBehavior)
		instance.playerID = playerID
	end

	if prop then
		local _, instance = prop:getPeep():addBehavior(InstancedBehavior)
		instance.playerID = playerID
	end

	return actor, prop
end

function Common.spawnMapObjectAtPosition(peep, mapObject, x, y, z, radius)
	radius = radius or 0

	if type(mapObject) == 'string' then
		local m = mapObject
		local map = Utility.Peep.getMapResource(peep)
		local gameDB = peep:getDirector():getGameDB()
		local reference = gameDB:getRecord("MapObjectReference", {
			Name = mapObject,
			Map = map
		})

		if not reference then
			Log.warn("Map object reference '%s' not found.", m)
			return nil, nil
		end

		mapObject = reference:get("Resource")
		if not mapObject then
			Log.info("Map object '%s' not found.", m)
			return nil, nil
		end
	end

	local stage = peep:getDirector():getGameInstance():getStage(peep)

	local actor, prop = stage:instantiateMapObject(mapObject, Utility.Peep.getLayer(peep), peep:getLayerName())
	
	if actor then
		local actorPeep = actor:getPeep()
		local position = actorPeep:getBehavior(PositionBehavior)
		if position then
			position.position = Vector(
				x + ((love.math.random() * 2) - 1) * radius,
				y, 
				z + ((love.math.random() * 2) - 1) * radius)
		end

		actorPeep:poke('spawnedByPeep', { peep = peep })
	end

	if prop then
		local propPeep = prop:getPeep()
		local position = propPeep:getBehavior(PositionBehavior)
		if position then
			position.position = Vector(
				x + ((math.random() * 2) - 1) * radius,
				y, 
				z + ((math.random() * 2) - 1) * radius)
		end

		propPeep:poke('spawnedByPeep', { peep = peep })
	end

	return actor, prop
end

function Common.spawnMapObjectAtAnchor(peep, mapObject, anchor, radius)
	local map = Utility.Peep.getMapResource(peep)
	local x, y, z = Utility.Map.getAnchorPosition(
		peep:getDirector():getGameInstance(),
		map,
		anchor)

	if x and y and z then
		local actor, prop = Common.spawnMapObjectAtPosition(peep, mapObject, x, y, z, radius)
		do
			if actor then
				actor:getPeep():listen('finalize',
					Common.orientateToAnchor,
					actor:getPeep(),
					map,
					anchor)
			end

			if prop then
				prop:getPeep():listen('finalize',
					Common.orientateToAnchor,
					prop:getPeep(),
					map,
					anchor)
			end
		end

		return actor, prop
	else
		Log.warn("Anchor '%s' for map '%s' not found.", anchor, map.name)
		return nil
	end
end

function Common.spawnPropAtPosition(peep, prop, x, y, z, radius)
	radius = radius or 0

	if type(prop) == 'string' then
		local gameDB = peep:getDirector():getGameDB()
		prop = gameDB:getResource(prop, "Prop")
	end

	if not prop then
		return nil
	end

	local stage = peep:getDirector():getGameInstance():getStage(peep)
	local success, prop = stage:placeProp("resource://" .. prop.name, Utility.Peep.getLayer(peep), peep:getLayerName())

	if success then
		local propPeep = prop:getPeep()
		local position = propPeep:getBehavior(PositionBehavior)
		if position then
			position.position = Vector(
				x + ((math.random() * 2) - 1) * radius,
				y, 
				z + ((math.random() * 2) - 1) * radius)
		end

		propPeep:poke('spawnedByPeep', { peep = peep })
	end

	return prop
end

function Common.spawnPropAtAnchor(peep, prop, anchor, radius)
	local map = Utility.Peep.getMapResource(peep)
	local x, y, z = Utility.Map.getAnchorPosition(
		peep:getDirector():getGameInstance(),
		map,
		anchor)

	if x and y and z then
		local prop = Common.spawnPropAtPosition(peep, prop, x, y, z, radius)
		if prop then
			prop:getPeep():listen('finalize',
				Common.orientateToAnchor,
				prop:getPeep(),
				map,
				anchor)
		end

		return prop
	else
		Log.warn("Anchor '%s' for map '%s' not found.", anchor, map.name)
		return nil
	end
end

function Common.spawnMapAtAnchor(peep, resource, anchor, args)
	local resourceName
	if type(resource) == 'string' then
		resourceName = resource
	else
		resourceName = resource.name
	end

	local map = Utility.Peep.getMapResource(peep)
	local x, y, z = Utility.Map.getAnchorPosition(
		peep:getDirector():getGameInstance(),
		map,
		anchor)

	if x and y and z then
		return Common.spawnMapAtPosition(peep, resource, x, y, z, args)
	else
		Log.warn("Anchor '%s' for map '%s' not found.", anchor, map.name)
		return nil, nil
	end
end

function Common.spawnMapAtPosition(peep, resource, x, y, z, args)
	local resourceName
	if type(resource) == 'string' then
		resourceName = resource
	else
		resourceName = resource.name
	end

	local map = Utility.Peep.getMapResource(peep)
	local layer, mapScript = Utility.Map.spawnMap(peep, resourceName, Vector(x, y, z), args)

	if mapScript then
		mapScript:listen('finalize', function()
			Utility.Peep.setPosition(mapScript, Vector(x, y, z))
		end)

		return mapScript, layer
	end

	Log.error("Couldn't spawn map '%s'.", resourceName)
	return nil, nil
end

function Common.spawnInstancedMapGroup(playerPeep, groupName)
	local stage = playerPeep:getDirector():getGameInstance():getStage()
	local gameDB = playerPeep:getDirector():getGameDB()

	local instance = Utility.Peep.getInstance(playerPeep)
	local instanceMapGroup = instance:getMapGroup(Utility.Peep.getLayer(playerPeep))
	local layerName = stage:buildLayerNameFromInstanceIDAndFilename(instance:getID(), instance:getFilename())

	local mapResource = Utility.Peep.getMapResource(playerPeep)
	if not mapResource then
		return false
	end

	local mapObjectGroupRecords = gameDB:getRecords("MapObjectGroup", {
		IsInstanced = 1,
		MapObjectGroup = groupName,
		Map = mapResource
	})

	local results = {}
	local namedPeeps = {}
	for _, mapObjectGroup in ipairs(mapObjectGroupRecords) do
		local mapObject = mapObjectGroup:get("MapObject")
		local mapObjectLocation = gameDB:getRecord("MapObjectLocation", {
			Resource = mapObject
		})

		local exists = #playerPeep:getDirector():probe(
			playerPeep:getLayerName(),
			Probe.mapObject(mapObject),
			Probe.instance(Utility.Peep.getPlayerModel(playerPeep))) >= 1

		if mapObjectLocation and not exists then
			local localLayer = math.max(mapObjectLocation:get("Layer"), 1)
			local globalLayer = instance:getGlobalLayerFromLocalLayer(instanceMapGroup, localLayer)
			local actor, prop = stage:instantiateMapObject(
				mapObject,
				globalLayer,
				layerName,
				false,
				playerPeep)

			assert(not (actor and prop), "single map object location spawned both an actor and prop")

			if actor then
				table.insert(results, actor:getPeep())
			end

			if prop then
				table.insert(results, prop:getPeep())
			end

			if actor or prop then
				namedPeeps[mapObjectLocation:get("Name")] = (actor or prop):getPeep()
			end
		end
	end

	return results, namedPeeps
end

function Common.performAction(game, resource, id, scope, ...)
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()
	local foundAction = false
	for action in brochure:findActionsByResource(resource) do
		local definition = brochure:getActionDefinitionFromAction(action)
		if (type(id) == 'number' and action.id.value == id) or
		   (type(id) == 'string' and definition.name:lower() == id:lower())
		then
			local typeName = string.format("Resources.Game.Actions.%s", definition.name)
			local s, r = pcall(require, typeName)
			if not s then
				Log.error("failed to load action %s: %s", typeName, r)
			else
				local ActionType = r
				if ActionType.SCOPES and (ActionType.SCOPES[scope] or not scope) then
					local a = ActionType(game, action)

					local didPerformAction, didFail = a:perform(...)
					if not didPerformAction and not didFail then
						a:fail(...)
						foundAction = false
					else
						foundAction = true
					end
				else
					Log.error(
						"action %s cannot be performed from scope %s (on resource '%s' [%d])",
						typeName,
						scope,
						resource.name,
						resource.id.value)
				end
			end
		end
	end

	return foundAction
end

function Common.getAction(game, action, scope, filter)
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()
	local definition = brochure:getActionDefinitionFromAction(action)
	local typeName = string.format("Resources.Game.Actions.%s", definition.name)
	local s, r = pcall(require, typeName)
	if not s then
		Log.error("failed to load action %s: %s", typeName, r)
	else
		local ActionType = r
		if (ActionType.SCOPES and ActionType.SCOPES[scope]) or not scope then
			local a = ActionType(game, action)
			local t = {
				id = action.id.value,
				type = definition.name,
				verb = a:getVerb() or a:getName()
			}

			if not filter then
				t.instance = ActionType(game, action)
			end

			return t, ActionType
		end
	end
end

function Common.getActionConstraintResource(game, resource, count)
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()
	local resourceType = brochure:getResourceTypeFromResource(resource)

	return {
		type = resourceType.name,
		resource = resource.name,
		name = Common.getName(resource, gameDB) or resource.name,
		description = Common.getDescription(resource, gameDB, nil, 1),
		count = count or 1
	}
end

function Common.getActionConstraints(game, action)
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()

	local result = {}
	do
		result.requirements = {}
		for requirement in brochure:getRequirements(action) do
			local resource = brochure:getConstraintResource(requirement)
			local constraint = Common.getActionConstraintResource(game, resource, requirement.count)

			table.insert(result.requirements, constraint)
		end
	end
	do
		result.inputs = {}
		for input in brochure:getInputs(action) do
			local resource = brochure:getConstraintResource(input)
			local constraint = Common.getActionConstraintResource(game, resource, input.count)

			table.insert(result.inputs, constraint)
		end
	end
	do
		result.outputs = {}
		for output in brochure:getOutputs(action) do
			local resource = brochure:getConstraintResource(output)
			local constraint = Common.getActionConstraintResource(game, resource, output.count)

			table.insert(result.outputs, constraint)
		end
	end

	return result
end

Common.ACTION_CACHE = {}

function Common.getActions(game, resource, scope, filter)
	if not filter then
		local cache = Common.ACTION_CACHE[resource.id.value]
		cache = cache and cache[scope or 'all']
		if cache then
			return cache
		end
	end

	local actions = {}
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()
	for action in brochure:findActionsByResource(resource) do
		local action = Common.getAction(game, action, scope, filter)
		if action then
			table.insert(actions, action)
		end
	end

	if not filter then
		local cache = Common.ACTION_CACHE[resource.id.value] or {}
		cache[scope or 'all'] = actions
		Common.ACTION_CACHE[resource.id.value] = cache
	end

	return actions
end

function Common.getName(resource, gameDB, lang)
	if not resource then
		return nil
	end

	lang = lang or "en-US"

	local nameRecord = gameDB:getRecords("ResourceName", { Resource = resource, Language = lang }, 1)[1]
	if nameRecord then
		return nameRecord:get("Value")
	else
		return false
	end
end

function Common.getDescription(resource, gameDB, lang, index)
	if not resource then
		return nil
	end

	lang = lang or "en-US"

	local descriptionRecord = gameDB:getRecords("ResourceDescription", { Resource = resource, Language = lang })
	if descriptionRecord and #descriptionRecord > 0 then
		return descriptionRecord[math.min(index or 1, #descriptionRecord) or love.math.random(#descriptionRecord)]:get("Value")
	else
		local name = Common.getName(resource, gameDB) or ("*" .. resource.name)
		return string.format("It's %s, as if you didn't know.", name)
	end
end

function Common.guessTier(action, gameDB)
	local brochure = gameDB:getBrochure()
	local tier = 0
	for requirement in brochure:getRequirements(action) do
		local resource = brochure:getConstraintResource(requirement)
		local resourceType = brochure:getResourceTypeFromResource(resource)
		if resourceType.name == "Skill" then
			tier = math.max(Curve.XP_CURVE:getLevel(requirement.count, tier))
		end
	end

	return tier
end

-- These are taken from the GameDB init script.
-- See Resources/Game/DB/Init.lua
local RESOURCE_CURVE = Curve()
function Common.xpForResource(a)
	local point1 = RESOURCE_CURVE(a)
	local point2 = RESOURCE_CURVE(a + 1)
	local xp = point2 - point1

	return math.floor(xp / CurveConfig.SkillXP:evaluate(a) + 0.5)
end

function Common.styleBonusForItem(tier, weight)
	weight = weight or 1
	return math.floor(CurveConfig.StyleBonus:evaluate(tier) * weight)
end

function Common.styleBonusForWeapon(tier, weight)
	weight = weight or 1
	return math.floor(Common.styleBonusForItem(tier + 10) / 3, weight)
end

function Common.strengthBonusForWeapon(tier, weight)
	weight = weight or 1
	return math.floor(CurveConfig.StrengthBonus:evaluate(tier) * weight)
end

return Common
