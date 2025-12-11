--------------------------------------------------------------------------------
-- ItsyScape/Graphics/OldOneGlyphInstance.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class" 
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local MathCommon = require "ItsyScape.Common.Math.Common"
local ProjectedOldOneGlyph = require "ItsyScape.Graphics.ProjectedOldOneGlyph"

local OldOneGlyphInstance = Class()

function OldOneGlyphInstance:new(glyph, glyphManager)
	self.glyph = glyph
	self.glyphManager = glyphManager

	local w, h = glyphManager:getDimensions()
	self.projection = ProjectedOldOneGlyph(w, h, glyphManager:getProjectionRadiusScale())

	self.rotation = Quaternion.IDENTITY
	self.theta = 0
	self.phi = 0
	self.currentPhi = 0
	self.parent = false
	self.children = {}
end

function OldOneGlyphInstance:serialize()
	local result = {
		glyph = self.glyphManager:index(self.glyph),
		rotation = self.rotation,
		theta = self.theta,
		phi = self.phi,
		children = {}
	}

	for _, child in ipairs(self.children) do
		table.insert(result.children, child:serialize())
	end

	return result
end

function OldOneGlyphInstance.deserialize(t, glyphManager)
	local glyph = glyphManager and glyphManager:get(t.glyph)
	if not glyph then
		return nil
	end

	local instance = OldOneGlyphInstance(glyph, glyphManager)
	instance:setRotation(t.rotation)
	instance:setTheta(t.theta)
	instance:setPhi(t.phi)

	for _, child in ipairs(t.children) do
		local childInstance = OldOneGlyphInstance.deserialize(child, glyphManager)
		childInstance:setParent(instance)
	end

	return instance
end

function OldOneGlyphInstance:getGlyph()
	return self.glyph
end

function OldOneGlyphInstance:getRotation()
	return self.rotation
end

function OldOneGlyphInstance:setRotation(value)
	self.rotation = value
end

function OldOneGlyphInstance:getTheta()
	return self.theta
end

function OldOneGlyphInstance:setTheta(value)
	self.theta = value
end

function OldOneGlyphInstance:getPhi()
	return self.phi
end

function OldOneGlyphInstance:setPhi(value)
	self.phi = value
	self.currentPhi = value
end

function OldOneGlyphInstance:layout()
	local count = #self.children

	for i, child in self:iterate() do
		local phi = math.lerp(0, math.pi * 2, (i - 1) / count)
		child:setPhi(phi)
		child:layout()
	end
end

function OldOneGlyphInstance:getPosition()
	local radius = self.parent and self.parent:getRadius() or 0

	return Vector(
		radius * math.cos(self.currentPhi) * math.cos(self.theta),
		radius * math.cos(self.currentPhi) * math.sin(self.theta),
		radius * math.sin(self.currentPhi))
end

function OldOneGlyphInstance:getParent()
	return self.parent
end

function OldOneGlyphInstance:iterate()
	return ipairs(self.children)
end

function OldOneGlyphInstance:getHasChildren()
	return #self.children > 0
end

function OldOneGlyphInstance:setParent(value)
	if self.parent then
		for i, child in ipairs(self.parent.children) do
			if child == self then
				table.remove(self.parent.children, i)
				break
			end
		end
	end

	if value then
		table.insert(value.children, self)
	end

	self.parent = value
end

function OldOneGlyphInstance:getParent()
	return self.parent
end

function OldOneGlyphInstance:getTransform()
	local position = self:getPosition()
	local transform = MathCommon.makeTransform(position)

	if self.parent then
		return self.parent:getTransform() * transform
	end

	return transform
end

function OldOneGlyphInstance:getRadius()
	radius = self.glyphManager:getRadius()

	local maxChildRadius = 0
	for _, child in self:iterate() do
		maxChildRadius = math.max(maxChildRadius, child:getRadius())
	end

	return radius + maxChildRadius * 2
end

function OldOneGlyphInstance:getDepth()
	if not self.parent then
		return 0
	end

	local n = 1

	local current = self.parent
	while current do
		n = n + 1
		current = current.parent
	end

	return n
end

function OldOneGlyphInstance:getIsLeaf()
	return #self.children == 0
end

function OldOneGlyphInstance:getProjection()
	return self.projection
end

function OldOneGlyphInstance:update(time)
	if self.parent then
		self.currentPhi = self.phi + time * self.glyphManager:getRotationSpeed() * math.sqrt(self:getDepth())
	end

	for _, child in self:iterate() do
		child:update(time)
	end
end

function OldOneGlyphInstance:project(normal, d, axis)
	if _DEBUG then
		assert(self.projection, "cannot project glyph without projection")
	end

	return self.glyph:project(self.projection, normal, d, self:getTransform(), axis)
end

return OldOneGlyphInstance
