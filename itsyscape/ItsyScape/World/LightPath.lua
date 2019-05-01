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
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

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

		local m = currentMirror:getBehavior(MirrorBehavior)
		local s = currentMirror:getBehavior(SizeBehavior)
		if m and s then
			local quad
			do
				local halfSize = s.size / 2
				local y = s.size.y
				quad = {
					Vector(-halfSize.x, 0, -halfSize.z),
					Vector( halfSize.x, 0,  halfSize.z),
					Vector(-halfSize.x, y, -halfSize.z),
					Vector( halfSize.x, y,  halfSize.z),
				}

				local rotation = currentMirror:getBehavior(RotationBehavior)
				if rotation then
					for i = 1, #quad do
						quad[i] = rotation.rotation:transformVector(quad[i])
					end
				end

				for i = 1, #quad do
					quad[i] = quad[i] + newOrigin
				end
			end

			local p, n
			do
				local success, hit
				success, hit = ray:hitTriangle(quad[1], quad[2], quad[3])
				if success then
					p = hit
					n = Vector.cross(quad[1] - quad[2], quad[2] - quad[3])
				else
					success, hit = ray:hitTriangle(quad[3], quad[4], quad[2])
					if success then
						p = hit
						n = Vector.cross(quad[3] - quad[4], quad[4] - quad[2])
					end
				end
			end

			if not p then
				return false, nil, nil
			end

			p = ray.direction
			n = n:getNormal()

			local reflection = p - 2 * n * p:dot(n)

			newDirection = reflection
		else
			newDirection = ray.direction
		end
	end

	newOrigin.y = ray.origin.y

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
