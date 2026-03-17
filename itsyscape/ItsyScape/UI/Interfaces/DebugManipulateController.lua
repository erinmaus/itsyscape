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
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Mapp = require "ItsyScape.GameDB.Mapp"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local Probe = require "ItsyScape.Peep.Probe"
local ActiveSpellBehavior = require "ItsyScape.Peep.Behaviors.ActiveSpellBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local ImmortalBehavior = require "ItsyScape.Peep.Behaviors.ImmortalBehavior"
local ManipulatedBehavior = require "ItsyScape.Peep.Behaviors.ManipulatedBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local OldOneDescriptionBehavior = require "ItsyScape.Peep.Behaviors.OldOneDescriptionBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local Controller = require "ItsyScape.UI.Controller"

local DebugManipulateController = Class(Controller)

DebugManipulateController.ACTION_NOT_STARTED = "not-yet-started"
DebugManipulateController.ACTION_PROCESSING  = "processing"
DebugManipulateController.ACTION_PENDING     = "pending"
DebugManipulateController.ACTION_COMPLETE    = "complete"

DebugManipulateController.REPLAYED_ACTIONS = {}

function DebugManipulateController.REPLAYED_ACTIONS:spawnActor(action)
	return function()
		local layer, mapScript = self:getLayerFromMapInfo(action.map)
		if not self:getPeepFromTargetInfo(action.target, layer) then
			local isComplete = false

			local actor = Utility.spawnActorAtPosition(
				mapScript,
				action.event.id,
				action.event.positionX,
				action.event.positionY,
				action.event.positionZ)

			actor:getPeep():listen("finalize", function()
				if action.event.id == "CameraDolly" then
					actor:getPeep():poke("visible")
				end

				self:recordPeep(actor:getPeep(), action.target.peepID)
				isComplete = true
			end)

			repeat
				coroutine.yield(DebugManipulateController.ACTION_PROCESSING)
			until isComplete
		end

		return DebugManipulateController.ACTION_COMPLETE
	end
end

function DebugManipulateController.REPLAYED_ACTIONS:spawnProp(action)
	return function()
		local layer, mapScript = self:getLayerFromMapInfo(action.map)
		if not self:getPeepFromTargetInfo(action.target, layer) then
			local isComplete = false

			local prop = Utility.spawnPropAtPosition(
				mapScript,
				action.event.id,
				action.event.positionX,
				action.event.positionY,
				action.event.positionZ)
			prop:getPeep():listen("finalize", function()
				self:recordPeep(prop:getPeep(), action.target.peepID)
				isComplete = true
			end)

			repeat
				coroutine.yield(DebugManipulateController.ACTION_PROCESSING)
			until isComplete
		end

		return DebugManipulateController.ACTION_COMPLETE
	end
end

function DebugManipulateController.REPLAYED_ACTIONS:spawnGlyphCircle(action)
	return function()
		local layer, mapScript = self:getLayerFromMapInfo(action.map)
		local map = self:getDirector():getMap(layer)

		if not self:getPeepFromTargetInfo(action.target, layer) and map then
			local isComplete = false

			local prop = Utility.spawnPropAtPosition(
				mapScript,
				"ProjectedGlyph",
				action.event.positionX,
				action.event.positionY,
				action.event.positionZ)

			local _, description = prop:getPeep():addBehavior(OldOneDescriptionBehavior)
			description.description = action.event.glyphDescription

			Utility.Peep.setSize(prop:getPeep(), Vector((action.event.glyphWidth or 4) * map:getCellSize(), 1, (action.event.glyphHeight or 4) * map:getCellSize()))

			prop:getPeep():listen("finalize", function()
				if action.event.fadeDuration > 0 then
					prop:getPeep():pushPoke("fade", action.event.fadeDuration / 1000, action.event.fadeDelay / 1000)
				end

				self:recordPeep(prop:getPeep(), action.target.peepID)
				isComplete = true
			end)

			repeat
				coroutine.yield(DebugManipulateController.ACTION_PENDING)
			until isComplete
		end

		return DebugManipulateController.ACTION_COMPLETE
	end
end

function DebugManipulateController.REPLAYED_ACTIONS:playAnimation(action)
	return function()
		local layer = self:getLayerFromMapInfo(action.map)
		local peep = self:getPeepFromTargetInfo(action.target, layer)
		if peep then
			Utility.Peep.playAnimation(
				peep,
				action.event.slot,
				action.event.priority,
				action.event.animation,
				true)

			coroutine.yield(DebugManipulateController.ACTION_PROCESSING)
		end

		return DebugManipulateController.ACTION_COMPLETE
	end
end

function DebugManipulateController.REPLAYED_ACTIONS:changeSkin(action)
	return function()
		local layer = self:getLayerFromMapInfo(action.map)
		local peep = self:getPeepFromTargetInfo(action.target, layer)
		if peep then
			local namedSlot = Equipment[string.format("PLAYER_SLOT_%s", tostring(action.event.slot):upper())]
			Utility.Peep.Human.changeSkin(
				peep,
				namedSlot or tonumber(action.event.slot) or action.event.slot,
				action.event.priority,
				action.event.filename)

			coroutine.yield(DebugManipulateController.ACTION_PROCESSING)
		end

		return DebugManipulateController.ACTION_COMPLETE
	end
end

