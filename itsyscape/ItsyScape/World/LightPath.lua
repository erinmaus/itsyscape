--------------------------------------------------------------------------------
-- ItsyScape/World/LightPath.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Ray = require "ItsyScape.Common.Math.Ray"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local MirrorBehavior = require "ItsyScape.Peep.Behaviors.MirrorBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"

local LightPath = Class()
LightPath.Node = Class()
function LightPath.Node:new(mirror, inputRay, outputRay)
	self.mirror = mirror
	self.inputRay = inputRay
	self.outputRay = outputRay
end

function LightPath.Node:getMirror()
	return self.mirror
end

function LightPath.Node:getInputRay()
	return self.inputRay
end

function LightPath.Node:getOutputRay()
	return self.outputRay
end

function LightPath:new()
	self.mirrors = {}
	self.path = {}
end

function LightPath:add(previousMirror, currentMirror, ray)
	if previousMirror then
		local pair = self.mirrors[previousMirror]

		-- If this pair of mirrors has been encountered, stop immediately.
		-- Infinite recursion somehow.
		if pair then
			return false, nil, nil
		else
			self.mirrors[previousMirror] = currentMirror
		end
	end

	local newOrigin, newDirection
	do
		newOrigin = Utility.Peep.getAbsolutePosition(currentMirror)

		local currentDirection = Quaternion.lookAt(Vector.UNIT_Z, ray.direction)
		local m = currentMirror:getBehavior(MirrorBehavior)
		if m then
			local reflection = m.reflection
			do
				local currentRotation = currentMirror:getBehavior(RotationBehavior)
				if currentRotation then
					reflection = currentRotation.rotation * reflection
				end
			end

			currentDirection = currentDirection * reflection
		end

		local transform = love.math.newTransform()
		transform:applyQuaternion(currentDirection:get())
		newDirection = Vector(transform:transformPoint(Vector.UNIT_Z:get()))
	end

	local newRay = Ray(newOrigin, newDirection)
	local node = LightPath.Node(currentMirror, ray, newRay)

	table.insert(self.path, node)
	
	return true, node, newRay
end

function LightPath:iterate()
	return ipairs(self.path)
end

function LightPath:count()
	return #self.path
end

return LightPath
