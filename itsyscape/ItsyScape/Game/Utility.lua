--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility.lua
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
local Color = require "ItsyScape.Graphics.Color"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"
local AggressiveBehavior = require "ItsyScape.Peep.Behaviors.AggressiveBehavior"
local CharacterBehavior = require "ItsyScape.Peep.Behaviors.CharacterBehavior"
local CombatChargeBehavior = require "ItsyScape.Peep.Behaviors.CombatChargeBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local Face3DBehavior = require "ItsyScape.Peep.Behaviors.Face3DBehavior"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"
local InstancedInventoryBehavior = require "ItsyScape.Peep.Behaviors.InstancedInventoryBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
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
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local TeamBehavior = require "ItsyScape.Peep.Behaviors.TeamBehavior"
local TeamsBehavior = require "ItsyScape.Peep.Behaviors.TeamsBehavior"
local TransformBehavior = require "ItsyScape.Peep.Behaviors.TransformBehavior"
local MapPathFinder = require "ItsyScape.World.MapPathFinder"

-- Contains utility methods for a variety of purposes.
--
-- These methods can be used on both the client and server. They should not load
-- any resources.
local Utility = {}

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
function Utility.move(player, path, anchor, raid, e, callback)
	local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
	local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
	local WaitCommand = require "ItsyScape.Peep.WaitCommand"

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

function Utility.save(player, saveLocation, talk, ...)
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

function Utility.moveToAnchor(peep, map, anchor)
	if not peep then
		return nil
	end

	local game = peep:getDirector():getGameInstance()
	local x, y, z, localLayer = Utility.Map.getAnchorPosition(game, map, anchor)
	Utility.Peep.setPosition(peep, Vector(x, y, z))
	Utility.Peep.setLocalLayer(peep, localLayer)

	return peep
end

function Utility.orientateToAnchor(peep, map, anchor)
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

function Utility.spawnActorAtPosition(peep, resource, x, y, z, radius)
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