local function _getMashinaTreeFilename(peep, filename)
	if not filename or filename == "" then
		return nil
	end

	local resource = Utility.Peep.getResource(peep)
	if not resource then
		return love.filesystem.getInfo(filename) and filename
	end

	local potentialFilenames = { filename }

	local instance = Utility.Peep.getInstance(peep)
	local mapScript = instance:getMapScriptByLayer(layer)
	local map = mapScript and Utility.Peep.getResource(mapScript)

	local mapObjectName, mapObjectNameRecord = Utility.Peep.getMapObjectName(peep)
	if mapObjectName then
		local otherMap = mapObjectNameRecord:get("Map")

		table.insert(potentialFilenames, string.format("Resources/Game/Maps/%s/Scripts/%s_%s.lua", otherMap.name, resource.name, filename))
		table.insert(potentialFilenames, string.format("Resources/Game/Maps/%s/Scripts/%s_%sLogic.lua", otherMap.name, resource.name, filename))
		table.insert(potentialFilenames, string.format("Resources/Game/Maps/%s/Scripts/%s.lua", otherMap.name, filename))
		table.insert(potentialFilenames, string.format("Resources/Game/Maps/%s/Scripts/%sLogic.lua", otherMap.name, filename))
	end

	if map then
		table.insert(potentialFilenames, string.format("Resources/Game/Maps/%s/Scripts/%s_%s.lua", map.name, resource.name, filename))
		table.insert(potentialFilenames, string.format("Resources/Game/Maps/%s/Scripts/%s_%sLogic.lua", map.name, resource.name, filename))
		table.insert(potentialFilenames, string.format("Resources/Game/Maps/%s/Scripts/%s.lua", map.name, filename))
		table.insert(potentialFilenames, string.format("Resources/Game/Maps/%s/Scripts/%sLogic.lua", map.name, filename))
	end

	local peepID = peep:getDirector():getGameDB():getRecord("PeepID", {
		Resource = resource
	})

	if peepID then
		local potentialBaseFilename = peepID:get("Value"):gsub("%.", "/")
		local potentialDirectory = potentialBaseFilename:match("(.*)/.*$") or potentialBaseFilename


		table.insert(potentialFilenames, string.format("%s/%s_%sLogic.lua", potentialDirectory, resource.name, filename))
		table.insert(potentialFilenames, string.format("%s/%s_%s.lua", potentialDirectory, resource.name, filename))
		table.insert(potentialFilenames, string.format("%s/%s.lua", potentialDirectory, filename))
		table.insert(potentialFilenames, string.format("%s/%sLogic.lua", potentialDirectory, filename))
		table.insert(potentialFilenames, string.format("%s_%s.lua", potentialBaseFilename, filename))
		table.insert(potentialFilenames, string.format("%s_%sLogic.lua", potentialBaseFilename, filename))
	end

	Log.info("Potential filenames: %s", Log.dump(potentialFilenames))

	for i, potentialFilename in ipairs(potentialFilenames) do
		if love.filesystem.getInfo(potentialFilename) then
			Log.info(
				"Found BMASHINA behavior tree file '%s' (candidate %d) (peep = '%s', resource = %s).",
				potentialFilename,
				i,
				peep:getName(),
				resource.name)

			return potentialFilename
		else
			Log.info(
				"Did NOT find BMASHINA behavior tree file '%s' (candidate %d) (peep = '%s', resource = %s).",
				potentialFilename,
				i,
				peep:getName(),
				resource.name)
		end
	end

	return nil
end

function DebugManipulateController.REPLAYED_ACTIONS:setMashinaState(action)
	return function()
		local layer = self:getLayerFromMapInfo(action.map)
		local peep = self:getPeepFromTargetInfo(action.target, layer)
		if peep then
			local filename = _getMashinaTreeFilename(peep, action.event.filename)
			if filename then
				local code = love.filesystem.load(filename)

				local _, mashina = peep:addBehavior(MashinaBehavior)
				mashina.states[action.event.state] = code()
			end

			Utility.Peep.setMashinaState(peep, action.event.state)
		end

		return DebugManipulateController.ACTION_COMPLETE
	end
end

function DebugManipulateController.REPLAYED_ACTIONS:talk(action)
	return function()
		local layer = self:getLayerFromMapInfo(action.map)
		local peep = self:getPeepFromTargetInfo(action.target, layer)
		if peep then
			Utility.Peep.talk(
				peep,
				action.event.message,
				Color.fromHexString(action.event.color),
				action.timing and action.timing.duration)

			coroutine.yield(DebugManipulateController.ACTION_PROCESSING)
		end

		return DebugManipulateController.ACTION_COMPLETE
	end
end

function DebugManipulateController.REPLAYED_ACTIONS:flashPower(action)
	return function()
		local layer = self:getLayerFromMapInfo(action.map)
		local peep = self:getPeepFromTargetInfo(action.target, layer)
		if peep then
			local gameDB = peep:getDirector():getGameDB()
			local resource = gameDB:getResource(action.event.power, "Power")
			local powerName = resource and Utility.getName(resource, gameDB) or action.event.power

			Utility.Peep.flash(peep, "Power", 0.5, action.event.power, powerName)

			coroutine.yield(DebugManipulateController.ACTION_PROCESSING)
		end

		return DebugManipulateController.ACTION_COMPLETE
	end
end

