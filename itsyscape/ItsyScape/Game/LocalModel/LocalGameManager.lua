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
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"

local LocalGameManager = Class(GameManager)

function LocalGameManager:new(rpcService, game)
	GameManager.new(self)

	self.rpcService = rpcService
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

	game.onPlayerSpawned:register(self.onPlayerSpawned, self)

	self.rpcService:connect(self)
end

function LocalGameManager:swapRPCService(rpcService)
	self.rpcService = rpcService
	self.rpcService:connect(self)
end

function LocalGameManager:onPlayerSpawned(_, player)
	player.onPoof:register(self.onPlayerPoof, self)
	player.onMove:register(self.onPlayerMove, self)
end

function LocalGameManager:onPlayerPoof(player)
	local stage = self.game:getStage()

	local instance
	do
		local previousID, previousFilename = stage:splitLayerNameIntoInstanceIDAndFilename(player:getActor():getPeep():getLayerName())
		instance = stage:getInstanceByFilenameAndID(previousFilename, previousID)
	end

	if not instance then
		Log.engine("Player '%s' (%d) poofed, but player is not in instance.", player:getActor():getName(), player:getID())
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

function LocalGameManager:_doSend(player, e)
	table.insert(self.pending, e)
end

function LocalGameManager:_doFlush(player)
	self.rpcService:sendBatch(player:getClientID(), self.pending)
	table.clear(self.pending)
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

function LocalGameManager:sendToPlayer(player)
	local playerInstance = player:getInstance()
	if not playerInstance then
		Log.warn("Player '%s' (%d) not ready; no instance.", (player:getActor() and player:getActor():getName()) or "<poofed player>", player:getID())
		return
	end

	for i = 1, #self.outgoing do
		local e = self.outgoing[i]

		local target = self.outgoingTargets[i]
		local isTargetMatch = target and target:getID() == player:getID()
		local hasTarget = target ~= nil

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
				local key = self.outgoingKeys[i]
				if key and key.layer then print(key and key.layer and key.layer.value) end
				local isLayerMatch = not hasTarget and key and key.layer and key.layer.value and playerInstance:hasLayer(key.layer.value)
				local isActorMatch = not hasTarget and e.interface == "ItsyScape.Game.Model.Actor" and playerInstance:hasActor(instance:getInstance())
				local isPropMatch = not hasTarget and e.interface == "ItsyScape.Game.Model.Prop" and playerInstance:hasProp(instance:getInstance())

				if isActorMatch or isPropMatch or isTargetMatch or isLayerMatch then
					if e.type == GameManager.QUEUE_EVENT_TYPE_CREATE or
					   e.type == GameManager.QUEUE_EVENT_TYPE_DESTROY
					then
						Log.engine(
							"Sending event to %s '%s' (%d) to player '%s' (%d).",
							e.type, e.interface, e.id, (player:getActor() and player:getActor():getName()) or "<poofed player>", player:getID())
						Log.debug(
							"Reason: isActorMatch = %s, isPropMatch = %s, isTargetMatch = %s, hasTarget = %s, isLayerMatch = %s",
							Log.boolean(isActorMatch), Log.boolean(isPropMatch), Log.boolean(isTargetMatch), Log.boolean(hasTarget), Log.boolean(isLayerMatch))
					end

					self:_doSend(player, e)
				end
			elseif e.interface == "ItsyScape.Game.Model.Player" then
				local isSamePlayer = e.id == player:getID()
				if isSamePlayer then
					self:_doSend(player, e)

					if e.type == GameManager.QUEUE_EVENT_TYPE_DESTROY then
						self.game:acknowledgePlayerDestroyed(player)
					end
				end
			elseif e.interface == "ItsyScape.Game.Model.Game" then
				self:_doSend(player, e)
			end
		elseif e.type == GameManager.QUEUE_EVENT_TYPE_CALLBACK then
			if e.interface == "ItsyScape.Game.Model.Stage" then
				local key = self.outgoingKeys[i]

				local isLayerMatch = not hasTarget and key and key.layer and key.layer.value and playerInstance:hasLayer(key.layer.value)
				local isActorMatch = not hasTarget and key and key.actor and key.actor.value and playerInstance:hasActor(key.actor.value)
				local isPropMatch = not hasTarget and key and key.prop and key.prop.value and playerInstance:hasProp(key.prop.value)

				if isLayerMatch or isActorMatch or isPropMatch or isTargetMatch then
					self:_doSend(player, e)
				end
			elseif e.interface == "ItsyScape.Game.Model.Actor" or
			       e.interface == "ItsyScape.Game.Model.Prop"
			then
				if instance then
					local layer = Utility.Peep.getLayer(instance:getInstance():getPeep())
					if (not hasTarget and playerInstance:hasLayer(layer)) or isTargetMatch then
						self:_doSend(player, e)
					end
				else
					Log.engine(
						"Instance '%s' (%d) does not exist; cannot send RPC '%s'.",
						e.interface, e.id, e.callback)
				end
			elseif e.interface == "ItsyScape.Game.Model.UI" then
				local key = self.outgoingKeys[i]
				local interfaceID = key and key.interfaceID and key.interfaceID.value
				local interfaceIndex = key and key.index and key.index.value
				local hasPlayer = key and key.player and key.player.value
				local isPlayerMatch = key and key.player and key.player.value and key.player.value:getID() == player:getID()

				if not interfaceID or not interfaceIndex then
					Log.engine("Interface ID and/or interface index keys missing; cannot process send for RPC '%s'.", e.callback)
				else
					local interface = self.game:getUI():get(interfaceID, interfaceIndex)
					if not interface and not hasPlayer then
						Log.warn(
							"Interface (id = '%s', index = %d) not found; cannot process send for RPC '%s'.",
							interfaceID, interfaceIndex, e.callback)
					else
						isPlayerMatch = isPlayerMatch or interface and interface:getPlayer():getID() == player:getID()

						if isPlayerMatch then
							self:_doSend(player, e)
						end
					end
				end
			elseif e.interface == "ItsyScape.Game.Model.Player" then
				local isSamePlayer = e.id == player:getID()
				if isSamePlayer then
					Log.engine(
						"Sending RPC '%s' to player %s (%d).",
						e.callback, (player:getActor() and player:getActor():getName()) or "<poofed player>", player:getID())
					self:_doSend(player, e)
				end
			elseif e.interface == "ItsyScape.Game.Model.Game" then
				local key = self.outgoingKeys[i]
				local isPlayerMatch = key and key.player and key.player.value:getID() == player:getID()
				if isPlayerMatch then
					self:_doSend(player, e)
				end
			end
		else
			self:_doSend(player, e)
		end
	end

	self:_doFlush(player)
