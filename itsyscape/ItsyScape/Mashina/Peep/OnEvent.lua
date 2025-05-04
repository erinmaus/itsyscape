--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/OnEvent.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Function = require "ItsyScape.Common.Function"
local Utility = require "ItsyScape.Game.Utility"

local OnEvent = B.Node("OnEvent")
OnEvent.TARGET = B.Reference()
OnEvent.EVENT = B.Reference()
OnEvent.CALLBACK = B.Reference()
OnEvent.RESULT = B.Reference()
OnEvent.RESULTS = B.Reference()

local _emptyCallback = function() end

function OnEvent:update(mashina, state, executor)
	local event = state[self.EVENT]
	local target = state[self.TARGET] or mashina
	local callback = state[self.CALLBACK] or _emptyCallback

	if self.event ~= event or self.target ~= target or self.callback ~= callback then
		self:silence()

		self.event = event
		self.target = target
		self.callback = callback
		self.wrappedCallback = Function(self.onFire, self, mashina, state, executor)
		self.target:listen("event", self.wrappedCallback)
	end

	if self.didFire then
		state[self.RESULT] = self.result
		state[self.RESULTS] = self.results

		self.didFire = false
		self.result = nil
		self.results = {}

		local status = self.status
		self.status = nil

		return status or B.Status.Success
	end

	return B.Status.Working
end

function OnEvent:onFire(mashina, state, executor, peep, event, ...)
	if event ~= self.event then
		return
	end

	local result, status = self.callback(mashina, state, executor, ...)
	if status == nil then
		status = B.Status.Success
	end

	self.status = status
	self.result = result
	self.results = self.results or {}
	table.insert(self.results, result)

	self.didFire = true
end

function OnEvent:silence()
	if self.target and self.wrappedCallback then
		self.target:silence("event", self.wrappedCallback)
	end

	self.event = nil
	self.target = nil
	self.callback = nil
	self.wrappedCallback = nil
	self.result = nil
	self.results = nil
end

function OnEvent:removed()
	self:silence()
end

function OnEvent:deactivated()
	self:silence()
end

return OnEvent
