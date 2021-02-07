--------------------------------------------------------------------------------
-- ItsyScape/Game/Cutscene.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MirrorSandbox = require "ItsyScape.Common.MirrorSandbox"
local CutsceneEntity = require "ItsyScape.Game.CutsceneEntity"
local CutsceneMap = require "ItsyScape.Game.CutsceneMap"
local Utility = require "ItsyScape.Game.Utility"

local Cutscene = Class()

function Cutscene:new(resource, player, director, layerName)
	self.director = director
	self.game = director:getGameInstance()
	self.gameDB = director:getGameDB()
	self.layerName = layerName
	self.resource = resource

	self.entities = {
		Player = CutsceneEntity(player),
		Map = CutsceneMap(Utility.Peep.getMapScript(player))
	}

	self:findMapObjects()
	self:findPeeps()
	self:findProps()
	self:findMaps()

	self:loadCutscene()
end

function Cutscene:addEntity(name, Type, probe)
	local hits = self.director:probe(self.layerName, probe)
	if #hits > 1 then
		Log.warn("More than 1 hit for '%s'; will use first found.", name)
	elseif #hits == 0 then
		Log.warn("No hit found for '%s'.", name)
		return
	end

	if self.entities[name] then
		Log.error("Entity '%s' already exists in cutscene %s..", name, self.resource.name)
		return
	end

	local peep = hits[1]
	self.entities[name] = Type(peep)
end

function Cutscene:find(recordName, Type, getResourceMethod)
	local records = self.gameDB:getRecords(recordName, {
		Cutscene = self.resource
	})

	for i = 1, #records do
		self:addEntity(records[i]:get("Name"), Type, function(p)
			local resource = getResourceMethod(p)
			return resource and resource.id.value == records[i]:get("Resource").id.value
		end)
	end

	Log.info("Added %d of '%s' record(s).", #records, recordName)
end

function Cutscene:findMapObjects()
	self:find("CutsceneMapObject", CutsceneEntity, Utility.Peep.getMapObject)
end

function Cutscene:findPeeps()
	self:find("CutscenePeep", CutsceneEntity, Utility.Peep.getResource)
end

function Cutscene:findProps()
	self:find("CutsceneProp", CutsceneEntity, Utility.Peep.getResource)
end

function Cutscene:findMaps()
	self:find("CutsceneMap", CutsceneMap, Utility.Peep.getResource)
end

function Cutscene.parallel(t)
	local transformedT = {}
	for i = 1, #t do
		transformedT[i] = coroutine.create(t[i])
	end

	local statusT = {}

	return function()
		local isRunning
		repeat
			isRunning = false
			for i = 1, #transformedT do
				local status = statusT[i]
				if status ~= "dead" then 
					local s, e = coroutine.resume(transformedT[i])
					if not s then
						Log.warn("Error running cutscene: %s", e)
					end

					statusT[i] = coroutine.status(transformedT[i])
					isRunning = true
				end
			end

			coroutine.yield()
		until not isRunning
	end
end

function Cutscene.sequence(t)
	return function()
		for i = 1, #t do
			t[i]()
		end
	end
end

function Cutscene:getSandbox()
	local gSandbox, sSandbox = MirrorSandbox()
	sSandbox.Sequence = Cutscene.sequence
	sSandbox.Parallel = Cutscene.parallel

	for name, entity in pairs(self.entities) do
		sSandbox[name] = entity
	end

	return gSandbox
end

function Cutscene.empty()
	Log.info("No cutscene executed.")
end

function Cutscene:loadCutscene()
	local sandbox = self:getSandbox()
	local filename = string.format("Resources/Game/Cutscenes/%s/Cutscene.lua", self.resource.name)

	local data = (love.filesystem.read(filename) or "")
	local chunk = assert(loadstring(data))
	local s, r = pcall(setfenv(chunk, sandbox))
	if not s then
		Log.warn("Couldn't compile cutscene '%s': %s", self.resource.name, r)
		r = Cutscene.empty
	end

	self.script = coroutine.create(r)	
end

function Cutscene:update()
	if coroutine.status(self.script) ~= "dead" then
		local s, e = coroutine.resume(self.script)
		if not s then
			Log.warn("Error running cutscene '%s': %s", self.resource.name, e)
		end

		return true
	end

	return false
end

return Cutscene
