--------------------------------------------------------------------------------
-- ItsyScape/World/Path.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"

local Path = Class()
function Path:new()
	self.nodes = {}
end

function Path:getNumNodes()
	return #self.nodes
end

function Path:getNodeAtIndex(index)
	return self.nodes[index]
end

-- Pushes a node to the end of the path of the specified type.
--
-- Returns the node.
function Path:makeNode(NodeType, ...)
	local previousNode = self.nodes[#self.nodes]
	local nextNode = NodeType(...)

	if previousNode then
		previousNode:setNextNode(nextNode)
	end

	table.insert(self.nodes, nextNode)

	return nextNode
end

-- Prepends an existing node to the path.
--
-- Returns the node.
function Path:prependNode(previousNode)
	previousNode:setNextNode(self.nodes[1])
	table.insert(self.nodes, 1, previousNode)

	return previousNode
end

-- Appends an existing node to the end of the path.
--
-- Returns the node.
function Path:appendNode(nextNode)
	local previousNode = self.nodes[#self.nodes]
	if previousNode then
		previousNode:setNextNode(nextNode)
	end

	table.insert(self.nodes, nextNode)

	return nextNode
end

-- Makes the peep start to follow the path.
--
-- Returns true if successful (e.g., the path is not empty), false otherwise.
function Path:activate(peep)
	if self.nodes[1] then
		self.nodes[1]:activate(peep)
		return true
	end

	return false
end

return Path
