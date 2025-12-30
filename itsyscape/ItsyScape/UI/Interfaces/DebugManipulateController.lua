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
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"

local DebugManipulateController = Class(Controller)

function DebugManipulateController:new(peep, director)
	Controller.new(self, peep, director)

	self.isRecording = false
	self.peepToID = {}
	self.idToPeep = {}

	self:recordPeep(self:getPeep(), -1)
	self:populate()
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

			local mapStorage = self:getStorage(resource.name)
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

function DebugManipulateController:getStorage(mapResourceName)
	local storage = self:getDirector():getPlayerStorage(self:getPeep())
	local manipulateStorage = storage:getRoot():getSection("UI"):getSection("DebugManipulate")
	if not mapResourceName then
		return manipulateStorage
	end

	local mapStorage = manipulateStorage:getSection(mapResourceName)
	mapStorage:set("resource", mapResourceName)

	return mapStorage
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

function DebugManipulateController:startRecording(e)
	self.isRecording = true
	self.recordingMapResource = e.resource or self.layers[1]
	self.recordingID = e.id or 0
	self.recordingQueue = {}
end

function DebugManipulateController:stopRecording()
	self.isRecording = false
end

function DebugManipulateController:newPreset(e)
	local mapStorage = self:getStorage(e.resource)

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
	local mapStorage = e.resource and self:getStorage(e.resource)
	if not mapStorage then
		return
	end

	for i = 1, mapStorage:length() do
		local p = mapStorage:getSection(i)
		if p:get("id") == e.id then
			mapStorage:removeSection(i)
			break
		end
	end

	self:populate()
end

function DebugManipulateController:selectPreset(e)
	local mapStorage = self:getStorage(e.resource or self.layers[1])

	local presetStorage, index
	for i = 1, mapStorage:length() do
		local p = mapStorage:getSection(i)
		if not e.id or p:get("id") == e.id then
			presetStorage = p
			index = i
			break
		end
	end

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
		local storage = self:getStorage()
		nextPeepID = storage:get("peepID") or 1
		storage:set("peepID", nextPeepID + 1)
	end

	self.idToPeep[nextPeepID] = target
	self.peepToID[target] = nextPeepID
end

function DebugManipulateController:getRecordedPeepID(target)
	return self.peepToID[target]
end

function DebugManipulateController:getRecordedPeep(id)
	return self.idToPeep[id]
end

function DebugManipulateController:record(layer, targetPeep, e)
	local mapInfo
	do
		local instance = Utility.Peep.getInstance(self:getPeep())
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

	local targetInfo
	do
		local mapObject = Utility.Peep.getMapObject(targetPeep)
		local mapObjectRecord = mapObject and (gameDB:getRecord("MapObjectLocation", {
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
					peepID = self:getRecordedPeepID(targetPeep)
				}
			end
		end
	end

	if targetInfo and mapInfo then
		local q = {
			map = mapInfo,
			target = targetInfo,
			event = e
		}

		table.insert(self.recordingQueue, q)
		Log.info("Recorded '%s'.", Log.dump(q))
	end
end

function DebugManipulateController:spawnActor(e)
	local instance = Utility.Peep.getInstance(self:getPeep())
	local mapScript = instance:getMapScriptByLayer(e.layer)
	if not mapScript then
		return
	end
	
	local x, y, z = unpack(e.position)
	local actor = Utility.spawnActorAtPosition(mapScript, e.id, x, y, z)

	if self.isRecording then
		self:recordPeep(actor:getPeep())
		self:record(e.layer, actor:getPeep(), {
			type = "spawnActor",
			id = e.id,
			position = { x, y, z },
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
		self:record(e.layer, prop:getPeep(), {
			type = "spawnProp",
			id = e.id,
			position = { x, y, z },
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
		self:record(Utility.Peep.getLayer(actor:getPeep()), actor:getPeep(), {
			type = "playAnimation",
			slot = e.slot,
			priority = e.priority,
			animation = e.animation
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