function DebugManipulateController.REPLAYED_ACTIONS:transform(action)
	return function(timeInfo)
		local layer = self:getLayerFromMapInfo(action.map)
		local peep = self:getPeepFromTargetInfo(action.target, layer)
		if peep then
			local currentPosition = Utility.Peep.getPosition(peep)
			local currentRotation = Utility.Peep.getRotation(peep)
			local currentScale = Utility.Peep.getScale(peep)

			local targetPosition = action.event.positionX and
			                       action.event.positionY and
			                       action.event.positionZ and
			                       Vector(action.event.positionX, action.event.positionY, action.event.positionZ)

			local targetRotation = action.event.rotationX and
			                       action.event.rotationY and
			                       action.event.rotationZ and
			                       Quaternion.fromEulerXYZ(math.rad(action.event.rotationX), math.rad(action.event.rotationY), math.rad(action.event.rotationZ))

			local targetScale    = action.event.scaleX and
			                       action.event.scaleY and
			                       action.event.scaleZ and
			                       Vector(action.event.scaleX, action.event.scaleY, action.event.scaleZ)

			local movement = peep:getBehavior(MovementBehavior)
			if movement then
				movement.noClip = action.event.noClip or movement.noClip
			end

			repeat
				local delta = timeInfo and timeInfo.delta or 1

				if targetPosition then
					peep:addBehavior(PositionBehavior)
					Utility.Peep.setPosition(peep, currentPosition:lerp(targetPosition, delta))
				end

				if targetRotation then
					peep:addBehavior(RotationBehavior)
					Utility.Peep.setRotation(peep, currentRotation:slerp(targetRotation, delta):getNormal())
				end

				if targetScale then
					peep:addBehavior(ScaleBehavior)
					Utility.Peep.setScale(peep, currentScale:lerp(targetScale, delta))
				end

				if delta < 1 then
					coroutine.yield(DebugManipulateController.ACTION_PENDING)
				else
					coroutine.yield(DebugManipulateController.ACTION_PROCESSING)
				end
			until not timeInfo or not (action.timing and timeInfo.elapsed < action.timing.duration + action.timing.delay)
		end

		return DebugManipulateController.ACTION_COMPLETE
	end
end

function DebugManipulateController.REPLAYED_ACTIONS:setLayer(action)
	return function(timeInfo)
		local layer = self:getLayerFromMapInfo(action.map)
		local peep = self:getPeepFromTargetInfo(action.target, layer)

		local targetLayer = self:getLayerFromMapInfo({
			resource = action.event.destinationMapResource,
			localLAyer = action.event.destinationMapLocalLayer,
		})

		if peep and layer >= 1 and targetLayer >= 1 then
			local peepAbsolutePosition = Utility.Peep.getAbsolutePosition(peep)
			local peepRelativePosition = Utility.Map.absolutePositionToRelativePosition(self:getDirector(), targetLayer, peepAbsolutePosition)

			Utility.Peep.teleport(peep, peepRelativePosition, targetLayer)

			coroutine.yield(DebugManipulateController.ACTION_PROCESSING)
		end

		return DebugManipulateController.ACTION_COMPLETE
	end
end

function DebugManipulateController.REPLAYED_ACTIONS:orientateCamera(action)
	return function()
		local player = Utility.Peep.getPlayerModel(self:getPeep())

		local layer = self:getLayerFromMapInfo(action.map)
		local peep = self:getPeepFromTargetInfo(action.target, layer)

		local otherLayer = self:getLayerFromMapInfo({
			resource = action.event.targetMapResource,
			localLayer = action.event.targetMapLocalLayer,
		})
		local otherPeep = self:getPeepFromTargetInfo({
			mapObjectName = action.event.targetMapObjectName,
			peepID = action.event.targetPeepID,
		}, otherLayer)

		local overrideLayer = self:getLayerFromMapInfo({
			resource = action.event.overrideMapResource,
			localLayer = action.event.overrideMapLocalLayer,
		})
		local overridePeep = self:getPeepFromTargetInfo({
			mapObjectName = action.event.overrideMapObjectName,
			peepID = action.event.overridePeepID,
		}, overrideLayer)

		local actor = peep and peep:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor

		local otherActor = otherPeep and otherPeep:getBehavior(ActorReferenceBehavior)
		otherActor = otherActor and otherActor.actor

		local overrideActor = overridePeep and overridePeep:getBehavior(ActorReferenceBehavior)
		overrideActor = overrideActor and overrideActor.actor

		if overrideActor then
			player:pokeCamera("overrideCameraPosition", actor:getID(), action.event.overrideBone or "")
		end

		if actor and overrideActor ~= actor then
			local delay = action.timing and action.timing.delay
			local duration = action.timing and action.timing.duration
			local tween = action.timing and action.timing.tween

			player:pokeCamera("resetTransforms")

			if otherPeep then
				player:pokeCamera("orientateFromActorToActor", actor:getID(), otherActor:getID(), action.event.bone or "", delay or 0, duration or 0, tween or "sineEaseInOut")
			else
				player:pokeCamera("orientateToActor", actor:getID(), delay or 0, duration or 0, tween or "sineEaseInOut")
			end

			coroutine.yield(DebugManipulateController.ACTION_PROCESSING)
		end

		return DebugManipulateController.ACTION_COMPLETE
	end
end

