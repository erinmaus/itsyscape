--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/LocalGameManager.lua
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
local Utility = require "ItsyScape.Game.Utility"
local GameProxy = require "ItsyScape.Game.Model.GameProxy"
local PlayerProxy = require "ItsyScape.Game.Model.PlayerProxy"
local StageProxy = require "ItsyScape.Game.Model.StageProxy"
local UIProxy = require "ItsyScape.Game.Model.UIProxy"
local GameManager = require "ItsyScape.Game.RPC.GameManager"
local TypeProvider = require "ItsyScape.Game.RPC.TypeProvider"

local LocalGameManager = Class(GameManager)

function LocalGameManager:new(inputChannel, outputChannel, game)
	GameManager.new(self)

	self.inputChannel = inputChannel
	self.outputChannel = outputChannel
	self.game = game

	self.pending = {}
	self.outgoing = {}
	self.outgoingTargets = {}
	self.outgoingKeys = {}
	self.pendingDeletion = {}

	self:registerInterface(
		"ItsyScape.Game.Model.Actor",
		require "ItsyScape.Game.LocalModel.Actor")
	self:registerInterface(
		"ItsyScape.Game.Model.Game",
		require "ItsyScape.Game.LocalModel.Game")
	self:registerInterface(
		"ItsyScape.Game.Model.Player",
		require "ItsyScape.Game.LocalModel.Player")
	self:registerInterface(
		"ItsyScape.Game.Model.Prop",
		require "ItsyScape.Game.LocalModel.Prop")
	self:registerInterface(
		"ItsyScape.Game.Model.Stage",
		require "ItsyScape.Game.LocalModel.Stage")
	self:registerInterface(
		"ItsyScape.Game.Model.UI",
		require "ItsyScape.Game.LocalModel.UI")

	self:newInstance("ItsyScape.Game.Model.Game", 0, game)
	GameProxy:wrapServer("ItsyScape.Game.Model.Game", 0, game, self)
	self:newInstance("ItsyScape.Game.Model.Player", 0, game:getPlayer())
	PlayerProxy:wrapServer("ItsyScape.Game.Model.Player", 0, game:getPlayer(), self)
	self:newInstance("ItsyScape.Game.Model.Stage", 0, game:getStage())
	StageProxy:wrapServer("ItsyScape.Game.Model.Stage", 0, game:getStage(), self)
	self:newInstance("ItsyScape.Game.Model.UI", 0, game:getUI())
	UIProxy:wrapServer("ItsyScape.Game.Model.UI", 0, game:getUI(), self)

	self.state:registerTypeProvider("ItsyScape.Game.LocalModel.Actor", TypeProvider.Instance(self), "ItsyScape.Game.Model.Actor")
	self.state:registerTypeProvider("ItsyScape.Game.LocalModel.Game", TypeProvider.Instance(self), "ItsyScape.Game.Model.Game")
	self.state:registerTypeProvider("ItsyScape.Game.LocalModel.Player", TypeProvider.Instance(self), "ItsyScape.Game.Model.Player")
	self.state:registerTypeProvider("ItsyScape.Game.LocalModel.Prop", TypeProvider.Instance(self), "ItsyScape.Game.Model.Prop")
	self.state:registerTypeProvider("ItsyScape.Game.LocalModel.Stage", TypeProvider.Instance(self), "ItsyScape.Game.Model.Stage")
	self.state:registerTypeProvider("ItsyScape.Game.LocalModel.UI", TypeProvider.Instance(self), "ItsyScape.Game.Model.UI")

	game:getStage():newMap(1, 1, 1)
	game:tick()

	game:getPlayer().onPoof:register(self.onPlayerPoof, self)
	game:getPlayer().onMove:register(self.onPlayerMove, self)
end

function LocalGameManager:onPlayerPoof(player)
	local stage = self.game:getStage()

	local instance
	do
		local previousID, previousFilename = stage:splitLayerNameIntoInstanceIDAndFilename(player:getActor():getPeep():getLayerName())
		instance = stage:getInstanceByFilenameAndID(previousFilename, previousID)
	end

	if not instance then
		return
	end

	instance:unloadPlayer(self, player)
end

function LocalGameManager:onPlayerMove(player, previousLayerName, currentLayerName)
	local stage = self.game:getStage()

	local previousInstance
	do
		local previousID, previousFilename = stage:splitLayerNameIntoInstanceIDAndFilename(previousLayerName)
		previousInstance = stage:getInstanceByFilenameAndID(previousFilename, previousID)
	end

	if previousInstance then
		previousInstance:unloadPlayer(self, player)
	end

	local currentInstance
	do
		local currentID, currentFilename = stage:splitLayerNameIntoInstanceIDAndFilename(currentLayerName)
		currentInstance = stage:getInstanceByFilenameAndID(currentFilename, currentID)
	end

	if currentInstance then
		currentInstance:loadPlayer(self, player)
	end
