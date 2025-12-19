--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Map.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Utility = require "ItsyScape.Game.Utility"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local Map = require "ItsyScape.World.Map"

local UMap = {}

local _sortRayCastRay
local function _sortRayCast(a, b)
	return a.position:distance(_sortRayCastRay.origin) < b.position:distance(_sortRayCastRay.origin)
end

function UMap.castRay(peep, ray, filter)
	local mapScript = Utility.Peep.getMapScript(peep)
	if not mapScript then
		return {}
	end

	local transform = Utility.Peep.getParentTransform(peep)
	ray = ray:transform(transform)

	local stage = peep:getDirector():getGameInstance():getStage()

	local mapScriptLayer = Utility.Peep.getLayer(mapScript)
	local instance = stage:getInstanceByLayer(mapScriptLayer)
	if not instance then
		return {}
	end

	local mapGroup = instance:getMapGroup(mapScriptLayer)
	if not mapGroup then
		return {}
	end

	local results = {}
	for localLayer, layer in instance:iterateMapGroup(mapGroup) do
		local currentMapScript = instance:getMapScriptByLayer(layer)
		local currentTransform = currentMapScript and Utility.Peep.getMapTransform(currentMapScript)

		local instanceMap = instance:getMap(layer)
		local meta = instanceMap and instanceMap:getMeta()

		if not filter or filter(layer, instance, meta) then
			local hits = stage:castAbsoluteMapRay(layer, ray)

			for _, hit in ipairs(hits) do
				table.insert(results, {
					tile = hit[Map.RAY_TEST_RESULT_TILE],
					position = hit[Map.RAY_TEST_RESULT_POSITION]:transform(currentTransform),
					i = hit[Map.RAY_TEST_RESULT_I],
					j = hit[Map.RAY_TEST_RESULT_J],
					layer = layer,
					localLayer = localLayer
				})
			end
		end
	end

	_sortRayCastRay = ray
	table.sort(results, _sortRayCast)

	return results
end

function UMap.getWind(game, layer)
	local instance = game:getStage():getInstanceByLayer(layer)
	local mapInfo = instance and instance:getMap(layer)
	local meta = mapInfo and mapInfo:getMeta()

	return (meta and meta.windDirection and Vector(unpack(meta.windDirection)) or Vector(-1, 0, -1)):getNormal(),
	       meta and meta.windSpeed or 4,
	       meta and meta.windPattern and Vector(unpack(meta.windPattern)) or Vector(5, 10, 15)
end

function UMap.transformWorldPositionByWind(time, windSpeed, windDirection, windPattern, anchorPosition, worldPosition, normal)
	local windRotation = Quaternion.lookAt(Vector.ZERO, windDirection, Vector.UNIT_Y)
	local windDelta = time * windSpeed + worldPosition:getLength() * windSpeed
	local windMu = (math.sin(windDelta / windPattern.x) * math.sin(windDelta / windPattern.y) * math.sin(windDelta / windPattern.z) + 1.0) / 2.0;
	local currentWindRotation = Quaternion.IDENTITY:slerp(windRotation, windMu):getNormal()

	local relativePosition = worldPosition - anchorPosition
	local transformedRelativePosition = currentWindRotation:transformVector(relativePosition)
	normal = currentWindRotation:transformVector(currentWindRotation, normal or Vector.UNIT_Y)

	return transformedRelativePosition + anchorPosition, normal, currentWindRotation
end

function UMap.transformWorldPositionByWave(time, windSpeed, windDirection, windPattern, anchorPosition, worldPosition)
	local windDelta = time * windSpeed
	local windDeltaCoordinate = windDirection * Vector(windDelta) + worldPosition
	local windMu = (math.sin((windDeltaCoordinate.x + windDeltaCoordinate.z) / windPattern.x) * math.sin((windDeltaCoordinate.x + windDeltaCoordinate.z) / windPattern.y) * math.sin((windDeltaCoordinate.x + windDeltaCoordinate.z) / windPattern.z) + 1.0) / 2.0
	
	local distance = (anchorPosition - worldPosition):getLength()
	return worldPosition + Vector(0, distance * windMu, 0)
end

