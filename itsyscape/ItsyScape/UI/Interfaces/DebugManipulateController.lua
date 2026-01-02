--------------------------------------------------------------------------------
-- ItsyScape/UI/DebugManipulateController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Probe = require "ItsyScape.Peep.Probe"
local ActiveSpellBehavior = require "ItsyScape.Peep.Behaviors.ActiveSpellBehavior"
local ManipulatedBehavior = require "ItsyScape.Peep.Behaviors.ManipulatedBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local Controller = require "ItsyScape.UI.Controller"

local DebugManipulateController = Class(Controller)

function DebugManipulateController:new(peep, director)
	Controller.new(self, peep, director)

	self.isRecording = false
	self.peepToID = {}
	self.idToPeep = {}

	self.isReplaying = false

	self:getPeep():listen("actionTried", self._onPeepTryAction, self)
	self:getPeep():listen("walk", self._onPeepWalk, self)

	self:recordPeep(self:getPeep(), -1)
	self:pullExistingPeeps()
	self:populate()
end

function DebugManipulateController:_onPeepTryAction(_, poke)
	if poke.pending then
		return
	end

	if not self.isRecording then
		return
	end

	local brochure = self:getGame():getGameDB():getBrochure()

	local actionID = Mapp.ID(poke.actionID)
	local _, action = brochure:tryGetAction(actionID)
	if not action then
		return
	end

	local actionDefinition = brochure:getActionDefinitionFromAction(action)

	local object = poke.object
	local objectPeep = object and object:getPeep()

	local resource = Utility.Peep.getResource(objectPeep)
	local mapObject = Utility.Peep.getMapObject(objectPeep)

	local targetResource, targetResourceActionIndex
	for otherResource in brochure:findResourcesByAction(action) do
		if (otherResource and otherResource.id.value == resource.id.value) or (mapObject and otherResource.id.value == mapObject.id.value) then
			local otherActionIndex = 0
			for otherAction in brochure:findActionsByResource(otherResource) do
				local otherActionDefinition = brochure:getActionDefinitionFromAction(otherAction)
				if otherActionDefinition.name == actionDefinition.name then
					otherActionIndex = otherActionIndex + 1
				end

				if otherAction.id.value == action.id.value then
					targetResource = otherResource
					targetResourceActionIndex = otherActionIndex
					break
				end
			end
		end

		if targetResource and targetResourceActionIndex then
			break
		end
	end

	if not (targetResource and targetResourceActionIndex) then
		return
	end

	local objectTargetInfo = self:getTargetInfo(objectPeep)
	local objectMapInfo = self:getMapInfo(Utility.Peep.getLayer(objectPeep))

	local targetResourceType = brochure:getResourceTypeFromResource(targetResource)

	self:record(Utility.Peep.getLayer(self:getPeep()), self:getPeep(), "performAction", {
		targetMapObjectName = objectTargetInfo.mapObjectName,
		targetPeepID = objectTargetInfo.peepID,
		targetMapResource = objectMapInfo.resource,
		targetMapLocalLayer = objectMapInfo.localLayer,
		targetResourceType = targetResourceType.name,
		actionDefinition = actionDefinition.name,
		actionIndex = targetResourceActionIndex
	})
end

function DebugManipulateController:_onPeepWalk(_, poke)
	if not (poke.position and poke.layer) then
		return
	end

	if not self.isRecording then
		return
	end

	local targetMapInfo = self:getMapInfo(poke.layer)
	self:record(Utility.Peep.getLayer(self:getPeep()), self:getPeep(), "walk", {
		targetMapResource = targetMapInfo.resource,
		targetMapLocalLayer = targetMapInfo.localLayer,
		positionX = poke.position.x,
		positionY = poke.position.y,
		positionZ = poke.position.z
	})
end

