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

function RemoteGameManager:new(inputChannel, outputChannel, ...)
	GameManager.new(self)

	self.inputChannel = inputChannel
	self.outputChannel = outputChannel

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

	self:newInstance("ItsyScape.Game.Model.Player", 0, RemotePlayer(self))
	PlayerProxy:wrapClient(
		"ItsyScape.Game.Model.Player",
		0,
		self:getInstance("ItsyScape.Game.Model.Player", 0):getInstance(),
		self)
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

	self.pending = {}

	self.onTick = Callback()
end

function RemoteGameManager:push(e)
	self.outputChannel:push(buffer.encode(e))
end

function RemoteGameManager:send()
	-- Nothing for now.
	-- We immediately send events via 'push' as we receive them.
end

function RemoteGameManager:receive()
	local e
	repeat
		e = self.inputChannel:pop()
		if e then
			e = buffer.decode(e)
			table.insert(self.pending, e)
			if e.type == GameManager.QUEUE_EVENT_TYPE_TICK then
				self:flush()
				return true
			end
		end
	until e == nil

	return false
end

function RemoteGameManager:flush()
	local p = self.pending
	for i = 1, #p do
		self:process(p[i])
	end

	self.pending = {}
end

function RemoteGameManager:processCreate(e)
	local exists = self:getInstance(e.interface, e.id)
	if exists then
		Log.debug("Interface '%s' with ID %d already exists; ignoring create.", e.interface, e.id)
		return
	end

	local proxyTypeName = string.format("%sProxy", e.interface)
	local proxy = require(proxyTypeName)

	local Type = self:getInterfaceType(e.interface)
	local instance = Type(self, e.id)

	self:newInstance(e.interface, e.id, instance)
	proxy:wrapClient(e.interface, e.id, instance, self)
end

function RemoteGameManager:processDestroy(e)
	self:destroyInstance(e.interface, e.id)
end

function RemoteGameManager:processTick()
	self.onTick(self:getInstance("ItsyScape.Game.Model.Game", 0):getInstance())
end

return RemoteGameManager