end

function LocalGameManager:push(e, key)
	table.insert(self.outgoing, e)
	self.outgoingKeys[#self.outgoing] = key
end

function LocalGameManager:assignTargetToLastPush(target)
	self.outgoingTargets[#self.outgoing] = target
end

function LocalGameManager:destroyInstance(interface, id)
	table.insert(self.pendingDeletion, self:getInstance(interface, id))
	GameManager.destroyInstance(self, interface, id)
end

function LocalGameManager:_doSend(e)
	self.outputChannel:push(buffer.encode(e))
end

function LocalGameManager:getInstance(interface, id)
	local instance = GameManager.getInstance(self, interface, id)
	if instance then
		return instance
	end

	for i = 1, #self.pendingDeletion do
		local d = self.pendingDeletion[i]
		if d:getInterface() == interface and d:getID() == id then
			return d
		end
	end

	return nil
end

function LocalGameManager:send()
	local player = self:getInstance("ItsyScape.Game.Model.Player", 0):getInstance()
	local playerInstance = player:getInstance()

	if not playerInstance then
		for i = 1, #self.outgoing do
			self:_doSend(self.outgoing[i])
		end
	else
		for i = 1, #self.outgoing do
			local e = self.outgoing[i]

			local target = self.outgoingTargets[i]
			local isTargetMatch = target and target:getID() == player:getID()

			local instance
			if e.interface and e.id then
				instance = self:getInstance(e.interface, e.id)
			end

			if e.type == GameManager.QUEUE_EVENT_TYPE_CREATE or
			   e.type == GameManager.QUEUE_EVENT_TYPE_DESTROY or
			   e.type == GameManager.QUEUE_EVENT_TYPE_PROPERTY
			then
				if e.interface == "ItsyScape.Game.Model.Actor" or
				   e.interface == "ItsyScape.Game.Model.Prop"
				then
					local isActorMatch = e.interface == "ItsyScape.Game.Model.Actor" and playerInstance:hasActor(instance:getInstance())
					local isPropMatch = e.interface == "ItsyScape.Game.Model.Prop" and playerInstance:hasProp(instance:getInstance())

					if isActorMatch or isPropMatch or isTargetMatch then
						if e.type == GameManager.QUEUE_EVENT_TYPE_CREATE or
						   e.type == GameManager.QUEUE_EVENT_TYPE_DESTROY
						then
							Log.engine(
								"Sending event to %s '%s' (%d) to player '%s' (%d).",
								e.type, e.interface, e.id, player:getActor():getName(), player:getID())
						end

						self:_doSend(e)
					end
				else
					self:_doSend(e)
				end
			elseif e.type == GameManager.QUEUE_EVENT_TYPE_CALLBACK then
				if e.interface == "ItsyScape.Game.Model.Stage" then
					local key = self.outgoingKeys[i]

					local isLayerMatch = key and key.layer and playerInstance:hasLayer(key.layer.value)
					local isActorMatch = key and key.actor and playerInstance:hasActor(key.actor.value)
					local isPropMatch = key and key.prop and playerInstance:hasProp(key.prop.value)
					local isGlobal = not key or (not key.layer and not key.actor and not key.prop)

					if isLayerMatch or isActorMatch or isPropMatch or isGlobal or isTargetMatch then
						self:_doSend(e)
					end
				elseif e.interface == "ItsyScape.Game.Model.Actor" or
				       e.interface == "ItsyScape.Game.Model.Prop"
				then
					local layer = Utility.Peep.getLayer(instance:getInstance():getPeep())
					if playerInstance:hasLayer(layer) or isTargetMatch then
						self:_doSend(e)
					end
				else
					self:_doSend(e)
				end
			else
				self:_doSend(e)
			end
		end
	end

	table.clear(self.outgoing)
	table.clear(self.outgoingKeys)
	table.clear(self.pendingDeletion)
end

function LocalGameManager:receive()
	local e
	repeat
		e = self.inputChannel:demand()
		if e then
			self.pending = buffer.decode(e)
			self:flush()
			return true
		end
	until e == nil
	return false
end

function LocalGameManager:flush()
	local p = self.pending
	for i = 1, #p do
		self:process(p[i])
	end

	self.pending = {}
end

return LocalGameManager