function UMap.calculateWaveNormal(time, windSpeed, windDirection, windPattern, anchorPosition, worldPosition, scale)
	scale = scale or Vector.ONE

	local normalWorldPositionLeft = UMap.transformWorldPositionByWave(
		time,
		windSpeed,
		windDirection,
		windPattern,
		anchorPosition - Vector(scale.x, 0, 0),
		worldPosition - Vector(scale.x, 0, 0))

	local normalWorldPositionRight = UMap.transformWorldPositionByWave(
		time,
		windSpeed,
		windDirection,
		windPattern,
		anchorPosition + Vector(scale.x, 0, 0),
		worldPosition + Vector(scale.x, 0, 0))

	local normalWorldPositionTop = UMap.transformWorldPositionByWave(
		time,
		windSpeed,
		windDirection,
		windPattern,
		anchorPosition - Vector(0, 0, 1),
		worldPosition - Vector(0, 0, scale.z))

	local normalWorldPositionBottom = UMap.transformWorldPositionByWave(
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

function UMap.getTileRotation(map, i, j)
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

function UMap.playCutscene(map, resource, cameraName, player, entities, ...)
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
		entities,
		{ n = select("#", ...), ... })
end

function UMap.getTilePosition(director, i, j, layer)
	local stage = director:getGameInstance():getStage()
	local center = stage:getMap(layer) and stage:getMap(layer):getTileCenter(i, j)
	return center or Vector.ZERO
end

function UMap.absolutePositionToRelativePosition(director, layer, position)
	local stage = director:getGameInstance():getStage()
	local instance = stage:getInstanceByLayer(layer)
	local mapScript = instance and instance:getMapScriptByLayer(layer)

	if not mapScript then
		return Vector.ZERO
	end

	local transform = Utility.Peep.getMapTransform(mapScript)
	return position:inverseTransform(transform)
end

function UMap.getAbsoluteTilePosition(director, i, j, layer)
	local stage = director:getGameInstance():getStage()
	local instance = stage:getInstanceByLayer(layer)
	local mapScript = instance and instance:getMapScriptByLayer(layer)

	local map = stage:getMap(layer)
	local center = (map and map:getTileCenter(i, j)) or Vector.ZERO
	center = center + (Vector(map and map:getCellSize() or 0) * Vector(i - math.floor(i), 0, j - math.floor(j)))

	if not mapScript then
		return center
	else
		local transform = Utility.Peep.getMapTransform(mapScript)
		return center:transform(transform)
	end
end

function UMap.getAbsolutePosition(director, position, layer)
	local stage = director:getGameInstance():getStage()
	local instance = stage:getInstanceByLayer(layer)
	local mapScript = instance and instance:getMapScriptByLayer(layer)

	if not mapScript then
		return position
	end

	local transform = Utility.Peep.getMapTransform(mapScript)
	return position:transform(transform)
end

function UMap.getMapObject(game, map, name)
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

function UMap.hasAnchor(game, map, anchor)
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

function UMap.getAnchorPosition(game, map, anchor)
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

function UMap.getAnchorRotation(game, map, anchor)
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

function UMap.getAnchorScale(game, map, anchor)
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

function UMap.getAnchorDirection(game, map, anchor)
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

function UMap.spawnMap(peep, map, position, args)
	local stage = peep:getDirector():getGameInstance():getStage()
	local instance = stage:getPeepInstance(peep)
	local mapLayer, mapScript = stage:loadMapResource(instance, map, args)

	local _, p = mapScript:addBehavior(PositionBehavior)
	p.position = position or Vector.ZERO

	return mapLayer, mapScript
end

function UMap.spawnShip(peep, shipName, layer, i, j, elevation, args)
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
function UMap.getRandomTile(map, i, j, distance, checkLineOfSight, rng, flags, ...)
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
function UMap.getRandomPosition(map, position, distance, checkLineOfSight, rng, ...)
	local _, tileI, tileJ = map:getTileAt(position.x, position.z)
	local i, j = UMapgetRandomTile(map, tileI, tileJ, math.max(distance / map:getCellSize(), math.sqrt(2)), checkLineOfSight, rng, ...)

	if i and j then
		return map:getTileCenter(i, j)
	end

	return nil
end

function UMap.getGlobalLayerFromLocalLayer(mapScript, localLayer)
	local mapScriptLayer = Utility.Peep.getLayer(mapScript)
	local instance = mapScript:getDirector():getGameInstance():getStage():getInstanceByLayer(mapScriptLayer)
	if not instance then
		return
	end

	local mapGroup = instance:getMapGroup(mapScriptLayer)
	if not mapGroup then
		return 1
	end

	return instance:getGlobalLayerFromLocalLayer(mapGroup, localLayer)
end

return UMap
