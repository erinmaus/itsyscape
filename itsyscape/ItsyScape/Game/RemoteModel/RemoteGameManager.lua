--------------------------------------------------------------------------------
-- ItsyScape/Game/RemoteModel/RemoteGameManager.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local GameManager = require "ItsyScape.Game.RPC.GameManager"
local Actor = require "ItsyScape.Game.Model.Actor"
local Game = require "ItsyScape.Game.Model.Game"
local Stage = require "ItsyScape.Game.Model.Stage"
local Player = require "ItsyScape.Game.Model.Player"
local Prop = require "ItsyScape.Game.Model.Prop"
local UI = require "ItsyScape.Game.Model.UI"

local RemoteGameManager = Class(GameManager)

function RemoteGameManager:new(inputChannel, outputChannel)
	GameManager.new(self)

	self.inputChannel = inputChannel
	self.outputChannel = outputChannel

	m:registerInterface("ItsyScape.Game.Model.Actor", Actor)
	m:registerInterface("ItsyScape.Game.Model.Game", Game)
	m:registerInterface("ItsyScape.Game.Model.Stage", Stage)
	m:registerInterface("ItsyScape.Game.Model.Player", Player)
	m:registerInterface("ItsyScape.Game.Model.Prop", Prop)
	m:registerInterface("ItsyScape.Game.Model.UI", UI)

	self:newInstance("ItsyScape.Game.Model.Game", 0, Game())
	GameProxy:wrapServer(self:getInstance("ItsyScape.Game.Model.Game", 0):getInstance())
	self:newInstance("ItsyScape.Game.Model.Player", 0, game:getPlayer())
	PlayerProxy:wrapServer(self:getInstance("ItsyScape.Game.Model.Player", 0):getInstance())
	self:newInstance("ItsyScape.Game.Model.Stage", 0, game:getStage())
	StageProxy:wrapServer(self:getInstance("ItsyScape.Game.Model.Stage", 0):getInstance())
	self:newInstance("ItsyScape.Game.Model.UI", 0, game:getUI())
	UIProxy:wrapServer(self:getInstance("ItsyScape.Game.Model.UI", 0):getInstance())

	self.pending = {}

	self.onTick = Callback()
end

function RemoteGameManager:push(e)
	self.outputChannel:push(e)
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
			table.insert(self.pending, e)
			if e.type == GameManager.QUEUE_EVENT_TYPE_TICK then
				self:flush()
				return
			end
		end
	until e == nil
end

function RemoteGameManager:flush()
	local p = self.pending
	for i = 1, #p do
		self:process(p[i])
	end

	table.clear(p)
end

function RemoteGameManager:processCreate(interface, id)
	local proxyTypeName = string.format("%sProxy", interface)
	local proxy = require(proxyTypeName)

	local Type = self:getInterfaceType(interface)
	local instance = Type(self, id)

	self:newInstance(interface, id, instance)
	proxy:wrapClient(interface, id, instance, self)
end

function RemoteGameManager:processDestroy(interface, id)
	self:destroyInstance(interface, id)
end

function RemoteGameManager:processTick()
	self.onTick(self:getInstance("ItsyScape.Game.Model.Game", 0):getInstance())
end

return RemoteGameManager
