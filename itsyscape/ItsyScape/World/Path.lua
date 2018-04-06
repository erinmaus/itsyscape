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

-- Pushes a node to the end of the path.
--
-- Returns the node.
function Path:pushNode(NodeType, ...)
	local previousNode = self.nodes[#self.nodes]
	local nextNode = NodeType(...)

	if previousNode then
		previousNode:setNextNode(nextNode)
	end

	table.insert(self.nodes, nextNode)

	return nextNode
end

return Path