function DebugManipulateController:pullExistingPeeps()
	local peeps = self:getDirector():probe(
		self:getPeep():getLayerName(),
		Probe.behavior(ManipulatedBehavior))

	for _, peep in ipairs(peeps) do
		local b = peep:getBehavior(ManipulatedBehavior)
		if b.debugID and b.owner == self:getPeep() then
			self:recordPeep(peep, b.debugID)
		end
	end
end

function DebugManipulateController:populate()
	self.layers = {}
	self.presets = {}

	local instance = Utility.Peep.getInstance(self:getPeep())
	for groupIndex, groupLayers in instance:iterateMapGroups() do
		local mapScript = groupLayers[1] and instance:getMapScriptByLayer(groupLayers[1])
		local resource = mapScript and Utility.Peep.getResource(mapScript)

		if mapScript and resource then
			table.insert(self.layers, resource.name)

			local mapStorage = self:getMapStorage(resource.name)
			for i = 1, mapStorage:length() do
				local presetStorage = mapStorage:getSection(i)
				local preset = {
					resource = resource.name,
					index = i,
					id = presetStorage:get("id")
				}

				table.insert(self.presets, preset)
			end
		end
	end

	self:send("populatePresets", self.presets)
end

function DebugManipulateController:getMapStorage(mapResourceName)
	local storage = self:getDirector():getPlayerStorage(self:getPeep())
	local manipulateStorage = storage:getRoot():getSection("UI"):getSection("DebugManipulate")
	if not mapResourceName then
		return manipulateStorage
	end

	local mapStorage = manipulateStorage:getSection(mapResourceName)
	mapStorage:set("resource", mapResourceName)

	return mapStorage
end

function DebugManipulateController:getPresetStorage(mapResourceName, id)
	local mapStorage = self:getMapStorage(mapResourceName)

	for i = 1, mapStorage:length() do
		local playerStorage = mapStorage:getSection(i)
		if playerStorage:get("id") == id then
			return playerStorage, i
		end
	end

	return nil, nil
end

