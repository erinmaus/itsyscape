--------------------------------------------------------------------------------
-- Resources/Peeps/HighChambersYendor/TorchPuzzleGhost.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Peep = require "ItsyScape.Peep.Peep"
local Utility = require "ItsyScape.Game.Utility"
local BaseGhost = require "Resources.Game.Peeps.Ghost.BaseGhost"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

local TorchPuzzleGhost = Class(BaseGhost)

function TorchPuzzleGhost:new(resource, name, ...)
	BaseGhost.new(self, resource, name or 'TorchPuzzleGhost', ...)

	self.torches = {}
end

function TorchPuzzleGhost:onTorchLit(p)
	table.insert(self.torches, p.torch)

	if #self.torches == 1 then
		self:pushPoke('startBeingMean')
	end
end

function TorchPuzzleGhost:onStartBeingMean()
	Utility.performAction(
		self:getDirector():getGameInstance(),
		Utility.Peep.getResource(self.torches[1]),
		'snuff',
		'world',
		self:getState(),
		self,
		self.torches[1])

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor.actor:flash('Message', 1, "No light, no light.")
	end

	local callback = CallbackCommand(self.nextTorch, self)
	self:getCommandQueue():push(callback)
end

function TorchPuzzleGhost:nextTorch()
	table.remove(self.torches, 1)

	if #self.torches > 0 then
		Utility.performAction(
			self:getDirector():getGameInstance(),
			Utility.Peep.getResource(self.torches[1]),
			'snuff',
			'world',
			self:getState(),
			self,
			self.torches[1])

		local callback = CallbackCommand(self.nextTorch, self)
		self:getCommandQueue():push(callback)
	end
end

return TorchPuzzleGhost