function Utility.spawnActorAtAnchor(peep, resource, anchor, radius)
	local map = Utility.Peep.getMapResource(peep)
	local x, y, z = Utility.Map.getAnchorPosition(
		peep:getDirector():getGameInstance(),
		map,
		anchor)

	if x and y and z then
		local actor = Utility.spawnActorAtPosition(peep, resource, x, y, z, radius)
		if actor then
			actor:getPeep():listen('finalize',
				Utility.orientateToAnchor,
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

function Utility.spawnInstancedMapObjectAtAnchor(peep, playerPeep, mapObject, anchor, radius)
	local FollowerCortex = require "ItsyScape.Peep.Cortexes.FollowerCortex"

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

	local actor, prop = Utility.spawnMapObjectAtAnchor(peep, mapObject, anchor, radius)
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

function Utility.spawnMapObjectAtPosition(peep, mapObject, x, y, z, radius)
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

function Utility.spawnMapObjectAtAnchor(peep, mapObject, anchor, radius)
	local map = Utility.Peep.getMapResource(peep)
	local x, y, z = Utility.Map.getAnchorPosition(
		peep:getDirector():getGameInstance(),
		map,
		anchor)

	if x and y and z then
		local actor, prop = Utility.spawnMapObjectAtPosition(peep, mapObject, x, y, z, radius)
		do
			if actor then
				actor:getPeep():listen('finalize',
					Utility.orientateToAnchor,
					actor:getPeep(),
					map,
					anchor)
			end

			if prop then
				prop:getPeep():listen('finalize',
					Utility.orientateToAnchor,
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

function Utility.spawnPropAtPosition(peep, prop, x, y, z, radius)
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

function Utility.spawnPropAtAnchor(peep, prop, anchor, radius)
	local map = Utility.Peep.getMapResource(peep)
	local x, y, z = Utility.Map.getAnchorPosition(
		peep:getDirector():getGameInstance(),
		map,
		anchor)

	if x and y and z then
		local prop = Utility.spawnPropAtPosition(peep, prop, x, y, z, radius)
		if prop then
			prop:getPeep():listen('finalize',
				Utility.orientateToAnchor,
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

function Utility.spawnMapAtAnchor(peep, resource, anchor, args)
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
		return Utility.spawnMapAtPosition(peep, resource, x, y, z, args)
	else
		Log.warn("Anchor '%s' for map '%s' not found.", anchor, map.name)
		return nil, nil
	end
end

function Utility.spawnMapAtPosition(peep, resource, x, y, z, args)
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

function Utility.spawnInstancedMapGroup(playerPeep, groupName)
	local Probe = require "ItsyScape.Peep.Probe"

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

function Utility.performAction(game, resource, id, scope, ...)
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

function Utility.getAction(game, action, scope, filter)
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

function Utility.getActionConstraintResource(game, resource, count)
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()
	local resourceType = brochure:getResourceTypeFromResource(resource)

	return {
		type = resourceType.name,
		resource = resource.name,
		name = Utility.getName(resource, gameDB) or resource.name,
		description = Utility.getDescription(resource, gameDB, nil, 1),
		count = count or 1
	}
end

function Utility.getActionConstraints(game, action)
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()

	local result = {}
	do
		result.requirements = {}
		for requirement in brochure:getRequirements(action) do
			local resource = brochure:getConstraintResource(requirement)
			local constraint = Utility.getActionConstraintResource(game, resource, requirement.count)

			table.insert(result.requirements, constraint)
		end
	end
	do
		result.inputs = {}
		for input in brochure:getInputs(action) do
			local resource = brochure:getConstraintResource(input)
			local constraint = Utility.getActionConstraintResource(game, resource, input.count)

			table.insert(result.inputs, constraint)
		end
	end
	do
		result.outputs = {}
		for output in brochure:getOutputs(action) do
			local resource = brochure:getConstraintResource(output)
			local constraint = Utility.getActionConstraintResource(game, resource, output.count)

			table.insert(result.outputs, constraint)
		end
	end

	return result
end

Utility.ACTION_CACHE = {}

function Utility.getActions(game, resource, scope, filter)
	if not filter then
		local cache = Utility.ACTION_CACHE[resource.id.value]
		cache = cache and cache[scope or 'all']
		if cache then
			return cache
		end
	end

	local actions = {}
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()
	for action in brochure:findActionsByResource(resource) do
		local action = Utility.getAction(game, action, scope, filter)
		if action then
			table.insert(actions, action)
		end
	end

	if not filter then
		local cache = Utility.ACTION_CACHE[resource.id.value] or {}
		cache[scope or 'all'] = actions
		Utility.ACTION_CACHE[resource.id.value] = cache
	end

	return actions
end

function Utility.getName(resource, gameDB, lang)
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

function Utility.getDescription(resource, gameDB, lang, index)
	if not resource then
		return nil
	end

	lang = lang or "en-US"

	local descriptionRecord = gameDB:getRecords("ResourceDescription", { Resource = resource, Language = lang })
	if descriptionRecord and #descriptionRecord > 0 then
		return descriptionRecord[math.min(index or 1, #descriptionRecord) or love.math.random(#descriptionRecord)]:get("Value")
	else
		local name = Utility.getName(resource, gameDB) or ("*" .. resource.name)
		return string.format("It's %s, as if you didn't know.", name)
	end
end

function Utility.guessTier(action, gameDB)
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
function Utility.xpForResource(a)
	local point1 = RESOURCE_CURVE(a)
	local point2 = RESOURCE_CURVE(a + 1)
	local xp = point2 - point1

	return math.floor(xp / CurveConfig.SkillXP:evaluate(a) + 0.5)
end

function Utility.styleBonusForItem(tier, weight)
	weight = weight or 1
	return math.floor(CurveConfig.StyleBonus:evaluate(tier) * weight)
end

function Utility.styleBonusForWeapon(tier, weight)
	weight = weight or 1
	return math.floor(Utility.styleBonusForItem(tier + 10) / 3, weight)
end

function Utility.strengthBonusForWeapon(tier, weight)
	weight = weight or 1
	return math.floor(CurveConfig.StrengthBonus:evaluate(tier) * weight)
end

Utility.Magic = {}
function Utility.Magic.newSpell(id, game)
	local TypeName = string.format("Resources.Game.Spells.%s.Spell", id)
	local Type = require(TypeName)

	return Type(id, game)
end

-- Contains time management.
Utility.Time = {}
Utility.Time.DAY = 24 * 60 * 60
Utility.Time.BIRTHDAY_INFO = {
	year = 2018,
	month = 3,
	day = 23,
}
Utility.Time.INGAME_BIRTHDAY_INFO = {
	year = 1000,
	month = 1,
	day = 1
}
Utility.Time.INGAME_RITUAL_INFO = {
	year = 1,
	month = 2,
	day = 25,
	dayOfWeek = 2,
}
Utility.Time.BIRTHDAY_TIME = os.time(Utility.Time.BIRTHDAY_INFO)

Utility.Time.DAYS = {
	"Featherday", -- Sunday
	"Myreday",    -- Monday
	"Theoday",    -- Tuesday
	"Brakday" ,   -- Wednesday
	"Takday",     -- Thursday
	"Enderday",   -- Friday,
	"Yenderday"   -- Saturday
}

Utility.Time.AGE_BEFORE_RITUAL = "Age of Gods"
Utility.Time.AGE_AFTER_RITUAL  = "Age of Humanity"

Utility.Time.SHORT_AGE = {
	[Utility.Time.AGE_BEFORE_RITUAL] = "A.G.",
	[Utility.Time.AGE_AFTER_RITUAL]  = "A.H."
}

Utility.Time.MONTHS = {
	"Fallsun",
	"Emptorius",
	"Longnights",
	"Basturian",
	"Godsun",
	"Yohnus",
	"Emberdawn",
	"Prisius",
	"Linshine",
	"Chillbreak",
	"Fogsden",
	"Darksere",
	"Yendermonth"
}

Utility.Time.DAYS_IN_INGAME_MONTH = {
	30,
	25,
	31,
	28,
	29,
	31,
	29,
	30,
	29,
	29,
	28,
	31,
	27
}

Utility.Time.NUM_DAYS_PER_INGAME_YEAR = 377

function Utility.Time._getIngameYearMonthDay(days)
	local daysSinceRitualYear = Utility.Time.INGAME_BIRTHDAY_INFO.year * Utility.Time.NUM_DAYS_PER_INGAME_YEAR + days
	local year = math.floor(daysSinceRitualYear / Utility.Time.NUM_DAYS_PER_INGAME_YEAR)

	local day = daysSinceRitualYear - (math.floor(daysSinceRitualYear / Utility.Time.NUM_DAYS_PER_INGAME_YEAR) * Utility.Time.NUM_DAYS_PER_INGAME_YEAR) + 1
	local dayOfWeek = daysSinceRitualYear % #Utility.Time.DAYS + 1

	local month
	do
		local d = 0
		for i, daysInMonth in ipairs(Utility.Time.DAYS_IN_INGAME_MONTH) do
			if day <= d + daysInMonth then
				month = i
				break
			else
				d = d + daysInMonth
			end
		end

		day = day - d
	end

	local age
	if year <= 0 then
		year = math.abs(year) + 1
		age = Utility.Time.AGE_BEFORE_RITUAL
	else
		age = Utility.Time.AGE_AFTER_RITUAL
	end

	return {
		year = year,
		month = month,
		day = day,
		age = age,
		dayOfWeek = dayOfWeek,
		dayOfWeekName = Utility.Time.DAYS[dayOfWeek],
		monthName = Utility.Time.MONTHS[month]
	}
end

function Utility.Time.getIngameYearMonthDay(currentTime)
	local days = Utility.Time.getDays(currentTime)
	return Utility.Time._getIngameYearMonthDay(days)
end

function Utility.Time.toCurrentTime(year, month, day)
	year = year or 1
	month = month or 1
	day = day or 1

	local yearDifference = year - Utility.Time.INGAME_BIRTHDAY_INFO.year
	local offsetDays = math.abs(yearDifference) * Utility.Time.NUM_DAYS_PER_INGAME_YEAR + (day - 1)

	for i = 1, month - 1 do
		offsetDays = offsetDays + Utility.Time.DAYS_IN_INGAME_MONTH[i]
	end

	offsetDays = offsetDays * math.sign(yearDifference)

	local offsetTime = offsetDays * Utility.Time.DAY
	local currentTime = Utility.Time.BIRTHDAY_TIME + offsetTime
	return currentTime
end

-- Applies years, then months, then days.
-- Does not handle fractional years/month/days.
function Utility.Time.offsetIngameTime(currentTime, dayOffset, monthOffset, yearOffset)
	yearOffset = math.floor(yearOffset or 0)
	monthOffset = math.floor(monthOffset or 0)
	dayOffset = math.floor(dayOffset or 0)

	local yearMonthDay = Utility.Time.getIngameYearMonthDay(currentTime)

	if yearMonthDay.age == Utility.AGE_BEFORE_RITUAL then
		yearMonthDay.year = -(yearMonthDay.year - 1)
	end

	yearMonthDay.year = yearMonthDay.year + yearOffset + math.floor(monthOffset / #Utility.Time.MONTHS) + math.floor(dayOffset / Utility.Time.NUM_DAYS_PER_INGAME_YEAR)

	local remainderMonths = math.sign(monthOffset) * (math.abs(monthOffset) % #Utility.Time.MONTHS)
	if monthOffset < 0 then
		if math.abs(remainderMonths) >= year.month then
			year = year - 1

			yearMonthDay.month = year.month - remainderMonths + #Utility.Time.MONTHS
		else
			yearMonthDay.month = yearMonthDay + remainderMonths
		end
	elseif monthOffset > 0 then
		yearMonthDay.month = yearMonthDay.month + remainderMonths
		if yearMonthDay.month >= #Utility.Time.MONTHS then
			yearMonthDay.month = yearMonthDay.month - #Utility.Time.MONTHS
			year = year + 1
		end
	end

	yearMonthDay.day = yearMonthDay.day + math.sign(dayOffset) * math.abs(dayOffset) % Utility.Time.NUM_DAYS_PER_INGAME_YEAR
	while yearMonthDay.day > Utility.Time.DAYS_IN_INGAME_MONTH[yearMonthDay.month] or yearMonthDay.day <= 0 do
		if yearMonthDay.day <= 0 then
			yearMonthDay.day = yearMonthDay + Utility.Time.DAYS_IN_INGAME_MONTH[yearMonthDay.month]

			yearMonthDay.month = yearMonthDay.month - 1
			if yearMonthDay.month <= 0 then
				yearMonthDay.month = #Utility.Time.MONTHS
				yearMonthDay.year = yearMonthDay.year - 1
			end
		else
			yearMonthDay.day = yearMonthDay.day - Utility.Time.DAYS_IN_INGAME_MONTH[yearMonthDay.month]

			yearMonthDay.month = yearMonthDay.month + 1
			if yearMonthDay.month > #Utility.Time.MONTHS then
				yearMonthDay.month = 1
				yearMonthDay.year = yearMonthDay.year + 1
			end
		end
	end

	do
		local daysSinceRitualYear = Utility.Time.NUM_DAYS_PER_INGAME_YEAR * yearMonthDay.year + yearMonthDay.day
		for i = 1, yearMonthDay.month - 1 do
			daysSinceRitualYear = daysSinceRitualYear + Utility.Time.DAYS_IN_INGAME_MONTH[i]
		end

		yearMonthDay.dayOfWeek = daysSinceRitualYear % #Utility.Time.DAYS + 1
		yearMonthDay.dayOfWeekName = Utility.Time.DAYS[yearMonthDay.dayOfWeek]
	end

	if yearMonthDay.year <= 0 then
		yearMonthDay.year = math.abs(yearMonthDay.year) + 1
		yearMonthDay.age = Utility.Time.AGE_BEFORE_RITUAL
	else
		yearMonthDay.age = Utility.Time.AGE_AFTER_RITUAL
	end

	yearMonthDay.monthName = Utility.Time.MONTHS[yearMonthDay.month]

	return yearMonthDay
end

function Utility.Time.getAndUpdateAdventureStartTime(root)
	local clockStorage = root:getSection("Clock")
	if not clockStorage:hasValue("start") then
		clockStorage:set("start", Utility.Time.BIRTHDAY_TIME)
	end

	return clockStorage:get("start")
end

function Utility.Time.getDays(currentTime, referenceTime)
	referenceTime = referenceTime or Utility.Time.BIRTHDAY_TIME
	currentTime = currentTime or os.time()

	return math.floor(os.difftime(currentTime, referenceTime) / Utility.Time.DAY)
end

function Utility.Time.getSeconds(root)
	return root:getSection("Clock"):get("seconds") or 0
end

function Utility.Time.getAndUpdateTime(root)
	local currentOffset = root:getSection("Clock"):get("offset") or 0
	local currentGameTime = root:getSection("Clock"):get("time") or os.time()
	local currentTime = os.time()

	if currentTime >= currentGameTime then
		root:getSection("clock"):set("time", currentTime)
	end

	return currentTime + currentOffset
end

function Utility.Time.updateTime(root, days, seconds)
	local currentOffset = root:getSection("Clock"):get("offset") or 0
	local futureOffset = currentOffset + Utility.Time.DAY * (days or 1) + (seconds or 0)
	root:getSection("Clock"):set("offset", futureOffset)

	if seconds then
		local currentSeconds = root:getSection("Clock"):get("seconds") or 0
		root:getSection("Clock"):set("seconds", currentSeconds + seconds)
	end

	return Utility.Time.getAndUpdateTime(root)
end

-- Contains utility methods that deal with combat.
Utility.Combat = {}

Utility.Combat.DEFAULT_STRAFE_ROTATIONS = {
	Quaternion.Y_90,
	Quaternion.Y_270
}

function Utility.Combat.disengage(peep)
	local CombatCortex = require "ItsyScape.Peep.Cortexes.CombatCortex2"

	local charge = peep:getBehavior(CombatChargeBehavior)
	if charge then
		Utility.Peep.cancelWalk(charge.currentWalkID)

		peep:removeBehavior(CombatChargeBehavior)
		peep:removeBehavior(TargetTileBehavior)
	end

	peep:getCommandQueue(CombatCortex.QUEUE):interrupt()
	peep:removeBehavior(CombatTargetBehavior)

	local aggressive = peep:getBehavior(AggressiveBehavior)
	if aggressive then
		aggressive.pendingTarget = false
		aggressive.pendingResponseTime = 0
	end
end

function Utility.Combat.strafe(peep, target, distance, rotations, onStrafe)
	if not target then
		local possibleTarget = peep:getBehavior(CombatTargetBehavior)
		if not (possibleTarget and possibleTarget.actor and possibleTarget.actor:getPeep()) then
			return false
		end
		target = possibleTarget.actor:getPeep()
	end

	rotations = rotations or Utility.Combat.DEFAULT_STRAFE_ROTATIONS
	local rotation = rotations[love.math.random(#rotations)]

	local peepPosition = Utility.Peep.getPosition(peep) * Vector.PLANE_XZ
	local direction
	if Class.isCompatibleType(target, Vector) then
		direction = rotation:transformVector(target):getNormal()
	else
		local targetPosition = Utility.Peep.getPosition(target) * Vector.PLANE_XZ
		direction = rotation:transformVector(peepPosition:direction(targetPosition)):getNormal()
	end

	local position = peepPosition + direction * distance
	local k = Utility.Peep.getLayer(peep)

	local callback, n = Utility.Peep.queueWalk(peep, position.x, position.z, k, math.huge, { asCloseAsPossible = true, isPosition = true })
	callback:register(function(s)
		if onStrafe then
			onStrafe(peep, target, s)
		end
	end)

	return true, n
end

function Utility.Combat.deflectPendingPower(power, activator, target)
	local ZealPoke = require "ItsyScape.Game.ZealPoke"

	if target and target:hasBehavior(PendingPowerBehavior) then
		local pendingPower = target:getBehavior(PendingPowerBehavior)
		if pendingPower.power then
			local pendingPowerID = pendingPower.power:getResource().name

			Log.info("%s (activated by '%s') negated pending power '%s' on target '%s'.",
				power:getResource().name,
				activator:getName(),
				pendingPowerID,
				target:getName())

			local rechargeCost = pendingPower.power:getCost(target)
			local _, recharge = target:addBehavior(PowerRechargeBehavior)
			recharge.powers[pendingPowerID] = math.max(recharge.powers[pendingPowerID] or 0, rechargeCost)

			target:poke("zeal", ZealPoke.onLosePower({
				power = pendingPower.power,
				zeal = -rechargeCost
			}))

			target:poke("powerDeflected", {
				activator = activator,
				power = pendingPower.power,
				action = pendingPower.power:getAction()
			})

			target:removeBehavior(PendingPowerBehavior)

			return pendingPower.power
		end
	end
end

function Utility.Combat.getCombatLevel(peep)
	local stats = peep:getBehavior(StatsBehavior)
	if stats and stats.stats then
		local constitution, faith
		do
			local status = peep:getBehavior(CombatStatusBehavior)
			if status then
				constitution = status.maximumHitpoints
				faith = status.maximumPrayer
			else
				constitution = 1
				faith = 1
			end
		end

		stats = stats.stats
		local base = (
			stats:getSkill("Defense"):getBaseLevel() +
			math.max(stats:getSkill("Constitution"):getBaseLevel(), constitution) +
			math.floor(math.max(stats:getSkill("Faith"):getBaseLevel(), faith) / 2 + 0.5)) / 2
		local melee = (stats:getSkill("Attack"):getBaseLevel() + stats:getSkill("Strength"):getBaseLevel()) / 2
		local magic = (stats:getSkill("Magic"):getBaseLevel() + stats:getSkill("Wisdom"):getBaseLevel()) / 2
		local ranged = (stats:getSkill("Archery"):getBaseLevel() + stats:getSkill("Dexterity"):getBaseLevel()) / 2
		return math.floor(base + math.max(melee, magic, ranged) + 0.5)
	end

	return 0
end

function Utility.Combat.getCombatXP(peep)
	local stats = peep:getBehavior(StatsBehavior)
	do
		stats = stats and stats.stats
		if not stats then
			return 0
		end
	end

	local hitpoints
	do
		local status = peep:getBehavior(CombatStatusBehavior)
		hitpoints = status and status.maximumHitpoints
		if not hitpoints then
			return 0
		end

		hitpoints = math.min(hitpoints, 100000)
	end

	local tier
	do
		local melee = (stats:getSkill("Attack"):getWorkingLevel() + stats:getSkill("Strength"):getWorkingLevel()) / 2
		local magic = (stats:getSkill("Magic"):getWorkingLevel() + stats:getSkill("Wisdom"):getWorkingLevel()) / 2
		local ranged = (stats:getSkill("Archery"):getWorkingLevel() + stats:getSkill("Dexterity"):getWorkingLevel()) / 2

		tier = math.max(melee, magic, ranged)
		tier = math.min(tier, 100)
	end

	local xpForTier
	do
		local point1 = RESOURCE_CURVE(tier)
		local point2 = RESOURCE_CURVE(tier + 1)
		xpForTier = point2 - point1
	end

	local xpFromTier
	do
		local tierDivisor = CurveConfig.CombatXP:evaluate(tier)
		tierDivisor = math.max(tierDivisor, CurveConfig.CombatXP.C)

		xpFromTier = math.floor(xpForTier / tierDivisor)
	end

	local xpFromHitpoints = CurveConfig.HealthXP:evaluate(hitpoints)

	local totalXP = xpFromTier + xpFromHitpoints
	return totalXP, xpFromTier, xpFromHitpoints
end

function Utility.Combat.giveCombatXP(peep, xp)
	local Equipment = require "ItsyScape.Game.Equipment"
	local Weapon = require "ItsyScape.Game.Weapon"
	local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

	local stance = peep:getBehavior(StanceBehavior)
	if not stance then
		return
	else
		stance = stance.stance
	end

	local weapon = Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_RIGHT_HAND) or
		Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_TWO_HANDED)

	local strength, accuracy
	if weapon then
		local logic = peep:getDirector():getItemManager():getLogic(weapon:getID())
		if logic:isCompatibleType(Weapon) then
			local _, s, a = logic:getSkill(Weapon.PURPOSE_KILL)
			strength = s
			accuracy = a
		end
	end

	if not strength or not accuracy then
		strength = "Strength"
		accuracy = "Attack"
	end

	if stance == Weapon.STANCE_AGGRESSIVE then
		peep:getState():give("Skill", strength, math.floor(xp + 0.5))
	elseif stance == Weapon.STANCE_CONTROLLED then
		peep:getState():give("Skill", accuracy, math.floor(xp + 0.5))
	elseif stance == Weapon.STANCE_DEFENSIVE then
		peep:getState():give("Skill", "Defense", math.floor(xp + 0.5))
	end

	peep:getState():give("Skill", "Constitution", math.floor(xp / 3 + 0.5))
end

-- Calculates the maximum hit given the level (including boosts), multiplier,
-- and equipment strength bonus.
function Utility.Combat.calcMaxHit(level, multiplier, bonus)
	return math.max(math.floor(0.5 + level * multiplier * (bonus + 64) / 640), 1)
end

function Utility.Combat.calcAccuracyRoll(level, bonus)
	return (level + 16) * (bonus + 64) * 4
end

function Utility.Combat.calcDefenseRoll(level, bonus)
	return (level + 8) * (bonus + 128)
end

function Utility.Combat.calcBoost(level, minLevel, maxLevel, minBoost, maxBoost)
	local delta = math.min((math.max(level, minLevel) - minLevel) / (maxLevel - minLevel), 1)
	return minBoost + (maxBoost - minBoost) * delta
end

-- Contains utility methods to deal with text.
Utility.Text = {}

Utility.Text.PRONOUN_SUBJECT    = GenderBehavior.PRONOUN_SUBJECT
Utility.Text.PRONOUN_OBJECT     = GenderBehavior.PRONOUN_OBJECT
Utility.Text.PRONOUN_POSSESSIVE = GenderBehavior.PRONOUN_POSSESSIVE
Utility.Text.FORMAL_ADDRESS     = GenderBehavior.FORMAL_ADDRESS

Utility.Text.NAMED_PRONOUN = {
	subject = Utility.Text.PRONOUN_SUBJECT,
	object = Utility.Text.PRONOUN_OBJECT,
	possessive = Utility.Text.PRONOUN_POSSESSIVE,
	formal = Utility.Text.FORMAL_ADDRESS,
}

Utility.Text.DEFAULT_PRONOUNS = {
	["en-US"] = {
		["x"] = {
			"they",
			"them",
			"their",
			"patrician"
		},
		["male"] = {
			"he",
			"him",
			"his",
			"ser"
		},
		["female"] = {
			"she",
			"her",
			"her",
			"misse"
		},
	}
}
Utility.Text.BE = {
	[true] = { present = 'are', past = 'were', future = 'will be' },
	[false] = { present = 'is', past = 'was', future = 'will be' }
}

function Utility.Text._find(text, pattern, offset)
	local i, j = text:sub(offset):find(pattern)
	if i and j then
		return i + offset - 1, j + offset - 1
	end

	return nil, nil
end

function Utility.Text.parse(text, rootTag)
	local _find = Utility.Text._find

	local rootElement = {
		tag = rootTag,
		attributes = {},
		children = {}
	}

	local elementStack = { rootElement }

	local previousI = 1
	local i, j = 0
	repeat
		i, j = text:find("</?([%w_-][%w%d_-]*)", previousI)

		if i and j then
			if i > previousI then
				local fragment = text:sub(previousI, i - 1)

				table.insert(elementStack[#elementStack].children, fragment)
			end

			local elementTag = text:sub(i + 1, j)

			if elementTag:sub(1, 1) == "/" then
				elementTag = elementTag:sub(2)

				local element = elementStack[#elementStack]
				if element.tag ~= elementTag then
					error(string.format("expected ending element tag '%s', got '%s'", element.tag, elementTag))
				end

				local endTagBracket = text:sub(j + 1, j + 1)
				if endTagBracket ~= ">" then
					error(string.format("expected '>' to end element tag '%s', got '%s'", elementTag, endTagBracket))
				end

				table.remove(elementStack, #elementStack)
			else
				local element = { attributes = {}, children = {}, tag = elementTag }

				if #elementStack >= 1 then
					local parent = elementStack[#elementStack]

					element.parent = parent
					table.insert(parent.children, element)
				end

				table.insert(elementStack, element)
			end

			local attributeJ, attributeI = j
			repeat
				local endTagI, endTagJ = _find(text, "^%s*/?>\n?", attributeJ + 1)
				attributeI, attributeJ = _find(text, "^%s+([%w_-][%w%d_-]*)", attributeJ + 1)

				if attributeI and attributeJ then
					local attribute = text:sub(attributeI + 1, attributeJ)
					local typeName = text:sub(attributeJ + 1):match("^:(%w+)=")

					local value
					do
						local valueStart = attributeJ + #(typeName or "") + (typeName and 2 or 1)
						if text:sub(valueStart, valueStart) ~= "=" then
							value = true
							typeName = typeName or "boolean"
						else
							local valueI, valueJ = _find(text, "^=\'[^\']+\'", valueStart)
							if valueI and valueJ then
								while text:sub(valueJ - 1, valueJ - 1) == "\\" do
									local _
									_, valueJ = _find(text, "^[^\']+\'", valueJ + 1)

									if not valueJ then
										error(string.format("value for attribute '%s' in element tag '%s' unterminated", attribute, elementStack[#elementStack].tag))
									else
										valueJ = valueJ + 1
									end
								end

								value = text:sub(valueI + 2, valueJ - 1):gsub("\\\'", "\'")

								attributeJ = valueJ
								j = valueJ
							else
								error(string.format("attribute '%s' in element tag '%s' malformed", attribute, elementStack[#elementStack].tag))
							end
						end
					end

					if value ~= nil then
						if typeName then
							if typeName == "number" then
								value = tonumber(value) or nil
							elseif typeName == "string" then
								value = tostring(value)
							elseif typeName == "boolean" then
								if type(value) == "string" then
									if value:lower() == "true" then
										value = true
									elseif value:lower() == "false" then
										value = false
									end
								else
									value = not not value
								end
							end
						else
							value = tonumber(value) or value
							typeName = type(value)
						end

						local element = elementStack[#elementStack]
						if element.attributes[attribute] ~= nil then
							error(string.format("duplicate attribute '%s' in element tag '%s'", attribute, element.tag))
						else
							element.attributes[attribute] = { value = value, type = typeName or "?" }
						end
					end
				elseif endTagI and endTagJ then
					if text:sub(endTagI, endTagJ):match("^%s/>") then
						table.remove(elementStack, #elementStack)
					end

					j = endTagJ + 1
					break
				else
					error(string.format("element tag '%s' unterminated", elementStack[#elementStack].tag))
				end
			until not attributeI

			previousI = j
		end
	until not i

	if previousI and previousI + 1 < #text then
		table.insert(rootElement.children, text:sub(previousI + 1))
	end

	if #elementStack > 1 then
		error(string.format("unmatched element tag '%s'", elementStack[#elementStack].tag))
	end

	return rootElement
end

Utility.Text.TIME_FORMAT = {
	year = function(yearMonthDay)
		return tostring(yearMonthDay.year)
	end,

	yearOptionalShortAge = function(yearMonthDay)
		if yearMonthDay.age ~= Utility.Time.AGE_AFTER_RITUAL then
			return string.format("%d %s", yearMonthDay.year, Utility.Time.SHORT_AGE[yearMonthDay.age])
		else
			return tostring(yearMonthDay.year)
		end
	end,

	yearOptionalLongAge = function(yearMonthDay)
		if yearMonthDay.age ~= Utility.Time.AGE_AFTER_RITUAL then
			return string.format("%d %s", yearMonthDay.year, yearMonthDay.age)
		else
			return tostring(yearMonthDay.year)
		end
	end,

	age = function(yearMonthDay)
		return Utility.Time.SHORT_AGE[yearMonthDay.age]
	end,

	longAge = function(yearMonthDay)
		return yearMonthDay.age
	end,

	day = function(yearMonthDay)
		return yearMonthDay.day
	end,

	dayWithSpacePadding = function(yearMonthDay)
		return string.format("% 2d", yearMonthDay.day)
	end,

	dayWithNumberPadding = function(yearMonthDay)
		return string.format("%02d", yearMonthDay.day)
	end,

	dayOfWeek = function(yearMonthDay)
		return yearMonthDay.dayOfWeek
	end,

	dayOfWeekName = function(yearMonthDay)
		return yearMonthDay.dayOfWeekName
	end,

	month = function(yearMonthDay)
		return yearMonthDay.month
	end,

	monthName = function(yearMonthDay)
		return Utility.Time.MONTHS[yearMonthDay.month]
	end
}

Utility.Text.Dialog = {}

local function _listToFlags(dialog, list)
	if type(list) ~= "table" then
		return {}
	end

	local flags = {}
	for k, v in list:values() do
		local flag = v:getValueName():gsub("_", "-")
		flags[flag] = true
	end

	return flags
end

function Utility.Text.Dialog.ir_state_has(dialog, characterName, resourceType, resource, count, flags)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	return peep:getState():has(resourceType, resource, count, _listToFlags(dialog, flags))
end

function Utility.Text.Dialog.ir_state_count(dialog, characterName, resourceType, resource, flags)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	return peep:getState():count(resourceType, resource, _listToFlags(dialog, flags))
end

function Utility.Text.Dialog.ir_state_give(dialog, characterName, resourceType, resource, count, flags)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	return peep:getState():give(resourceType, resource, count, _listToFlags(dialog, flags))
end

function Utility.Text.Dialog.ir_state_take(dialog, characterName, resourceType, resource, count, flags)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	return peep:getState():take(resourceType, resource, count, _listToFlags(dialog, flags))
end

function Utility.Text.Dialog.ir_has_started_quest(dialog, characterName, questName)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	return Utility.Quest.didStart(questName, peep)
end

function Utility.Text.Dialog.ir_is_next_quest_step(dialog, characterName, questName, keyItemID)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	return Utility.Quest.isNextStep(questName, keyItemID, peep)
end

function Utility.Text.Dialog.ir_get_pronoun(dialog, characterName, pronounType, upperCase)
	local index = Utility.Text.NAMED_PRONOUN[pronounType]
	local default = Utility.Text.DEFAULT_PRONOUNS["en-US"]["x"][index] or ""

	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return default
	end

	return Utility.Text.getPronoun(peep, index, "en-US", upperCase)
end

function Utility.Text.Dialog.ir_is_pronoun_plural(dialog, characterName)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return true
	end

	local gender = peep:getBehavior(GenderBehavior)
	if gender then
		return gender.pronounsPlural
	end

	return true
end

function Utility.Text.Dialog.ir_get_pronoun_lowercase(dialog, characterName, pronounType)
	return Utility.Text.Dialog.ir_get_pronoun(dialog, characterName, pronounType, false)
end

function Utility.Text.Dialog.ir_get_pronoun_uppercase(dialog, characterName, pronounType)
	return Utility.Text.Dialog.ir_get_pronoun(dialog, characterName, pronounType, true)
end

function Utility.Text.Dialog.ir_get_english_be(dialog, characterName, tense, upperCase)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return Utility.Text.BE[true][tense] or ""
	end

	return Utility.Text.getEnglishBe(peep, tense, upperCase)
end

function Utility.Text.Dialog.ir_get_english_be_lowercase(dialog, characterName, tense)
	return Utility.Text.Dialog.ir_get_english_be(dialog, characterName, tense, false)
end

function Utility.Text.Dialog.ir_get_english_be_uppercase(dialog, characterName, tense)
	return Utility.Text.Dialog.ir_get_english_be(dialog, characterName, tense, true)
end

function Utility.Text.Dialog.ir_get_relative_date_from_start(dialog, dayOffset, monthOffset, yearOffset, format)
	local rootStorage = peep:getDirector():getPlayerStorage(peep):getRoot()
	local startTime = Utility.Time.getAndUpdateAdventureStartTime(rootStorage)
	return Utility.Text.Dialog.ir_get_relative_date_from_time(dialog, dayOffset, monthOffset, yearOffset, format, startTime)
end

function Utility.Text.Dialog.ir_get_relative_date_from_now(dialog, dayOffset, monthOffset, yearOffset, format)
	local rootStorage = peep:getDirector():getPlayerStorage(peep):getRoot()
	local currentTime = Utility.Time.getAndUpdateTime(rootStorage)
	return Utility.Text.Dialog.ir_get_relative_date_from_time(dialog, dayOffset, monthOffset, yearOffset, format, currentTime)
end

function Utility.Text.Dialog.ir_get_relative_date_from_birthday(dialog, dayOffset, monthOffset, yearOffset, format)
	local currentTime = Utility.Time.BIRTHDAY_TIME
	return Utility.Text.Dialog.ir_get_relative_date_from_time(dialog, dayOffset, monthOffset, yearOffset, format, currentTime)
end

function Utility.Text.Dialog.ir_get_relative_date_from_time(dialog, dayOffset, monthOffset, yearOffset, format, currentTime)
	local yearMonthDay = Utility.Time.offsetIngameTime(currentTime or Utility.Time.BIRTHDAY_TIME, dayOffset, monthOffset, yearOffset)
	local newTime = Utility.Time.toCurrentTime(yearMonthDay.year, yearMonthDay.month, yearMonthDay.day)

	return Utility.Text.Dialog.ir_format_date(dialog, format, newTime)
end

function Utility.Text.Dialog.ir_format_date(dialog, format, currentTime)
	local format = format or "%monthName %day, %yearOptionalShortAge"
	local yearMonthDay = Utility.Time.getIngameYearMonthDay(currentTime or Utility.Time.BIRTHDAY_TIME)

	return format:gsub("%%(%w+)", function(key)
		local func = Utility.Text.TIME_FORMAT[key]
		if not func then
			error(string.format("time format specifier '%s' not valid", key))
		end

		return func(yearMonthDay)
	end)
end

function Utility.Text.Dialog.ir_get_start_time(dialog)
	local rootStorage = peep:getDirector():getPlayerStorage(peep):getRoot()
	return Utility.Time.getAndUpdateAdventureStartTime(rootStorage)
end

function Utility.Text.Dialog.ir_get_current_time(dialog)
	local rootStorage = peep:getDirector():getPlayerStorage(peep):getRoot()
	return Utility.Time.getAndUpdateTime(rootStorage)
end

function Utility.Text.Dialog.ir_get_birthday_time(dialog)
	return Utility.Time.BIRTHDAY_TIME
end

function Utility.Text.Dialog.ir_get_date_component(dialog, currentTime, component)
	return Utility.Time.getIngameYearMonthDay(currentTime)[component]
end

function Utility.Text.Dialog.ir_to_current_time(dialog, year, month, day)
	return Utility.Time.toCurrentTime(year, month, day)
end

function Utility.Text.Dialog.ir_offset_current_time(dialog, currentTime, dayOffset, monthOffset, yearOffset)
	local yearMonthDay = Utility.Time.offsetIngameTime(currentTime, dayOffset, monthOffset, yearOffset)
	return Utility.Time.toCurrentTime(yearMonthDay.year, yearMonthDay.month, yearMonthDay.day)
end

function Utility.Text.Dialog.ir_get_num_days_in_month(dialog, month)
	return Utility.Time.DAYS_IN_INGAME_MONTH[month]
end

function Utility.Text.Dialog.ir_get_month_name(dialog, month)
	return Utility.Time.MONTHS[month]
end

function Utility.Text.Dialog.ir_get_day_name(dialog, day)
	return Utility.Time.DAYS[day]
end

function Utility.Text.Dialog.ir_yell(dialog, message)
	return message:upper()
end

function Utility.Text.Dialog.ir_get_infinite()
	return math.huge
end

function Utility.Text.Dialog.ir_play_animation(dialog, characterName, animationSlot, animationPriority, animationName, animationForced, animationTime)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	local actor = peep:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor
	if not actor then
		return false
	end

	local filename = string.format("Resources/Game/Animations/%s/Script.lua", animationName)
	if not love.filesystem.getInfo(filename) then
		return false
	end

	actor:playAnimation(
		animationSlot,
		animationPriority,
		CacheRef("ItsyScape.Graphics.AnimationResource", filename),
		animationForced,
		animationTime)

	return true
end

function Utility.Text.Dialog.ir_poke_map(dialog, characterName, pokeName)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	local mapScript = Utility.Peep.getMapScript(peep)
	if not mapScript then
		return false
	end

	mapScript:poke(pokeName, dialog:getSpeaker("_TARGET"), peep)
end

function Utility.Text.Dialog.ir_push_poke_map(dialog, characterName, pokeName, time)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	local mapScript = Utility.Peep.getMapScript(peep)
	if not mapScript then
		return false
	end

	mapScript:pushPoke(time, pokeName, dialog:getSpeaker("_TARGET"), peep)
end

function Utility.Text.Dialog.ir_poke_peep(dialog, characterName, pokeName)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	if characterName == "_TARGET" then
		peep:poke(pokeName)
	else
		peep:poke(pokeName, dialog:getSpeaker("_TARGET"))
	end
end

function Utility.Text.Dialog.ir_push_poke_peep(dialog, characterName, pokeName, time)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	if characterName == "_TARGET" then
		peep:pushPoke(time, pokeName)
	else
		peep:pushPoke(time, pokeName, dialog:getSpeaker("_TARGET"))
	end
end

function Utility.Text.Dialog.ir_move_peep_to_anchor(dialog, characterName, anchorName)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	Utility.moveToAnchor(peep, Utility.Peep.getMapResource(peep), anchorName)
	return true
end

function Utility.Text.Dialog.ir_orientate_peep_to_anchor(dialog, characterName, anchorName)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	Utility.orientateToAnchor(peep, Utility.Peep.getMapResource(peep), anchorName)
	return true
end

function Utility.Text.Dialog.ir_face(dialog, selfCharacterName, targetCharacterName)
	local selfPeep = dialog:getSpeaker(selfCharacterName)
	local targetPeep = dialog:getSpeaker(targetCharacterName)
	if not (targetPeep and selfPeep) then
		return false
	end

	Utility.Peep.face(selfPeep, targetPeep)
	return true
end

function Utility.Text.Dialog.ir_face_away(dialog, selfCharacterName, targetCharacterName)
	local selfPeep = dialog:getSpeaker(selfCharacterName)
	local targetPeep = dialog:getSpeaker(targetCharacterName)
	if not (targetPeep and selfPeep) then
		return false
	end

	Utility.Peep.faceAway(selfPeep, targetPeep)
	return true
end

function Utility.Text.Dialog.ir_set_peep_mashina_state(dialog, characterName, state)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	return Utility.Peep.setMashinaState(peep, state)
end

function Utility.Text.Dialog.ir_set_external_dialog_variable(dialog, characterName, variableName, variableValue)
	local playerPeep = dialog:getSpeaker("_TARGET")
	if not playerPeep then
		return false
	end

	Utility.Text.setDialogVariable(playerPeep, characterName, variableName, variableValue)
	return true
end

function Utility.Text.Dialog.ir_get_external_dialog_variable(dialog, characterName, variableName)
	local playerPeep = dialog:getSpeaker("_TARGET")
	if not playerPeep then
		return ""
	end

	local result = Utility.Text.getDialogVariable(playerPeep, characterName, variableName)
	if result == nil then
		return ""
	end

	return result
end

function Utility.Text.Dialog.ir_is_in_passage(dialog, characterName, passageName)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	return Utility.Peep.isInPassage(peep, passageName)
end

function Utility.Text.Dialog.ir_get_stance(dialog, characterName)
	local Weapon = require "ItsyScape.Game.Weapon"

	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return Weapon.STANCE_NONE
	end

	local stance = peep:getBehavior(StanceBehavior)
	if not stance then
		return Weapon.STANCE_NONE
	end

	return stance.stance
end


function Utility.Text.bind(dialog, common, language)
	common = common or Utility.Text.Dialog

	for k, v in pairs(common) do
		dialog:bindExternalFunction(k, v, dialog)
	end
end

function Utility.Text.setDialogVariable(playerPeep, character, variableName, variableValue)
	local director = playerPeep:getDirector()

	if type(character) == "string" then
		character = director:getGameDB():getResource(character, "Character")
	end

	if not character then
		return false
	end

	local dialogStorage = director:getPlayerStorage(playerPeep):getRoot():getSection("Player"):getSection("Dialog")
	local characterDialogStorage = dialogStorage:getSection(character.name)

	characterDialogStorage:unset(variableName)
	characterDialogStorage:set(variableName, variableValue)

	return true
end

function Utility.Text.getDialogVariable(playerPeep, character, variableName)
	local director = playerPeep:getDirector()

	if type(character) == "string" then
		character = director:getGameDB():getResource(character, "Character")
	end

	if not character then
		return nil
	end

	local dialogStorage = director:getPlayerStorage(playerPeep):getRoot():getSection("Player"):getSection("Dialog")
	local characterDialogStorage = dialogStorage:getSection(character.name)

	return characterDialogStorage:get(variableName)
end

function Utility.Text.getPronouns(peep)
	local gender = peep:getBehavior(GenderBehavior)
	if gender then
		if #gender.pronouns > 0 then
			return gender.pronouns
		else
			return Utility.Text.DEFAULT_PRONOUNS["en-US"][gender.gender or "x"]
		end
	end

	return {
		"???",
		"???",
		"???",
		"???"
	}
end

function Utility.Text.getPronoun(peep, class, lang, upperCase)
	lang = lang or "en-US"

	local g
	do
		local gender = peep:getBehavior(GenderBehavior)
		if gender then
			g = gender.pronouns[class] or "*None"
		else
			g = Utility.Text.DEFAULT_PRONOUNS[lang]["x"][class] or "*Default"
		end
	end

	if upperCase then
		g = g:sub(1, 1):upper() .. g:sub(2)
	end

	return g
end

function Utility.Text.getEnglishBe(peep, class, upperCase)
	local g
	do
		local gender = peep:getBehavior(GenderBehavior)
		if gender then
			g = Utility.Text.BE[gender.pronounsPlural or false]
		end

		g = g or Utility.Text.BE[true]
	end
	g = g[class] or (upperCase and "*Be" or "*be")

	if upperCase then
		g = g:sub(1, 1):upper() .. g:sub(2)
	end

	return g
end

Utility.Text.INFINITY = require("utf8").char(8734)

function Utility.Text.prettyNumber(value)
	if value == math.huge then
		return Utility.Text.INFINITY
	elseif value == -math.huge then
		return "-" .. Utility.Text.INFINITY
	elseif value ~= value then -- Not a number
		return "???"
	end

	local i, j, minus, int, fraction = tostring(value):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")

	return minus .. int:reverse():gsub("^,", "") .. fraction
end

Utility.UI = {}
Utility.UI.Groups = {
	WORLD = {
		"Ribbon",
		"Chat",
		"GamepadRibbon",
		"GamepadCombatHUD",
		"QuestProgressNotification"
	}
}

function Utility.UI.openGroup(peep, group)
	if type(group) == "string" then
		if not Utility.UI.Groups[group] then
			Log.error("Built-in UI group '%s' not found; cannot open for peep '%s'.", group, peep:getName())
			return
		end

		group = Utility.UI.Groups[group]
	end

	for i = 1, #group do
		local interfaceID = group[i]

		if not Utility.UI.isOpen(peep, interfaceID) then
			Utility.UI.openInterface(peep, interfaceID, false)
		end
	end
end

function Utility.UI.closeAll(peep, id, exceptions)
	local e = { ["ConfigWindow"] = true }
	if exceptions then
		for _, exception in ipairs(exceptions) do
			e[exception] = true
		end
	end

	local ui = peep:getDirector():getGameInstance():getUI()

	local interfaces = {}
	for interfaceID, interfaceIndex in ui:getInterfacesForPeep(peep) do
		if not id or id == interfaceID then
			table.insert(interfaces, { id = interfaceID, index = interfaceIndex })
		end
	end

	for i = 1, #interfaces do
		if not e[interfaces[i].id] then
			ui:close(interfaces[i].id, interfaces[i].index)
		end
	end
end

function Utility.UI.broadcast(ui, peep, interfaceID, ...)
	if interfaceID then
		for interfaceIndex in ui:getInterfacesForPeep(peep, interfaceID) do
			ui:poke(interfaceID, interfaceIndex, ...)
		end
	else
		for interfaceID, interfaceIndex in ui:getInterfacesForPeep(peep) do
			ui:poke(interfaceID, interfaceIndex, ...)
		end
	end
end

function Utility.UI.openInterface(peep, interfaceID, blocking, ...)
	local Instance = require "ItsyScape.Game.LocalModel.Instance"

	if Class.isCompatibleType(peep, Instance) then
		local results = {}
		for _, player in peep:iteratePlayers() do
			local playerPeep = player:getActor() and player:getActor():getPeep()
			if playerPeep then
				table.insert(results, {
					Utility.UI.openInterface(playerPeep, interfaceID, blocking, ...)
				})
			end
		end
		return results
	else
		local ui = peep:getDirector():getGameInstance():getUI()
		if blocking then
			local _, n, controller = ui:openBlockingInterface(peep, interfaceID, ...)
			return n ~= nil, n, controller
		else
			local _, n, controller = ui:open(peep, interfaceID, ...)
			return n ~= nil, n, controller
		end
	end
end

function Utility.UI.isOpen(peep, interfaceID, interfaceIndex)
	local ui = peep:getDirector():getGameInstance():getUI()

	for index in ui:getInterfacesForPeep(peep, interfaceID) do
		if index == interfaceIndex or not interfaceIndex then
			return true, index
		end
	end

	return false
end

function Utility.UI.getOpenInterface(peep, interfaceID, interfaceIndex)
	if not interfaceIndex then
		local isOpen, i = Utility.UI.isOpen(peep, interfaceID)
		if not isOpen then
			return nil
		end

		interfaceIndex = i
	end

	local ui = peep:getDirector():getGameInstance():getUI()
	return ui:get(interfaceID, interfaceIndex)
end

function Utility.UI.tutorial(target, tips, done, state)
	state = state or {}

	local index = 0
	local function after()
		index = index + 1
		if index <= #tips then
			if Class.isCallable(tips[index].init) then
				tips[index].init(target, index)
			end

			local id = tips[index].id
			if Class.isCallable(id) then
				id = id(target, state)
			end

			local message = tips[index].message
			if Class.isCallable(message) then
				message = message(target, state)
			end

			local position = tips[index].position
			if Class.isCallable(position) then
				position = position(target, state)
			end

			local style = tips[index].style
			if Class.isCallable(style) then
				style = style(target, state)
			end

			Utility.UI.openInterface(
				target,
				"TutorialHint",
				false,
				id,
				message,
				tips[index].open(target, state),
				{ position = position, style = style },
				after)
		else
			if done then
				done()
			end
		end
	end

	after()
end

function Utility.UI.notifyFailure(peep, message)
	local director = peep:getDirector()
	if not director then
		return
	end

	local gameDB = director:getGameDB()
	if type(message) == "string" then
		local resource = gameDB:getResource(message, "KeyItem")
		if resource then
			message = resource
		end
	end

	local requirement
	if type(message) == "string" then
		requirement = {
			type = "KeyItem",
			resource = "_MESSAGE",
			name = "Message",
			description = message,
			count = 1
		}
	else
		local name = Utility.getName(message, gameDB) or ("*" .. message.name)
		local description = Utility.getDescription(message, gameDB, nil, 1)

		requirement = {
			type = "KeyItem",
			resource = message.name,
			name = name,
			description = description,
			count = 1
		}
	end

	local constraints = {
		requirements = { requirement },
		inputs = {},
		outputs = {}
	}

	Utility.UI.openInterface(peep, "Notification", false, constraints)
end

-- Contains utility methods to deal with items.
Utility.Item = {}

function Utility.Item._pullActions(game, item, scope)
	if item:isNoted() then
		return {}
	end

	local result = {}

	local gameDB = game:getGameDB()
	local itemResource = gameDB:getResource(item:getID(), "Item")
	if itemResource then
		table.insert(result, Utility.getActions(game, itemResource, scope, true))
	end

	return result
end

function Utility.Item.pull(peep, item, scope)
	return {
		ref = item:getRef(),
		id = item:getID(),
		count = item:getCount(),
		noted = item:isNoted(),
		name = Utility.Item.getInstanceName(item),
		description = Utility.Item.getInstanceDescription(item),
		stats = Utility.Item.getInstanceStats(item, peep),
		slot = Utility.Item.getSlot(item),
		actions = peep and Utility.Item._pullActions(peep:getDirector():getGameInstance(), item, scope) or {}
	}
end

function Utility.Item.getStorage(peep, tag, clear, player)
	local director = peep:getDirector()
	local gameDB = director:getGameDB()

	local storage = Utility.Peep.getStorage(peep, player)
	if storage then
		if clear then
			storage:getSection("Inventory"):removeSection(tag)
		end

		return storage:getSection("Inventory"):getSection(tag)
	end

	return nil
end

-- Gets the shorthand count and color for 'count' using 'lang'.
--
-- 'lang' defaults to "en-US".
--
-- Values
--  * Under 10,000 remain as-is.
--  * Up to 100,000 (exclusive) is divided by 10,000 and suffixed is with a 'k' specifier.
--  * Up to a million are divided by 100,000 and suffixed with a 'k' specifier.
--  * Up to a billion are divided by the same and suffixed with an 'm' specifier.
--  * Up to a trillion are divided by the same and suffixed with an 'b' specifier.
--  * Up to a quadrillion are divided by the same and suffixed with an 'q' specifier.
--
-- Values are floored. Thus 100,999 becomes '100k' (or whatever it may be in
-- 'lang').
function Utility.Item.getItemCountShorthand(count, lang)
	lang = lang or "en-US"
	-- 'lang' is NYI.

	local TEN_THOUSAND     = 10000
	local HUNDRED_THOUSAND = 100000
	local MILLION          = 1000000
	local BILLION          = 1000000000
	local TRILLION         = 1000000000000
	local QUADRILLION      = 1000000000000000

	local text, color
	if count >= QUADRILLION then
		text = string.format("%dq", count / QUADRILLION)
		color = { 1, 0, 1, 1 }
	elseif count >= TRILLION then
		text = string.format("%dt", count / TRILLION)
		color = { 0, 1, 1, 1 }
	elseif count >= BILLION then
		text = string.format("%db", count / BILLION)
		color = { 1, 0.5, 0, 1 }
	elseif count >= MILLION then
		text = string.format("%dm", count / MILLION)
		color = { 0, 1, 0.5, 1 }
	elseif count >= HUNDRED_THOUSAND then
		text = string.format("%dk", count / HUNDRED_THOUSAND * 100)
		color = { 1, 1, 1, 1 }
	elseif count >= TEN_THOUSAND then
		text = string.format("%dk", count / TEN_THOUSAND * 10)
		color = { 1, 1, 0, 1 }
	else
		text = string.format("%d", count)
		color = { 1, 1, 0, 1 }
	end

	return text, color
end

function Utility.Item.parseItemCountInput(value)
	value = value:gsub("%s*(.*)%s*", "%1"):gsub(",", ""):lower()

	local num, modifier = value:match("^(%d*)([kmbq]?)$")
	if num then
		num = tonumber(num)
		if modifier then
			if modifier == 'k' then
				num = num * 100
			elseif modifier == 'm' then
				num = num * 1000000
			elseif modifier == 'b' then
				num = num * 1000000000
			elseif modifier == 'q' then
				num = num * 1000000000000
			end
		end

		return true, num
	end

	return false, 0
end

function Utility.Item.getName(id, gameDB, lang)
	lang = lang or "en-US"

	local itemResource = gameDB:getResource(id, "Item")
	local nameRecord = gameDB:getRecord("ResourceName", { Resource = itemResource, Language = lang }, 1)
	if nameRecord then
		return nameRecord:get("Value")
	else
		return false
	end
end

function Utility.Item.getDescription(id, gameDB, lang)
	lang = lang or "en-US"

	local itemResource = gameDB:getResource(id, "Item")
	local nameRecord = gameDB:getRecord("ResourceDescription", { Resource = itemResource, Language = lang })
	if nameRecord then
		return nameRecord:get("Value")
	else
		return false
	end
end

function Utility.Item.getUserdataHints(id, gameDB, lang)
	lang = lang or "en-US"

	local itemResource = gameDB:getResource(id, "Item")
	if not itemResource then
		return {}
	end

	local result = {}
	local userdataTypes = gameDB:getRecords("ItemUserdata", { Item = itemResource })
	for _, userdataType in ipairs(userdataTypes) do
		local hint = gameDB:getRecord("UserdataHint", { Userdata = userdataType:get("Userdata"), Language = lang })
		if hint then
			hint = hint:get("Value")
		else
			hint = "*" .. userdataType:get("Userdata").name
		end

		table.insert(result, hint)
	end

	return result
end

function Utility.Item.getInstanceName(instance, lang)
	lang = lang or "en-US"

	local gameDB = instance:getManager():getGameDB()
	local itemResource = gameDB:getResource(instance:getID(), "Item")
	if not itemResource then
		return "*" .. instance:getID()
	end

	local nameRecord = gameDB:getRecord("ResourceName", { Resource = itemResource, Language = lang }, 1)
	if nameRecord then
		return nameRecord:get("Value")
	else
		return "*" .. instance:getID()
	end
end

function Utility.Item.getInstanceDescription(instance, lang)
	lang = lang or "en-US"

	local baseDescription
	do
		local gameDB = instance:getManager():getGameDB()
		local itemResource = gameDB:getResource(instance:getID(), "Item")
		local descriptionRecord = gameDB:getRecord("ResourceDescription", { Resource = itemResource, Language = lang })
		if itemResource and descriptionRecord then
			baseDescription = descriptionRecord:get("Value")
		else
			baseDescription = string.format("It's %s, as if you didn't know.", Utility.Item.getInstanceName(instance))
		end
	end

	local userdata = {}
	for name in instance:iterateUserdata() do
		table.insert(userdata, name)
	end
	table.sort(userdata)

	local result = {}
	for i = 1, #userdata do
		local description = instance:getUserdata(userdata[i]):getDescription()
		if description then
			table.insert(result, description)
		end
	end

	table.insert(result, 1, baseDescription)

	return table.concat(result, "\n")
end

function Utility.Item.getStats(id, gameDB)
	local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"

	local itemResource = gameDB:getResource(id, "Item")
	local statsRecord = gameDB:getRecord("Equipment", { Resource = itemResource })

	if statsRecord then
		local stats = {}
		for i = 1, #EquipmentInventoryProvider.STATS do
			local statName = EquipmentInventoryProvider.STATS[i]
			local statValue = statsRecord:get(statName)
			if statValue ~= 0 then
				table.insert(stats, { name = statName, value = statValue })
			end
		end

		return stats
	end

	return nil
end

function Utility.Item.getSlot(item)
	local gameDB = item:getManager():getGameDB()
	local itemResource = gameDB:getResource(item:getID(), "Item")
	if not itemResource then
		return nil
	end

	local equipmentRecord = gameDB:getRecord("Equipment", { Resource = itemResource })
	if not equipmentRecord then
		return nil
	end

	return equipmentRecord:get("EquipSlot")
end

function Utility.Item.getInstanceStats(item, peep)
	local baseStats = Utility.Item.getStats(item:getID(), item:getManager():getGameDB())

	local calculatedStats
	do
		local logic = item:getManager():getLogic(item:getID())
		if peep and logic and Class.isCompatibleType(logic, require "ItsyScape.Game.Equipment") then
			calculatedStats = logic:getCalculatedBonuses(peep, item)
		else
			calculatedStats = {}
		end
	end

	for stat, value in pairs(calculatedStats) do
		local found = false
		for _, baseStat in ipairs(baseStats) do
			if baseStat.name == stat then
				baseStat.value = baseStat.value + value
				found = true
				break
			end
		end

		if not found then
			table.insert(baseStats, { name = stat, value = value })
		end
	end

	return baseStats
end

function Utility.Item.getInfo(id, gameDB, lang)
	lang = lang or "en-US"

	name = Utility.Item.getName(id, gameDB, lang)
	if not name then
		name = "*" .. id
	end

	description = Utility.Item.getDescription(id, gameDB, lang)
	if not description then
		description = string.format("It's %s, as if you didn't know.", object)
	end

	stats = Utility.Item.getStats(id, gameDB)

	return name, description, stats
end

function Utility.Item.groupStats(stats)
	local Equipment = require "ItsyScape.Game.Equipment"

	local offensive, defensive, other = {}, {}, {}
	for i = 1, #stats do
		local stat = stats[i]

		if Equipment.OFFENSIVE_STATS[stat.name] then
			table.insert(offensive, stat)
			stat.niceName = Equipment.OFFENSIVE_STATS[stat.name]
		elseif Equipment.DEFENSIVE_STATS[stat.name] then
			table.insert(defensive, stat)
			stat.niceName = Equipment.DEFENSIVE_STATS[stat.name]
		else
			table.insert(other, stat)
			stat.niceName = Equipment.MISC_STATS[stat.name] or stat.name
		end
	end

	return {
		offensive = offensive,
		defensive = defensive,
		other = other
	}
end

function Utility.Item.spawnInPeepInventory(peep, item, quantity, noted, userdata)
	local flags = { ['item-inventory'] = true }

	if noted then
		flags['item-noted'] = true
	end

	if userdata then
		flags['item-userdata'] = userdata
	end

	return peep:getState():give("Item", item, quantity, flags)
end

function Utility.Item.getItemInPeepInventory(peep, itemID)
	return Utility.Item.getItemsInPeepInventory(peep, itemID)[1]
end

function Utility.Item.getItemsInPeepInventory(peep, itemID)
	local inventory = peep:getBehavior(InventoryBehavior)
	inventory = inventory and inventory.inventory

	if not inventory then
		return {}
	end

	local result = {}
	for item in inventory:getBroker():iterateItems(inventory) do
		if type(itemID) == "string" and item:getID() == itemID then
			table.insert(result, item)
		elseif type(itemID) == "table" or type(itemID) == "function" and itemID(item) then
			table.insert(result, item)
		elseif itemID == nil then
			table.insert(result, item)
		end
	end

	return result
end

Utility.Map = {}

function Utility.Map.getWind(game, layer)
	local instance = game:getStage():getInstanceByLayer(layer)
	local mapInfo = instance and instance:getMap(layer)
	local meta = mapInfo and mapInfo:getMeta()

	return (meta and meta.windDirection and Vector(unpack(meta.windDirection)) or Vector(-1, 0, -1)):getNormal(),
	       meta and meta.windSpeed or 4,
	       meta and meta.windPattern and Vector(unpack(meta.windPattern)) or Vector(5, 10, 15)
end

function Utility.Map.transformWorldPositionByWind(time, windSpeed, windDirection, windPattern, anchorPosition, worldPosition, normal)
	local windRotation = Quaternion.lookAt(Vector.ZERO, windDirection, Vector.UNIT_Y)
	local windDelta = time * windSpeed + worldPosition:getLength() * windSpeed
	local windMu = (math.sin(windDelta / windPattern.x) * math.sin(windDelta / windPattern.y) * math.sin(windDelta / windPattern.z) + 1.0) / 2.0;
	local currentWindRotation = Quaternion.IDENTITY:slerp(windRotation, windMu):getNormal()

	local relativePosition = worldPosition - anchorPosition
	local transformedRelativePosition = currentWindRotation:transformVector(relativePosition)
	normal = currentWindRotation:transformVector(currentWindRotation, normal or Vector.UNIT_Y)

	return transformedRelativePosition + anchorPosition, normal, currentWindRotation
end

function Utility.Map.transformWorldPositionByWave(time, windSpeed, windDirection, windPattern, anchorPosition, worldPosition)
	local windDelta = time * windSpeed
	local windDeltaCoordinate = windDirection * Vector(windDelta) + worldPosition
	local windMu = (math.sin((windDeltaCoordinate.x + windDeltaCoordinate.z) / windPattern.x) * math.sin((windDeltaCoordinate.x + windDeltaCoordinate.z) / windPattern.y) * math.sin((windDeltaCoordinate.x + windDeltaCoordinate.z) / windPattern.z) + 1.0) / 2.0
	
	local distance = (anchorPosition - worldPosition):getLength()
	return worldPosition + Vector(0, distance * windMu, 0)
end

function Utility.Map.calculateWaveNormal(time, windSpeed, windDirection, windPattern, anchorPosition, worldPosition, scale)
	scale = scale or Vector.ONE

	local normalWorldPositionLeft = Utility.Map.transformWorldPositionByWave(
		time,
		windSpeed,
		windDirection,
		windPattern,
		anchorPosition - Vector(scale.x, 0, 0),
		worldPosition - Vector(scale.x, 0, 0))

	local normalWorldPositionRight = Utility.Map.transformWorldPositionByWave(
		time,
		windSpeed,
		windDirection,
		windPattern,
		anchorPosition + Vector(scale.x, 0, 0),
		worldPosition + Vector(scale.x, 0, 0))

	local normalWorldPositionTop = Utility.Map.transformWorldPositionByWave(
		time,
		windSpeed,
		windDirection,
		windPattern,
		anchorPosition - Vector(0, 0, 1),
		worldPosition - Vector(0, 0, scale.z))

	local normalWorldPositionBottom = Utility.Map.transformWorldPositionByWave(
		time,
		windSpeed,
		windDirection,
		windPattern,
		anchorPosition + Vector(0, 0, 1),
		worldPosition + Vector(0, 0, scale.z))

	local normal = Vector(
		2.0 * (normalWorldPositionLeft.y - normalWorldPositionRight.y),
		4.0,
		2.0 * (normalWorldPositionTop.y - normalWorldPositionBottom.y))
	return normal:getNormal()
end

function Utility.Map.getTileRotation(map, i, j)
	local tile = map:getTile(i, j)
	local crease = tile:getCrease()

	local E = map:getCellSize() / 2
	local topLeft = Vector(-E, tile.topLeft, -E)
	local topRight = Vector(E, tile.topRight, -E)
	local bottomLeft = Vector(-E, tile.bottomLeft, E)
	local bottomRight = Vector(E, tile.bottomRight, E)

	if tile.topLeft == tile.bottomLeft and
	   tile.topLeft > tile.topRight and
	   tile.bottomLeft > tile.bottomRight
	then
		return Quaternion.fromAxisAngle(Vector.UNIT_Z, -math.pi / 8)
	elseif tile.topLeft == tile.bottomLeft and
	   tile.topLeft < tile.topRight and
	   tile.bottomLeft < tile.bottomRight
	then
		return Quaternion.fromAxisAngle(Vector.UNIT_Z, math.pi / 8)
	elseif tile.topRight ~= tile.bottomLeft then
		return Quaternion.lookAt(bottomLeft, topRight)
	elseif tile.topLeft ~= tile.bottomRight then
		return Quaternion.lookAt(bottomRight, topLeft)
	else
		return Quaternion.IDENTITY
	end
end

function Utility.Map.playCutscene(map, resource, cameraName, player, entities)
	player = player or Utility.Peep.getPlayer(map)
	local director = map:getDirector()

	if type(resource) == 'string' then
		resource = director:getGameDB():getResource(resource, "Cutscene")
	end

	return director:addPeep(
		map:getLayerName(),
		require "ItsyScape.Peep.Peeps.Cutscene",
		resource,
		cameraName,
		player,
		map,
		entities)
end

function Utility.Map.getTilePosition(director, i, j, layer)
	local stage = director:getGameInstance():getStage()
	local center = stage:getMap(layer) and stage:getMap(layer):getTileCenter(i, j)
	return center or Vector.ZERO
end

function Utility.Map.getAbsoluteTilePosition(director, i, j, layer)
	local stage = director:getGameInstance():getStage()
	local instance = stage:getInstanceByLayer(layer)
	local mapScript = instance and instance:getMapScriptByLayer(layer)

	local map = stage:getMap(layer)
	local center = (map and map:getTileCenter(i, j)) or Vector.ZERO
	center = center + (Vector(map and map:getCellSize() or 0) * Vector(i - math.floor(i), j - math.floor(j)))

	if not mapScript then
		return center
	else
		local transform = Utility.Peep.getMapTransform(mapScript)
		return Vector(transform:transformPoint(center.x, center.y, center.z))
	end
end

function Utility.Map.getMapObject(game, map, name)
	local gameDB = game:getGameDB()

	if type(map) == 'string' then
		map = gameDB:getResource(map, "Map")
	end

	local mapObject = gameDB:getRecord("MapObjectReference", {
		Name = name,
		Map = map
	}) or gameDB:getRecord("MapObjectLocation", {
		Name = name,
		Map = map
	})

	if mapObject then
		return mapObject:get("Resource")
	end

	return nil
end

function Utility.Map.hasAnchor(game, map, anchor)
	local gameDB = game:getGameDB()

	if type(map) == 'string' then
		map = gameDB:getResource(map, "Map")
	end

	local mapObject = gameDB:getRecord("MapObjectLocation", {
		Name = anchor,
		Map = map
	})

	return mapObject ~= nil
end

function Utility.Map.getAnchorPosition(game, map, anchor)
	local gameDB = game:getGameDB()

	if type(map) == 'string' then
		map = gameDB:getResource(map, "Map")
	end

	local mapObject = gameDB:getRecord("MapObjectLocation", {
		Name = anchor,
		Map = map
	})

	if mapObject then
		local x, y, z = mapObject:get("PositionX"), mapObject:get("PositionY"), mapObject:get("PositionZ")
		local localLayer = math.max(mapObject:get("Layer"), 1)
		return x or 0, y or 0, z or 0, localLayer
	end

	return 0, 0, 0, 1
end

function Utility.Map.getAnchorRotation(game, map, anchor)
	local gameDB = game:getGameDB()

	if type(map) == 'string' then
		map = gameDB:getResource(map, "Map")
	end

	local mapObject = gameDB:getRecord("MapObjectLocation", {
		Name = anchor,
		Map = map
	})

	if mapObject then
		local x, y, z, w = mapObject:get("RotationX"), mapObject:get("RotationY"), mapObject:get("RotationZ"), mapObject:get("RotationW")
		if x == 0 and y == 0 and z == 0 and w == 0 then
			return 0, 0, 0, 1
		else
			return x or 0, y or 0, z or 0, w or 1
		end
	end

	return 0, 0, 0, 1
end

function Utility.Map.getAnchorScale(game, map, anchor)
	local gameDB = game:getGameDB()

	if type(map) == 'string' then
		map = gameDB:getResource(map, "Map")
	end

	local mapObject = gameDB:getRecord("MapObjectLocation", {
		Name = anchor,
		Map = map
	})

	if mapObject then
		local x, y, z = mapObject:get("ScaleX"), mapObject:get("ScaleY"), mapObject:get("ScaleZ")
		if x == 0 then x = 1 end
		if y == 0 then y = 1 end
		if z == 0 then z = 1 end
		
		return x, y, z
	end

	return 1, 1, 1
end

function Utility.Map.getAnchorDirection(game, map, anchor)
	local gameDB = game:getGameDB()

	if type(map) == 'string' then
		map = gameDB:getResource(map, "Map")
	end

	local mapObject = gameDB:getRecord("MapObjectLocation", {
		Name = anchor,
		Map = map
	})

	if mapObject then
		return mapObject:get("Direction") or 0
	end

	return 0
end

function Utility.Map.spawnMap(peep, map, position, args)
	local stage = peep:getDirector():getGameInstance():getStage()
	local instance = stage:getPeepInstance(peep)
	local mapLayer, mapScript = stage:loadMapResource(instance, map, args)

	local _, p = mapScript:addBehavior(PositionBehavior)
	p.position = position or Vector.ZERO

	return mapLayer, mapScript
end

function Utility.Map.spawnShip(peep, shipName, layer, i, j, elevation, args)
	local WATER_ELEVATION = 1.75

	local stage = peep:getDirector():getGameInstance():getStage()
	local instance = stage:getPeepInstance(peep)
	local shipLayer, shipScript = stage:loadMapResource(instance, shipName, args)

	if shipScript then
		local baseMap = stage:getMap(layer)

		local x, z
		do
			local position = shipScript:getBehavior(PositionBehavior)
			local map = stage:getMap(shipLayer)
			local s = i - map:getWidth() / 2
			local t = j - map:getHeight() / 2

			position.position = baseMap:getTileCenter(s, t)

			x = position.position.x + map:getWidth() / 2 * map:getCellSize()
			z = position.position.z + map:getHeight() / 2 * map:getCellSize()
		end

		local boatFoamPropName = string.format("resource://BoatFoam_%s_%s", shipScript:getPrefix(), shipScript:getSuffix())
		local _, boatFoamProp = stage:placeProp(boatFoamPropName, layer, peep:getLayerName())
		if boatFoamProp then
			local peep = boatFoamProp:getPeep()
			peep:listen('finalize', function()
				local position = peep:getBehavior(PositionBehavior)
				if position then
					position.position = Vector(x, WATER_ELEVATION, z)
				end

				peep:poke("spawnedByPeep", { peep = shipScript })
			end)

			shipScript.boatFoamProp = peep
		end

		local boatFoamTrailPropName = string.format("resource://BoatFoamTrail_%s_%s", shipScript:getPrefix(), shipScript:getSuffix())
		local _, boatFoamTrailProp = stage:placeProp(boatFoamTrailPropName, layer, peep:getLayerName())
		if boatFoamTrailProp then
			local peep = boatFoamTrailProp:getPeep()
			peep:listen('finalize', function()
				local position = peep:getBehavior(PositionBehavior)
				if position then
					position.position = Vector(x, WATER_ELEVATION, z)
				end

				peep:poke("spawnedByPeep", { peep = shipScript })
			end)

			shipScript.boatFoamTrailProp = peep
		end	
	else
		Log.warn("Couldn't load map %s.", shipName)
	end

	return shipLayer, shipScript
end

-- Gets a random tile within the line of sight of (i, j) no more than 'distance' tiles away (Euclidean)
-- Returns nil, nil if nothing was found
function Utility.Map.getRandomTile(map, i, j, distance, checkLineOfSight, rng, flags, ...)
	if checkLineOfSight == nil then
		checkLineOfSight = true
	end

	local m = {}

	for mapJ = 1, map:getHeight() do
		for mapI = 1, map:getWidth() do
			local d = math.sqrt((mapI - i) ^ 2 + (mapJ - j) ^ 2)
			local tile = map:getTile(mapI, mapJ)
			if (i ~= mapI or j ~= mapJ) and d <= distance and tile:getIsPassable(flags) then
				table.insert(m, { mapI, mapJ })
			end
		end
	end

	repeat
		local index
		if rng then
			index = rng:random(1, #m)
		else
			index = love.math.random(1, #m)
		end

		local tile = table.remove(m, index)

		local currentI, currentJ = unpack(tile)
		local isLineOfSightClear = not checkLineOfSight or map:lineOfSightPassable(i, j, currentI, currentJ, ...)

		if isLineOfSightClear then
			return currentI, currentJ
		end
	until #m == 0 

	return nil, nil
end

-- Gets a random position within the line of sight of position no more than 'distance' units away (Euclidean)
-- Returns nil if nothing was found
-- May round 'distance' to the nearest tile size
function Utility.Map.getRandomPosition(map, position, distance, checkLineOfSight, rng, ...)
	local _, tileI, tileJ = map:getTileAt(position.x, position.z)
	local i, j = Utility.Map.getRandomTile(map, tileI, tileJ, math.max(distance / map:getCellSize(), math.sqrt(2)), checkLineOfSight, rng, ...)

	if i and j then
		return map:getTileCenter(i, j)
	end

	return nil
end

Utility.Peep = {}

function Utility.Peep.isEnabled(peep)
	local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
	return not peep:hasBehavior(DisabledBehavior)
end

function Utility.Peep.isDisabled(peep)
	local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
	return peep:hasBehavior(DisabledBehavior)
end

function Utility.Peep.disable(peep)
	local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"

	local disabled = peep:getBehavior(DisabledBehavior)
	if not disabled then
		peep:removeBehavior(TargetTileBehavior)
		peep:addBehavior(DisabledBehavior)
		return true
	end


	disabled.index = disabled.index + 1
	return false
end

function Utility.Peep.enable(peep)
	local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"

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

function Utility.Peep.dialog(peep, obj, target, overrideEntryPoint)
	local map = Utility.Peep.getMapResource(peep)

	if type(target) == "string" then
		local Probe = require "ItsyScape.Peep.Probe"

		local hit = peep:getDirector():probe(
			peep:getLayerName(),
			Probe.namedMapObject(target),
			Probe.instance(Utility.Peep.getPlayerModel(peep)))[1]

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

		local mapObject = target and Utility.Peep.getMapObject(target)
		local namedMapObjectAction = mapObject and gameDB:getRecord("NamedPeepAction", {
			Name = obj,
			Peep = mapObject
		})

		local resource = target and Utility.Peep.getResource(target)
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

function Utility.Peep.talk(peep, message, ...)
	Utility.Peep.message(peep, "Message", message, ...)
end

function Utility.Peep.yell(peep, message, ...)
	Utility.Peep.message(peep, "Yell", message, ...)
end

function Utility.Peep.notify(peep, message, suppressGenericNotification)
	local Instance = require "ItsyScape.Game.LocalModel.Instance"

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
				local player = Utility.Peep.getPlayerModel(peep)
				if player then
					player:addExclusiveChatMessage(message)
				end
			end
		end
	end
end

function Utility.Peep.message(peep, sprite, message, ...)
	local instance = Utility.Peep.getInstance(peep)
	if instance then
		for _, player in instance:iteratePlayers() do
			player:pushMessage(peep, message)
		end
	end

	local size = Utility.Peep.getSize(peep)
	y = (size and size.y and (math.max(size.y - 1, 1))) or 1

	local actor = peep:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor.actor:flash(sprite, y, message, ...)
	end
end

function Utility.Peep.getPlayerModel(peep)
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

function Utility.Peep.getPlayerActor(peep)
	local model = Utility.Peep.getPlayerModel(peep)
	return model and model:getActor()
end

function Utility.Peep.getPlayer(peep)
	local actor = Utility.Peep.getPlayerActor(peep)
	return actor and actor:getPeep()
end

function Utility.Peep.isInstancedToPlayer(peep, player)
	local instance = peep:getBehavior(InstancedBehavior)
	if instance and instance.playerID == player:getID() then
		return true
	end

	return false
end

function Utility.Peep.dismiss(peep)
	local name = peep:getName()

	Log.info("Dismissing '%s'...", name)

	local follower = peep:getBehavior(FollowerBehavior)
	if follower and follower.followerID ~= FollowerBehavior.NIL_ID then
		local director = peep:getDirector()
		local worldStorage = director:getPlayerStorage(Utility.Peep.getPlayer(peep)):getRoot()
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

		Utility.Peep.poof(peep)
		Log.info("Dismissed '%s'.", name)
	else
		Log.warn("Can't dismiss '%s': not a follower.")
	end
end

function Utility.Peep.getTransform(peep)
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

function Utility.Peep.getAbsoluteTransform(peep)
	local transform = love.math.newTransform()
	do
		local mapScript = Utility.Peep.getMapScript(peep)
		if mapScript then
			local parentTransform = Utility.Peep.getMapTransform(mapScript)
			transform:apply(parentTransform)
		end


		local peepTransform = Utility.Peep.getTransform(peep)
		transform:apply(peepTransform)
	end

	return transform
end

function Utility.Peep.getDecomposedMapTransform(peep)
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
			parent = Utility.Peep.getInstance(peep):getMapScriptByLayer(mapOffset.parentLayer)
		end
	end

	return position, rotation, scale, origin, parent
end

function Utility.Peep.getMapTransform(peep, transform)
	transform = transform or love.math.newTransform()

	do
		local transformOverride = peep:getBehavior(TransformBehavior)
		if transformOverride then
			transform:apply(transformOverride.transform)
			return transform
		end
	end

	do
		local position, rotation, scale, origin, parent = Utility.Peep.getDecomposedMapTransform(peep)

		if parent then
			Utility.Peep.getMapTransform(parent, transform)
		end

		transform:translate(origin:get())
		transform:translate(position:get())
		transform:scale(scale:get())
		transform:applyQuaternion(rotation:get())
		transform:translate((-origin):get())
	end

	return transform
end

function Utility.Peep.getParentTransform(peep)
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

	return Utility.Peep.getMapTransform(mapScript)
end

function Utility.Peep.getLayer(peep)
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

function Utility.Peep.setLayer(peep, layer)
	local position = peep:getBehavior(PositionBehavior)
	if position then
		position.layer = layer
	end
end

function Utility.Peep.setLocalLayer(peep, localLayer, mapScript)
	mapScript = mapScript or Utility.Peep.getMapScript(peep)
	if not mapScript then
		return
	end

	local mapScriptLayer = Utility.Peep.getLayer(mapScript)
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

	Utility.Peep.setLayer(peep, globalLayer)
end

function Utility.Peep.getPosition(peep)
	local position = peep:getBehavior(PositionBehavior)
	if position then
		return position.position
	else
		return Vector.ZERO
	end
end

function Utility.Peep.setPosition(peep, position, lerp)
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

function Utility.Peep.makeInstanced(peep, playerPeep)
	local _, instance = peep:addBehavior(InstancedBehavior)
	instance.playerID = Utility.Peep.getPlayerModel(playerPeep):getID()
end

function Utility.Peep.teleportCompanion(peep, targetPeep)
	local i, j, k = Utility.Peep.getTile(targetPeep)
	local map = Utility.Peep.getMap(targetPeep)

	local offsetX = (love.math.random() - 0.5) * 2 * (map:getCellSize() / 2)
	local offsetZ = (love.math.random() - 0.5) * 2 * (map:getCellSize() / 2)
	local offset = Vector(offsetX, 0, offsetZ)

	if map:canMove(i, j, 1, 0) then
		Utility.Peep.setPosition(peep, map:getTileCenter(i + 1, j) + offset)
		return true
	elseif map:canMove(i, j, -1, 0) then
		Utility.Peep.setPosition(peep, map:getTileCenter(i - 1, j) + offset)
		return true
	elseif map:canMove(i, j, 0, -1) then
		Utility.Peep.setPosition(peep, map:getTileCenter(i, j - 1) + offset)
		return true
	elseif map:canMove(i, j, 0, 1) then
		Utility.Peep.setPosition(peep, map:getTileCenter(i, j + 1) + offset)
		return true
	end

	return false
end

function Utility.Peep.getScale(peep)
	local scale = peep:getBehavior(ScaleBehavior)
	if scale then
		return scale.scale
	else
		return Vector.ONE
	end
end

function Utility.Peep.setScale(peep, scale)
	local p = peep:getBehavior(ScaleBehavior)
	if p then
		p.scale = scale
	else
		Log.warn("Peep '%s' doesn't have a scale; can't set new scale.", peep:getName())
	end
end

function Utility.Peep.getRotation(peep)
	local rotation = peep:getBehavior(RotationBehavior)
	if rotation then
		return rotation.rotation
	else
		return Quaternion.IDENTITY
	end
end

function Utility.Peep.setRotation(peep, rotation)
	local p = peep:getBehavior(RotationBehavior)
	if p then
		p.rotation = rotation
	else
		Log.warn("Peep '%s' doesn't have a rotation; can't set new rotation.", peep:getName())
	end
end

function Utility.Peep.setOrigin(peep, origin)
	local p = peep:getBehavior(OriginBehavior)
	if p then
		p.origin = origin
	else
		Log.warn("Peep '%s' doesn't have an origin; can't set new origin.", peep:getName())
	end
end

function Utility.Peep.getAbsolutePosition(peep)
	local position = Utility.Peep.getPosition(peep)
	local transform = Utility.Peep.getParentTransform(peep)
	if transform then
		local tx, ty, tz = transform:transformPoint(position:get())
		return Vector(tx, ty, tz)
	else
		return position
	end
end

function Utility.Peep.getAbsoluteDistance(sourcePeep, targetPeep)
	local sourcePeepPosition = Utility.Peep.getAbsolutePosition(sourcePeep)
	local sourcePeepSize = Utility.Peep.getSize(sourcePeep)
	local sourcePeepHalfSize = sourcePeepSize / 2
	local sourcePeepMin, sourcePeepMax = sourcePeepPosition - sourcePeepHalfSize, sourcePeepPosition + sourcePeepHalfSize

	local targetPeepPosition = Utility.Peep.getAbsolutePosition(targetPeep)
	local targetPeepSize = Utility.Peep.getSize(targetPeep)
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

function Utility.Peep.getSize(peep)
	local size = peep:getBehavior(SizeBehavior)
	if size then
		return size.size
	else
		return Vector.ZERO
	end
end

function Utility.Peep.setSize(peep, size)
	local s = peep:getBehavior(SizeBehavior)
	if s then
		s.size = size
	else
		Log.warn("Peep '%s' doesn't have a size; can't set new size.", peep:getName())
	end
end

function Utility.Peep.getBounds(peep)
	local position = Utility.Peep.getPosition(peep)
	local size = Utility.Peep.getSize(peep)

	return position - Vector(size.x / 2, 0, size.z / 2), position + Vector(size.x / 2, size.y, size.z / 2)
end

function Utility.Peep.getTargetLineOfSight(peep, target, offset)
	offset = offset or Vector.UNIT_Y

	local peepPosition = Utility.Peep.getAbsolutePosition(peep)
	local targetPosition = Utility.Peep.getAbsolutePosition(target)
	local difference = peepPosition - targetPosition
	local range = difference:getLength()
	local direction = difference / range

	return Ray(peepPosition + offset, -direction), range
end

function Utility.Peep.getPeepsAlongRay(peep, ray, range)
	local peepsDistance = {}
	local hits = peep:getDirector():probe(peep:getLayerName(), function(p)
		local position = Utility.Peep.getAbsolutePosition(p)
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

function Utility.Peep.getPeepsInRadius(peep, range, ...)
	local selfPosition = Utility.Peep.getAbsolutePosition(peep)

	local peepsDistance = {}
	local hits = peep:getDirector():probe(peep:getLayerName(), function(p)
		local otherPosition = Utility.Peep.getAbsolutePosition(p)
		local distance = (otherPosition - selfPosition):getLength()

		peepsDistance[p] = distance

		return distance <= range
	end, ...)

	table.sort(hits, function(a, b)
		return peepsDistance[a] < peepsDistance[b]
	end)

	return hits
end

function Utility.Peep.getDescription(peep, lang)
	lang = lang or "en-US"

	local director = peep:getDirector()
	if director then
		local gameDB = director:getGameDB()

		local mapObject = Utility.Peep.getMapObject(peep)
		if mapObject then
			local description = gameDB:getRecord("ResourceDescription", {
				Language = lang,
				Resource = mapObject
			})

			if description and description:get("Value") then
				return description:get("Value")
			end
		end

		local resource = Utility.Peep.getResource(peep)
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

function Utility.Peep.getTemporaryStorage(peep)
	return Utility.Peep.getPlayerModel(peep):getTemporaryStorage()
end

function Utility.Peep.getStorage(peep, instancedPlayer)
	local director = peep:getDirector()
	local gameDB = director:getGameDB()

	local player = peep:getBehavior(PlayerBehavior)
	if player then
		local root = director:getPlayerStorage(peep):getRoot()
		return root:getSection("Peep")
	else
		local resource = Utility.Peep.getResource(peep)
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
						(instancedPlayer and Utility.Peep.getPlayerModel(instancedPlayer) and Utility.Peep.getPlayerModel(instancedPlayer):getID()) or -1)

					local worldStorage = director:getPlayerStorage(instancedPlayer or Utility.Peep.getPlayer(peep)):getRoot():getSection("World")
					local mapStorage = worldStorage:getSection("Singleton")
					local peepStorage = mapStorage:getSection("Peeps"):getSection(name)

					return peepStorage
				end
			end
		end

		local follower = peep:getBehavior(FollowerBehavior)
		if follower and follower.followerID ~= FollowerBehavior.NIL_ID then
			local worldStorage = director:getPlayerStorage(Utility.Peep.getPlayer(peep)):getRoot()
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

		local mapObject = Utility.Peep.getMapObject(peep)
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

function Utility.Peep.getInventory(peep)
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

function Utility.Peep.getEquippedItem(peep, slot)
	local equipment = peep:getBehavior(EquipmentBehavior)
	if equipment and equipment.equipment then
		equipment = equipment.equipment
		return equipment:getEquipped(slot)
	end
end

function Utility.Peep.canEquipItem(peep, itemResource)
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

function Utility.Peep.getToolsFromInventory(peep, toolType)
	local Weapon = require "ItsyScape.Game.Weapon"

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
		local canEquipTool = Utility.Peep.canEquipItem(peep, item:getID())

		if isToolOfType and canEquipTool then
			table.insert(tools, {
				item = item,
				logic = logic
			})
		end
	end

	return tools
end

function Utility.Peep.getEquippedTool(peep, toolType)
	local Weapon = require "ItsyScape.Game.Weapon"

	local logic, item = Utility.Peep.getEquippedWeapon(peep, true)
	local isLogicWeapon = Class.isCompatibleType(logic, Weapon)
	local isToolOfType = isLogicWeapon and logic:getWeaponType() == toolType

	if isToolOfType then
		return item, logic
	end

	return nil, nil
end

function Utility.Peep.getBestTool(peep, toolType)
	local Weapon = require "ItsyScape.Game.Weapon"

	local tools
	do
		tools = Utility.Peep.getToolsFromInventory(peep, toolType)
		local equippedItem, equippedLogic = Utility.Peep.getEquippedTool(peep, toolType)
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

function Utility.Peep.getEquippedWeapon(peep, includeXWeapon)
	local Equipment = require "ItsyScape.Game.Equipment"

	if includeXWeapon then
		local WeaponBehavior = require "ItsyScape.Peep.Behaviors.WeaponBehavior"
		local xWeapon = peep:getBehavior(WeaponBehavior)
		if xWeapon and xWeapon.weapon then
			return xWeapon.weapon
		end
	end

	local weapon = Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_RIGHT_HAND) or
		Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_TWO_HANDED)
	if weapon then
		local logic = peep:getDirector():getItemManager():getLogic(weapon:getID())
		if logic then
			return logic, weapon
		end
	end

	return nil
end

function Utility.Peep.getEquippedShield(peep, includeXShield)
	local Equipment = require "ItsyScape.Game.Equipment"
	local Shield = require "ItsyScape.Game.Shield"

	local rightHandItem = Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_LEFT_HAND)
	if rightHandItem then
		local shieldLogic = peep:getDirector():getItemManager():getLogic(rightHandItem:getID())
		if shieldLogic:isCompatibleType(Shield) then
			return shieldLogic, rightHandItem
		end
	end

	if includeXShield then
		local ShieldBehavior = require "ItsyScape.Peep.Behaviors.ShieldBehavior"
		local xShield = peep:getBehavior(ShieldBehavior)
		if xShield and xShield.shield and xShield.shield:isCompatibleType(Shield) then
			return xShield.shield
		end
	end

	return nil, nil
end

function Utility.Peep.getEquipmentBonuses(peep)
	local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
	local EquipmentBonusesBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBonusesBehavior"

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

function Utility.Peep.getXWeaponType(id)
	local XName = string.format("Resources.Game.Items.X_%s.Logic", id)
	local XType = require(XName)

	return XType
end

function Utility.Peep.getXWeapon(game, id, proxyID, ...)
	local XName = string.format("Resources.Game.Items.X_%s.Logic", id)
	local XType = require(XName)

	return XType(proxyID or id, game:getDirector():getItemManager(), ...)
end

function Utility.Peep.equipXWeapon(peep, id)
	local Equipment = require "ItsyScape.Game.Equipment"
	local WeaponBehavior = require "ItsyScape.Peep.Behaviors.WeaponBehavior"

	local xWeapon = Utility.Peep.getXWeapon(peep:getDirector():getGameInstance(), id)
	local s, weapon = peep:addBehavior(WeaponBehavior)
	if s then
		weapon.weapon = xWeapon
		if Class.isDerived(xWeapon:getType(), Equipment) then
			xWeapon:onEquip(peep)
		end
	end
end

function Utility.Peep.equipXShield(peep, id)
	local Equipment = require "ItsyScape.Game.Equipment"
	local ShieldBehavior = require "ItsyScape.Peep.Behaviors.ShieldBehavior"

	local xShield = Utility.Peep.getXWeapon(peep:getDirector():getGameInstance(), id)
	local s, shield = peep:addBehavior(ShieldBehavior)
	if s then
		shield.shield = xShield
		if Class.isDerived(xShield:getType(), Equipment) then
			xShield:onEquip(peep)
		end
	end
end

function Utility.Peep.getEffectType(resource, gameDB)
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

function Utility.Peep.applyEffect(peep, resource, singular, ...)
	local gameDB = peep:getDirector():getGameDB()

	if type(resource) == 'string' then
		resource = gameDB:getResource(resource, "Effect")
	end

	if not resource then
		return false, nil
	end

	local EffectType = Utility.Peep.getEffectType(resource, gameDB)

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

function Utility.Peep.toggleEffect(peep, resource, onOrOff, ...)
	local gameDB = peep:getDirector():getGameDB()

	local EffectType = Utility.Peep.getEffectType(resource, gameDB)

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

function Utility.Peep.getPowerType(resource, gameDB)
	local PowerTypeName = string.format("Resources.Game.Powers.%s.Power", resource.name)
	local s, r = pcall(require, PowerTypeName)
	if s then
		return r
	else
		Log.error("Couldn't load power '%s': %s", Utility.getName(resource, gameDB) or resource.name, r)
	end

	return nil
end

function Utility.Peep.canAttack(peep)
	local status = peep:getBehavior(require "ItsyScape.Peep.Behaviors.CombatStatusBehavior")
	if not status then
		return false
	end

	return status.currentHitpoints > 0 and not status.dead
end

function _canPeepAttack(peep, target, teams, otherTeams, matchup)
	local targetCharacter = Utility.Peep.getCharacter(target)
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

function Utility.Peep.canPeepAttackTarget(peep, target)
	if not (Utility.Peep.isAttackable(peep) and Utility.Peep.canAttack(peep)) then
		return false
	end

	if not (Utility.Peep.isAttackable(target) and Utility.Peep.canAttack(target)) then
		return false
	end

	local player = Utility.Peep.getPlayer(peep)
	if not player then
		return true
	end

	local teams = player:getBehavior(TeamsBehavior)
	if not teams then
		return true
	end

	local peepTeams = peep:getBehavior(TeamBehavior)
	local targetTeams = target:getBehavior(TeamBehavior)

	local peepCharacter = Utility.Peep.getCharacter(peep)
	local targetCharacter = Utility.Peep.getCharacter(target)

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

function Utility.Peep.isAttackable(peep)
	if peep:hasBehavior(PlayerBehavior) then
		return true
	end

	local resource = Utility.Peep.getResource(peep)
	local mapObject = Utility.Peep.getMapObject(peep)

	return _isAttackable(peep, resource) or _isAttackable(peep, mapObject) or peep:hasBehavior(PlayerBehavior)
end

function Utility.Peep.playAnimation(peep, animationSlot, animationPriority, animationName, animationForced, animationTime)
	local actor = peep:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor
	if not actor then
		return false
	end

	local filename = string.format("Resources/Game/Animations/%s/Script.lua", animationName)
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
function Utility.Peep.walk(peep, i, j, k, distance, t, ...)
	local command, r = Utility.Peep.getWalk(peep, i, j, k, distance, t, ...)
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

Utility.Peep.WALK_QUEUE = { n = 0, pending = {} }

function Utility.Peep.cancelWalk(n)
	for i, pending in ipairs(Utility.Peep.WALK_QUEUE.pending) do
		if pending.n == n then
			table.remove(Utility.Peep.WALK_QUEUE.pending, i)
			break
		end
	end
end

function Utility.Peep.updateWalks(time)
	local walkQueueTimeMS = Config.get("Config", "ENGINE", "var", "walkQueueTimeMS", "_", 10)
	local targetTime = love.timer.getTime() + (time or (walkQueueTimeMS / 1000))

	local queue = Utility.Peep.WALK_QUEUE.pending
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

function Utility.Peep.queueWalk(peep, i, j, k, distance, t, ...)
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
		local map = peep:getDirector():getGameInstance():getStage():getMap(k or Utility.Peep.getLayer(peep))
		local _, s, t = map:getTileAt(i, j)

		i = s
		j = t
	end

	Utility.Peep.WALK_QUEUE.n = Utility.Peep.WALK_QUEUE.n + 1
	local walkCoroutine = coroutine.wrap(Utility.Peep.walk)
	local pending = {
		n = Utility.Peep.WALK_QUEUE.n,
		callback = callback,
		update = walkCoroutine
	}

	pending.s = walkCoroutine(peep, i, j, k, distance, y, ...)

	table.insert(Utility.Peep.WALK_QUEUE.pending, pending)
	return callback, pending.n
end

function Utility.Peep.getTileAnchor(peep, offsetI, offsetJ)
	local rotation = Utility.Peep.getRotation(peep)
	local size = Utility.Peep.getSize(peep)

	if not (offsetI and offsetJ) then
		local mapObject = Utility.Peep.getMapObject(peep)
		local resource = Utility.Peep.getResource(peep)
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
		local i, j, k = Utility.Peep.getTile(peep)
		i = i + (offsetI or 0)
		j = j + (offsetJ or 0)

		return i, j, k
	end

	if not (offsetI and offsetJ) then
		local map = Utility.Peep.getMap(peep)

		offsetI = 0
		offsetJ = math.max(math.floor(size.z / map:getCellSize()), 1)
	end

	local i, j = Utility.Peep.getTile(peep)
	local v = rotation:transformVector(Vector(offsetI, 0, offsetJ))

	i = i + math.floor(v.x)
	j = j + math.floor(v.z)

	return i, j, Utility.Peep.getLayer(peep)
end

function Utility.Peep.getTile(peep)
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

function Utility.Peep.getPassages(peep)
	local position = Utility.Peep.getPosition(peep)
	local mapResource = Utility.Peep.getMapResource(peep)

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

function Utility.Peep.isInPassage(peep, passage)
	local passages = Utility.Peep.getPassages(peep)
	for _, p in ipairs(passages) do
		if p == passage then
			return true
		end
	end
	return false
end

function Utility.Peep.getTileRotation(peep)
	local i, j = Utility.Peep.getTile(peep)
	local map = Utility.Peep.getMap(peep)

	return Utility.Map.getTileRotation(map, i, j)
end

function Utility.Peep.getWalk(peep, i, j, k, distance, t, ...)
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
	local SmartPathFinder = require "ItsyScape.World.SmartPathFinder"
	local ExecutePathCommand = require "ItsyScape.World.ExecutePathCommand"

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

function Utility.Peep.setFacing(peep, direction)
	local movement = peep:getBehavior(MovementBehavior)
	if movement then
		if direction < 0 then
			movement.targetFacing = MovementBehavior.FACING_LEFT
		elseif direction > 0 then
			movement.targetFacing = MovementBehavior.FACING_RIGHT
		end
	end
end

function Utility.Peep.face(peep, target)
	local peepPosition = Utility.Peep.getAbsolutePosition(peep)
	local targetPosition = Utility.Peep.getAbsolutePosition(target)

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

function Utility.Peep.faceAway(peep, target)
	local peepPosition = Utility.Peep.getAbsolutePosition(peep)
	local targetPosition = Utility.Peep.getAbsolutePosition(target)

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

function Utility.Peep.lookAt(self, target, delta)
	local rotation = self:getBehavior(RotationBehavior)
	if rotation then
		local selfPosition = Utility.Peep.getAbsolutePosition(self)
		local peepPosition

		if Class.isCompatibleType(target, Vector) then
			peepPosition = target
		elseif Class.isCompatibleType(target, Ray) then
			peepPosition = target.origin
		elseif Class.isCompatibleType(target, require "ItsyScape.Peep.Peep") then
			peepPosition = Utility.Peep.getAbsolutePosition(target)
		else
			return
		end

		local selfMapTransform = Utility.Peep.getParentTransform(self)
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

function Utility.Peep.face3D(self)
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
			return Utility.Peep.lookAt(self, peep)
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

			local xzSelfPosition = Utility.Peep.getPosition(self) * Vector.PLANE_XZ
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

function Utility.Peep.applyCooldown(peep, time)
	if not time then
		local weapon = Utility.Peep.getEquippedWeapon(peep, true)
		if weapon and Class.isCompatibleType(weapon, require "ItsyScape.Game.Weapon") then
			time = weapon:getCooldown(peep)
		end
	end

	local _, cooldown = peep:addBehavior(AttackCooldownBehavior)
	cooldown.cooldown = math.max(cooldown.cooldown, time)
	cooldown.ticks = peep:getDirector():getGameInstance():getCurrentTick()
end

function Utility.Peep.attack(peep, other, distance)
	local CombatCortex = require "ItsyScape.Peep.Cortexes.CombatCortex2"

	do
		local status = peep:getBehavior(CombatStatusBehavior)
		if not status then
			return false
		end

		if status and (status.dead or status.currentHitpoints == 0) then
			return false
		end
	end

	if not Utility.Peep.canPeepAttackTarget(peep, other) then
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

function Utility.Peep.getCharacter(peep)
	local character = peep:getBehavior(CharacterBehavior)
	return character and character.character
end

function Utility.Peep.getResource(peep)
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

function Utility.Peep.setResource(peep, resource)
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

function Utility.Peep.getMapObject(peep)
	local mapObject = peep:getBehavior(MapObjectBehavior)
	if mapObject then
		return mapObject.mapObject
	else
		return false
	end
end

function Utility.Peep.setMapObject(peep, mapObject)
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

function Utility.Peep.getTier(peep)
	local resource = Utility.Peep.getResource(peep)
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

function Utility.Peep.getInstance(peep)
	return peep:getDirector():getGameInstance():getStage():getPeepInstance(peep)
end

function Utility.Peep.getRaid(peep)
	local instance = Utility.Peep.getInstance(peep)
	return instance and instance:getRaid()
end

function Utility.Peep.getMap(peep)
	if not peep:getDirector() then
		return Utility.Peep._defaultMap
	end

	local director = peep:getDirector()
	local position = peep:getBehavior(PositionBehavior)

	local Map = require "ItsyScape.World.Map"
	Utility.Peep._defaultMap = Utility.Peep._defaultMap or Map(1, 1, 2)

	if peep:isCompatibleType(require "ItsyScape.Peep.Peeps.Map") then
		return director:getMap(peep:getLayer()) or Utility.Peep._defaultMap
	end

	if position and position.layer and director then 
		return director:getMap(position.layer) or Utility.Peep._defaultMap
	end

	return Utility.Peep._defaultMap
end

function Utility.Peep.getMapResource(peep)
	local instance = Utility.Peep.getInstance(peep)
	local mapGroup = instance:getMapGroup(Utility.Peep.getLayer(peep))
	local groupBaseLayer = instance:getGlobalLayerFromLocalLayer(mapGroup)
	local mapScript = instance:getMapScriptByLayer(groupBaseLayer) or instance:getBaseMapScript()
	return Utility.Peep.getResource(mapScript)
end

function Utility.Peep.getMapResourceFromLayer(peep)
	local instance = peep:getDirector():getGameInstance():getStage():getPeepInstance(peep)
	if instance then
		local mapScript = instance:getMapScriptByLayer(Utility.Peep.getLayer(peep))
		if mapScript then
			return Utility.Peep.getResource(mapScript)
		end
	end

	return nil
end

function Utility.Peep.setMapResource(peep, map)
	local _, mapResourceReference = peep:addBehavior(MapResourceReferenceBehavior)
	mapResourceReference.map = map
end

function Utility.Peep.getMapScript(peep)
	local instance = Utility.Peep.getInstance(peep)
	local mapGroup = instance:getMapGroup(Utility.Peep.getLayer(peep))
	local groupBaseLayer = instance:getGlobalLayerFromLocalLayer(mapGroup)
	local mapScript = instance:getMapScriptByLayer(groupBaseLayer)

	return mapScript
end

function Utility.Peep.setNameMagically(peep)
	local gameDB = peep:getDirector():getGameDB()
	local resource = Utility.Peep.getResource(peep)
	local mapObject = Utility.Peep.getMapObject(peep)
	local storage = Utility.Peep.getStorage(peep)

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

function Utility.Peep.poofInstancedMapGroup(playerPeep, mapObjectGroup)
	local Probe = require "ItsyScape.Peep.Probe"

	local director = playerPeep:getDirector()
	local hits = director:probe(
		playerPeep:getLayerName(),
		Probe.mapObjectGroup(mapObjectGroup),
		Probe.instance(Utility.Peep.getPlayerModel(playerPeep)))

	for _, hit in ipairs(hits) do
		Utility.Peep.poof(hit)
	end
end

function Utility.Peep.poof(peep)
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

Utility.Peep.Stats = {}
function Utility.Peep.Stats.onAssign(max, self, director)
	local stats = self:getBehavior(StatsBehavior)
	if stats then
		stats.stats = Stats(self:getName(), director:getGameDB(), max)
		stats.stats:getSkill("Constitution").onLevelUp:register(function(skill, oldLevel)
			local difference = math.max(skill:getBaseLevel() - oldLevel, 0)

			local combat = self:getBehavior(CombatStatusBehavior)
			if combat then
				combat.maximumHitpoints = combat.maximumHitpoints + difference
				combat.currentHitpoints = combat.currentHitpoints + difference
			end
		end)
		stats.stats:getSkill("Faith").onLevelUp:register(function(skill, oldLevel)
			local difference = math.max(skill:getBaseLevel() - oldLevel, 0)

			local combat = self:getBehavior(CombatStatusBehavior)
			if combat then
				combat.maximumPrayer = combat.maximumPrayer + difference
				combat.currentPrayer = combat.currentPrayer + difference
			end
		end)
	end
end

function Utility.Peep.Stats:onReady(director)
	local stats = self:getBehavior(StatsBehavior)
	if stats and stats.stats then
		stats = stats.stats
		local function setStats(records)
			for i = 1, #records do
				local skill = records[i]:get("Skill").name
				local xp = records[i]:get("Value")

				if stats:hasSkill(skill) then
					stats:getSkill(skill):setXP(xp)
				else
					Log.warn("Skill %s not found on Peep %s.", skill, self:getName())
				end
			end
		end

		local gameDB = director:getGameDB()
		local resource = Utility.Peep.getResource(self)
		local mapObject = Utility.Peep.getMapObject(self)

		if resource then
			setStats(gameDB:getRecords("PeepStat", { Resource = resource }))
		end

		if mapObject then
			setStats(gameDB:getRecords("PeepStat", { Resource = mapObject }))
		end
	end

	Log.info("%s combat level: %d (%d [from tier = %d, from hitpoints = %d] XP)", self:getName(), Utility.Combat.getCombatLevel(self), Utility.Combat.getCombatXP(self))

	self:getState():addProvider("Skill", PlayerStatsStateProvider(self))
end

function Utility.Peep.Stats:onFinalize(director)
	local combat = self:getBehavior(CombatStatusBehavior)
	local stats = self:getBehavior(StatsBehavior)
	if combat and stats and stats.stats then
		stats = stats.stats

		combat.maximumHitpoints = math.max(stats:getSkill("Constitution"):getWorkingLevel(), combat.maximumHitpoints)
		combat.currentHitpoints = math.max(stats:getSkill("Constitution"):getWorkingLevel(), combat.currentHitpoints)
		combat.maximumPrayer = math.max(stats:getSkill("Faith"):getWorkingLevel(), combat.maximumPrayer)
		combat.currentPrayer = math.max(stats:getSkill("Faith"):getWorkingLevel(), combat.currentPrayer)
	end
end

function Utility.Peep.addStats(peep, max)
	peep:addBehavior(StatsBehavior)

	peep:listen('assign', Utility.Peep.Stats.onAssign, max)
	peep:listen('ready', Utility.Peep.Stats.onReady)
	peep:listen('finalize', Utility.Peep.Stats.onFinalize)
end

Utility.Peep.Mashina = {}
function Utility.Peep.Mashina:onReady(director)
	local function setMashinaStates(records)
		if #records > 0 then
			local m = self:getBehavior(MashinaBehavior)
			if m then
				for i = 1, #records do
					local record = records[i]
					local state = record:get("State")
					local tree = record:get("Tree")
					local code = love.filesystem.load(tree)
					if code then
						m.states[state] = code()

						local default = record:get("IsDefault")
						if default and default ~= 0 and not m.currentState then
							m.currentState = state
						end
					else
						m.states[state] = nil
					end
				end
			end
		end
	end

	local gameDB = director:getGameDB()
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)

	if resource then
		setMashinaStates(gameDB:getRecords("PeepMashinaState", { Resource = resource }))
	end

	if mapObject then
		setMashinaStates(gameDB:getRecords("PeepMashinaState", { Resource = mapObject }))
	end
end

function Utility.Peep.makeMashina(peep)
	peep:addBehavior(MashinaBehavior)

	peep:listen('ready', Utility.Peep.Mashina.onReady)
end

function Utility.Peep.getMashinaState(peep)
	local mashina = peep:getBehavior(MashinaBehavior)
	return mashina and mashina.currentState or false
end

function Utility.Peep.setMashinaState(peep, state)
	local mashina = peep:getBehavior(MashinaBehavior)
	if mashina then
		mashina.currentState = state or false
		return not not mashina.states[state] or state == false
	end

	return false
end

Utility.Peep.Inventory = {}
function Utility.Peep.Inventory:reload(skipSerialize)
	local director = self:getDirector()
	local inventory = self:getBehavior(InventoryBehavior)
	director:getItemBroker():removeProvider(inventory.inventory, skipSerialize)
	director:getItemBroker():addProvider(inventory.inventory)
end

function Utility.Peep.Inventory:onAssign(director)
	local PlayerInventoryStateProvider = require "ItsyScape.Game.PlayerInventoryStateProvider"

	local inventory = self:getBehavior(InventoryBehavior)
	director:getItemBroker():addProvider(inventory.inventory)

	self:getState():addProvider("Item", PlayerInventoryStateProvider(self))
end

function Utility.Peep.Inventory:onReady(director)
	local broker = director:getItemBroker()
	local function spawnItems(records)
		local inventory = self:getBehavior(InventoryBehavior)
		if inventory and inventory.inventory then
			inventory = inventory.inventory
			for i = 1, #records do
				local record = records[i]
				local item = record:get("Item")
				local count = record:get("Count") or 1
				local noted = record:get("Noted") ~= 0

				local transaction = broker:createTransaction()
				transaction:addParty(inventory)
				transaction:spawn(inventory, item.name, count, noted)
				local s, r = transaction:commit()
				if not s then
					Log.error("Failed to spawn item: %s", r)
				end
			end
		end
	end
	
	local gameDB = director:getGameDB()
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)

	if resource then
		spawnItems(gameDB:getRecords("PeepInventoryItem", { Resource = resource }))
	end

	if mapObject then
		spawnItems(gameDB:getRecords("PeepInventoryItem", { Resource = mapObject }))
	end
end

function Utility.Peep.addInventory(peep, InventoryType)
	InventoryType = InventoryType or require "ItsyScape.Game.PlayerInventoryProvider"

	peep:addBehavior(InventoryBehavior)
	local inventory = peep:getBehavior(InventoryBehavior)
	inventory.inventory = InventoryType(peep)

	peep:listen('assign', Utility.Peep.Inventory.onAssign)
	peep:listen('ready', Utility.Peep.Inventory.onReady)
end

function Utility.Peep.prepInstancedInventory(peep, InventoryType, player)
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

Utility.Peep.Equipment = {}
function Utility.Peep.Equipment:reload(skipSerialize)
	local director = self:getDirector()
	local equipment = self:getBehavior(EquipmentBehavior)
	director:getItemBroker():removeProvider(equipment.equipment, skipSerialize)
	director:getItemBroker():addProvider(equipment.equipment)
end

function Utility.Peep.Equipment:onAssign(director)
	local PlayerEquipmentStateProvider = require "ItsyScape.Game.PlayerEquipmentStateProvider"

	local equipment = self:getBehavior(EquipmentBehavior)
	director:getItemBroker():addProvider(equipment.equipment)

	self:getState():addProvider("Item", PlayerEquipmentStateProvider(self))
end

function Utility.Peep.Equipment:onReady(director)
	local broker = director:getItemBroker()
	local function equipItems(records)
		local equipment = self:getBehavior(EquipmentBehavior)
		if equipment and equipment.equipment then
			equipment = equipment.equipment
			for i = 1, #records do
				local record = records[i]
				local item = record:get("Item")
				local count = record:get("Count") or 1

				local transaction = broker:createTransaction()
				transaction:addParty(equipment)
				transaction:spawn(equipment, item.name, count, false)
				local s, r = transaction:commit()
				if not s then
					Log.error("Failed to equip item: %s", r)
				end
			end
		end
	end
	
	local gameDB = director:getGameDB()
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)

	if resource then
		equipItems(gameDB:getRecords("PeepEquipmentItem", { Resource = resource }))
	end

	if mapObject then
		equipItems(gameDB:getRecords("PeepEquipmentItem", { Resource = mapObject }))
	end
end

function Utility.Peep.addEquipment(peep, EquipmentType)
	EquipmentType = EquipmentType or require "ItsyScape.Game.EquipmentInventoryProvider"

	peep:addBehavior(EquipmentBehavior)
	local equipment = peep:getBehavior(EquipmentBehavior)
	equipment.equipment = EquipmentType(peep)

	peep:listen('assign', Utility.Peep.Equipment.onAssign)
	peep:listen('ready', Utility.Peep.Equipment.onReady)
end

Utility.Peep.Attackable = {}
function Utility.Peep.Attackable:onInitiateAttack()
	-- Nothing.
end

function Utility.Peep.Attackable:onTargetFled(p)
	local mashina = self:getBehavior(MashinaBehavior)
	if mashina then
		local isCurrentStateValid = mashina.currentState
		if isCurrentStateValid then
			local isCurrentStateAttack = mashina.currentState == 'attack' or
			                             not mashina.states[mashina.currentState]

			if isCurrentStateAttack and mashina.states['idle'] then
				mashina.currentState = 'idle'
				Log.info("Target for %s fled, returning to idle.", self:getName())
			end
		end
	end
end

function Utility.Peep.Attackable:bossReceiveAttack(p)
	local aggressor = p:getAggressor()
	if not aggressor then
		return
	end

	local isPlayer = aggressor:hasBehavior(PlayerBehavior)
	if not isPlayer then
		return
	end

	local isOpen = Utility.UI.isOpen(aggressor, "BossHUD")
	if isOpen then
		return
	end

	Utility.UI.openInterface(
		aggressor,
		"BossHUD",
		false,
		self)
end

function Utility.Peep.Attackable:onReceiveAttack(p)
	local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
	local WaitCommand = require "ItsyScape.Peep.WaitCommand"
	local UninterrupibleCallbackCommand = require "ItsyScape.Peep.UninterrupibleCallbackCommand"

	local combat = self:getBehavior(CombatStatusBehavior)
	if not combat then
		return
	end
	
	local isAttackable = Utility.Peep.isAttackable(self)
	local isPlayerAggressor = p:getAggressor() and p:getAggressor():hasBehavior(PlayerBehavior)
	local isSelfPlayer = self:hasBehavior(PlayerBehavior)
	if (not isAttackable and isPlayerAggressor) or (isPlayerAggressor and isSelfPlayer) then
		return
	end

	local damage = math.max(math.min(combat.currentHitpoints, p:getDamage()), 0)

	local attack = AttackPoke({
		attackType = p:getAttackType(),
		weaponType = p:getWeaponType(),
		damageType = p:getDamageType(),
		damage = damage,
		aggressor = p:getAggressor(),
		delay = p:getDelay()
	})

	if damage > 0 then
		if p:getDelay() > 0 then
			local queue = self:getParallelCommandQueue('hit')
			local a = WaitCommand(p:getDelay(), false)
			local b = UninterrupibleCallbackCommand(function() self:poke('hit', attack) end)
			queue:push(CompositeCommand(true, a, b))
		else
			self:poke('hit', attack)
		end
	else
		if p:getDelay() > 0 then
			local queue = self:getParallelCommandQueue('hit')
			local a = WaitCommand(p:getDelay(), false)
			local b = UninterrupibleCallbackCommand(function() self:poke('miss', attack) end)
			queue:push(CompositeCommand(true, a, b))
		else
			self:poke('miss', attack)
		end
	end
end

Utility.Peep.Attackable.aggressiveOnReceiveAttack = Utility.Peep.Attackable.onReceiveAttack

function Utility.Peep.Attackable:onHeal(p)
	local combat = self:getBehavior(CombatStatusBehavior)
	if combat and combat.currentHitpoints >= 0 then
		local newHitPoints = combat.currentHitpoints + math.max(p.hitPoints or p.hitpoints or 0, 0)
		if not p.zealous then
			newHitPoints = math.min(newHitPoints, combat.maximumHitpoints)
		else
			newHitPoints = math.min(newHitPoints, combat.maximumHitpoints + (p.hitPoints or p.hitpoints or 0))
		end

		combat.currentHitpoints = newHitPoints
	end
end

function Utility.Peep.Attackable:onZeal(p)
	for effect in self:getEffects(require "ItsyScape.Peep.Effects.ZealEffect") do
		effect:modifyZealEvent(p, self)
	end

	local pendingPowers = self:getBehavior(PowerRechargeBehavior)
	if pendingPowers then
		for powerID, powerZeal in pairs(pendingPowers.powers) do
			local multiplier, offset = 1, 0
			for effect in self:getEffects(require "ItsyScape.Peep.Effects.ZealEffect") do
				local m, o = effect:modifyActiveRecharge(p, powerID)
				multiplier = multiplier + m
				offset = offset + o
			end

			local recharge = math.clamp(p:getEffectiveZeal() * multiplier + offset, 0.01, 1)
			powerZeal = powerZeal - recharge

			if powerZeal <= 0 then
				pendingPowers.powers[powerID] = nil
			else
				pendingPowers.powers[powerID] = powerZeal
			end
		end
	end

	local status = self:getBehavior(CombatStatusBehavior)
	if not status then
		return
	end

	local zeal = p:getEffectiveZeal()
	local currentZeal = status.currentZeal + zeal
	local multiplier, offset = 1, 0
	for effect in self:getEffects(require "ItsyScape.Peep.Effects.ZealEffect") do
		local m, o = effect:modifyZeal(p, self)
		multiplier = multiplier + m
		offset = offset + o
	end

	status.currentZeal = math.clamp(currentZeal * multiplier + offset, 0, status.maximumZeal)
end

function Utility.Peep.Attackable:onHit(p)
	if self:hasBehavior(DisabledBehavior) then
		return
	end

	local combat = self:getBehavior(CombatStatusBehavior)
	if not combat then
		return
	end

	if combat.currentHitpoints == 0 or combat.isDead then
		return
	end

	combat.currentHitpoints = math.max(combat.currentHitpoints - p:getDamage(), 0)
	if combat.currentHitpoints <= 0 and self:hasBehavior(ImmortalBehavior) then
		combat.currentHitpoints = 1
	end

	if math.floor(combat.currentHitpoints) == 0 then
		self:pushPoke('die', p)
	end
end

function Utility.Peep.Attackable:onMiss(p)
	-- Nothing.
end

function Utility.Peep.Attackable:onDie(p)
	local CombatCortex = require "ItsyScape.Peep.Cortexes.CombatCortex2"
	self:getCommandQueue():clear()
	self:getCommandQueue(CombatCortex.QUEUE):clear()
	self:removeBehavior(CombatTargetBehavior)

	local mashina = self:getBehavior(MashinaBehavior)
	if mashina then
		mashina.currentState = false
	end

	local movement = self:getBehavior(MovementBehavior)
	movement.velocity = Vector.ZERO
	movement.acceleration = Vector.ZERO

	local xp = Utility.Combat.getCombatXP(self)
	local slayers = {}
	do
		local actor = self:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			local status = self:getBehavior(CombatStatusBehavior)
			if status then
				local currentSlayerDamage = 0
				for peep, d in pairs(status.damage) do
					if peep:hasBehavior(PlayerBehavior) then
						slayers[peep] = d
					end

					local damage = d / status.maximumHitpoints
					Log.info("%s gets %d%% XP for slaying %s (dealt %d damage).", peep:getName(), damage * 100, self:getName(), d)

					if peep:hasBehavior(PlayerBehavior) then
						Analytics:killedNPC(peep, self, math.floor(xp * damage))
					end

					Utility.Combat.giveCombatXP(peep, xp * damage)
				end

				status.dead = true
			end
		end
	end

	do
		local s = {}
		for slayer in pairs(slayers) do
			table.insert(s, slayer)
		end

		table.sort(s, function(a, b)
			return slayer[a] > slayer[b]
		end)

		slayers = s
	end

	if Utility.Boss.isBoss(self) then
		local gameDB = self:getDirector():getGameDB()

		local isDead = true
		do
			local mapObject = Utility.Peep.getMapObject(self)
			if mapObject then
				local group = gameDB:getRecord("MapObjectGroup", {
					MapObject = mapObject,
					Map = Utility.Peep.getMapResource(self)
				})

				if group then
					local Probe = require "ItsyScape.Peep.Probe"
					local hits = self:getDirector():probe(
						self:getLayerName(),
						function(peep)
							local m = Utility.Peep.getMapObject(peep)
							local g = m and gameDB:getRecord("MapObjectGroup", {
								MapObject = m,
								Map = Utility.Peep.getMapResource(peep),
								MapObjectGroup = group:get("MapObjectGroup")
							})

							return m and g
						end)

					isDead = true
					for _, hit in ipairs(hits) do
						local status = hit:getBehavior(CombatStatusBehavior)

						if not status or not status.dead then
							isDead = false
							break
						end
					end
				end
			end
		end

		if isDead then
			local instance = Utility.Peep.getInstance(self)
			if instance and instance:getIsGlobal() and #slayers >= 1 then
				Utility.Boss.recordKill(slayers[1], self)
			elseif instance and instance:getIsLocal() then
				for _, player in instance:iteratePlayers() do
					Utility.Boss.recordKill(player:getActor():getPeep(), self)
				end
			end
		end
	end
end

function Utility.Peep.Attackable:onResurrect()
	local status = self:getBehavior(CombatStatusBehavior)
	if status then
		status.damage = {}
		status.dead = false
	end

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor.actor:stopAnimation("combat-die")
	end
end

function Utility.Peep.Attackable:onReady(director)
	local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
	local EquipmentBonusesBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBonusesBehavior"

	local function setEquipmentBonuses(record)
		if not record then
			return false
		else
			self:addBehavior(EquipmentBonusesBehavior)
		end

		local bonuses = self:getBehavior(EquipmentBonusesBehavior).bonuses
		for i = 1, #EquipmentInventoryProvider.STATS do
			local stat = EquipmentInventoryProvider.STATS[i]
			bonuses[stat] = record:get(stat) or 0
		end

		return true
	end
	
	local gameDB = director:getGameDB()
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)

	local success = false
	if mapObject then
		success = setEquipmentBonuses(gameDB:getRecord("Equipment", { Resource = mapObject, Name = "" }))
	end

	if not success and resource then
		success = setEquipmentBonuses(gameDB:getRecord("Equipment", { Resource = resource, Name = "" }))
	end

	if success then
		Log.info("Peep '%s' has bonuses.", self:getName())
	end
end

function Utility.Peep.Attackable:onPostReady(director)
	local gameDB = director:getGameDB()
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)

	local mapObjectHealth = mapObject and gameDB:getRecord("PeepHealth", { Resource = mapObject })
	local resourceHealth = resource and gameDB:getRecord("PeepHealth", { Resource = resource })

	local health = (mapObjectHealth and mapObjectHealth:get("Hitpoints")) or (resourceHealth and resourceHealth:get("Hitpoints"))

	if health then
		local _, status = self:addBehavior(CombatStatusBehavior)
		status.currentHitpoints = health
		status.maximumHitpoints = health
	end
end

function Utility.Peep.makeAttackable(peep, retaliate)
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

function Utility.Peep.makeSkiller(peep)
	peep:addPoke('resourceHit')
	peep:addPoke('resourceObtained')
end

function Utility.Peep.makeDummy(peep)
	peep:listen('finalize', Utility.Peep.Dummy.onFinalize)
end

Utility.Peep.Dummy = {}
Utility.Peep.Dummy.TIERS = {
	{
		base = "Staff",
		"Dinky",
		"Feeble",
		"Moldy",
		"Springy",
		"Tense",
		"Scary"
	},
	{
		base = "Longbow",
		"Puny",
		"Bendy",
		"Petty",
		"Shaky",
		"Spindly",
		"Terrifying"
	},
	{
		base = "Zweihander",
		"Bronze",
		"Iron",
		"BlackenedIron",
		"Mithril",
		"Adamant",
		"Itsy"
	}
}

Utility.Peep.Dummy.ANIMATIONS = {
	"Human_AttackStaffMagic_1",
	"Human_AttackBowRanged_1",
	"Human_AttackZweihanderSlash_1"
}

Utility.Peep.Dummy.WEAPONS = {
	"Dummy_Staff",
	"Dummy_Bow",
	"Dummy_Sword"
}

function Utility.Peep.Dummy.getAttackCooldown(peep)
	local gameDB = peep:getDirector():getGameDB()
	local resource = Utility.Peep.getResource(peep)

	local dummy = gameDB:getRecord("Dummy", { Resource = resource })
	local cooldown = dummy and dummy:get("AttackCooldown")
	return ((not cooldown or cooldown == 0) and nil) or cooldown
end

function Utility.Peep.Dummy.getAttackRange(peep)
	local gameDB = peep:getDirector():getGameDB()
	local resource = Utility.Peep.getResource(peep)

	local dummy = gameDB:getRecord("Dummy", { Resource = resource })
	local distance = dummy and dummy:get("AttackDistance")
	return ((not distance or distance == 0) and nil) or distance
end

function Utility.Peep.Dummy.getProjectile(peep)
	local gameDB = peep:getDirector():getGameDB()
	local resource = Utility.Peep.getResource(peep)

	local dummy = gameDB:getRecord("Dummy", { Resource = resource })
	local projectile = dummy and dummy:get("AttackProjectile")
	
	return projectile
end

function Utility.Peep.Dummy:onFinalize()
	local gameDB = self:getDirector():getGameDB()
	local resource = Utility.Peep.getResource(self)

	if not resource then
		return
	end

	local dummy = gameDB:getRecord("Dummy", {
		Resource = resource
	})

	if not dummy then
		return
	end

	local hitpoints = dummy:get("Hitpoints")
	if hitpoints > 0 then
		local _, c = self:addBehavior(CombatStatusBehavior)
		c.currentHitpoints = hitpoints
		c.maximumHitpoints = hitpoints
	end

	local chaseDistance = dummy:get("ChaseDistance")
	if chaseDistance > 0 then
		local _, c = self:addBehavior(CombatStatusBehavior)
		c.maxChaseDistance = chaseDistance
	end

	local size = dummy:get("Size")
	if size > 0 then
		local _, s = self:addBehavior(ScaleBehavior)
		s.scale = Vector(size)
	end

	local style = dummy:get("CombatStyle")
	local tier = math.max(math.floor(dummy:get("Tier") / 10), 1)

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor
	if not actor then
		return
	end

	local Equipment = require "ItsyScape.Game.Equipment"

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Human.lskel")
	actor:setBody(body)

	Utility.Peep.Human.applySkin(
		self,
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Head/Dummy.lua",
		{ Utility.Peep.Human.Palette.SKIN_MEDIUM })
	Utility.Peep.Human.applySkin(
		self,
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shirts/Dummy.lua",
		{ Utility.Peep.Human.Palette.SKIN_MEDIUM })
	Utility.Peep.Human.applySkin(
		self,
		Equipment.PLAYER_SLOT_HEAD,
		math.huge,
		"PlayerKit2/Eyes/Eyes.lua",
		{ Utility.Peep.Human.Palette.ACCENT_PINK, Utility.Peep.Human.Palette.EYE_BLACK, Utility.Peep.Human.Palette.EYE_WHITE })
	Utility.Peep.Human.applySkin(
		self,
		Equipment.PLAYER_SLOT_HANDS,
		Equipment.SKIN_PRIORITY_BASE, 
		"PlayerKit2/Hands/Dummy.lua",
		{ Utility.Peep.Human.Palette.SKIN_MEDIUM })
	Utility.Peep.Human.applySkin(
		self,
		Equipment.PLAYER_SLOT_FEET,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shoes/Dummy.lua",
		{ Utility.Peep.Human.Palette.SKIN_MEDIUM })

	if dummy:get("Shield") ~= "" and not Class.isCompatibleType(self, require "ItsyScape.Peep.Peeps.Player") then
		local shieldSkin = CacheRef(
			"ItsyScape.Game.Skin.ModelSkin",
			"Resources/Game/Skins/Wooden/Shield.lua")
		actor:setSkin(Equipment.PLAYER_SLOT_RIGHT_HAND, Equipment.SKIN_PRIORITY_EQUIPMENT, shieldSkin)
	end

	if Class.isCompatibleType(self, require "ItsyScape.Peep.Peeps.Player") then
		local broker = self:getDirector():getItemBroker()
		local equipment = self:getBehavior(EquipmentBehavior)

		local shield = dummy:get("Shield")
		if shield ~= "" then
			local transaction = broker:createTransaction()
			transaction:addParty(equipment.equipment)
			transaction:spawn(equipment.equipment, shield, 1, false)
			transaction:commit()
		end

		local weapon = dummy:get("Weapon")
		if weapon ~= "" then
			local transaction = broker:createTransaction()
			transaction:addParty(equipment.equipment)
			transaction:spawn(equipment.equipment, weapon, 1, false)
			transaction:commit()
		end
	else
		local walkAnimation = CacheRef(
			"ItsyScape.Graphics.AnimationResource",
			"Resources/Game/Animations/Human_Walk_1/Script.lua")
		self:addResource("animation-walk", walkAnimation)
		local idleAnimation = CacheRef(
			"ItsyScape.Graphics.AnimationResource",
			"Resources/Game/Animations/Human_Idle_1/Script.lua")
		self:addResource("animation-idle", idleAnimation)
		local dieAnimation = CacheRef(
			"ItsyScape.Graphics.AnimationResource",
			"Resources/Game/Animations/Human_Die_1/Script.lua")
		self:addResource("animation-die", dieAnimation)

		local animation = Utility.Peep.Dummy.ANIMATIONS[style]
		if animation then
			local attackAnimation = CacheRef(
				"ItsyScape.Graphics.AnimationResource",
				string.format("Resources/Game/Animations/%s/Script.lua", animation))
			self:addResource("animation-attack", attackAnimation)
		end

		local skins = Utility.Peep.Dummy.TIERS[style]
		local skin = skins and skins[tier]

		if skins and skin then
			local weaponSkin = CacheRef(
				"ItsyScape.Game.Skin.ModelSkin",
				string.format("Resources/Game/Skins/%s/%s.lua", skin, skins.base))
			actor:setSkin(Equipment.PLAYER_SLOT_RIGHT_HAND, Equipment.SKIN_PRIORITY_EQUIPMENT, weaponSkin)
		end

		local shield = dummy:get("Shield")
		if shield ~= "" then
			local shieldSkin = CacheRef(
				"ItsyScape.Game.Skin.ModelSkin",
				"Resources/Game/Skins/Wooden/Shield.lua")
			actor:setSkin(Equipment.PLAYER_SLOT_RIGHT_HAND, Equipment.SKIN_PRIORITY_EQUIPMENT, shieldSkin)

			Utility.Peep.equipXShield(self, shield)
		end

		local weapon = dummy:get("Weapon")
		if weapon ~= "" then
			Utility.Peep.equipXWeapon(self, weapon)
		else
			weapon = Utility.Peep.Dummy.WEAPONS[style]
			if weapon then
				Utility.Peep.equipXWeapon(self, weapon)
			end
		end
	end
end

Utility.Peep.Creep = {}

function Utility.Peep.Creep.addAnimation(peep, name, animation)
	Utility.Peep.Human.addAnimation(peep, name, animation)
end

function Utility.Peep.Creep.applySkin(...)
	Utility.Peep.Human.applySkin(...)
end

function Utility.Peep.Creep.setBody(peep, body)
	local filename = string.format("Resources/Game/Bodies/%s.lskel", body)
	if not love.filesystem.getInfo(filename) then
		Log.error("Cannot set body '%s' for peep '%s': file '%s' not found!", body, peep:getName(), filename)
		return false
	end

	local actor = peep:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	if not actor then
		return false
	end

	actor:setBody(CacheRef("ItsyScape.Game.Body", filename))
end

function Utility.Peep.Creep:applySkins()
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor

		local function applySkins(resource)
			local skins = gameDB:getRecords("PeepSkin", {
				Resource = resource
			})

			for i = 1, #skins do
				local skin = skins[i]
				if skin:get("Type") and skin:get("Filename") then
					local c = CacheRef(skin:get("Type"), skin:get("Filename"))
					actor:setSkin(skin:get("Slot"), skin:get("Priority"), c)
				end
			end
		end

		local resource = Utility.Peep.getResource(self)
		if resource then
			local resourceType = gameDB:getBrochure():getResourceTypeFromResource(resource)
			if resourceType.name:lower() == "peep" then
				applySkins(resource)
			end
		end

		local mapObject = Utility.Peep.getMapObject(self)
		if mapObject then
			applySkins(mapObject)
		end
	end
end

Utility.Peep.Human = {}
Utility.Peep.Human.Palette = {
	SKIN_LIGHT = Color.fromHexString("efe3a9"),
	SKIN_MEDIUM = Color.fromHexString("c5995f"),
	SKIN_DARK = Color.fromHexString("a4693c"),
	SKIN_PLASTIC = Color.fromHexString("ffcc00"),
	SKIN_ZOMBI = Color.fromHexString("bf50d9"),
	SKIN_NYMPH = Color.fromHexString("cdde87"),

	HAIR_BROWN = Color.fromHexString("6c4527"),
	HAIR_BLACK = Color.fromHexString("3e3e3e"),
	HAIR_GREY = Color.fromHexString("cccccc"),
	HAIR_BLONDE = Color.fromHexString("ffee00"),
	HAIR_PURPLE = Color.fromHexString("8358c3"),
	HAIR_RED = Color.fromHexString("d45500"),
	HAIR_GREEN = Color.fromHexString("8dd35f"),

	EYE_BLACK = Color.fromHexString("000000"),
	EYE_WHITE = Color.fromHexString("ffffff"),

	BONE = Color.fromHexString("e9ddaf"),
	BONE_ANCIENT = Color.fromHexString("939dac"),

	PRIMARY_RED = Color.fromHexString("cb1d1d"),
	PRIMARY_GREEN = Color.fromHexString("abc837"),
	PRIMARY_BLUE = Color.fromHexString("3771c8"),
	PRIMARY_YELLOW = Color.fromHexString("ffcc00"),
	PRIMARY_PURPLE = Color.fromHexString("855ad8"),
	PRIMARY_PINK = Color.fromHexString("ffd5e5"),
	PRIMARY_BROWN = Color.fromHexString("76523c"),
	PRIMARY_WHITE = Color.fromHexString("ebf7f9"),
	PRIMARY_GREY = Color.fromHexString("cccccc"),
	PRIMARY_BLACK = Color.fromHexString("4d4d4d"),

	ACCENT_GREEN = Color.fromHexString("8dd35f"),
	ACCENT_PINK = Color.fromHexString("ff2a7f"),
}

function Utility.Peep.Human:addAnimation(name, animation)
	local filename = string.format("Resources/Game/Animations/%s/Script.lua", animation)
	if not love.filesystem.getInfo(filename) then
		Log.error("Cannot add animation '%s' as resource '%s' for peep '%s': file '%s' not found!", animation, name, peep:getName(), filename)
		return false
	end

	local animation = CacheRef("ItsyScape.Graphics.AnimationResource", filename)
	self:addResource(name, animation)
end

function Utility.Peep.Human:applySkin(slot, priority, relativeFilename, colorConfig)
	colorConfig = colorConfig or {}

	local remappedColorConfig = {}
	for _, color in ipairs(colorConfig) do
		table.insert(remappedColorConfig, { color:get() })
	end

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	if not actor then
		return false
	end

	local filename = string.format("Resources/Game/Skins/%s", relativeFilename)
	if not love.filesystem.getInfo(filename) then
		error(string.format("Could not find skin '%s'!", filename))
	end

	local skin = CacheRef("ItsyScape.Game.Skin.ModelSkin", filename)
	actor:setSkin(slot, priority, skin, remappedColorConfig)

	return true
end

function Utility.Peep.Human:applySkins()
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor

		local body = CacheRef(
			"ItsyScape.Game.Body",
			"Resources/Game/Bodies/Human.lskel")
		actor:setBody(body)

		local function applySkins(resource)
			local skins = gameDB:getRecords("PeepSkin", {
				Resource = resource
			})

			for i = 1, #skins do
				local skin = skins[i]
				if skin:get("Type") and skin:get("Filename") then
					local colors = gameDB:getRecords("PeepSkinColor", {
						Resource = resource,
						Slot = skin:get("Slot"),
						Priority = skin:get("Priority")
					})

					local colorConfig = {}
					for _, color in ipairs(colors) do
						local key = color:get("Color")
						local c = Utility.Peep.Human.Palette[key] or Color.fromHexString(key) or Color(1, 0, 0)

						local h = color:get("H")
						local s = color:get("S")
						local l = color:get("L")

						table.insert(colorConfig, { c:shiftHSL(h, s, l):get() })
					end

					local c = CacheRef(skin:get("Type"), skin:get("Filename"))
					actor:setSkin(skin:get("Slot"), skin:get("Priority"), c, colorConfig)
				end
			end
		end

		local resource = Utility.Peep.getResource(self)
		if resource then
			local resourceType = gameDB:getBrochure():getResourceTypeFromResource(resource)
			if resourceType.name:lower() == "peep" then
				applySkins(resource)
			end
		end

		local mapObject = Utility.Peep.getMapObject(self)
		if mapObject then
			applySkins(mapObject)
		end
	end
end

function Utility.Peep.Human:onFinalize(director)
	local stats = self:getBehavior(StatsBehavior)
	if stats and stats.stats then
		stats.stats.onXPGain:register(function(_, skill, xp)
			stats.pendingXP[skill:getName()] = (stats.pendingXP[skill:getName()] or 0) + xp
		end)
	end

	Utility.Peep.Human.applySkins(self)
end

function Utility.Peep.Human:flashXP()
	local pendingXP = self:hasBehavior(StatsBehavior) and self:getBehavior(StatsBehavior).pendingXP

	if pendingXP and next(pendingXP) then
		local actor = self:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor

		if actor then
			local skills = {}
			for skillName in pairs(pendingXP) do
				table.insert(skills, skillName)
			end

			table.sort(skills)

			for _, skillName in ipairs(skills) do
				actor:flash("XPPopup", 1, skillName, pendingXP[skillName])
			end
		end

		table.clear(pendingXP)
	end
end

function Utility.Peep.makeHuman(peep)
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

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Walk_1/Script.lua")
	peep:addResource("animation-walk", walkAnimation)
	local walkBlunderbussAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_WalkBlunderbuss_1/Script.lua")
	peep:addResource("animation-walk-blunderbuss", walkBlunderbussAnimation)
	peep:addResource("animation-walk-musket", walkBlunderbussAnimation)
	local walkCaneAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_WalkCane_1/Script.lua")
	peep:addResource("animation-walk-cane", walkCaneAnimation)
	local tripAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Trip_1/Script.lua")
	peep:addResource("animation-trip", tripAnimation)
	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Idle_1/Script.lua")
	peep:addResource("animation-idle", idleAnimation)
	local idleCaneAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_IdleCane_1/Script.lua")
	peep:addResource("animation-idle-cane", idleCaneAnimation)
	local idleZweihanderAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_IdleZweihander_1/Script.lua")
	peep:addResource("animation-idle-zweihander", idleZweihanderAnimation)
	local idleBlunderbussAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_IdleBlunderbuss_1/Script.lua")
	peep:addResource("animation-idle-blunderbuss", idleBlunderbussAnimation)
	peep:addResource("animation-idle-musket", idleBlunderbussAnimation)
	local idleFishingRodAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_IdleFishingRod_1/Script.lua")
	peep:addResource("animation-idle-fishing-rod", idleFishingRodAnimation)
	local idleFlamethrowerAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_IdleFlamethrower_1/Script.lua")
	peep:addResource("animation-idle-flamethrower", idleFlamethrowerAnimation)
	local actionOpen = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionOpen_1/Script.lua")
	peep:addResource("animation-action-open", actionOpen)
	local actionClose = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionClose_1/Script.lua")
	peep:addResource("animation-action-close", actionClose)
	local actionBury = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionBury_1/Script.lua")
	peep:addResource("animation-action-bury", actionBury)
	local actionPick = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionBury_1/Script.lua")
	peep:addResource("animation-action-pick", actionPick)
	local actionCook = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionCook_1/Script.lua")
	peep:addResource("animation-action-cook", actionCook)
	local actionMilk = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionCook_1/Script.lua")
	peep:addResource("animation-action-milk", actionMilk)
	local actionLightProp = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionBurn_1/Script.lua")
	peep:addResource("animation-action-light_prop", actionLightProp)
	local actionLight = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionBurn_1/Script.lua")
	peep:addResource("animation-action-light", actionLight)
	local actionBurn = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionBurn_1/Script.lua")
	peep:addResource("animation-action-burn", actionBurn)
	local actionChurn = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionCook_1/Script.lua")
	peep:addResource("animation-action-churn", actionChurn)
	local actionCraft = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionCraft_1/Script.lua")
	peep:addResource("animation-action-craft", actionCraft)
	local actionEat = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionEat_1/Script.lua")
	peep:addResource("animation-action-enchant", actionEat)
	local actionEnchant = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionEnchant_1/Script.lua")
	peep:addResource("animation-action-enchant", actionEnchant)
	local actionFletch = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionFletch_1/Script.lua")
	peep:addResource("animation-action-fletch", actionFletch)
	local actionMix = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionMix_1/Script.lua")
	peep:addResource("animation-action-mix", actionMix)
	local actionPet = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionPet_1/Script.lua")
	peep:addResource("animation-action-pet", actionPet)
	local actionPray = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionPray_1/Script.lua")
	peep:addResource("animation-action-pray", actionPray)
	local actionPray = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionPray_1/Script.lua")
	peep:addResource("animation-action-offer", actionPray)
	local actionShake = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionShake_1/Script.lua")
	peep:addResource("animation-action-shake", actionShake)
	local actionSmelt = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionSmelt_1/Script.lua")
	peep:addResource("animation-action-smelt", actionSmelt)
	local actionSmith = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionSmith_1/Script.lua")
	peep:addResource("animation-action-smith", actionSmith)
	local defendShieldRightAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Defend_Shield_Right_1/Script.lua")
	peep:addResource("animation-defend-shield-right", defendShieldRightAnimation)
	local defendShieldLeftAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Defend_Shield_Left_1/Script.lua")
	peep:addResource("animation-defend-shield-left", defendShieldLeftAnimation)
	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Die_1/Script.lua")
	peep:addResource("animation-die", dieAnimation)
	local resurrectAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Resurrect_1/Script.lua")
	peep:addResource("animation-resurrect", resurrectAnimation)
	local attackAnimationBoomerangRanged = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackBoomerangRanged_1/Script.lua")
	peep:addResource("animation-attack-ranged-boomerang", attackAnimationBoomerangRanged)
	local attackAnimationBowRanged = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackBowRanged_1/Script.lua")
	peep:addResource("animation-attack-ranged-bow", attackAnimationBowRanged)
	local attackAnimationBlunderbussRanged = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackBlunderbussRanged_1/Script.lua")
	peep:addResource("animation-attack-ranged-blunderbuss", attackAnimationBlunderbussRanged)
	peep:addResource("animation-attack-ranged-musket", attackAnimationBlunderbussRanged)
	local attackAnimationLongbowRanged = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackBowRanged_1/Script.lua")
	peep:addResource("animation-attack-ranged-longbow", attackAnimationLongbowRanged)
	local attackAnimationFlamethrowerRanged = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackFlamethrowerRanged_1/Script.lua")
	peep:addResource("animation-attack-ranged-flamethrower", attackAnimationFlamethrowerRanged)
	local attackAnimationGrenadeRanged = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackGrenadeRanged_1/Script.lua")
	peep:addResource("animation-attack-ranged-grenade", attackAnimationGrenadeRanged)
	local attackAnimationPistolRanged = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackPistolRanged_1/Script.lua")
	peep:addResource("animation-attack-ranged-pistol", attackAnimationPistolRanged)
	local attackAnimationStaffCrush = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackStaffCrush_1/Script.lua")
	peep:addResource("animation-attack-crush-staff", attackAnimationStaffCrush)
	local attackAnimationStaffMagic = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackStaffMagic_1/Script.lua")
	peep:addResource("animation-attack-magic-staff", attackAnimationStaffMagic)
	local attackAnimationStaff = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackStaffMagic_1/Script.lua")
	peep:addResource("animation-attack-staff", attackAnimationStaff)
	local attackAnimationWandStab = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackWandStab_1/Script.lua")
	peep:addResource("animation-attack-stab-wand", attackAnimationWandStab)
	local attackAnimationWandMagic = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackWandMagic_1/Script.lua")
	peep:addResource("animation-attack-magic-wand", attackAnimationWandMagic)
	local attackAnimationWand = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackStaffMagic_1/Script.lua")
	peep:addResource("animation-attack-magic-wand", attackAnimationWand)
	local attackAnimationCaneSlash = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackCaneSlash_1/Script.lua")
	peep:addResource("animation-attack-slash-cane", attackAnimationCaneSlash)
	local attackAnimationCaneMagic = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackCaneMagic_1/Script.lua")
	peep:addResource("animation-attack-magic-cane", attackAnimationCaneMagic)
	local attackAnimationCane = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackCaneMagic_1/Script.lua")
	peep:addResource("animation-attack-cane", attackAnimationCane)
	local attackAnimationPickaxeStab = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackPickaxeStab_1/Script.lua")
	peep:addResource("animation-attack-stab-pickaxe", attackAnimationPickaxeStab)
	local attackAnimationHatchetSlash = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackHatchetSlash_1/Script.lua")
	peep:addResource("animation-attack-slash-hatchet", attackAnimationHatchetSlash)
	local attackAnimationLongswordSlash = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackLongswordSlash_1/Script.lua")
	peep:addResource("animation-attack-slash-longsword", attackAnimationLongswordSlash)
	local attackAnimationMaceCrush = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackMaceCrush_1/Script.lua")
	peep:addResource("animation-attack-crush-mace", attackAnimationMaceCrush)
	local attackAnimationDaggerStab = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackDaggerStab_1/Script.lua")
	peep:addResource("animation-attack-stab-dagger", attackAnimationDaggerStab)	
	local attackAnimationDaggerSlash = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackDaggerSlash_1/Script.lua")
	peep:addResource("animation-attack-slash-dagger", attackAnimationDaggerSlash)
	local attackAnimationZweihanderSlash = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackZweihanderSlash_1/Script.lua")
	peep:addResource("animation-attack-slash-zweihander", attackAnimationZweihanderSlash)
	local attackAnimationZweihanderStab = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackZweihanderStab_1/Script.lua")
	peep:addResource("animation-attack-stab-zweihander", attackAnimationZweihanderStab)
	local attackAnimationFishingRodCrush = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackFishingRodCrush_1/Script.lua")
	peep:addResource("animation-attack-crush-fishing-rod", attackAnimationFishingRodCrush)
	local attackAnimationCrushUnarmed = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackUnarmedCrush_1/Script.lua")
	peep:addResource("animation-attack-crush-none", attackAnimationCrushUnarmed)
	local skillAnimationMine = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_SkillMine_1/Script.lua")
	peep:addResource("animation-skill-mining", skillAnimationMine)
	local skillAnimationFish = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_SkillFish_FishingRod_1/Script.lua")
	peep:addResource("animation-skill-fishing", skillAnimationFish)
	local skillAnimationWoodcutting = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_SkillWoodcut_1/Script.lua")
	peep:addResource("animation-skill-woodcutting", skillAnimationWoodcutting)
	local jumpAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Jump_1/Script.lua")
	peep:addResource("animation-jump", jumpAnimation)

	peep:listen('finalize', Utility.Peep.Human.onFinalize)
end

Utility.Peep.Character = {}

local function _tryMakeCharacter(peep, resource)
	if not resource then
		return false
	end

	local gameDB = peep:getDirector():getGameDB()
	local character = gameDB:getRecord("PeepCharacter", {
		Peep = resource
	})

	if character then
		local _, c = peep:addBehavior(CharacterBehavior)
		c.character = character:get("Character")

		return true
	end

	return false
end

function Utility.Peep.Character:onFinalize()
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)

	if not (_tryMakeCharacter(self, mapObject) or _tryMakeCharacter(self, resource)) then
		return
	end

	local character = Utility.Peep.getCharacter(self)
	local teamRecords = character and self:getDirector():getGameDB():getRecords("CharacterTeam", {
		Character = character
	})

	if not teamRecords then
		return
	end

	local _, teams = self:addBehavior(TeamBehavior)
	for _, teamRecord in ipairs(teamRecords) do
		local team = teamRecord:get("Team").name

		local hasTeam = false
		for _, otherTeam in ipairs(teams.teams) do
			if otherTeam == team then
				hasTeam = true
				break
			end
		end

		if not hasTeam then
			Log.info("Peep '%s' (character = '%s') is on team '%s'.", self:getName(), character.name, team)
			table.insert(teams.teams, team)
		end
	end
end

function Utility.Peep.makeCharacter(peep)
	peep:addBehavior(TeamBehavior)
	peep:listen('finalize', Utility.Peep.Character.onFinalize)
end

Utility.Boss = {}
function Utility.Boss.getBoss(target)
	local resource = Utility.Peep.getResource(target)

	local boss = resource and target:getDirector():getGameDB():getRecord("Boss", {
		Target = resource
	})

	return boss and boss:get("Boss")
end

function Utility.Boss.isBoss(target)
	return Utility.Boss.getBoss(target) ~= nil
end

function Utility.Boss.isLegendary(gameDB, itemID)
	local legendaryLootCategory = gameDB:getResource("Legendary", "LootCategory")
	local itemResource = gameDB:getResource(itemID, "Item")
	local isLegendary = gameDB:getRecord("LootCategory", {
		Item = itemResource,
		Category = legendaryLootCategory
	})

	return legendaryLootCategory and itemResource and isLegendary
end

function Utility.Boss.isSpecial(gameDB, itemID)
	local specialLootCategory = gameDB:getResource("Special", "LootCategory")
	local itemResource = gameDB:getResource(itemID, "Item")
	local isSpecial = gameDB:getRecord("LootCategory", {
		Item = itemResource,
		Category = specialLootCategory
	})

	return specialLootCategory and itemResource and isSpecial
end

function Utility.Boss.recordKill(peep, target)
	local boss = Utility.Boss.getBoss(target)
	if not boss then
		return
	end

	local storage = Utility.Peep.getStorage(peep):getSection("Bosses")
	local bossStorage = storage:getSection(boss.name)

	bossStorage:set("count", (bossStorage:get("count") or 0) + 1)
end

function Utility.Boss.recordDrop(peep, target, itemID, itemCount)
	local boss = Utility.Boss.getBoss(target)
	if not boss then
		return
	end

	local storage = Utility.Peep.getStorage(peep):getSection("Bosses")
	local bossStorage = storage:getSection(boss.name)
	local dropStorage = bossStorage:getSection("Drops"):getSection(itemID)

	dropStorage:set({ count = (dropStorage:get("count") or 0) + itemCount })
end

function Utility.Boss.getDrops(peep, boss)
	if type(boss) == 'string' then
		boss = peep:getDirector():getGameDB():getResource(boss, "Boss")
	end

	if not boss then
		return {}
	end

	local storage = Utility.Peep.getStorage(peep):getSection("Bosses")
	local bossStorage = storage:getSection(boss.name)
	return bossStorage:getSection("Drops"):get()
end

function Utility.Boss.getKillCount(peep, boss)
	if type(boss) == 'string' then
		boss = peep:getDirector():getGameDB():getResource(boss, "Boss")
	end

	if not boss then
		return 0
	end

	local storage = Utility.Peep.getStorage(peep):getSection("Bosses")
	local bossStorage = storage:getSection(boss.name)
	return bossStorage:get("count") or 0
end

Utility.Quest = {}

function Utility.Quest.isNextStep(quest, step, peep)
	local nextStep = { Utility.Quest.getNextStep(quest, peep) }
	nextStep = nextStep[#nextStep]

	local isBranch = #nextStep > 1
	for i = 1, #nextStep do
		isBranch = isBranch and type(nextStep[i]) == 'table'
	end

	if isBranch then
		for _, branch in ipairs(nextStep) do
			if branch[1][1].name == step then
				return true
			end
		end
	else
		for _, keyItem in ipairs(nextStep) do
			if keyItem.name == step then
				return true
			end
		end
	end

	return false
end

function Utility.Quest._getNextStep(steps, peep, isBranch)
	for index = 1, #steps do
		local step = steps[index]

		local numStepsCompleted = 0
		for i = 1, #step do
			if type(step[i]) == 'table' then
				local branchSteps = { Utility.Quest._getNextStep(step[i], peep, true) }
				if #branchSteps > 0 then
					local result = {}

					for j = 1, index - 1 do
						table.insert(result, steps[j])
					end

					for j = 1, #branchSteps do
						table.insert(result, branchSteps[j])
					end

					return unpack(result)
				end
			else
				if peep:getState():has("KeyItem", step[i].name) then
					numStepsCompleted = numStepsCompleted + 1
				end
			end
		end

		if numStepsCompleted < #step then
			if index == 1 and isBranch then
				return nil
			end

			return unpack(steps, 1, index)
		end
	end

	return unpack(steps)
end

function Utility.Quest.getNextStep(quest, peep)
	local steps
	if type(quest) == 'table' then
		steps = quest
	else
		steps = Utility.Quest.build(quest, peep:getDirector():getGameDB())
	end

	return Utility.Quest._getNextStep(steps, peep)
end

function Utility.Quest.build(quest, gameDB)
	if type(quest) == 'string' then
		local resource = gameDB:getResource(quest, "Quest")
		if not resource then
			Log.error("Could not find quest: '%s'", quest)
			return {}
		end

		quest = resource
	end

	local brochure = gameDB:getBrochure()

	local firstStep
	for action in brochure:findActionsByResource(quest) do
		local definition = brochure:getActionDefinitionFromAction(action)
		if definition.name:lower() == 'queststart' then
			for output in brochure:getOutputs(action) do
				local resource = brochure:getConstraintResource(output)
				local resourceType = brochure:getResourceTypeFromResource(resource)
				if resourceType.name:lower() == 'keyitem' then
					firstStep = resource
					break
				end
			end
		end

		if firstStep then
			break
		end
	end

	if not firstStep then
		return { quest = quest, keyItems = {} }
	end

	local nodes = {}
	local keyItems = {}
	do
		local keyItemsEncountered = {}
		local nodesList = gameDB:getRecords("QuestStep", {
			Quest = quest
		})

		for i = 1, #nodesList do
			local node = nodesList[i]
			local id = node:get("StepID")
			local keyItem = node:get("KeyItem")

			local n = nodes[id] or {}
			table.insert(n, {
				id = id,
				quest = quest,
				keyItem = keyItem,
				parentID = node:get("ParentID"),
				nextID = node:get("NextID"),
				previousID = node:get("PreviousID"),
				children = {},
				keyItems = {}
			})

			if not keyItemsEncountered[keyItem.name] then
				table.insert(keyItems, keyItem)
				keyItemsEncountered[keyItem.name] = true
			end

			nodes[id] = n
		end
	end

	local function resolve(currentNodeID)
		local currentNodes = nodes[currentNodeID]

		local parentNodes = {}
		for i = 1, #currentNodes do
			local currentNode = currentNodes[i]
			local parentNodes = nodes[currentNode.parentID]
			local nextNodes = nodes[currentNode.nextID]
			local previousNodes = nodes[currentNode.previousID]

			if parentNodes then
				for j = 1, #parentNodes do
					table.insert(parentNodes[j].children, currentNode)
				end

				currentNode.parent = parentNodes[1]
			end

			currentNode.next = nextNodes and nextNodes[1]
			currentNode.previous = previousNodes and previousNodes[1]

			table.insert(currentNodes[1].keyItems, currentNode.keyItem)
		end
	end

	for i = 1, #nodes do
		resolve(i)
	end

	local id = 1
	local function materialize(node)
		local result = {}

		local current = node
		while current do
			do
				local currentSteps = { id = id }
				id = id + 1

				for i = 1, #current.keyItems do
					currentSteps[i] = current.keyItems[i]
				end
				table.insert(result, currentSteps)
			end

			if #current.children > 0 then
				local nextSteps = { id = id }
				id = id + 1

				for i = 1, #current.children do
					nextSteps[i] = materialize(current.children[i])
				end
				table.insert(result, nextSteps)
			end

			current = current.next
		end

		return result
	end

	local result = materialize(nodes[1] and nodes[1][1])
	result.quest = quest
	result.keyItems = keyItems

	return result
end

function Utility.Quest.buildWorkingQuestLog(steps, gameDB, questInfo)
	questInfo = questInfo or { quest = steps.quest }

	for i = 1, #steps do
		local step = steps[i]
		if #step > 1 then
			local block = { t = 'list' }

			for j = 1, #step do
				if type(step[j]) == 'table' then
					Utility.Quest.buildWorkingQuestLog(step[j], gameDB, questInfo)
				else
					local description1 = Utility.getDescription(step[j], gameDB, nil, 1)
					local description2 = Utility.getDescription(step[j], gameDB, nil, 2)
					table.insert(block, { description1, description2 })
				end
			end

			questInfo[step.id] = { block = block, resources = step }
		else
			questInfo[step.id] = {
				block = {
					{ Utility.getDescription(step[1], gameDB, nil, 1),
					  Utility.getDescription(step[1], gameDB, nil, 2) }
				},
				resources = step
			}
		end
	end

	return questInfo
end

function Utility.Quest.buildRichTextLabelFromQuestLog(questLog, peep, scroll)
	local result = {}

	local steps = { Utility.Quest.getNextStep(questLog.quest, peep) }
	if #steps == 0 then
		steps = {}
	end

	local hasScrolled = false

	for i = 1, #steps do
		local step = steps[i]
		local questLogForStep = questLog[step.id]
		local isChoice = type(step[1]) == 'table'

		if isChoice then
			if i == #steps then
				table.insert(result, { t = 'text', "And so you see multiple possible paths..."})

				local choices = { t = 'list' }
				for j = 1, #step do
					local subStep = step[j][1]
					table.insert(choices, questLog[subStep.id].block[1][1])
				end

				table.insert(result, choices)
			else
				table.insert(result, { t = 'text', "And so you made a choice..."})

				for j = 1, #step do
					local subStep = step[j][1]
					local subStepKeyItem = subStep[1]

					if peep:getState():has("KeyItem", subStepKeyItem.name) then
						table.insert(result, { t = 'text', questLog[subStep.id].block[1][2] })
						break
					end
				end
			end
		else
			local block = {}

			for j = 1, #step do
				if peep:getState():has("KeyItem", step[j].name) then
					table.insert(block, {
						t = "text",
						color = scroll and { 0.75, 0.75, 0.75, 1 },
						questLogForStep.block[j][2]
					})
				else
					table.insert(block, {
						t = "text",
						questLogForStep.block[j][1],
						scroll = not hasScrolled
					})

					if scroll and not hasScrolled then
						hasScrolled = true
					end
				end
			end

			if #block == 1 then
				block.t = 'text'
			else
				block.t = 'list'
			end

			table.insert(result, block)
		end
	end

	return result
end

function Utility.Quest.getStartAction(quest, game)
	local gameDB = game:getGameDB()

	if type(quest) == 'string' then
		quest = gameDB:getResource(quest, "Quest")
	end

	local action
	do
		local actions = Utility.getActions(game, quest, 'quest')
		for i = 1, #actions do
			if actions[i].instance:is('QuestStart') then
				action = actions[i].instance
			end
		end
	end

	if not action then
		Log.warn("No quest start found for %s.", quest.name)
		return nil
	end

	return action
end

function Utility.Quest.getCompleteAction(quest, game)
	local gameDB = game:getGameDB()

	if type(quest) == 'string' then
		quest = gameDB:getResource(quest, "Quest")
	end

	local action
	do
		local actions = Utility.getActions(game, quest, 'quest')
		for i = 1, #actions do
			if actions[i].instance:is('QuestComplete') then
				action = actions[i].instance
			end
		end
	end

	if not action then
		Log.warn("No quest complete found for %s.", quest.name)
		return nil
	end

	return action
end

function Utility.Quest.promptToStart(quest, peep, questGiver)
	local director = peep:getDirector()
	local gameDB = director:getGameDB()
	local game = director:getGameInstance()
	local action = Utility.Quest.getStartAction(quest, game)

	if type(quest) == 'string' then
		quest = gameDB:getResource(quest, "Quest")
	end

	Utility.UI.openInterface(
		peep,
		"QuestAccept",
		true,
		quest,
		action,
		questGiver)
end

function Utility.Quest.complete(quest, peep)
	local action = Utility.Quest.getCompleteAction(quest, peep:getDirector():getGameInstance())
	if action then
		local result = action:perform(peep:getState(), peep)
		if not result then
			Log.warn("Could not complete quest '%s' for peep '%s'", quest.name or quest, peep)
		end
	end
end

function Utility.Quest.didComplete(quest, peep)
	if type(quest) ~= 'string' then
		quest = quest.name
	end

	return peep:getState():has("Quest", quest)
end

function Utility.Quest.didStep(quest, step, peep)
	return peep:getState():has("KeyItem", step)
end

function Utility.Quest.didStart(quest, peep)
	local game = peep:getDirector():getGameInstance()
	local action = Utility.Quest.getStartAction(quest, game)
	return action and action:didStart(peep:getState(), peep)
end

function Utility.Quest.canStart(quest, peep)
	local game = peep:getDirector():getGameInstance()
	local action = Utility.Quest.getStartAction(quest, game)
	if action then
		return action:canPerform(peep:getState())
	end

	return false
end

function Utility.Quest.getDreams(peep)
	local director = peep:getDirector()
	local gameDB = director:getGameDB()

	local dreams = {}
	for dream in gameDB:getResources("Dream") do
		table.insert(dreams, dream)
	end

	return dreams
end

function Utility.Quest.getPendingDreams(peep)
	local director = peep:getDirector()
	local gameDB = director:getGameDB()
	local state = peep:getState()

	local allDreams = Utility.Quest.getDreams(peep)
	local pendingDreams = {}

	for i = 1, #allDreams do
		local dreamRequirement = gameDB:getRecord("DreamRequirement", {
			Dream = allDreams[i]
		})

		if not dreamRequirement then
			Log.warn("Dream '%s' doesn't have a requirement.", allDreams[i].name)
		else
			local keyItemName = dreamRequirement:get("KeyItem").name
			local dreamName = allDreams[i].name

			local hasKeyItem = state:has("KeyItem", keyItemName)
			local hasDreamtDream = state:has("Dream", dreamName)

			if hasKeyItem and not hasDreamtDream then
				table.insert(pendingDreams, allDreams[i])
			end
		end
	end

	return pendingDreams
end

function Utility.Quest.dream(peep, dream)
	local director = peep:getDirector()
	local gameDB = director:getGameDB()

	if type(dream) == 'string' then
		local resource = gameDB:getResource(dream, "Dream")

		if not dream then
			Log.error("Dream '%s' not found.", dream)
			return false
		else
			dream = resource
		end
	end

	local dreamRequirement = gameDB:getRecord("DreamRequirement", {
		Dream = dream
	})

	if not dreamRequirement then
		Log.warn("Dream '%s' doesn't have a requirement.", dream.name)
		return false
	else
		Analytics:dreamed(peep, dream.name)

		local stage = director:getGameInstance():getStage()
		stage:movePeep(
			peep,
			dreamRequirement:get("Map").name,
			dreamRequirement:get("Anchor"))
	end
end

function Utility.Quest.wakeUp(peep)
	local director = peep:getDirector()
	local stage = director:getGameInstance():getStage()

	local storage = director:getPlayerStorage(peep):getRoot()
	local location = storage:getSection("Spawn")

	stage:movePeep(
		peep,
		location:get("name"),
		Vector(location:get("x"), location:get("y"), location:get("z")))
end

function Utility.Quest.listenForAction(peep, resourceType, resourceName, actionType, callback)
	local targetActionInstance
	do
		local director = peep:getDirector()
		local gameDB = director:getGameDB()
		local resource = gameDB:getResource(resourceName, resourceType)
		if not resource then
			Log.warn("Resource '%s' (%s) not found; cannot listen for action.", resourceName, resourceType)
			return false
		end

		local actions = Utility.getActions(director:getGameInstance(), resource)
		for i = 1, #actions do
			if actions[i].instance:is(actionType) then
				targetActionInstance = actions[i].instance
				break
			end
		end

		if not targetActionInstance then
			Log.warn(
				"Couldn't find action '%s' on resource '%s' (%s); cannot listen for action.",
				actionType, resourceName, resourceType)
		end
	end

	local listen, silence

	silence = function()
		peep:silence('actionPerformed', listen)
		peep:silence('move', silence)
	end

	listen = function(_, p)
		if p.action:getID() == targetActionInstance:getID() then
			callback(p.action)

			silence()
		end
	end

	peep:listen('actionPerformed', listen)
	peep:listen('move', silence)
end

function Utility.Quest.listenForItem(peep, itemID, callback)
	local listen, silence

	silence = function()
		peep:silence('transferItemTo', listen)
		peep:silence('spawnItem', listen)
		peep:silence('move', silence)
	end

	listen = function(_, p)
		if p.item:getID() == itemID then
			callback(p.item)
			silence()
		end
	end

	peep:listen('transferItemTo', listen)
	peep:listen('spawnItem', listen)
	peep:listen('move', silence)
end

function Utility.Quest._showKeyItemHint(peep)
	local targetTime = love.timer.getTime() + 2.5

	Utility.UI.openInterface(
		peep,
		"TutorialHint",
		false,
		"QuestProgressNotification",
		nil,
		function()
			return love.timer.getTime() > targetTime
		end)
end

function Utility.Quest.listenForKeyItemHint(peep, quest)
	Utility.Quest.listenForKeyItem(peep, string.format("%s_(.+)", quest), function()
		Utility.Quest._showKeyItemHint(peep)
	end)
end

function Utility.Quest.listenForKeyItem(peep, keyItemID, callback)
	local listen, silence

	silence = function()
		peep:silence('gotKeyItem', listen)
		peep:silence('move', silence)
	end

	listen = function(_, k)
		if k and k:match(keyItemID) then
			if callback() then
				silence()
			end
		end
	end

	peep:listen('gotKeyItem', listen)
	peep:listen('move', silence)
end

return Utility