end

function LocalGameManager:send()
	for _, player in self.game:iteratePlayers() do
		self:sendToPlayer(player)
	end

	table.clear(self.outgoing)
	table.clear(self.outgoingKeys)
	table.clear(self.pendingDeletion)
	table.clear(self.outgoingTargets)
end

function LocalGameManager:processCallback(e)
	if e.interface == "ItsyScape.Game.Model.Player" then
		local player = self:getInstance(e.interface, e.id)
		player = player and player:getInstance()

		if not player then
			Log.info("Player not found trying to call RPC '%s' for player ID %d.", e.callback, e.id)
		else
			local isClientMatch = player:getClientID() == e.clientID or e.clientID == nil
			if not isClientMatch then
				Log.warn(
					"Potential security issue: client %d tried invoking RPC '%s' on player %d, but player is not associated with the client.",
					e.clientID or 0, e.callback, player:getID())
			else
				GameManager.processCallback(self, e)
			end
		end
	elseif e.interface == "ItsyScape.Game.Model.UI" then
		local ui = self:getInstance(e.interface, e.id)
		ui = ui and ui:getInstance()

		if not ui then
			Log.info("UI not found trying to call RPC '%s' for player ID %d.", e.callback, e.id)
		else
			local args = self.state:deserialize(e.value)
			local interfaceID, interfaceIndex = unpack(args, 1, table.maxn(args))

			local interface = ui:get(interfaceID, interfaceIndex)
			if not interface then
				Log.warn("Interface (id = '%s', index = %d) not found.", interfaceID, interfaceIndex)
			else
				local peep = interface:getPeep()
				local playerBehavior = peep:getBehavior(PlayerBehavior)
				if not playerBehavior then
					Log.warn("Interface (id = '%s', index = %d) is not owned by a player.", interfaceID, interfaceIndex)
				else
					local player = self.game:getPlayerByID(playerBehavior.id)
					if not player or player:getClientID() ~= e.clientID then
						Log.warn(
							"Potential security issue: client %d tried invoking RPC '%s' on interface (id = '%s', index = %d), but player does not own that interface.",
							e.clientID, e.callback, interfaceID, interfaceIndex)
					else
						GameManager.processCallback(self, e)
					end
				end
			end
		end
	else
		if e.client ~= nil then
			Log.warn(
				"Potential security issue; client %d tried invoking RPC '%s' on '%s' (%d), but this is not allowed.",
				e.clientID or 0, e.callback, e.interface, e.id)
		else
			GameManager.processCallback(self, e)
		end
	end
end

function LocalGameManager:receive()
	local e
	repeat
		e = self.rpcService:receive()
		if e then
			self:process(e)
		end
	until not e
	return true
end

return LocalGameManager
