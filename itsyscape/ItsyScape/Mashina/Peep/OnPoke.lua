--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/OnPoke.lua
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

local OnPoke = B.Node("OnPoke")
OnPoke.TARGET = B.Reference()
OnPoke.EVENT = B.Reference()
OnPoke.CALLBACK = B.Reference()
OnPoke.RESULT = B.Reference()
OnPoke.RESULTS = B.Reference()

function OnPoke:update(mashina, state, executor)
	local event = state[self.EVENT]
	local target = state[self.TARGET] or mashina
	local callback = state[self.CALLBACK]

	if self.event ~= event or self.target ~= target or self.callback ~= callback then
		self:silence()

		self.event = event
		self.target = target
		self.callback = callback or function() end
		self.wrappedCallback = Function(self.onFire, self, mashina, state, executor)
		self.target:listen(self.event, self.wrappedCallback)
	end

	if self.didFire then
		state[self.RESULT] = result
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

function OnPoke:onFire(mashina, state, executor, ...)
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

function OnPoke:silence()
	if self.event and self.target and self.wrappedCallback then
		self.target:silence(self.event, self.wrappedCallback)
	end

	self.event = nil
	self.target = nil
	self.callack = nil
	self.wrappedCallback = nil
end

function OnPoke:removed()
	self:silence()
end

function OnPoke:deactivated()
	self:silence()
end

return OnPoke
