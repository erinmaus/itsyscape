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
local Vector = require "ItsyScape.Common.Math.Vector"
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
	self.hits = {}
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
		if oldLayer then
			oldLayer[peep] = nil

			if not next(oldLayer, nil) then
				set[key] = nil
			end
		end
	end

	if self.hits[peep] then
		peep:poke('lightFade')
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

function MirrorCortex:hit(ray, mirror)
	local position = Utility.Peep.getAbsolutePosition(mirror)

	local size, halfSize
	do
		size = mirror:getBehavior(SizeBehavior)
		if not size then
			return false, false, nil
		end

		halfSize = size.size / 2
	end

	local s, p = ray:hitBounds(
		position + size.offset - halfSize,
		position + size.offset + halfSize)
	if not s then
		return false, false, nil
	end

	local x, z = p.x, p.z
	local m = mirror:getBehavior(MirrorBehavior)
	if m then
		local direction
		do
			local rotation = mirror:getBehavior(RotationBehavior)
			if rotation then
				direction = rotation.rotation:transformVector(m.direction)
			else
				direction = m.direction
			end

			direction = direction:getNormal()
		end

		local dot = math.pi - math.acos(direction:dot(Vector(position.x - x, 0, position.z - z):getNormal()))
		if math.floor(math.deg(dot)) > math.floor(math.deg(m.range)) then
			return true, false, p
		end
	end

	return true, true, p
end

function MirrorCortex:stepRayCast(layer, path, currentMirror, currentPosition, ray)
	local peeps = self.mirrors[layer]
	local mirrorsHit = {}
	local success = false
	if peeps then
		for peep in pairs(peeps) do
			if peep ~= currentMirror then
				local size = peep:getBehavior(SizeBehavior)
				if size then
					local halfSize = size.size / 2
					local position = Utility.Peep.getAbsolutePosition(peep)

					local s, b, p = self:hit(ray, peep)
					if s then
						table.insert(mirrorsHit, {
							mirror = peep,
							position = p,
							bounce = b
						})

						success = true
					end
				end
			end
		end
	end

	table.sort(mirrorsHit, function(a, b)
		local s = (a.position - currentPosition):getLength() 
		local t = (b.position - currentPosition):getLength()

		return s < t
	end)

	local hit = mirrorsHit[1]
	if hit then
		local s, _, nextRay = path:add(currentMirror, hit.mirror, ray)
		if s then
			if hit.bounce then
				return true, nextRay, hit.mirror
			else
				return false, nil, nil
			end
		end
	end

	return false, nil, nil
end

function MirrorCortex:update(delta)
	local hits = {}
	for layerName, lightSources in pairs(self.lightSources) do
		for lightSource in pairs(lightSources) do
			local paths = {}
			local l = lightSource:getBehavior(LightRaySourceBehavior)
			for i = 1, #l.rays do
				local path = LightPath()

				local currentMirror = nil
				local currentPosition = Utility.Peep.getAbsolutePosition(lightSource)
				local ray = l.rays[i]
				do
					local newPosition = ray.origin + Utility.Peep.getAbsolutePosition(lightSource)
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
					local s, r, m = self:stepRayCast(
						layerName,
						path,
						currentMirror,
						currentPosition,
						ray)

					if s then
						ray = r
						currentMirror = m
						currentPosition = Utility.Peep.getAbsolutePosition(m)

						hits[m] = true
					else
						currentMirror = nil
					end
				until not currentMirror

				if path:count() > 0 then
					paths[i] = path
				end
			end

			l.paths = paths
		end
	end

	for m in pairs(hits) do
		if not self.hits[m] then
			m:poke('lightHit')
		end
	end

	for m in pairs(self.hits) do
		if not hits[m] then
			m:poke('lightFade')
		end
	end

	self.hits = hits
end

return MirrorCortex
