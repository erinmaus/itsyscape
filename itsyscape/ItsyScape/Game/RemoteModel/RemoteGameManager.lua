--------------------------------------------------------------------------------
-- ItsyScape/Game/RemoteModel/RemoteGameManager.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local buffer = require "string.buffer"
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local GameProxy = require "ItsyScape.Game.Model.GameProxy"
local StageProxy = require "ItsyScape.Game.Model.StageProxy"
local PlayerProxy = require "ItsyScape.Game.Model.PlayerProxy"
local UIProxy = require "ItsyScape.Game.Model.UIProxy"
local RemoteActor = require "ItsyScape.Game.RemoteModel.Actor"
local RemoteGame = require "ItsyScape.Game.RemoteModel.Game"
local RemotePlayer = require "ItsyScape.Game.RemoteModel.Player"
local RemoteProp = require "ItsyScape.Game.RemoteModel.Prop"
local RemoteStage = require "ItsyScape.Game.RemoteModel.Stage"
local RemoteUI = require "ItsyScape.Game.RemoteModel.UI"
local EventQueue = require "ItsyScape.Game.RPC.EventQueue"
local OutgoingEventQueue = require "ItsyScape.Game.RPC.OutgoingEventQueue"
local GameManager = require "ItsyScape.Game.RPC.GameManager"
local TypeProvider = require "ItsyScape.Game.RPC.TypeProvider"
local NGameManager = require "nbunny.gamemanager"
local NEventQueue = require "nbunny.gamemanager.eventqueue"
local NVariant = require "nbunny.gamemanager.variant"

local RemoteGameManager = Class(GameManager)

function RemoteGameManager:new(rpcService, ...)
	GameManager.new(self)

	self.rpcService = rpcService

	self.pending = NEventQueue()
	self.event = NVariant()

	self:registerInterface("ItsyScape.Game.Model.Actor", RemoteActor)
	self:registerInterface("ItsyScape.Game.Model.Game", RemoteGame)
	self:registerInterface("ItsyScape.Game.Model.Stage", RemoteStage)
	self:registerInterface("ItsyScape.Game.Model.Player", RemotePlayer)
	self:registerInterface("ItsyScape.Game.Model.Prop", RemoteProp)
	self:registerInterface("ItsyScape.Game.Model.UI", RemoteUI)

	self.processedTicks = {
		["ItsyScape.Game.Model.Actor"] = 0,
		["ItsyScape.Game.Model.Game"] = 0,
		["ItsyScape.Game.Model.Stage"] = 0,
		["ItsyScape.Game.Model.Player"] = 0,
		["ItsyScape.Game.Model.Prop"] = 0,
		["ItsyScape.Game.Model.UI"] = 0
	}

	self:newInstance("ItsyScape.Game.Model.Game", 0, RemoteGame(self, ...))
	GameProxy:wrapClient(
		"ItsyScape.Game.Model.Game",
		0,
		self:getInstance("ItsyScape.Game.Model.Game", 0):getInstance(),
		self)
	self.game = self:getInstance("ItsyScape.Game.Model.Game", 0):getInstance()
	self:newInstance("ItsyScape.Game.Model.Stage", 0, RemoteStage(self))
	StageProxy:wrapClient(
		"ItsyScape.Game.Model.Stage",
		0,
		self:getInstance("ItsyScape.Game.Model.Stage", 0):getInstance(),
		self)
	self:newInstance("ItsyScape.Game.Model.UI", 0, RemoteUI(self))
	UIProxy:wrapClient(
		"ItsyScape.Game.Model.UI",
		0,
		self:getInstance("ItsyScape.Game.Model.UI", 0):getInstance(),
		self)

	self.onTick = Callback(false)

	self.rpcService:connect(self)
end

function RemoteGameManager:getRPCService()
	return self.rpcService
end

function RemoteGameManager:swapRPCService(rpcService)
	self.rpcService = rpcService
	self.rpcService:connect(self)

	self:removeAllInstances("ItsyScape.Game.Model.Actor")
	self:removeAllInstances("ItsyScape.Game.Model.Prop")

	for interface in pairs(self.processedTicks) do
		self.processedTicks[interface] = 0
	end