function DebugManipulateController.REPLAYED_ACTIONS:fireProjectile(action)
	return function()
		local sourceLayer = self:getLayerFromMapInfo(action.map)
		local sourcePeep = self:getPeepFromTargetInfo(action.target, sourceLayer)
		local destinationLayer = self:getLayerFromMapInfo({
			resource = action.event.targetMapResource,
			localLayer = action.event.targetMapLocalLayer,
		})
		local destinationPeep = self:getPeepFromTargetInfo({
			mapObjectName = action.event.targetMapObjectName,
			peepID = action.event.targetPeepID,
		}, destinationLayer)

		if sourcePeep and destinationPeep then
			self:getGame():getStage():fireProjectile(action.event.projectile or "AirStrike", sourcePeep, destinationPeep)

			coroutine.yield(DebugManipulateController.ACTION_PROCESSING)
		end

		return DebugManipulateController.ACTION_COMPLETE
	end
end

function DebugManipulateController.REPLAYED_ACTIONS:fireSpell(action)
	return function()
		local sourceLayer = self:getLayerFromMapInfo(action.map)
		local sourcePeep = self:getPeepFromTargetInfo(action.target, sourceLayer)
		local destinationLayer = self:getLayerFromMapInfo({
			resource = action.event.targetMapResource,
			localLayer = action.event.targetMapLocalLayer,
		})
		local destinationPeep = self:getPeepFromTargetInfo({
			mapObjectName = action.event.targetMapObjectName,
			peepID = action.event.targetPeepID,
		}, destinationLayer)

		if sourcePeep and destinationPeep then
			local spellInstance = Utility.Peep.getSpell(action.event.spell or "AirStrike", self:getGame())
			spellInstance:show(sourcePeep, destinationPeep, true)

			coroutine.yield(DebugManipulateController.ACTION_PROCESSING)
		end

		return DebugManipulateController.ACTION_COMPLETE
	end
end

function DebugManipulateController.REPLAYED_ACTIONS:face(action)
	return function()
		local sourceLayer = self:getLayerFromMapInfo(action.map)
		local sourcePeep = self:getPeepFromTargetInfo(action.target, sourceLayer)
		local destinationLayer = self:getLayerFromMapInfo({
			resource = action.event.targetMapResource,
			localLayer = action.event.targetMapLocalLayer,
		})
		local destinationPeep = self:getPeepFromTargetInfo({
			mapObjectName = action.event.targetMapObjectName,
			peepID = action.event.targetPeepID,
		}, destinationLayer)

		if sourcePeep and destinationPeep then
			Utility.Peep.face(sourcePeep, destinationPeep)
			coroutine.yield(DebugManipulateController.ACTION_PROCESSING)
		end

		return DebugManipulateController.ACTION_COMPLETE
	end
end

function DebugManipulateController.REPLAYED_ACTIONS:walk(action)
	return function(timeInfo)
		local layer = self:getLayerFromMapInfo(action.map)
		local peep = self:getPeepFromTargetInfo(action.target, layer)
		local targetLayer = self:getLayerFromMapInfo({
			resource = action.event.targetMapResource,
			localLayer = action.event.targetMapLocalLayer,
		})

		if peep and targetLayer >= 1 then
			local callback, id = Utility.Peep.queueWalk(peep, Vector(action.positionX, action.positionY, action.positionZ), targetLayer, math.huge, { asCloseAsPossible = true })

			local isComplete = false
			local success
			callback:register(function(s)
				success = s
				isComplete = true
			end)

			repeat
				coroutine.yield(DebugManipulateController.ACTION_PROCESSING)
			until isComplete

			if success then
				local isDone = false
				isDone = not peep:getCommandQueue():push(CallbackCommand(function()
					isDone = true
				end))

				while not isDone do
					coroutine.yield(DebugManipulateController.ACTION_PENDING)
				end
			end
		end

		return DebugManipulateController.ACTION_COMPLETE
	end
end

function DebugManipulateController.REPLAYED_ACTIONS:performAction(action)
	return function()
		local brochure = self:getGame():getGameDB():getBrochure()
		local playerLayer = self:getLayerFromMapInfo(action.map)
		local playerPeep = self:getPeepFromTargetInfo(action.target, playerLayer)
		local targetLayer = self:getLayerFromMapInfo({
			resource = action.event.targetMapResource,
			localLayer = action.event.targetMapLocalLayer,
		})
		local targetPeep = self:getPeepFromTargetInfo({
			mapObjectName = action.event.targetMapObjectName,
			peepID = action.event.targetPeepID,
		}, targetLayer)

		if playerPeep and targetPeep then
			local resource
			if action.event.targetResourceType == "MapObject" then
				resource = Utility.Peep.getMapObject(targetPeep)
			else
				resource = Utility.Peep.getResource(targetPeep)
			end

			local resourceType = resource and brochure:getResourceTypeFromResource(resource)
			local targetAction

			if resourceType and resourceType.name == action.event.targetResourceType then
				local currentActionIndex = 0

				for a in brochure:findActionsByResource(resource) do
					local actionDefinition = brochure:getActionDefinitionFromAction(a)
					if actionDefinition.name == action.event.actionDefinition then
						currentActionIndex = currentActionIndex + 1

						if currentActionIndex == action.event.actionIndex then
							targetAction = a
							break
						end
					end
				end
			end

			if targetAction then
				local playerModel = Utility.Peep.getPlayerModel(playerPeep)
				local actor = targetPeep:hasBehavior(ActorReferenceBehavior) and targetPeep:getBehavior(ActorReferenceBehavior).actor
				local prop = targetPeep:hasBehavior(PropReferenceBehavior) and targetPeep:getBehavior(PropReferenceBehavior).prop
				local object = actor or prop

				if playerModel and playerModel:getActor() and playerModel:getActor():getPeep() == playerPeep and object then
					playerModel:poke(targetAction.id.value, object, "world")
					coroutine.yield(DebugManipulateController.ACTION_PROCESSING)
				end
			end
		end

		return DebugManipulateController.ACTION_COMPLETE
	end
