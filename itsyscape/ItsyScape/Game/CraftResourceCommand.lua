--------------------------------------------------------------------------------
-- ItsyScape/World/CraftResourceCommand.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Command = require "ItsyScape.Peep.Command"
local Utility = require "ItsyScape.Game.Utility"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"

local CraftResourceCommand = Class(Command)

function CraftResourceCommand:new(action, count, prop)
	Command.new(self)

	self.action = action
	self.progress = 0
	self.count = count
	self.isDone = false
	self.isInterfaceOpen = false
	self.prop = prop
end

function CraftResourceCommand:getIsFinished()
	return self.isDone
end

function CraftResourceCommand:finish(peep)
	if self.isInterfaceOpen then
		local ui = peep:getDirector():getGameInstance():getUI()
		ui:close("CraftProgress", self.interfaceIndex)
	end
end

function CraftResourceCommand:step(peep)
	if self.progress >= self.count then
		print("DONE!", self.progress, "/", self.count)
		self.isDone = true
		return
	end

	local canStep = self.action:canPerform(peep:getState()) and self.action:canTransfer(peep:getState())
	if not canStep then
		print("CAN'T STEP", self.action:getDebugInfo().shortName)
		self.isDone = true
	end

	local didPerform = self.action:perform(peep:getState(), peep, self.prop)
	if not didPerform then
		print("DID NOT PERFORM")
		self.isDone = true
	end

	if not self.isDone then
		self.progress = self.progress + 1
	end

	if not peep:getCommandQueue():shift(self) then
		print("COULD NOT SHIFT")
		self.isDone = true
	end

	if self.isInterfaceOpen and self.interfaceController then
		self.interfaceController:updateProgress(self.progress, self.count)
	end
end

function CraftResourceCommand:onBegin(peep)
	if peep:hasBehavior(PlayerBehavior) then
		self.isInterfaceOpen, self.interfaceIndex, self.interfaceController = Utility.UI.openInterface(peep, "CraftProgress", false, self.action, self.prop)
	else
		self.isInterfaceOpen = false
	end

	self:step(peep)
end

function CraftResourceCommand:onResume(peep)
	self:step(peep)
end

function CraftResourceCommand:onEnd(peep)
	self:finish(peep)
end

function CraftResourceCommand:onInterrupt(peep)
	self:finish(peep)
end

return CraftResourceCommand