end

function RemoteGameManager:removeAllInstances(type)
	local instances = {}
	for instance in self:iterateInstances(type) do
		table.insert(instances, instance)
	end

	for i = 1, #instances do
		self:destroyInstance(type, instances[i]:getID())
	end
end

function RemoteGameManager:send()
	self.rpcService:sendBatch(0, self:getQueue():toBuffer())
	self:getQueue():tick()
end

function RemoteGameManager:receive()
	local b = love.timer.getTime()
	local e
	local t = false
	local o = 0
	local c = 0
	repeat
		e = self.rpcService:receive()
		if e then
		local x = love.timer.getTime() 
			self.pending:pull(e)
			local a = love.timer.getTime() 
			o = o + (a - x)
			c = c + 1
			if e.type == EventQueue.EVENT_TYPE_TICK then
				if e.interface then
					if self.processedTicks[e.interface] then
						self.processedTicks[e.interface] = self.processedTicks[e.interface] + 1

						local isMatch = true
						for _, ticks in pairs(self.processedTicks) do
							if ticks == 0 then
								isMatch = false
							end
						end

						if isMatch then
							for interface, ticks in pairs(self.processedTicks) do
								self.processedTicks[interface] = ticks - 1
							end

							self.pending:sort("__timestamp")
							self.onTick(self:getInstance("ItsyScape.Game.Model.Game", 0):getInstance())
							self:flush()

							break
						end
					end
				else
					t = true
					self.onTick(self:getInstance("ItsyScape.Game.Model.Game", 0):getInstance())
					self:flush()

					break
				end
			end
		end
	until e == nil
	local a = love.timer.getTime()

	return false
end

function RemoteGameManager:_flush()
	local b = love.timer.getTime()
	local n = 0
	for i = 1, self.pending:length() do
		n = n + 1
		self.pending:get(i - 1, self.event)
		self:process(self.event)

		if self.event.type == EventQueue.EVENT_TYPE_TICK then
			local j = i + 1
			while self.event.type == EventQueue.EVENT_TYPE_TICK and j <= self.pending:length() do
				self.pending:get(j - 1, self.event)
				j = j + 1
			end

			break
		end
	end
	local a = love.timer.getTime()

	self.pending:clear(n)
end

function RemoteGameManager:flush()
	self:getDebugStats():measure(
		"RemoteGameManager::flush",
		self._flush,
		self)
end

function RemoteGameManager:pushTick()
	GameManager.pushTick(self)

	self:send()
end

function RemoteGameManager:processCreate(e)
	local exists = self:getInstance(e.interface, e.id)
	if exists then
		Log.debug("Interface '%s' with ID %d already exists; ignoring create.", e.interface, e.id)
		return
	end

	Log.engine("Creating '%s' (%d).", e.interface, e.id)

	local proxyTypeName = string.format("%sProxy", e.interface)
	local proxy = require(proxyTypeName)

	local Type = self:getInterfaceType(e.interface)
	local instance = Type(self, e.id)
	instance.id = e.id

	self:newInstance(e.interface, e.id, instance)
	proxy:wrapClient(e.interface, e.id, instance, self)
end

function RemoteGameManager:processDestroy(e)
	Log.engine("Destroying '%s' (%d).", e.interface, e.id)
	self:destroyInstance(e.interface, e.id)
end

function RemoteGameManager:processCallback(e)
	self:getDebugStats():measure(
		string.format("%s::%s::%s", EventQueue.EVENT_TYPE_CALLBACK, e.interface, e.callback),
		GameManager.processCallback,
		self,
		e)
end

function RemoteGameManager:processProperty(e)
	self:getDebugStats():measure(
		string.format("%s::%s::%s", EventQueue.EVENT_TYPE_PROPERTY, e.interface, e.property),
		GameManager.processProperty,
		self,
		e)
end

function RemoteGameManager:processTick()
	-- Nothing.
end

return RemoteGameManager
