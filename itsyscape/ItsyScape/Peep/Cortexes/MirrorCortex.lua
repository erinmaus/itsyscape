--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/MirrorCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Ray = require "ItsyScape.Common.Math.Ray"
local Utility = require "ItsyScape.Game.Utility"
local Cortex = require "ItsyScape.Peep.Cortex"
local MirrorBehavior = require "ItsyScape.Peep.Behaviors.MirrorBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local LightRaySourceBehavior = require "ItsyScape.Peep.Behaviors.LightRaySourceBehavior"
local LightPath = require "ItsyScape.World.LightPath"

local MirrorCortex = Class(Cortex)

function MirrorCortex:new()
	Cortex.new(self)

	self:require(MirrorBehavior)
	self:require(PositionBehavior)
	self:require(SizeBehavior)

	self.lightSources = {}
	self.mirrors = {}
	self.layers = {}
end

function MirrorCortex:addToLayeredSet(peep, set)
	do
		local oldKey = self.layers[peep]
		if oldKey then
			if oldKey ~= peep:getLayerName() then
				self:removeFromLayeredSet(peep, set)
			else
				-- The peep is in the correct set, don't do anything.
				return
			end
		end
	end

	local key = peep:getLayerName()
	local layer = set[key]
	if not layer then
		layer = {}
		set[key] = layer
	end

	layer[peep] = {}
	self.layers[peep] = key
end

function MirrorCortex:removeFromLayeredSet(peep, set)
	local key = self.layers[peep]
	if key then
		local oldLayer = set[key]
		oldLayer[peep] = nil

		if not next(oldLayer, nil) then
			set[key] = nil
		end
	end
end

function MirrorCortex:getFromSet(peep, set)
	local key = self.layers[peep]
	if key then
		local layer = set[key]
		if layer then
			return layer[peep]
		end
	end

	return nil
end

function MirrorCortex:previewPeep(peep)
	Cortex.previewPeep(self, peep)

	if peep:hasBehavior(LightRaySourceBehavior) then
		self:addToLayeredSet(peep, self.lightSources)
	elseif self.layers[peep] then
		-- The peep may have been a light source, so try and remove it anyway.
		self:removeFromLayeredSet(peep, self.lightSources)

		if not peep:hasBehavior(MirrorBehavior) then
			self.layers[peep] = nil
		end
	end
end

function MirrorCortex:addPeep(peep)
	Cortex.addPeep(self, peep)

	self:addToLayeredSet(peep, self.mirrors)
end

function MirrorCortex:removePeep(peep)
	Cortex.removePeep(self, peep)

	self:removeFromLayeredSet(peep, self.mirrors)
end

function MirrorCortex:stepRayCast(layer, path, currentMirror, ray)
	local peeps = self.mirrors[layer]
	if peeps then
		for peep in pairs(peeps) do
			if peep ~= currentMirror then
				local size = peep:getBehavior(SizeBehavior)
				if size then
					local halfSize = size.size / 2
					local position = Utility.Peep.getAbsolutePosition(peep)

					if ray:hitBounds(
						position + size.offset - size,
						position + size.offset + size)
					then
						local success, _, nextRay = path:add(currentMirror, peep, ray)
						return success, nextRay, peep
					end
				end
			end
		end
	end

	return false, nil
end

function MirrorCortex:update(delta)
	for layerName, lightSources in pairs(self.lightSources) do
		for lightSource in pairs(lightSources) do
			local paths = {}
			local l = lightSource:getBehavior(LightRaySourceBehavior)
			for i = 1, #l.rays do
				local path = LightPath()

				local currentMirror = nil
				local ray = l.rays[i]
				do
					local newPosition = ray.position + Utility.Peep.getAbsolutePosition(lightSource)
					local newDirection = ray.direction

					local rotation = lightSource:getBehavior(RotationBehavior)
					if rotation then
						local transform = love.math.newTransform()
						transform:applyQuaternion(rotation.rotation:get())
						newDirection = Vector(transform:transformPoint(ray.direction:get()))
					end

					ray = Ray(newPosition, newDirection)
				end

				repeat
					local s, r, m = self:stepRayCast(layerName, path, currentMirror, ray)

					if s then
						ray = r
						currentMirror = m
					end
				until not currentMirror
			end

			l.paths = paths
		end
	end
end

return MirrorCortex
