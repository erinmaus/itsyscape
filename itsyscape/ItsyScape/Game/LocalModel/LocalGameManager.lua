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

	self.pending = {}

	game:getStage():newMap(1, 1, 1)
	game:tick()
end

function LocalGameManager:push(e)
	self.outputChannel:push(buffer.encode(e))
end

function LocalGameManager:send()
	-- Nothing for now.
	-- We immediately send events via 'push' as we receive them.
end

function LocalGameManager:receive()
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

function LocalGameManager:flush()
	local p = self.pending
	for i = 1, #p do
		self:process(p[i])
	end

	self.pending = {}
end

return LocalGameManager