function DebugManipulateController:poke(actionID, actionIndex, e)
	if actionID == "select" then
		self:selectPreset(e)
	elseif actionID == "new" then
		self:newPreset(e)
	elseif actionID == "delete" then
		self:deletePreset(e)
	elseif actionID == "spawnActor" then
		self:spawnActor(e)
	elseif actionID == "spawnProp" then
		self:spawnProp(e)
	elseif actionID == "playAnimation" then
		self:playAnimation(e)
	elseif actionID == "changeSkin" then
		self:changeSkin(e)
	elseif actionID == "transform" then
		self:transform(e)
	elseif actionID == "setLayer" then
		self:setLayer(e)
	elseif actionID == "orientateCamera" then
		self:orientateCamera(e)
	elseif actionID == "fireProjectile" then
		self:fireProjectile(e)
	elseif actionID == "fireSpell" then
		self:fireSpell(e)
	elseif actionID == "simulateAttack" then
		self:simulateAttack(e)
	elseif actionID == "face" then
		self:face(e)
	elseif actionID == "editAction" then
		self:editAction(e)
	elseif actionID == "shiftAction" then
		self:shiftAction(e)
	elseif actionID == "deleteAction" then
		self:deleteAction(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	elseif actionID == "startRecording" then
		self:startRecording(e)
	elseif actionID == "stopRecording" then
		self:stopRecording(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function DebugManipulateController:close()
	if self.isRecording then
		self:stopRecording()
	end
end

function DebugManipulateController:startRecording(e)
	self.isRecording = true
	self.recordingMapResource = e.resource or self.layers[1]
	self.recordingID = e.id or 0
	self.recordingQueue = {}

	local layerInfo = self:getMapInfo(Utility.Peep.getLayer(self:getPeep()))
	if layerInfo then
		self:record(Utility.Peep.getLayer(self:getPeep()), self:getPeep(), "setLayer", {
			destinationMapResource = layerInfo.resource,
			destinationMapLocalLayer = layerInfo.localLayer,
		})
	end

	local position = Utility.Peep.getPosition(self:getPeep())
	local rotation = self:getPeep():hasBehavior(RotationBehavior) and Utility.Peep.getRotation(self:getPeep())
	local rotationX, rotationY, rotationZ
	if rotation then
		rotationX, rotationY, rotationZ = rotation:getEulerXYZ()
		rotationX, rotationY, rotationZ = math.deg(rotationX), math.deg(rotationY), math.deg(rotationZ)
	end
	local scale = self:getPeep():hasBehavior(ScaleBehavior) and Utility.Peep.getScale(self:getPeep())

	self:record(Utility.Peep.getLayer(self:getPeep()), self:getPeep(), "transform", {
		positionX = position.x,
		positionY = position.y,
		positionZ = position.z,
		rotationX = rotationX,
		rotationY = rotationY,
		rotationZ = rotationZ,
		scaleX = scale and scale.x or nil,
		scaleY = scale and scale.y or nil,
		scaleZ = scale and scale.z or nil,
	})
end

function DebugManipulateController:stopRecording()
	self.isRecording = false

	local presetStorage = self:getPresetStorage(self.recordingMapResource, self.recordingID)
	if not presetStorage then
		return
	end

	for i = 1, #self.recordingQueue do
		presetStorage:set(presetStorage:length() + 1, self.recordingQueue[i])
	end
end

function DebugManipulateController:newPreset(e)
	if self.isRecording then
		self:stopRecording()
	end

	local mapStorage = self:getMapStorage(e.resource)

	local id
	if mapStorage:length() >= 1 then
		local lastPresetStorage = mapStorage:getSection(mapStorage:length())
		id = lastPresetStorage:get("id") + 1
	else
		id = 1
	end

	local newPresetStorage = mapStorage:getSection(mapStorage:length() + 1)
	newPresetStorage:set("id", id)

	self:populate()
	self:send("showPreset", {
		resource = e.resource,
		index = mapStorage:length(),
		id = id
	}, newPresetStorage:get())
end

function DebugManipulateController:deletePreset(e)
	if self.isRecording then
		self:stopRecording()
	end

	local mapStorage = e.resource and self:getMapStorage(e.resource)
	if not mapStorage then
		return
	end

	local _, index = self:getPresetStorage(e.resource, e.id)
	if index then
		mapStorage:removeSection(index)
	end

	self:populate()
end

function DebugManipulateController:selectPreset(e)
	if self.isRecording then
		self:stopRecording()
	end

	local mapStorage = self:getMapStorage(e.resource or self.layers[1])

	local presetStorage, index = self:getPresetStorage(e.resource, e.id)
	if presetStorage then
		self:send("showPreset", {
			resource = e.resource,
			index = index,
			id = e.id
		}, presetStorage:get())
	end
end

function DebugManipulateController:recordPeep(target, peepID)
	assert(not self.peepToID[target])

	local nextPeepID = peepID
	if not nextPeepID then
		local storage = self:getMapStorage()
		nextPeepID = storage:get("peepID") or 1
		storage:set("peepID", nextPeepID + 1)
	end

	self.idToPeep[nextPeepID] = target
	self.peepToID[target] = nextPeepID

	if target ~= self:getPeep() then
		local _, m = target:addBehavior(ManipulatedBehavior)
		m.debugID = nextPeepID
		m.owner = self:getPeep()
	end
end

function DebugManipulateController:getRecordedPeepID(target)
	return self.peepToID[target]
end

function DebugManipulateController:getRecordedPeep(id)
	return self.idToPeep[id]
end

function DebugManipulateController:getMapInfo(layer)
	local mapInfo
	do
		local instance = Utility.Peep.getInstance(self:getPeep())
		if instance:hasLayer(layer, Utility.Peep.getPlayerModel(self:getPeep())) then
			local mapGroup = instance:getMapGroup(layer)
			local baseLayer = instance:getGlobalLayerFromLocalLayer(mapGroup, 1)
			local baseMapScript = instance:getMapScriptByLayer(baseLayer)
			local baseMapResource = baseMapScript and Utility.Peep.getResource(baseMapScript)
			local localLayer = instance:getLocalLayerFromGlobalLayer(mapGroup, layer)

			if baseMapResource then
				mapInfo = {
					resource = baseMapResource.name,
					localLayer = localLayer
				}
			end
		end
	end

	return mapInfo
end

function DebugManipulateController:getTargetInfo(targetPeep)
	local targetInfo
	do
		local mapObject = Utility.Peep.getMapObject(targetPeep)
		local mapObjectRecord = mapObject and (self:getGame():getGameDB():getRecord("MapObjectLocation", {
			Resource = mapObject
		}) or gameDB:getRecord("MapObjectReference", {
			Resource = mapObject
		}))

		if mapObjectRecord then
			targetInfo = {
				mapObjectName = mapObjectRecord:get("Name")
			}
		else
			local peepID = self:getRecordedPeepID(targetPeep)
			if peepID then
				targetInfo = {
					peepID = peepID
				}
			end
		end
	end

	return targetInfo
end

function DebugManipulateController:makeRecord(layer, targetPeep, actionType, e)
	local mapInfo = self:getMapInfo(layer)
	local targetInfo = self:getTargetInfo(targetPeep)

	if targetInfo and mapInfo then
		local q = {
			map = mapInfo,
			target = targetInfo,
			type = actionType,
			event = e
		}

		return q
	end

	return nil
end

function DebugManipulateController:commitRecord(action)
	table.insert(self.recordingQueue, action)
	Log.info("Recorded '%s'.", Log.dump(action))
end

function DebugManipulateController:updateClientRecords()
	local result, index
	do
		local p, i = self:getPresetStorage(self.recordingMapResource, self.recordingID)
		if p and i then
			result = p:get()
			index = i
		end

		result = result or {}
		for i, q in ipairs(self.recordingQueue) do
			table.insert(result, q)
		end
	end

	self:send("showPreset", {
		resource = self.recordingMapResource,
		index = index,
		id = self.recordingID
	}, result)
end

function DebugManipulateController:record(layer, targetPeep, actionType, e)
	local action = self:makeRecord(layer, targetPeep, actionType, e)
	if not action then
		return
	end

	self:commitRecord(action)
	self:updateClientRecords()
end

function DebugManipulateController:mergeOrRecord(layer, targetPeep, actionType, e)
	local action = self:makeRecord(layer, targetPeep, actionType, e)
	if not action then
		return
	end

	local previousAction = self.recordingQueue[#self.recordingQueue]
	if previousAction and previousAction.type == action.type and
	   previousAction.map.resource == action.map.resource and
	   previousAction.map.localLayer == action.map.localLayer and
	   (previousAction.target.mapObjectName == action.target.mapObjectName or previousAction.target.peepID == action.target.peepID)
	then
		for k, v in pairs(action.event) do
			previousAction.event[k] = v
		end
	else
		self:commitRecord(action)
	end

	self:updateClientRecords()
end

function DebugManipulateController:spawnActor(e)
	local instance = Utility.Peep.getInstance(self:getPeep())
	local mapScript = instance:getMapScriptByLayer(e.layer)
	if not mapScript then
		return
	end
	
	local x, y, z = unpack(e.position)
	local actor = Utility.spawnActorAtPosition(mapScript, e.id, x, y, z)

	if e.id == "CameraDolly" then
		actor:getPeep():pushPoke("visible")
	end

	if self.isRecording then
		self:recordPeep(actor:getPeep())
		self:record(e.layer, actor:getPeep(), "spawnActor", {
			id = e.id,
			positionX = x,
			positionY = y,
			positionZ = z,
		})
	end
end

function DebugManipulateController:spawnProp(e)
	local instance = Utility.Peep.getInstance(self:getPeep())
	local mapScript = instance:getMapScriptByLayer(e.layer)
	if not mapScript then
		return
	end
	
	local x, y, z = unpack(e.position)
	local prop = Utility.spawnPropAtPosition(mapScript, e.id, x, y, z)

	if self.isRecording then
		self:recordPeep(prop:getPeep())
		self:record(e.layer, prop:getPeep(), "spawnProp", {
			id = e.id,
			positionX = x,
			positionY = y,
			positionZ = z,
		})
	end
end

function DebugManipulateController:playAnimation(e)
	local actor = self:getGame():getStage():getActorByID(e.actorID)
	if not actor then
		return
	end

	local selfInstance = Utility.Peep.getInstance(self:getPeep())
	local actorInstance = Utility.Peep.getInstance(actor:getPeep())

	if selfInstance ~= actorInstance then
		return
	end

	local success = Utility.Peep.playAnimation(actor:getPeep(), e.slot, e.priority, e.animation, true)
	if not success then
		return
	end

	if self.isRecording then
		self:record(Utility.Peep.getLayer(actor:getPeep()), actor:getPeep(), "playAnimation", {
			slot = e.slot,
			priority = e.priority,
			animation = e.animation
		})
	end
end

function DebugManipulateController:changeSkin(e)
	local actor = self:getGame():getStage():getActorByID(e.actorID)
	if not actor then
		return
	end

	local selfInstance = Utility.Peep.getInstance(self:getPeep())
	local otherInstance = Utility.Peep.getInstance(actor:getPeep())

	if selfInstance ~= otherInstance then
		return
	end

	local slotIndex = Equipment[string.format("PLAYER_SLOT_%s", tostring(e.slot):upper())]
	local success = Utility.Peep.Human.applySkin(actor:getPeep(), slotIndex or e.slot, e.priority, e.filename)
	if not success then
		return
	end

	if self.isRecording then
		self:record(Utility.Peep.getLayer(actor:getPeep()), actor:getPeep(), "changeSkin", {
			slot = e.slot,
			priority = e.priority,
			filename = e.filename
		})
	end
end

function DebugManipulateController:transform(e)
	local actor = self:getGame():getStage():getActorByID(e.actorID)
	local prop = self:getGame():getStage():getPropByID(e.propID)
	if not (actor or prop) then
		return
	end

	local peep = (actor and actor:getPeep()) or (prop and prop:getPeep())

	local selfInstance = Utility.Peep.getInstance(self:getPeep())
	local actorInstance = Utility.Peep.getInstance(peep)

	if selfInstance ~= actorInstance then
		return
	end

	local event = {}
	if type(e.translationX) == "number" and type(e.translationY) == "number" and type(e.translationZ) == "number" then
		peep:addBehavior(PositionBehavior)
		Utility.Peep.setPosition(peep, Vector(e.translationX, e.translationY, e.translationZ))

		event.translationX = e.translationX
		event.translationY = e.translationY
		event.translationZ = e.translationZ
	end

	if type(e.rotationX) == "number" and type(e.rotationY) == "number" and type(e.rotationZ) == "number" then
		peep:addBehavior(RotationBehavior)
		Utility.Peep.setRotation(peep, Quaternion.fromEulerXYZ(math.rad(e.rotationX), math.rad(e.rotationY), math.rad(e.rotationZ)):getNormal())

		event.rotationX = e.rotationX
		event.rotationY = e.rotationY
		event.rotationZ = e.rotationZ
	end

	if type(e.scaleX) == "number" and type(e.scaleY) == "number" and type(e.scaleZ) == "number" then
		peep:addBehavior(ScaleBehavior)
		Utility.Peep.setScale(peep, Vector(e.scaleX, e.scaleY, e.scaleZ))

		event.scaleX = e.scaleX
		event.scaleY = e.scaleY
		event.scaleZ = e.scaleZ
	end

	if self.isRecording then
		self:mergeOrRecord(Utility.Peep.getLayer(peep), peep, "transform", event)
	end
end

function DebugManipulateController:setLayer(e)
	local actor = self:getGame():getStage():getActorByID(e.actorID)
	local prop = self:getGame():getStage():getPropByID(e.propID)
	if not (actor or prop) then
		return
	end

	local peep = (actor and actor:getPeep()) or (prop and prop:getPeep())

	local selfInstance = Utility.Peep.getInstance(self:getPeep())
	local otherInstance = Utility.Peep.getInstance(peep)

	if selfInstance ~= otherInstance then
		return
	end

	local otherMapInfo = self:getMapInfo(e.layer)
	if not otherMapInfo then
		return
	end

	if self.isRecording then
		self:record(Utility.Peep.getLayer(peep), peep, "setLayer", {
			destinationMapResource = destinationMapInfo.resource,
			destinationMapLocalLayer = destinationMapInfo.localLayer,
		})
	end

	local peepLayer = Utility.Peep.getLayer(peep)
	local peepAbsolutePosition = Utility.Peep.getAbsolutePosition(peep)
	local peepRelativePosition = Utility.Map.absolutePositionToRelativePosition(self:getDirector(), e.layer, peepAbsolutePosition)

	Utility.Peep.teleport(peep, peepRelativePosition, e.layer)
end

function DebugManipulateController:orientateCamera(e)
	local actor = self:getGame():getStage():getActorByID(e.actorID)
	local peep = actor and actor:getPeep()
	if not peep then
		return
	end

	local peepInstance = Utility.Peep.getInstance(peep)
	local selfInstance = Utility.Peep.getInstance(self:getPeep())

	if peepInstance ~= selfInstance then
		return
	end

	if self.isRecording then
		self:record(Utility.Peep.getLayer(peep), peep, "orientateCamera", {})
	end
end

function DebugManipulateController:fireProjectile(e)
	local sourceActor = e.sourceActorID and self:getGame():getStage():getActorByID(e.sourceActorID)
	local sourceProp = e.sourcePropID and self:getGame():getStage():getPropByID(e.sourcePropID)
	local destinationActor = e.destinationActorID and self:getGame():getStage():getActorByID(e.destinationActorID)
	local destinationProp = e.destinationPropID and self:getGame():getStage():getPropByID(e.destinationPropID)

	local source = sourceActor or sourceProp
	local destination = destinationActor or destinationProp

	local sourcePeep = source and source:getPeep()
	local destinationPeep = destination and destination:getPeep()
	if not (sourcePeep and destinationPeep) then
		return
	end

	local sourceInstance = Utility.Peep.getInstance(sourcePeep)
	local destinationInstance = Utility.Peep.getInstance(destinationPeep)
	local selfInstance = Utility.Peep.getInstance(self:getPeep())

	if sourceInstance ~= selfInstance or destinationInstance ~= selfInstance then
		return
	end

	local destinationTargetInfo = self:getTargetInfo(destinationPeep)
	if not destinationTargetInfo then
		return
	end

	local destinationMapInfo = self:getMapInfo(Utility.Peep.getLayer(destinationPeep))
	if not destinationMapInfo then
		return
	end

	if self.isRecording then
		self:record(Utility.Peep.getLayer(sourcePeep), sourcePeep, "fireProjectile", {
			targetMapObjectName = destinationTargetInfo.mapObjectName,
			targetPeepID = destinationTargetInfo.peepID,
			targetMapResource = destinationMapInfo.resource,
			targetMapLocalLayer = destinationMapInfo.localLayer,
			projectile = e.projectile or "AirStrike"
		})
	end

	self:getGame():getStage():fireProjectile(e.projectile or "AirStrike", sourcePeep, destinationPeep)
end

function DebugManipulateController:fireSpell(e)
	local actor = e.peepID and self:getGame():getStage():getActorByID(e.peepID)
	local targetActor = e.targetPeepID and self:getGame():getStage():getActorByID(e.targetPeepID)

	local peep = actor and peep:getPeep()
	local targetPeep = targetActor and targetActor:getPeep()
	if not (sourcePeep and targetPeep) then
		return
	end

	local instance = Utility.Peep.getInstance(sourcePeep)
	local targetInstance = Utility.Peep.getInstance(targetPeep)
	local selfInstance = Utility.Peep.getInstance(self:getPeep())

	if instance ~= selfInstance or targetInstance ~= selfInstance then
		return
	end

	local otherTargetInfo = self:getTargetInfo(targetPeep)
	if not otherTargetInfo then
		return
	end

	local otherMapInfo = self:getMapInfo(Utility.Peep.getLayer(targetPeep))
	if not otherMapInfo then
		return
	end

	if self.isRecording then
		self:record(Utility.Peep.getLayer(sourcePeep), sourcePeep, "fireSpell", {
			targetMapObjectName = otherTargetInfo.mapObjectName,
			targetPeepID = otherTargetInfo.peepID,
			targetMapResource = otherMapInfo.resource,
			targetMapLocalLayer = otherMapInfo.localLayer,
			spell = e.spell or "AirStrike"
		})
	end

	if spell then
		local spellInstance = Utility.Peep.getSpell(e.spell or "AirStrike", self:getGame())
		spellInstance:show(sourcePeep, targetPeep, true)
	end
end

function DebugManipulateController:face(e)
	local actor = e.peepID and self:getGame():getStage():getActorByID(e.peepID)
	local targetActor = e.targetPeepID and self:getGame():getStage():getActorByID(e.targetPeepID)

	local peep = actor and peep:getPeep()
	local targetPeep = target and target:getPeep()
	if not (sourcePeep and destinationPeep) then
		return
	end

	local instance = Utility.Peep.getInstance(peep)
	local targetInstance = Utility.Peep.getInstance(targetPeep)
	local selfInstance = Utility.Peep.getInstance(self:getPeep())

	if instance ~= selfInstance or targetInstance ~= selfInstance then
		return
	end

	local otherTargetInfo = self:getTargetInfo(targetPeep)
	if not otherTargetInfo then
		return
	end

	local otherMapInfo = self:getMapInfo(Utility.Peep.getLayer(targetPeep))
	if not otherMapInfo then
		return
	end

	if self.isRecording then
		self:record(Utility.Peep.getLayer(peep), peep, "face", {
			targetMapObjectName = otherTargetInfo.mapObjectName,
			targetPeepID = otherTargetInfo.peepID,
			targetMapResource = otherMapInfo.resource,
			targetMapLocalLayer = otherMapInfo.localLayer
		})
	end

	Utility.Peep.face(peep, targetPeep)
end

function DebugManipulateController:simulateAttack(e)
	local actor = e.peepID and self:getGame():getStage():getActorByID(e.peepID)
	local targetActor = e.targetPeepID and self:getGame():getStage():getActorByID(e.targetPeepID)

	local peep = actor and actor:getPeep()
	local targetPeep = targetActor and targetActor:getPeep()
	if not (peep and targetPeep) then
		return
	end

	local instance = Utility.Peep.getInstance(peep)
	local targetInstance = Utility.Peep.getInstance(targetPeep)
	local selfInstance = Utility.Peep.getInstance(self:getPeep())

	if instance ~= selfInstance or targetInstance ~= selfInstance then
		return
	end

	local otherTargetInfo = self:getTargetInfo(targetPeep)
	if not otherTargetInfo then
		return
	end

	local otherMapInfo = self:getMapInfo(Utility.Peep.getLayer(targetPeep))
	if not otherMapInfo then
		return
	end

	local weapon = Utility.Peep.getEquippedWeapon(peep, true)
	local animation, projectile, spell
	if weapon then
		local animations = {
			string.format("animation-attack-%s-%s", weapon:getBonusForStance(peep):lower(), weapon:getWeaponType()),
			string.format("animation-attack-%s", weapon:getBonusForStance(peep):lower()),
			string.format("animation-attack-%s", weapon:getWeaponType()),
			"animation-attack"
		}

		for _, a in ipairs(animations) do
			local resource = peep:getResource(a, "ItsyScape.Graphics.AnimationResource")
			if resource then
				animation = resource
				break
			end
		end

		local activeSpell = peep:getBehavior(ActiveSpellBehavior)
		local stance = peep:getBehavior(StanceBehavior)

		spell = stance and stance.useSpell and activeSpell and activeSpell.spell and activeSpell.spell
		projectile = not spell and weapon:getProjectile(peep) or (spell and spell:getProjectile())
	else
		animation = peep:getResource("animation-attack", "ItsyScape.Graphics.AnimationResource")
	end

	if self.isRecording then
		self:record(Utility.Peep.getLayer(peep), peep, "face", {
			targetMapObjectName = otherTargetInfo.mapObjectName,
			targetPeepID = otherTargetInfo.peepID,
			targetMapResource = otherMapInfo.resource,
			targetMapLocalLayer = otherMapInfo.localLayer
		})

		if animation then
			self:record(Utility.Peep.getLayer(peep), peep, "playAnimation", {
				slot = "combat-attack",
				priority = 5000,
				animation = animation:getFilename()
			})
		end

		if spell then
			self:record(Utility.Peep.getLayer(peep), peep, "fireSpell", {
				targetMapObjectName = otherTargetInfo.mapObjectName,
				targetPeepID = otherTargetInfo.peepID,
				targetMapResource = otherMapInfo.resource,
				targetMapLocalLayer = otherMapInfo.localLayer,
				spell = spell:getID()
			})
		end

		if projectile then
			self:record(Utility.Peep.getLayer(peep), peep, "fireProjectile", {
				targetMapObjectName = otherTargetInfo.mapObjectName,
				targetPeepID = otherTargetInfo.peepID,
				targetMapResource = otherMapInfo.resource,
				targetMapLocalLayer = otherMapInfo.localLayer,
				projectile = projectile
			})
		end
	end

	Utility.Peep.face(peep, targetPeep)

	if animation then
		Utility.Peep.playAnimation(peep, "combat-attack", 5000, animation:getFilename())
	end

	if spell then
		spell:show(peep, targetPeep, true)
	end

	if projectile then
		self:getGame():getStage():fireProjectile(projectile, peep, targetPeep)
	end
end

function DebugManipulateController:editAction(e)
	local presetStorage = self:getPresetStorage(e.resource, e.id)
	if not presetStorage then
		return
	end

	presetStorage:getSection(e.index):clear()
	presetStorage:set(e.index, e.action)

	if self.isRecording then
		self:updateClientRecords()
	else
		self:selectPreset({
			resource = e.resource,
			id = e.id
		})
	end
end

function DebugManipulateController:shiftAction(e)
	local presetStorage = self:getPresetStorage(e.resource, e.id)
	if not presetStorage then
		return
	end

	local preset = presetStorage:get()
	presetStorage:clear()

	local index = e.index
	local nextIndex = e.nextIndex
	local action = table.remove(preset, index)
	table.insert(preset, math.clamp(nextIndex, 1, #preset + 1), action)

	presetStorage:set(preset)

	if self.isRecording then
		self:updateClientRecords()
	else
		self:selectPreset({
			resource = e.resource,
			id = e.id
		})
	end
end

function DebugManipulateController:deleteAction(e)
	local presetStorage = self:getPresetStorage(e.resource, e.id)
	if not presetStorage then
		return
	end

	presetStorage:removeSection(e.index)

	if self.isRecording then
		self:updateClientRecords()
	else
		self:selectPreset({
			resource = e.resource,
			id = e.id
		})
	end
end

function DebugManipulateController:pull()
	return {
		layers = self.layers,
		presets = self.presets
	}
end

return DebugManipulateController
