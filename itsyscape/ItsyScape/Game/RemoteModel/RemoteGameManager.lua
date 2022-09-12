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
local GameManager = require "ItsyScape.Game.RPC.GameManager"
local TypeProvider = require "ItsyScape.Game.RPC.TypeProvider"

local RemoteGameManager = Class(GameManager)

function RemoteGameManager:new(rpcService, ...)
	GameManager.new(self)

	self.rpcService = rpcService

	self.pending = {}
	self.outgoing = {}

	self:registerInterface("ItsyScape.Game.Model.Actor", RemoteActor)
	self:registerInterface("ItsyScape.Game.Model.Game", RemoteGame)
	self:registerInterface("ItsyScape.Game.Model.Stage", RemoteStage)
	self:registerInterface("ItsyScape.Game.Model.Player", RemotePlayer)
	self:registerInterface("ItsyScape.Game.Model.Prop", RemoteProp)
	self:registerInterface("ItsyScape.Game.Model.UI", RemoteUI)

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

	self.state:registerTypeProvider("ItsyScape.Game.RemoteModel.Actor", TypeProvider.Instance(self), "ItsyScape.Game.Model.Actor")
	self.state:registerTypeProvider("ItsyScape.Game.RemoteModel.Game", TypeProvider.Instance(self), "ItsyScape.Game.Model.Game")
	self.state:registerTypeProvider("ItsyScape.Game.RemoteModel.Player", TypeProvider.Instance(self), "ItsyScape.Game.Model.Player")
	self.state:registerTypeProvider("ItsyScape.Game.RemoteModel.Prop", TypeProvider.Instance(self), "ItsyScape.Game.Model.Prop")
	self.state:registerTypeProvider("ItsyScape.Game.RemoteModel.Stage", TypeProvider.Instance(self), "ItsyScape.Game.Model.Stage")
	self.state:registerTypeProvider("ItsyScape.Game.RemoteModel.UI", TypeProvider.Instance(self), "ItsyScape.Game.Model.UI")

	self.onTick = Callback()

	self.rpcService:connect(self)
end

function RemoteGameManager:swapRPCService(rpcService)
	self.rpcService = rpcService
	self.rpcService:connect(self)

	self:removeAllInstances("ItsyScape.Game.Model.Actor")
	self:removeAllInstances("ItsyScape.Game.Model.Prop")
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

function RemoteGameManager:push(e)
	table.insert(self.outgoing, e)

	if e.type == GameManager.QUEUE_EVENT_TYPE_TICK then
		self:send()
	end
end

function RemoteGameManager:send()
	for i = 1, #self.outgoing do
		self.rpcService:send(0, self.outgoing[i])
	end

	table.clear(self.outgoing)
end

function RemoteGameManager:receive()
	local e
	repeat
		e = self.rpcService:receive()
		if e then
			table.insert(self.pending, e)
			if e.type == GameManager.QUEUE_EVENT_TYPE_TICK then
				self.onTick(self:getInstance("ItsyScape.Game.Model.Game", 0):getInstance())
				self:flush()
			end
		end
	until e == nil

	return false
end

function RemoteGameManager:flush()
	for i = 1, #self.pending do
		self:process(self.pending[i])
	end

	table.clear(self.pending)
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

	self:newInstance(e.interface, e.id, instance)
	proxy:wrapClient(e.interface, e.id, instance, self)
end

function RemoteGameManager:processCallback(e)
	GameManager.processCallback(self, e)
end

function RemoteGameManager:processDestroy(e)
	self:destroyInstance(e.interface, e.id)
end

function RemoteGameManager:processTick()
	-- Nothing.
end

return RemoteGameManager