end

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

	self:getPeep():addBehavior(ImmortalBehavior)
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

	if not (objectTargetInfo and objectMapInfo) then
		return
	end

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
					id = presetStorage:get("id"),
					name = presetStorage:get("name")
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
	elseif actionID == "duplicate" then
		self:duplicatePreset(e)
	elseif actionID == "rename" then
		self:renamePreset(e)
	elseif actionID == "spawnActor" then
		self:spawnActor(e)
	elseif actionID == "spawnProp" then
		self:spawnProp(e)
	elseif actionID == "spawnGlyphCircle" then
		self:spawnGlyphCircle(e)
	elseif actionID == "playAnimation" then
		self:playAnimation(e)
	elseif actionID == "changeSkin" then
		self:changeSkin(e)
	elseif actionID == "setMashinaState" then
		self:setMashinaState(e)
	elseif actionID == "talk" then
		self:talk(e)
	elseif actionID == "flashPower" then
		self:flashPower(e)
	elseif actionID == "transform" then
		self:transform(e)
	elseif actionID == "saveLocation" then
		self:saveLocation(e)
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
	elseif actionID == "mergePrevious" then
		self:mergePrevious(e)
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
	elseif actionID == "startReplay" then
		self:startReplay(e)
	elseif actionID == "stopReplay" then
		self:stopReplay(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function DebugManipulateController:close()
	if self.isRecording then
		self:stopRecording()
	end

	self:getPeep():silence("actionTried", self._onPeepTryAction)
	self:getPeep():silence("walk", self._onPeepWalk)
	self:getPeep():removeBehavior(ImmortalBehavior)
end

function DebugManipulateController:startRecording(e)
	if self.replay then
		self:stopReplay()
	end

	if self.isRecording then
		self:stopRecording()
	end

	self.isRecording = true
	self.recordingMapResource = e.resource or self.layers[1]
	self.recordingID = e.id or 0
	self.recordingIndex = e.index or -1
	self.recordingQueue = {}
end

function DebugManipulateController:stopRecording()
	self.isRecording = false

	local presetStorage, index = self:getPresetStorage(self.recordingMapResource, self.recordingID)
	if not presetStorage then
		return
	end

	if self.recordingIndex >= 1 and self.recordingIndex <= presetStorage:length() then
		local preset = presetStorage:get()
		presetStorage:clear()

		for i = #self.recordingQueue, 1, -1 do
			table.insert(preset, self.recordingIndex, self.recordingQueue[i])
		end

		presetStorage:set(preset)
	else
		for i = 1, #self.recordingQueue do
			presetStorage:set(presetStorage:length() + 1, self.recordingQueue[i])
		end
	end

	self:send("finishRecording", { resource = self.recordingMapResource, index = index, id = self.recordingID })
end

function DebugManipulateController:startReplay(e)
	if self.isRecording then
		self:stopRecording()
	end

	if self.replay then
		self:stopReplay()
	end

	self.replayMapResource = e.resource or self.layers[1]
	self.replayID = e.id or 0

	local storage = self:getPresetStorage(self.replayMapResource, self.replayID)
	if not storage then
		return
	end

	local preset = storage:get()
	self.replay = coroutine.wrap(self:generateReplay(preset))

	for peep in pairs(self.peepToID) do
		local resource = Utility.Peep.getResource(peep)
		if resource and resource.name == "CameraDolly" then
			peep:poke("hidden")
		end
	end

	local player = Utility.Peep.getPlayerModel(self:getPeep())
	player:pushCamera("DebugManipulate")
	player:pokeCamera("copyTransforms")
end

function DebugManipulateController:stopReplay()
	self.replay = nil

	local _, index = self:getPresetStorage(self.recordingMapResource, self.recordingID)
	self:send("finishReplay", { resource = self.replayMapResource, index = index, id = self.replayID })

	local player = Utility.Peep.getPlayerModel(self:getPeep())
	player:popCamera()

	for peep in pairs(self.peepToID) do
		local resource = Utility.Peep.getResource(peep)
		if resource and resource.name == "CameraDolly" then
			peep:poke("visible")
		end
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

function DebugManipulateController:duplicatePreset(e)
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

	local preset = self:getPresetStorage(e.resource, e.id):get()
	preset.id = id

	mapStorage:set(mapStorage:length() + 1, preset)

	self:populate()
end

function DebugManipulateController:renamePreset(e)
	if self.isRecording then
		self:stopRecording()
	end

	local preset = self:getPresetStorage(e.resource, e.id)
	if not e.name then
		preset:unset("name", e.name)
	else
		preset:set("name", e.name)
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
			id = e.id,
			name = presetStorage:get("name")
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
	local id = self.peepToID[target]
	if target and target:wasPoofed() then
		self.peepToID[target] = nil
		self.idToPeep[id] = nil
	end

	return self.peepToID[target]
end

function DebugManipulateController:getRecordedPeep(id)
	local target = self.idToPeep[id]
	if target and target:wasPoofed() then
		self.peepToID[target] = nil
		self.idToPeep[id] = nil
	end

	return self.idToPeep[id]
end

function DebugManipulateController:getLayerFromMapInfo(mapInfo)
	local instance = Utility.Peep.getInstance(self:getPeep())

	for group, layers in instance:iterateMapGroups() do
		local baseMapScript = instance:getMapScriptByLayer(instance:getGlobalLayerFromLocalLayer(group, 1))
		local mapResource = baseMapScript and Utility.Peep.getResource(baseMapScript)
		if mapResource and mapResource.name == mapInfo.resource and layers[mapInfo.localLayer] then
			return layers[mapInfo.localLayer], instance:getMapScriptByLayer(layers[mapInfo.localLayer])
		end
	end

	return -1
end

function DebugManipulateController:getPeepFromTargetInfo(targetInfo, layer)
	if layer <= 0 then
		return nil
	end

	if targetInfo.mapObjectName then
		local hits = self:getDirector():probe(
			self:getPeep():getLayerName(),
			Probe.layer(layer),
			Probe.namedMapObject(targetInfo.mapObjectName))

		return hits[1]
	end

	if targetInfo.peepID then
		return self:getRecordedPeep(targetInfo.peepID)
	end

	return nil
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
		}) or self:getGame():getGameDB():getRecord("MapObjectReference", {
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
	local result, index, name
	do
		local p, i = self:getPresetStorage(self.recordingMapResource, self.recordingID)
		if p and i then
			result = p:get()
			index = i
			name = p:get("name")
		end

		result = result or {}
		for i, q in ipairs(self.recordingQueue) do
			table.insert(result, q)
		end
	end

	self:send("showPreset", {
		resource = self.recordingMapResource,
		index = index,
		id = self.recordingID,
		name = name
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
	   ((previousAction.target.mapObjectName and previousAction.target.mapObjectName == action.target.mapObjectName) or (previousAction.target.peepID and previousAction.target.peepID == action.target.peepID))
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

	local x, y, z = e.positionX, e.positionY, e.positionZ
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
	
	local x, y, z = e.positionX, e.positionY, e.positionZ
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

function DebugManipulateController:spawnGlyphCircle(e)
	local instance = Utility.Peep.getInstance(self:getPeep())
	local mapScript = instance:getMapScriptByLayer(e.layer)
	local map = self:getDirector():getMap(e.layer)
	if not (mapScript and map) then
		return
	end
	
	local x, y, z = e.positionX, e.positionY, e.positionZ
	local prop = Utility.spawnPropAtPosition(mapScript, "ProjectedGlyph", x, y, z)
	Utility.Peep.setSize(prop:getPeep(), Vector((e.glyphWidth or 4) * map:getCellSize(), 1, (e.glyphHeight or 4) * map:getCellSize()))

	local _, description = prop:getPeep():addBehavior(OldOneDescriptionBehavior)
	description.description = e.glyphDescription or 1

	if e.fadeDuration and e.fadeDuration > 0 then
		prop:getPeep():pushPoke("fade", e.fadeDuration / 1000, e.fadeDelay / 1000)
	end

	if self.isRecording then
		self:recordPeep(prop:getPeep(), e.peepID)
		self:record(e.layer, prop:getPeep(), "spawnGlyphCircle", {
			positionX = x,
			positionY = y,
			positionZ = z,
			glyphDescription = e.glyphDescription or 1,
			glyphWidth = e.glyphWidth or 4,
			glyphHeight = e.glyphHeight or 4,
			fadeDuration = e.fadeDuration or 0,
			fadeDelay = e.fadeDelay or 0,
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
	local success = Utility.Peep.Human.applySkin(actor:getPeep(), slotIndex or tonumber(e.slot) or e.slot, e.priority, e.filename)
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

function DebugManipulateController:setMashinaState(e)
	local actor = self:getGame():getStage():getActorByID(e.actorID)
	if not actor then
		return
	end

	local selfInstance = Utility.Peep.getInstance(self:getPeep())
	local otherInstance = Utility.Peep.getInstance(actor:getPeep())

	if selfInstance ~= otherInstance then
		return
	end

	local filename = _getMashinaTreeFilename(actor:getPeep(), e.filename)
	if filename then
		local code = love.filesystem.load(filename)
		local _, mashina = actor:getPeep():addBehavior(MashinaBehavior)
		mashina.states[e.state] = code()
	end

	Utility.Peep.setMashinaState(actor:getPeep(), e.state)

	if self.isRecording then
		self:record(Utility.Peep.getLayer(actor:getPeep()), actor:getPeep(), "setMashinaState", {
			state = e.state,
			filename = e.filename
		})
	end
end

function DebugManipulateController:talk(e)
	local actor = self:getGame():getStage():getActorByID(e.actorID)
	if not actor then
		return
	end

	local selfInstance = Utility.Peep.getInstance(self:getPeep())
	local otherInstance = Utility.Peep.getInstance(actor:getPeep())

	if selfInstance ~= otherInstance then
		return
	end

	if self.isRecording then
		self:record(Utility.Peep.getLayer(actor:getPeep()), actor:getPeep(), "talk", {
			message = e.message or "'Ey!",
			color = e.color or "ffff00"
		})
	end

	Utility.Peep.talk(actor:getPeep(), e.message or "'Ey!", Color.fromHexString(e.color or "ffff00"))
end

function DebugManipulateController:flashPower(e)
	local actor = self:getGame():getStage():getActorByID(e.actorID)
	if not actor then
		return
	end

	local selfInstance = Utility.Peep.getInstance(self:getPeep())
	local otherInstance = Utility.Peep.getInstance(actor:getPeep())

	if selfInstance ~= otherInstance then
		return
	end

	if self.isRecording then
		self:record(Utility.Peep.getLayer(actor:getPeep()), actor:getPeep(), "flashPower", {
			power = e.power or ""
		})
	end

	local gameDB = peep:getDirector():getGameDB()
	local resource = gameDB:getResource(power, "Power")
	local powerName = resource and Utility.getName(resource, gameDB) or power

	Utility.Peep.flash(actor:getPeep(), "Power", 0.5, action.event.power, powerName)
end

function DebugManipulateController:saveLocation(e)
	local actor = self:getGame():getStage():getActorByID(e.id)
	local peep = actor and actor:getPeep()
	if not peep then
		return
	end

	local selfInstance = Utility.Peep.getInstance(self:getPeep())
	local peepInstance = Utility.Peep.getInstance(peep)

	if selfInstance ~= peepInstance then
		return
	end

	local layerInfo = self:getMapInfo(Utility.Peep.getLayer(peep))
	if layerInfo then
		self:mergeOrRecord(Utility.Peep.getLayer(peep), peep, "setLayer", {
			destinationMapResource = layerInfo.resource,
			destinationMapLocalLayer = layerInfo.localLayer,
		})
	end

	local position = Utility.Peep.getPosition(peep)
	local rotation = peep:hasBehavior(RotationBehavior) and Utility.Peep.getRotation(peep)
	local rotationX, rotationY, rotationZ
	if rotation then
		rotationX, rotationY, rotationZ = rotation:getEulerXYZ()
		rotationX, rotationY, rotationZ = math.deg(rotationX), math.deg(rotationY), math.deg(rotationZ)
	end
	local scale = peep:hasBehavior(ScaleBehavior) and Utility.Peep.getScale(peep)

	self:mergeOrRecord(Utility.Peep.getLayer(peep), peep, "transform", {
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
	if type(e.positionX) == "number" and type(e.positionY) == "number" and type(e.positionZ) == "number" then
		peep:addBehavior(PositionBehavior)

		if event.noClip == nil then
			local movement = peep:getBehavior(MovementBehavior)
			local y = Utility.Peep.getPosition(peep).y
			if e.positionY > y and event.noClip == nil and movement then
				movement.noClip = true
				event.noClip = true
			else
				event.noClip = movement and movement.noClip or false
			end
		end

		Utility.Peep.setPosition(peep, Vector(e.positionX, e.positionY, e.positionZ))

		event.positionX = e.positionX
		event.positionY = e.positionY
		event.positionZ = e.positionZ
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

	local overrideActor = self:getGame():getStage():getActorByID(e.overrideActorID)
	local overridePeep = overrideActor and overrideActor:getPeep()

	if e.overrideActorID and not overridePeep then
		return
	end

	if not (peep or overridePeep) then
		return
	end

	local otherActor = self:getGame():getStage():getActorByID(e.otherActorID)
	local otherPeep = otherActor and otherActor:getPeep()

	if e.otherActorID and not otherPeep then
		return
	end

	local selfInstance = Utility.Peep.getInstance(self:getPeep())
	local peepInstance = peep and Utility.Peep.getInstance(peep)
	local otherInstance = otherPeep and Utility.Peep.getInstance(otherPeep)
	local overrideInstance = overridePeep and Utility.Peep.getInstance(overridePeep)

	if (peep and peepInstance ~= selfInstance) or
	   (otherPeep and otherInstance ~= selfInstance) or
	   (overridePeep and overrideInstance ~= selfInstance)
	then
		return
	end

	if self.isRecording then
		local otherMapInfo = otherPeep and self:getMapInfo(Utility.Peep.getLayer(otherPeep))
		local otherTargetInfo = otherMapInfo and self:getTargetInfo(otherPeep)
		local overrideMapInfo = overridePeep and self:getMapInfo(Utility.Peep.getLayer(overridePeep))
		local overrideTargetInfo = overrideMapInfo and self:getTargetInfo(overridePeep)

		self:mergeOrRecord(Utility.Peep.getLayer(peep or overridePeep), peep or overridePeep, "orientateCamera", {
			targetMapObjectName = otherTargetInfo and otherTargetInfo.mapObjectName,
			targetPeepID = otherTargetInfo and otherTargetInfo.peepID,
			targetMapResource = otherMapInfo and otherMapInfo.resource,
			targetMapLocalLayer = otherMapInfo and otherMapInfo.localLayer,
			bone = "",
			overrideMapResource = overrideMapInfo and overrideMapInfo.resource,
			overrideMapLocalLayer = overrideMapInfo and overrideMapInfo.localLayer,
			overridePeepID = overrideTargetInfo and overrideTargetInfo.peepID,
			overrideBone = overridePeep and "" or nil
		})
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

	local defendAnimation
	do
		local direction = targetPeep:hasBehavior(MovementBehavior) and targetPeep:getBehavior(MovementBehavior).facing

		local shield = Utility.Peep.getEquippedShield(targetPeep)
		if shield and direction and targetPeep:hasBehavior(HumanoidBehavior) then
			if direction == MovementBehavior.FACING_LEFT then
				defendAnimation = targetPeep:getResource(
					"animation-defend-shield-left",
					"ItsyScape.Graphics.AnimationResource")
			elseif direction == MovementBehavior.FACING_RIGHT then
				defendAnimation = targetPeep:getResource(
					"animation-defend-shield-right",
					"ItsyScape.Graphics.AnimationResource")
			end
		end

		if not defendAnimation then
			resource = targetPeep:getResource("animation-defend", "ItsyScape.Graphics.AnimationResource")
		end
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

		if defendAnimation then
			self:record(Utility.Peep.getLayer(targetPeep), targetPeep, "playAnimation", {
				slot = "combat-attack",
				priority = 50,
				animation = defendAnimation:getFilename()
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

function DebugManipulateController:walk(e)
	local actor = e.peepID and self:getGame():getStage():getActorByID(e.peepID)
	local peep = actor and actor:getPeep()

	local instance = Utility.Peep.getInstance(peep)
	local selfInstance = Utility.Peep.getInstance(self:getPeep())

	if instance ~= selfInstance then
		return
	end

	local targetMapInfo = self:getMapInfo(e.layer)
	if not targetMapInfo then
		return
	end

	if self.isRecording then
		self:record(Utility.Peep.getLayer(self:getPeep()), self:getPeep(), "walk", {
			targetMapResource = targetMapInfo.resource,
			targetMapLocalLayer = targetMapInfo.localLayer,
			positionX = e.positionX,
			positionY = e.positionY,
			positionZ = e.positionZ
		})
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

function DebugManipulateController:mergePrevious(e)
	local presetStorage = self:getPresetStorage(e.resource, e.id)
	if not presetStorage then
		return
	end

	local action = presetStorage:getSection(e.index):get()
	for i = e.index - 1, 1, -1 do
		local otherAction = presetStorage:getSection(i):get()
		if otherAction and otherAction.type == action.type and
		   otherAction.map.resource == action.map.resource and
		   otherAction.map.localLayer == action.map.localLayer and
		   ((otherAction.target.mapObjectName and otherAction.target.mapObjectName == action.target.mapObjectName) or (otherAction.target.peepID and otherAction.target.peepID == action.target.peepID))
		then
			for k, v in pairs(action.event) do
				otherAction.event[k] = v
			end

			local actionStorage = presetStorage:getSection(i)
			actionStorage:clear()
			actionStorage:set(otherAction)

			presetStorage:removeSection(e.index)

			self:selectPreset({
				resource = e.resource,
				id = e.id
			})
		end
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

function DebugManipulateController:generateReplay(preset)
	return function()
		local currentIndex, currentLength = 1, 0

		while currentIndex <= #preset do
			local pendingActionGroup = {}

			local startAction = preset[currentIndex]
			local pendingActionGroup = {
				{ action = startAction }
			}

			currentLength = 1
			for i = currentIndex + 1, #preset do
				local action = preset[i]
				if not action.timing or action.timing.mode == "parallel" or action.timing.mode == "off" then
					table.insert(pendingActionGroup, { action = action })
					currentLength = currentLength + 1
				else
					break
				end
			end

			for _, pendingAction in ipairs(pendingActionGroup) do
				local action = pendingAction.action

				pendingAction.timeInfo = {
					elapsed = 0,
					delta = (not action.timing or action.timing.duration <= 0) and 1 or action.timing.duration,
					status = DebugManipulateController.ACTION_NOT_STARTED
				}

				pendingAction.callback = self.REPLAYED_ACTIONS[action.type] and coroutine.wrap(self.REPLAYED_ACTIONS[action.type](self, action))
			end

			local complete = false
			local previousTime = love.timer.getTime()
			repeat
				local currentTime = love.timer.getTime()
				local elapsed = currentTime - previousTime
				previousTime = currentTime

				local numCompleteActions = 0
				for _, pending in ipairs(pendingActionGroup) do
					local action = pending.action
					local duration = action.timing and action.timing.mode ~= "off" and action.timing.duration or 0
					local delay = action.timing and action.timing.mode ~= "off" and action.timing.delay or 0
					local tween = action.timing and action.timing.tween or "sineEaseInOut"

					pending.timeInfo.elapsed = pending.timeInfo.elapsed + elapsed
					if duration > 0 then
						local tweenFunc = Tween[tween] or Tween.linear
						pending.timeInfo.delta = tweenFunc(math.clamp(math.max(pending.timeInfo.elapsed - delay, 0) / duration))
					else
						pending.timeInfo.delta = 1
					end

					if pending.timeInfo.status ~= DebugManipulateController.ACTION_COMPLETE then
						if pending.timeInfo.elapsed >= delay then
							local status = pending.callback and pending.callback(pending.timeInfo)
							if not status or status == DebugManipulateController.ACTION_COMPLETE then
								status = DebugManipulateController.ACTION_COMPLETE
							elseif status == DebugManipulateController.ACTION_PENDING then
								if not action.timing or action.timing.mode == "off" then
									status = DebugManipulateController.ACTION_COMPLETE
								end
							end

							pending.timeInfo.status = status
						end
					elseif pending.timeInfo.elapsed - delay >= duration then
						numCompleteActions = numCompleteActions + 1
					end
				end

				complete = numCompleteActions == #pendingActionGroup
				coroutine.yield(DebugManipulateController.ACTION_PENDING)
			until complete

			currentIndex = currentIndex + currentLength
		end

		return DebugManipulateController.ACTION_COMPLETE
	end
end

function DebugManipulateController:pull()
	return {
		isRecording = self.isRecording,
		isReplaying = self.replay ~= nil,
		layers = self.layers,
		presets = self.presets
	}
end

function DebugManipulateController:update(delta)
	Controller.update(self, delta)

	if self.replay then
		local status = self.replay()
		if status == DebugManipulateController.ACTION_COMPLETE then
			self:stopReplay()
		end
	end
end

return DebugManipulateController
