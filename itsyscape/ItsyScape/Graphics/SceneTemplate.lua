--------------------------------------------------------------------------------
-- ItsyScape/Graphics/SceneTemplate.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local SceneTemplate = Class()

SceneTemplate.Node = Class()
function SceneTemplate.Node:new(name, transform, parent, children, scene)
	self.name = name
	self.transform = transform
	self.parent = parent
	self.children = children
	self.scene = scene
end

function SceneTemplate.Node:getName()
	return self.name
end

function SceneTemplate.Node:iterate()
	return ipairs(self.children)
end

function SceneTemplate.Node:getParent()
	return self.parent
end

function SceneTemplate.Node:getLocalTransform()
	return self.transform
end

function SceneTemplate.Node:getGlobalTransform()
	if self.parent then
		return self.parent:getGlobalTransform() * self:getLocalTransform()
	end

	return self.transform
end

function SceneTemplate.Node:getScene()
	return self.scene
end

function SceneTemplate:new(d)
	self.nodesByName = {}
	self.rootNode = false

	if type(d) == 'string' then
		self:loadFromFile(d)
	elseif type(d) == 'table' then
		self:loadFromTable(d)
	end
end

function SceneTemplate:hasNode(name)
	return self.nodesByName[name] ~= nil
end

function SceneTemplate:getNodeByName(name)
	return self:hasNode(name) and self.nodesByName[name]
end

function SceneTemplate:iterate()
	return pairs(self.nodesByName)
end

function SceneTemplate:loadFromFile(filename)
	local data = "return " .. (love.filesystem.read(filename) or "")
	local chunk = assert(loadstring(data))
	local result = setfenv(chunk, {})() or {}

	self:loadFromTable(result)
end

function SceneTemplate:loadFromTable(t)
	local nodes = {}
	local root

	local sortedNodeNames = {}
	for name, value in pairs(t) do
		table.insert(sortedNodeNames, name)
	end

	table.sort(sortedNodeNames)

	for _, name in ipairs(sortedNodeNames) do
		local value = t[name]

		local node = {}
		node.name = name
		node.parent = value.parent
		node.transform = value.transform
		node.children = {}

		nodes[name] = node
		if not root and not node.parent then
			root = node
		end
	end

	if not root then
		error("no root node", 2)
	end

	local function buildChildren(node)
		for _, key in ipairs(sortedNodeNames) do
			local value = nodes[key]

			if value.parent == node.name then
				local child = nodes[key]
				table.insert(node.children, child)

				buildChildren(child)
			end
		end
	end
	buildChildren(root)

	local function addNode(nodeDefinition, parentNodeDefinition)
		local transform = love.math.newTransform()
		transform:setMatrix('row', unpack(nodeDefinition.transform))

		local node = SceneTemplate.Node(
			nodeDefinition.name,
			transform,
			nodeDefinition.parent and self.nodesByName[nodeDefinition.parent] or false,
			nodeDefinition.children,
			self)

		self.nodesByName[nodeDefinition.name] = node

		for i = 1, #nodeDefinition.children do
			nodeDefinition.children[i] = addNode(nodeDefinition.children[i], nodeDefinition)
		end

		return node
	end
	self.rootNode = addNode(root)
end

-- Constants.
SceneTemplate.EMPTY = SceneTemplate()

return SceneTemplate
