--------------------------------------------------------------------------------
-- Resources/Game/Peeps/ViziersRock/SewersCommon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Equipment = require "ItsyScape.Game.Equipment"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local Common = {}

Common.MARK_TRIANGLE = "triangle"
Common.MARK_SQUARE   = "square"
Common.MARK_CIRCLE   = "circle"
Common.MARK_STAR     = "star"
Common.MARK_NONE     = "none"

Common.DOOR_CLOSED_SIZE = Vector(5.5, 8, 5.5)
Common.DOOR_OPENED_SIZE = Vector(0)

function Common:hasValveBeenOpenedOrClosed(shape)
	local storageProvider = Utility.Peep.getRaid(self) or Utility.Peep.getInstance(self)
	local storage = storageProvider:getPlayerStorage()
	local doorsStorage = storage:getRoot():getSection("Doors")
	return doorsStorage:get(shape) == nil
end

function Common:closeValve(shape)
	local storageProvider = Utility.Peep.getRaid(self) or Utility.Peep.getInstance(self)
	local storage = storageProvider:getPlayerStorage()

	local doorsStorage = storage:getRoot():getSection("Doors")
	local shapeCount = doorsStorage:get(shape)
	doorsStorage:set(shape, (shapeCount or 0) + 1)
end

function Common:closeValve(shape)
	local storageProvider = Utility.Peep.getRaid(self) or Utility.Peep.getInstance(self)
	local storage = storageProvider:getPlayerStorage()

	local doorsStorage = storage:getRoot():getSection("Doors")
	local shapeCount = doorsStorage:get(shape)
	doorsStorage:set(shape, math.max((shapeCount or 1) - 1, 0))
end

function Common:updateValve(mapObjectName, verticalMark, horizontalMark)
	local valve = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject(mapObjectName))[1]

	if not valve then
		Log.errorOnce("Valve '%s' not found when updating.", mapObjectName, shape)
		return
	end

	local storageProvider = Utility.Peep.getRaid(self) or Utility.Peep.getInstance(self)
	local storage = storageProvider:getPlayerStorage()

	local valvesStorage = storage:getRoot():getSection("Valves"):getSection(self:getLayerName())
	local valveStorage = valvesStorage:getSection(mapObjectName)

	local currentDirection = valve:getDirection()
	local previousDirection = valveStorage:get("direction")
	if currentDirection ~= previousDirection then
		valveStorage:set("direction", currentDirection)

		local doorsStorage = storage:getRoot():getSection("Doors")
		local shapeCount = doorsStorage:get(shape)

		if previousDirection ~= nil then
			if previousDirection == valve.VERTICAL then
				doorsStorage:set(verticalMark, math.max((doorsStorage:get(verticalMark) or 1) - 1, 0))
			elseif previousDirection == valve.HORIZONTAL then
				doorsStorage:set(horizontalMark, math.max((doorsStorage:get(horizontalMark) or 1) - 1, 0))
			end
		end

		if currentDirection == valve.VERTICAL then
			doorsStorage:set(verticalMark, (doorsStorage:get(verticalMark) or 0) + 1)
		elseif currentDirection == valve.HORIZONTAL then
			doorsStorage:set(horizontalMark, (doorsStorage:get(horizontalMark) or 0) + 1)
		end
	end
end

function Common:updateDoor(mapObjectName, shape)
	local door = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject(mapObjectName))[1]

	if not door then
		Log.errorOnce("Door '%s' not found when updating (shape = '%s').", mapObjectName, shape)
		return
	end

	local storageProvider = Utility.Peep.getRaid(self) or Utility.Peep.getInstance(self)
	local storage = storageProvider:getPlayerStorage()

	local doorsStorage = storage:getRoot():getSection("Doors")
	local shapeCount = doorsStorage:get(shape)
	if shapeCount and shapeCount > 0 then
		if not door:getIsOpen() then
			door:poke("open")

			local size = door:getBehavior(SizeBehavior)
			size.size = Common.DOOR_OPENED_SIZE
		end
	else
		if door:getIsOpen() then
			local size = door:getBehavior(SizeBehavior)
			size.size = Common.DOOR_CLOSED_SIZE

			door:poke("close")
		end
	end
end

return Common
