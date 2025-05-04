--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/DidUsePower.lua
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

local DidUsePower = B.Node("DidUsePower")
DidUsePower.PEEP = B.Reference()
DidUsePower.POWER = B.Reference()

function DidUsePower:update(mashina, state, executor)
	local target = state[self.PEEP] or mashina
	local callback = state[self.CALLBACK]

	if self.target ~= target then
		self:silence()

		self.power = state[self.POWER]
		self.activatedCallback = Function(self.onActivate, self, mashina, state, executor)
		self.deflectedCallback = Function(self.onDeflect, self, mashina, state, executor)
		self.target = target

		self.target:listen("powerActivated", self.activatedCallback)
		self.target:listen("powerDeflected", self.deflectedCallback)
	end

	if self.didFire then
		state[self.RESULT] = self.result
		state[self.RESULTS] = self.results

		self.didFire = false
		self.result = nil
		self.results = nil

		local status = self.status
		self.status = nil

		return status or B.Status.Success
	end

	return B.Status.Working
end

function DidUsePower:onDeflect(mashina, state, executor, _, e)
	local status
	if self.power and e.power and self.power ~= e.power:getResource().name then
		return
	end

	self.status = B.Status.Failure
	self.result = e
	self.results = self.results or {}
	table.insert(self.results, e)

	self.didFire = true
end

function DidUsePower:onActivate(mashina, state, executor, _, e)
	local status
	if self.power and e.power and self.power ~= e.power:getResource().name then
		status = B.Status.Failure
	else
		status = B.Status.Success
	end

	self.status = status
	self.result = e
	self.results = self.results or {}
	table.insert(self.results, e)

	self.didFire = true
end

function DidUsePower:silence()
	if self.target then
		if self.activatedCallback then
			self.target:silence("powerActivated", self.activatedCallback)
		end

		if self.deflectedCallback then
			self.target:silence("powerDeflected", self.deflectedCallback)
		end
	end

	self.target = nil
	self.activatedCallback = nil
	self.deflectedCallback = nil
	self.result = nil
	self.results = nil
end

function DidUsePower:removed()
	self:silence()
end

function DidUsePower:deactivated()
	self:silence()
end

return DidUsePower
