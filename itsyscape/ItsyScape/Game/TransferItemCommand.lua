--------------------------------------------------------------------------------
-- ItsyScape/Game/TransferItemCommand.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Command = require "ItsyScape.Peep.Command"

local TransferItemCommand = Class(Command)

function TransferItemCommand:new(broker, item, destination, count, purpose, merge)
	Command.new(self)

	self.broker = broker
	self.item = item
	self.destination = destination
	self.count = count
	self.purpose = purpose
	self.merge = merge
end

function TransferItemCommand:getIsFinished()
	return not self.broker:hasItem(self.item) or
	       self.broker:getItemProvider(self.item) == self.destination
end

function TransferItemCommand:onBegin(peep)
	local transaction = self.broker:createTransaction()
	transaction:addParty(self.broker:getItemProvider(self.item))
	transaction:addParty(self.destination)
	transaction:transfer(
		self.destination,
		self.item,
		self.count,
		self.purpose,
		self.merge)
	local s, r = transaction:commit()
end

return TransferItemCommand
