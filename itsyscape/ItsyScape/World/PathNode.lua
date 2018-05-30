--------------------------------------------------------------------------------
-- ItsyScape/World/PathNode.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"

local PathNode = Class()

-- Constructs a new node at (i, j, layer).
--
-- i and j are coordinates in the map at layer.
--
-- Values default to 1, but should be provided.
function PathNode:new(i, j, layer)
	self.i = i or 1
	self.j = j or 1
	self.layer = layer or 1
	self.next = false
	self.onBegin = Callback()
	self.onEnd = Callback()
end

-- Sets the next node, or unsets it if node is falsey.
function PathNode:setNextNode(node)
	self.next = node or false
end

-- Gets the next node, or false if there is no next node.
function PathNode:getNextNode()
	return self.next
end

-- Returns true if the path node is a leaf, false otherwise.
--
-- A leaf node is the final node in a path; it has no next node.
function PathNode:getIsLeaf()
	return self.next == false
end

function PathNode:distance(other)
	local dx = math.abs(self.x - other.x)
	local dy = math.abs(self.y - other.y)
	local dl = math.abs(self.layer - other.layer)

	return dx + dy + dl
end

-- Activates the node on the provided Peep.
--
-- In essence, the peep should start moving towards this node, however it
-- should.
--
-- A simple tile, for example, would make the peep walk, while a shortcut would
-- make it teleport.
--
-- Invokes the 'onBegin' callback with 'peep'.
function PathNode:activate(peep, nextNode)
	self.onBegin(self, peep)
end

-- Called when the node is interrupted.
--
-- Should not invoke onEnd.
function PathNode:interrupt(peep)
	-- Nothing.
end

-- Called when the node is done.
--
-- Invokes onEnd callback with the 'peep'.
function PathNode:finish(peep)
	self.onEnd(self, peep)
end

return PathNode
