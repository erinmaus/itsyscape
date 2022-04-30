--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/LocalGameManager.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local GameProxy = require "ItsyScape.Common.Model.GameProxy"
local PlayerProxy = require "ItsyScape.Common.Model.PlayerProxy"
local StageProxy = require "ItsyScape.Common.Model.StageProxy"
local UIProxy = require "ItsyScape.Common.Model.UIProxy"

local LocalGameManager = Class(GameManager)

function LocalGameManager:new(inputChannel, outputChannel, game)
	GameManager.new(self)

	self.inputChannel = inputChannel
	self.outputChannel = outputChannel

	m:registerInterface(
		"ItsyScape.Game.Model.Actor",
		require "ItsyScape.Game.LocalModel.Actor")
	m:registerInterface(
		"ItsyScape.Game.Model.Game",
		require "ItsyScape.Game.LocalModel.Game")
	m:registerInterface(
		"ItsyScape.Game.Model.Player",
		require "ItsyScape.Game.LocalModel.Player")
	m:registerInterface(
		"ItsyScape.Game.Model.Prop",
		require "ItsyScape.Game.LocalModel.Prop")
	m:registerInterface(
		"ItsyScape.Game.Model.Stage",
		require "ItsyScape.Game.LocalModel.Stage")
	m:registerInterface(
		"ItsyScape.Game.Model.UI",
		require "ItsyScape.Game.LocalModel.UI")

	self:newInstance("ItsyScape.Game.Model.Game", 0, game)
	GameProxy:wrapServer(game)
	self:newInstance("ItsyScape.Game.Model.Player", 0, game:getPlayer())
	PlayerProxy:wrapServer(game:getPlayer())
	self:newInstance("ItsyScape.Game.Model.Stage", 0, game:getStage())
	StageProxy:wrapServer(game:getStage())
	self:newInstance("ItsyScape.Game.Model.UI", 0, game:getUI())
	UIProxy:wrapServer(game:getUI())

	self.pending = {}
end

function LocalGameManager:push(e)
	self.outputChannel:push(e)
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
			table.insert(self.pending, e)
			if e.type == GameManager.QUEUE_EVENT_TYPE_TICK then
				self:flush()
				return
			end
		end
	until e == nil
end

function LocalGameManager:flush()
	local p = self.pending
	for i = 1, #p do
		self:process(p[i])
	end

	table.clear(p)
end

return LocalGameManager
